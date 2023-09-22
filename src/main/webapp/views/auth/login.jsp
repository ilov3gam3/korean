<%@ page import="com.example.korean.Init.Config" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container col-6 mb-3">
    <h2><%= language.getProperty("login.title") %></h2>
    <form action="/login" method="post" class="m-1" id="form">
        <div class="form-group mt-1 mb-1">
            <label for="email"><%= language.getProperty("login.email.label") %></label>
            <input required class="form-control" type="text" name="email" id="email" value="${not empty email ? email : ''}" placeholder="<%= language.getProperty("login.email.placeholder") %>">
        </div>
        <div class="form-group mt-1 mb-1">
            <label for="password"><%= language.getProperty("login.password.label") %></label>
            <input required class="form-control" type="password" name="password" id="password" placeholder="<%= language.getProperty("login.password.placeholder") %>">
        </div>
        <button type="submit" class="btn btn-primary mt-2" style="width: 100%"><%= language.getProperty("login.login_button") %></button>
        <div class="container-fluid text-center mb-2">
            <p><%= language.getProperty("login.or") %></p>
            <a href="https://accounts.google.com/o/oauth2/auth?client_id=950893291709-9rqulakhl78cnlejkuofncru62p49epo.apps.googleusercontent.com&redirect_uri=<%=Config.config.get("redirect_uri")%>&response_type=code&scope=openid%20profile%20email"><%= language.getProperty("login.login_with_google") %></a>
        </div>
        <div class="container-fluid text-center mt-2">
            <a href="/register"><%= language.getProperty("login.register_instead") %></a>
        </div>
    </form>
</div>
<%@ include file="../master/foot.jsp" %>


