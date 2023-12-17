<%@ page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<% ArrayList<MyObject> posts = (ArrayList<MyObject>) request.getAttribute("posts");%>
<% MyObject myObject = new MyObject();%>
<div class="container col-12">
    <table class="table table-bordered table-striped col-12" >
        <thead>
        <tr>
            <th scope="col">#</th>
            <th><%= language.getProperty("make_post_title") %></th>
            <th><%= language.getProperty("make_post_content") %></th>
            <th><%= language.getProperty("view_subs_status") %></th>
            <th><%= language.getProperty("view_subs_create_at") %></th>
        </tr>
        </thead>
        <tbody>
        <% for (int i = 0; i < posts.size(); i++) { %>
            <tr <%=posts.get(i).getIs_verified().equals("1") ? "class=\"table-success\"" : ""%>>
                <td><%=posts.get(i).getId()%></td>
                <td><%=posts.get(i).getTitle()%></td>
                <td><%=posts.get(i).getContent()%></td>
                <td><%=posts.get(i).getIs_verified().equals("1") ? language.getProperty("make_post_verified") : language.getProperty("make_post_not_verified")%></td>
                <td><%=posts.get(i).getCreated_at()%></td>
            </tr>
        <% } %>
        </tbody>
    </table>
</div>
<%@ include file="../master/foot.jsp" %>
