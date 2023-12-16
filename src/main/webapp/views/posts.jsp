<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/views/master/head.jsp" %>
<div class="container col-12" id="app">
    <h3 v-if="is_admin !== true"><%=language.getProperty("post_number_of_comments")%>: {{number_of_comments}}, <%=language.getProperty("post_commented")%> {{commented}} <%=language.getProperty("post_time")%></h3>
    <h3 v-if="is_admin !== true && new_account && logged_in"><%=language.getProperty("post_free_cmt")%>: {{free_comments}}, <%=language.getProperty("post_free_word")%> {{free_words}}</h3>
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
                                ({{value.created_at}})<br>
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
                                <input v-if="logged_in && parseInt(commented) < parseInt(number_of_comments)" type="text" class="form-control"
                                       placeholder="<%=language.getProperty("post_comment")%>" v-model="value.comment_input" aria-describedby="basic-addon2">
                                <input v-if="logged_in && parseInt(commented) >= parseInt(number_of_comments)" type="text" class="form-control"
                                       placeholder="<%=language.getProperty("post_comment")%>" v-on:click="no_more_cmt()" readonly aria-describedby="basic-addon2">

                                <div class="input-group-append">
                                    <span v-if="logged_in && is_admin !== true" class="input-group-text">{{value.comment_input !== '' ? (value.comment_input.length + '/' + number_of_words_per_cmt) : '0/' + number_of_words_per_cmt}}</span>
                                </div>
                                <div class="input-group-append">
                                    <button  class="btn btn-outline-primary"
                                             type="submit"><%=language.getProperty("post_comment")%>
                                    </button>
                                </div>
                                <div class="input-group-append">
                                    <button data-bs-toggle="modal" data-bs-target="#exampleModal" v-on:click="view_comments(value.id, key)" class="btn btn-primary"
                                            type="button"><%=language.getProperty("post_view_interact")%>
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
        <button style="width: 100%;" class="btn btn-primary" v-if="show_load_more" v-on:click="get_posts()"><%=language.getProperty("post_get_more_post")%></button>
    </div>
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-xl">
            <div class="modal-content" style="max-height: 70vh; overflow-y: scroll">
                <div class="col-lg-12 text-start text-lg-center wow slideInRight" data-wow-delay="0.1s">
                    <ul class="nav nav-pills d-inline-flex justify-content-end mb-1 mt-3">
                        <li class="nav-item me-2">
                            <a class="btn btn-outline-primary active" data-bs-toggle="pill" href="#comments"><%=language.getProperty("post_comment")%></a>
                        </li>
                        <li class="nav-item me-2">
                            <a class="btn btn-outline-primary" v-on:click="get_likes()" data-bs-toggle="pill" href="#likes"><%=language.getProperty("post_like")%></a>
                        </li>
                    </ul>
                </div>
                <div class="tab-content">
                    <div id="comments" class="tab-pane fade show p-0 active">
                        <div class="modal-header">
                            <h5 class="modal-title" ><%=language.getProperty("post_comment")%></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div v-if="viewing_comments_of !== -1" >
                                <div v-if="posts[viewing_comments_of].comments !== -1">
                                    <div v-if="posts[viewing_comments_of].comments.length === 0">
                                        <p class="text-center col-12"><%=language.getProperty("post_no_cmt")%></p>
                                    </div>
                                    <div v-else>
                                        <template v-for="(value, key) in posts[viewing_comments_of].comments">
                                            <div class="col-12">
                                                <img style="width: 40px; height: 40px; object-fit: cover; border-radius: 50%"
                                                     :src="value.avatar.startsWith('http') ? value.avatar : '${pageContext.request.contextPath}' + value.avatar"
                                                     alt="">
                                                {{value.username}}
                                                ({{value.created_at}})<br>
                                                <h6 style="text-indent: 50px; font-weight: bold">{{value.content}}</h6>
                                            </div>
                                        </template>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="likes" class="tab-pane fade show p-0">
                        <div class="modal-header">
                            <h5 class="modal-title" ><%=language.getProperty("post_like")%></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div v-if="viewing_comments_of !== -1" >
                                <div v-if="posts[viewing_comments_of].likes !== -1">
                                    <div v-if="posts[viewing_comments_of].comments.likes === 0">
                                        <p class="text-center col-12"><%=language.getProperty("post_no_like")%></p>
                                    </div>
                                    <div v-else>
                                        <template v-for="(value, key) in posts[viewing_comments_of].likes">
                                            <div class="col-12 m-1">
                                                <img style="width: 40px; height: 40px; object-fit: cover; border-radius: 50%"
                                                     :src="value.avatar.startsWith('http') ? value.avatar : '${pageContext.request.contextPath}' + value.avatar"
                                                     alt="">
                                                {{value.username}}
                                            </div>
                                        </template>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-warning" data-bs-dismiss="modal"><%=language.getProperty("post_close")%></button>
                </div>
            </div>
        </div>
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
            viewing_comments_of : -1,
            commented: 0,
            is_admin: null,
            free_comments : <%=Config.config.getProperty("free_comments")%> ,
            free_words : <%=Config.config.getProperty("free_comments")%> ,
            <% boolean new_account;
                if (user == null){
                    new_account = false;
                } else {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
                    Date givenDate;
                    try{
                        givenDate = dateFormat.parse(user.registered_at);
                        Date currentDate = new Date();
                        long timeDifference = currentDate.getTime() - givenDate.getTime();
                        long dayDifference = TimeUnit.MILLISECONDS.toDays(timeDifference);
                        System.out.println(dayDifference);
                        new_account = dayDifference <= 30;
                    }catch (Exception e){
                        e.printStackTrace();
                        new_account = false;
                    }
                }
            %>
            new_account: <%=new_account%>
        },
        created() {
            this.get_posts()
            if (this.logged_in){
                this.get_word_count();
            }

        },
        methods: {
            get_posts() {
                axios.get("${pageContext.request.contextPath}/get-posts?last_id=" + this.last_id)
                    .then((res) => {
                        const temp = JSON.parse(res.data.posts)
                        for (let i = 0; i < temp.length; i++) {
                            temp[i].comment_input = ''
                            temp[i].comments = -1
                            temp[i].likes = -1
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
                        this.commented = res.data.commented
                        this.is_admin = res.data.is_admin
                        if (this.new_account){
                            this.number_of_comments = parseInt(this.number_of_comments) + parseInt(this.free_comments)
                        }
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
                                this.update_posts(id)
                                this.get_word_count()
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
                        toastr.warning("<%=language.getProperty("post_pls_input_cmt")%>")
                    } else {
                        if (this.posts[key].comment_input.length > this.number_of_words_per_cmt){
                            toastr.warning("<%=language.getProperty("post_dont_input_more_than")%>".replace("123", this.number_of_words_per_cmt))
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
                                        toastr.success(res.data.message)
                                        this.update_posts(id)
                                        this.get_word_count()
                                    } else {
                                        toastr.error(res.data.message)
                                    }
                                })
                        }
                    }
                }
            },
            view_comments(id, key){
                this.viewing_comments_of = key
                axios.get("${pageContext.request.contextPath}/get-comments?post_id=" + id)
                    .then((res)=>{
                        this.posts[key].comments = JSON.parse(res.data.comments)
                    })
            },
            get_likes(){
                axios.get("${pageContext.request.contextPath}/get-likes?post_id=" + this.posts[this.viewing_comments_of].id)
                    .then((res)=>{
                        this.posts[this.viewing_comments_of].likes = JSON.parse(res.data.likes)
                    })
            },
            no_more_cmt(){
                toastr.warning("<%=language.getProperty("post_no_more_cmt")%>")
            },
        }
    })
</script>
