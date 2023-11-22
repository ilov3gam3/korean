<%@ page import="Init.Config" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container col-6 mb-3">
  <h2><%= language.getProperty("change-password.title") %></h2>
  <form action="${pageContext.request.contextPath}/user/change-password" method="post" class="m-1" id="form">
    <div class="form-group mt-1 mb-1">
      <label for="current_password"><%= language.getProperty("change-password.current-password") %></label>
      <input required class="form-control" type="password" name="current_password" id="current_password" value="${not empty form ? form.getPassword() : ''}" placeholder="<%= language.getProperty("login.password.placeholder") %>">
    </div>
    <div class="form-group mt-1 mb-1">
      <label for="new_password"><%= language.getProperty("change-password.new-password") %></label>
      <input required class="form-control" type="password" name="new_password" id="new_password" value="${not empty form ? form.getPassword() : ''}" placeholder="<%= language.getProperty("login.password.placeholder") %>">
    </div>
    <div class="form-group mt-1 mb-1">
      <label for="confirm_new_password"><%= language.getProperty("change-password.confirm-new-password") %></label>
      <input required class="form-control" type="password" name="confirm_new_password" id="confirm_new_password" value="${not empty form ? form.getPassword() : ''}" placeholder="<%= language.getProperty("login.password.placeholder") %>">
    </div>
    <button type="submit" class="btn btn-primary mt-2" style="width: 100%"><%= language.getProperty("change-password.button-submit") %></button>
  </form>
</div>
<%@ include file="../master/foot.jsp" %>


