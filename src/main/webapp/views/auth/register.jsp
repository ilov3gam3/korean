<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container col-6 mb-3">
    <h2><%= language.getProperty("register.title") %></h2>
    <form action="/register" method="post" class="m-1" id="form">
        <div class="form-group mt-1 mb-1">
            <label for="name"><%= language.getProperty("register.name.label") %></label>
            <input required class="form-control" type="text" name="name" id="name" value="${not empty load_form.getName() ? load_form.getName() : ''}" placeholder="<%= language.getProperty("register.name.placeholder") %>">
        </div>
        <div class="form-group mt-1 mb-1">
            <label for="email"><%= language.getProperty("register.email.label") %></label>
            <input required class="form-control" type="text" name="email" id="email" value="${not empty load_form.getEmail() ? load_form.getEmail() : ''}" placeholder="<%= language.getProperty("register.email.placeholder") %>">
        </div>
        <div class="form-group mt-1 mb-1">
            <label for="password"><%= language.getProperty("register.password.label") %></label>
            <input required class="form-control" type="password" name="password" id="password" placeholder="<%= language.getProperty("register.password.placeholder") %>">
        </div>
        <div class="form-group mt-1 mb-1">
            <label for="phone"><%= language.getProperty("register.phone.label") %></label>
            <input required class="form-control" type="text" name="phone" id="phone" value="${not empty load_form.getPhone() ? load_form.getPhone() : ''}" placeholder="<%= language.getProperty("register.phone.placeholder") %>">
        </div>
        <div class="form-group mt-1 mb-1">
            <label for="dob"><%= language.getProperty("register.dob.label") %></label>
            <input required class="form-control" type="date" name="dob" id="dob" value="${not empty load_form.getDob() ? load_form.getDob() : ''}" placeholder="<%= language.getProperty("register.dob.placeholder") %>">
        </div>
        <div class="form-group mt-1 mb-1">
            <label for="national_id"><%= language.getProperty("register.national_id.label") %></label>
            <input required class="form-control" type="text" name="national_id" id="national_id" value="${not empty load_form.getNational_id() ? load_form.getNational_id() : ''}" placeholder="<%= language.getProperty("register.national_id.placeholder") %>">
        </div>
        <button type="submit" class="btn btn-primary mt-2" style="width: 100%"><%= language.getProperty("register.title") %></button>
        <div class="container-fluid text-center">
            <a href="/login"><%= language.getProperty("register.login_instead") %></a>
        </div>
    </form>
</div>
<%@ include file="../master/foot.jsp" %>


