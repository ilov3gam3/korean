<%@ page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<% ArrayList<MyObject> posts = (ArrayList<MyObject>) request.getAttribute("posts");%>
<div id="app" class="container col-12">
  <table class="table table-bordered table-striped col-12" >
    <thead>
    <tr>
      <th scope="col">#</th>
      <th><%= language.getProperty("view_subs_name") %></th>
      <th><%= language.getProperty("make_post_title") %></th>
      <th><%= language.getProperty("make_post_content") %></th>
      <th class="col-1"><%= language.getProperty("view_subs_status") %></th>
      <th><%= language.getProperty("view_subs_create_at") %></th>
      <th class="col-2"><%= language.getProperty("amenities_action") %></th>
    </tr>
    </thead>
    <tbody>
    <% for (int i = 0; i < posts.size(); i++) { %>
    <tr <%=posts.get(i).getIs_verified().equals("1") ? "class=\"table-success\"" : ""%>>
      <td><%=posts.get(i).getId()%></td>
      <td><%=posts.get(i).getUsername()%></td>
      <td><%=posts.get(i).getTitle()%></td>
      <td><%=posts.get(i).getContent()%></td>
      <td class="col-1">
        <form action="${pageContext.request.contextPath}/admin/view-posts" method="post">
        <input type="hidden" name="id" value="<%=posts.get(i).getId()%>">
        <%=posts.get(i).getIs_verified().equals("1") ? "<button class=\"btn btn-primary\">"+language.getProperty("make_post_verified")+"</button>" : "<button class=\"btn btn-danger\">"+language.getProperty("make_post_not_verified")+"</button>"%>
        </form>
      </td>
      <td class="col-2"><%=posts.get(i).getCreated_at()%></td>
      <td>
        <button v-on:click="view_post('<%=posts.get(i).getId()%>','<%=posts.get(i).getTitle()%>', '<%=posts.get(i).getContent()%>')" style="width: 100%" type="button" data-bs-toggle="modal" data-bs-target="#editModal" class="btn btn-warning"><%=language.getProperty("edit_post")%></button>
        <button v-on:click="view_comments(<%=posts.get(i).getId()%>)" style="width: 100%" type="button" class="btn btn-info mt-2 mb-1" data-bs-toggle="modal" data-bs-target="#commentsModal"><%=language.getProperty("view_comments")%></button>
        <a href="${pageContext.request.contextPath}/admin/update-post?id=<%=posts.get(i).getId()%>">
          <button style="width: 100%" type="button" class="btn btn-danger"><%=language.getProperty("amenities_delete")%></button>
        </a>
      </td>
    </tr>
    <% } %>
    </tbody>
  </table>
  <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl ">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" ><%= language.getProperty("property_type_add_new") %></h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="col-md-12">
            <form action="${pageContext.request.contextPath}/admin/update-post" method="post">
              <input type="hidden" name="id" v-model="post.id">
              <input type="hidden" name="id" v-model="test">
              <div class="form-group">
                <label for="title"><%=language.getProperty("make_post_title")%></label>
                <input v-model="post.title" type="text" class="form-control" name="title" id="title">
              </div>
              <div class="form-group">
                <label for="content"><%=language.getProperty("make_post_content")%></label>
                <textarea v-model="post.content" class="form-control" name="content" id="content" style="width: 100%" rows="10"></textarea>
              </div>
              <div class="form-group mt-2">
                <button class="btn btn-primary" style="width: 100%"><%=language.getProperty("profile.update")%></button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="modal fade" id="commentsModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl ">
      <div class="modal-content" style="max-height: 73vh; overflow-y: auto;">
        <div class="modal-header">
          <h5 class="modal-title" ><%= language.getProperty("property_type_add_new") %></h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="col-md-12">
              <template v-for="(value, key) in comments">
                <div class="col-12 m-3">
                  <img style="width: 40px; height: 40px; object-fit: cover; border-radius: 50%"
                       :src="value.avatar.startsWith('http') ? value.avatar : '${pageContext.request.contextPath}' + value.avatar"
                       alt="">
                  {{value.username}}
                  ({{value.created_at}})<br>
<%--                  <h6 style="text-indent: 50px; font-weight: bold">{{value.content}}</h6>--%>
                  <form v-on:submit="update_comment(event, value)" class="col-12 mt-2">
                    <div class="input-group">
                      <input type="text" class="form-control" v-model="value.content">
                      <div class="input-group-append">
                        <button type="submit" class="btn btn-info"><%=language.getProperty("profile.update")%></button>
                      </div>
                        <div class="input-group-append">
                            <button v-on:click="delete_comment(value.id)" type="button" class="btn btn-danger"><%=language.getProperty("amenities_delete")%></button>
                        </div>
                    </div>
                  </form>
                </div>
              </template>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="../master/foot.jsp" %>
<script>
  var app = new Vue({
    el: "#app",
    data:{
      post: {},
      comments: [],
      test: 0,
      current_post: 0
    },
    created(){

    },
    methods:{
      view_post(id, title, content){
        this.post.id = id
        this.post.title = title
        this.post.content = content
        this.test++
      },
      view_comments(id) {
        this.current_post = id
        axios.get("${pageContext.request.contextPath}/get-comments?post_id=" + id)
                .then((res)=>{
                  this.comments = JSON.parse(res.data.comments)
                })
      },
      update_comment(e, value){
        e.preventDefault();
        axios.post('${pageContext.request.contextPath}/admin/update-comments', value)
                .then((res)=>{
                    if (res.data.status){
                      toastr.success("<%=language.getProperty("update_id_card_success")%>")
                    } else {
                      toastr.warning("<%=language.getProperty("update_id_card_fail")%>")
                    }
                })
      },
      delete_comment(id){
        axios.get('${pageContext.request.contextPath}/admin/update-comments?id=' + id)
                .then((res)=>{
                  if (res.data.status){
                    toastr.success("<%=language.getProperty("update_id_card_success")%>")
                      this.view_comments(this.current_post)
                  } else {
                    toastr.warning("<%=language.getProperty("update_id_card_fail")%>")
                  }
                })
      },
    },
  })
</script>
