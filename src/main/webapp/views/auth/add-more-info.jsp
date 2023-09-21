<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container col-6 mb-3">
    <h2><%= language.getProperty("info.title") %></h2>
    <form action="/add-more-info" method="post" class="m-1" id="form">
        <input type="hidden" value="${avatar}" name="avatar">
        <div class="form-group mt-1 mb-1">
            <label for="name"><%= language.getProperty("info.name.label") %></label>
            <input required class="form-control" type="text" name="name" id="name" value="${name}" readonly>
        </div>
        <div class="form-group mt-1 mb-1">
            <label for="email"><%= language.getProperty("info.email.label") %></label>
            <input required class="form-control" type="text" name="email" id="email" value="${email}" readonly>
        </div>
        <div class="form-group mt-1 mb-1">
            <label for="password"><%= language.getProperty("info.password.label") %></label>
            <input required class="form-control" type="password" name="password" id="password" placeholder="<%= language.getProperty("info.password.placeholder") %>">
        </div>
        <div class="form-group mt-1 mb-1">
            <label for="phone"><%= language.getProperty("info.phone.label") %></label>
            <input required class="form-control" type="text" name="phone" id="phone" placeholder="<%= language.getProperty("info.phone.placeholder") %>">
        </div>
        <div class="form-group mt-1 mb-1">
            <label for="dob"><%= language.getProperty("info.dob.label") %></label>
            <input required class="form-control" type="date" name="dob" id="dob" placeholder="<%= language.getProperty("info.dob.placeholder") %>">
        </div>
        <div class="form-group mt-1 mb-1">
            <label for="national_id"><%= language.getProperty("info.national_id.label") %></label>
            <input required class="form-control" type="text" name="national_id" id="national_id" placeholder="<%= language.getProperty("info.national_id.placeholder") %>">
        </div>
        <button type="submit" class="btn btn-primary mt-2" style="width: 100%"><%= language.getProperty("info.add_info") %></button>
    </form>
</div>
<%@ include file="../master/foot.jsp" %>


