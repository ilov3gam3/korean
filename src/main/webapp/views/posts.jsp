<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/views/master/head.jsp" %>
<div class="container col-12" id="app">
    <template v-for="(value, key) in posts">
        <div class="p-2 mb-4 bg-body-tertiary rounded-3">
            <div class="container-fluid">
                <div class="card">
                    <div class="card-header">
                        <div class="row">
                            <div class="col-12">
                                <img style="width: 40px; height: 40px; object-fit: cover; border-radius: 50%"
                                     :src="value.avatar.startsWith('http') ? value.avatar : '${pageContext.request.contextPath}' + value.avatar"
                                     alt="">
                                {{value.username}}
                                ({{value.created_at}})
                            </div>
                        </div>
                    </div>
                    <div class="card-body">
                        <h5>{{value.title}}</h5>
                        <p>{{value.content}}</p>
                    </div>
                    <div class="card-footer">
                        <form v-on:submit="comment(value.id, key, event)">
                            <div class="input-group">
                                <div class="input-group-prepend">
                                    <button v-on:click="like(value.id)"
                                            :class="{'btn btn-outline-success' : value.like_id === '0', 'btn btn-success' : value.like_id !== '0'}"
                                            type="button">{{value.count_like}}👍
                                    </button>
                                </div>
                                <input v-if="!logged_in" type="text" class="form-control"
                                       placeholder="<%=language.getProperty("post_comment")%>" v-on:click="like(0)" readonly aria-describedby="basic-addon2">
                                <input v-if="logged_in" type="text" class="form-control"
                                       placeholder="<%=language.getProperty("post_comment")%>" v-model="value.comment_input" aria-describedby="basic-addon2">
                                <div class="input-group-append">
<%--                                    <span class="input-group-text">{{value.comment_input !== '' ? value.comment_input.length + '/' + number_of_words_per_cmt}}</span>--%>
<%--                                    <span v-if="!logged_in" class="input-group-text" disabled="">0</span>--%>
                                    <span v-if="logged_in" class="input-group-text">{{value.comment_input !== '' ? (value.comment_input.length + '/' + number_of_words_per_cmt) : '0/' + number_of_words_per_cmt}}</span>
                                </div>
                                <div class="input-group-append">
                                    <button  class="btn btn-outline-primary"
                                            type="submit"><%=language.getProperty("post_comment")%>
                                    </button>
                                </div>
                                <div class="input-group-append">
                                    <button class="btn btn-primary"
                                            type="button"><%=language.getProperty("post_view_comment")%>
                                        ({{value.count_comment}})
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </template>
    <div class="container">
        <button style="width: 100%;" class="btn btn-primary" v-if="show_load_more" v-on:click="get_posts()">Get more post</button>
    </div>
</div>
<%@ include file="/views/master/foot.jsp" %>
<script>
    var app = new Vue({
        el: "#app",
        data: {
            last_id: 0,
            first_id: 0,
            posts: [],
            logged_in: <%=request.getSession().getAttribute("login") != null ? "true" : "false"%>,
            show_load_more: true,
            number_of_comments: 0,
            number_of_words_per_cmt: 0,

        },
        created() {
            this.get_posts()
            if (this.logged_in){
                this.get_word_count()
            }
        },
        methods: {
            get_posts() {
                axios.get("${pageContext.request.contextPath}/get-posts?last_id=" + this.last_id)
                    .then((res) => {
                        const temp = JSON.parse(res.data.posts)
                        console.log(temp)
                        for (let i = 0; i < temp.length; i++) {
                            temp[i].comment_input = ''
                            temp[i].comments = []
                            this.posts.push(temp[i])
                        }
                        this.last_id = this.posts[this.posts.length - 1].id
                        this.first_id = this.posts[0].id
                        if (temp.length < 5) {
                            this.show_load_more = false
                        }
                    })
            },
            get_word_count(){
                axios.get("${pageContext.request.contextPath}/user/get-subs")
                    .then((res)=>{
                        this.number_of_comments = res.data.number_of_comments
                        this.number_of_words_per_cmt = res.data.number_of_words_per_cmt
                    })
            },
            like(id) {
                if (!this.logged_in) {
                    toastr.warning("<%=language.getProperty("post_pls_login")%>")
                } else {
                    axios.get("${pageContext.request.contextPath}/user/like-post?id=" + id)
                        .then((res) => {
                            if (res.data.status) {
                                toastr.success(res.data.message)
                                /*for (let i = 0; i < this.posts.length; i++) {
                                    if (this.posts[i].id === id){
                                        if (this.posts[i].like_id === '0'){
                                            this.posts[i].like_id = '-1'
                                            this.posts[i].count_like++
                                        } else {
                                            this.posts[i].like_id = '0'
                                            this.posts[i].count_like--
                                        }
                                    }
                                }*/
                                this.update_posts(id)
                            } else {
                                toastr.error(res.data.message)
                            }
                        })
                }
            },
            update_posts(id) {
                axios.get("${pageContext.request.contextPath}/get-one-post?id=" + id)
                    .then((res) => {
                        var temp = JSON.parse(res.data.posts)
                        temp.comment_input = ''
                        for (let i = 0; i < this.posts.length; i++) {
                            if (this.posts[i].id === temp.id){
                                this.posts[i].count_like = temp.count_like
                                this.posts[i].count_comment = temp.count_comment
                                this.posts[i].like_id = temp.like_id
                            }
                        }
                    })
            },
            comment(id, key, e) {
                e.preventDefault();
                if (!this.logged_in) {
                    toastr.warning("<%=language.getProperty("post_pls_login")%>")
                } else {
                    if (this.posts[key].comment_input === ''){
                        toastr.warning("Vui lòng nhập bình luận.")
                    } else {
                        if (this.posts[key].comment_input.length > this.number_of_words_per_cmt){
                            toastr.warning("Không được nhập quá " + this.number_of_words_per_cmt + " từ.")
                        } else {
                            var form = new FormData()
                            form.append('comment', this.posts[key].comment_input)
                            form.append('post_id', this.posts[key].id)
                            axios.post("${pageContext.request.contextPath}/user/comment", form,{
                                headers: {
                                    'Content-Type': 'multipart/form-data'
                                }
                            })
                                .then((res)=>{
                                    if (res.data.status){
                                        this.posts[key].comment_input = ''
                                        console.log(res.data)
                                        toastr.success(res.data.message)
                                        this.update_posts(id)
                                    } else {
                                        toastr.error(res.data.message)
                                    }
                                })
                        }
                    }
                }
            },
            get_comments(id){
                axios.get("${pageContext.request.contextPath}/user/comment?post_id=" + id)
                    .then((res)=>{
                        for (let i = 0; i < this.posts.length; i++) {
                            if (this.posts[i].id === id){
                                this.posts.comments = res.data.comments
                            }
                        }
                    })
            }
        }
    })
</script>
