<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container col-6 mb-3">
    <c:if test="${not empty message}">
        <div class="col-12 text-center">
            <h1>${message}</h1>
        </div>
    </c:if>
    <c:if test="${empty message}">
        <h2><%= language.getProperty("reset_password_title") %></h2>
        <form action="" method="post" class="m-1" id="form">
            <div class="form-group mt-1 mb-1">
                <label for="password"><%= language.getProperty("reset_password_password") %></label>
                <input required class="form-control" type="password" name="password" id="password">
            </div>
            <button type="submit" class="btn btn-primary mt-2" style="width: 100%"><%= language.getProperty("reset_password_button") %></button>
        </form>
    </c:if>
</div>
<%@ include file="../master/foot.jsp" %>


