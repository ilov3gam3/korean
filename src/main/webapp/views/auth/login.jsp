<%@ page import="Init.Config" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container col-6 mb-3">
    <h2><%= language.getProperty("login.title") %></h2>
    <form action="${pageContext.request.contextPath}/login" method="post" class="m-1" id="form">
        <div class="form-group mt-1 mb-1">
            <label for="email"><%= language.getProperty("login.email.label") %></label>
            <input required class="form-control" type="email" name="email" id="email" value="${not empty form ? form.getEmail() : ''}" placeholder="<%= language.getProperty("login.email.placeholder") %>">
        </div>
        <div class="form-group mt-1 mb-1">
            <label for="password"><%= language.getProperty("login.password.label") %></label>
            <input required class="form-control" type="password" name="password" id="password" value="${not empty form ? form.getPassword() : ''}" placeholder="<%= language.getProperty("login.password.placeholder") %>">
        </div>
        <div class="form-group d-flex justify-content-center">
            <button type="submit" class="btn btn-primary mt-2" style="width: 60%"><%= language.getProperty("login.login_button") %></button>
        </div>
        <div class="form-group d-flex justify-content-center mt-2">
            <p><%= language.getProperty("login.or") %></p>
        </div>
        <div class="form-group d-flex justify-content-center">
            <a class="d-flex justify-content-center" style="width: 100%;" href="https://accounts.google.com/o/oauth2/auth?client_id=950893291709-9rqulakhl78cnlejkuofncru62p49epo.apps.googleusercontent.com&redirect_uri=<%=Config.config.get("redirect_uri")%>&response_type=code&scope=openid%20profile%20email">
                <button type="button" style="width: 60%" class="btn btn-outline-primary"><%= language.getProperty("login.login_with_google") %>  &nbsp;&nbsp; <svg xmlns="http://www.w3.org/2000/svg" x="0px" y="0px" width="25" height="25" viewBox="0 0 48 48">
                    <path fill="#FFC107" d="M43.611,20.083H42V20H24v8h11.303c-1.649,4.657-6.08,8-11.303,8c-6.627,0-12-5.373-12-12c0-6.627,5.373-12,12-12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C12.955,4,4,12.955,4,24c0,11.045,8.955,20,20,20c11.045,0,20-8.955,20-20C44,22.659,43.862,21.35,43.611,20.083z"></path><path fill="#FF3D00" d="M6.306,14.691l6.571,4.819C14.655,15.108,18.961,12,24,12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4C16.318,4,9.656,8.337,6.306,14.691z"></path><path fill="#4CAF50" d="M24,44c5.166,0,9.86-1.977,13.409-5.192l-6.19-5.238C29.211,35.091,26.715,36,24,36c-5.202,0-9.619-3.317-11.283-7.946l-6.522,5.025C9.505,39.556,16.227,44,24,44z"></path><path fill="#1976D2" d="M43.611,20.083H42V20H24v8h11.303c-0.792,2.237-2.231,4.166-4.087,5.571c0.001-0.001,0.002-0.001,0.003-0.002l6.19,5.238C36.971,39.205,44,34,44,24C44,22.659,43.862,21.35,43.611,20.083z"></path>
                </svg></button>
            </a>
        </div>
        <div class="container-fluid text-center mt-2">
            <a href="${pageContext.request.contextPath}/register"><%= language.getProperty("login.register_instead") %></a>
        </div>
    </form>
</div>
<%@ include file="../master/foot.jsp" %>


