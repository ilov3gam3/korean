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
        <h2><%= language.getProperty("forgot_password_title") %></h2>
        <form action="${pageContext.request.contextPath}/forgot-password" method="post" class="m-1" id="form">
            <div class="form-group mt-1 mb-1">
                <label for="email"><%= language.getProperty("forgot_password_email") %></label>
                <input required class="form-control" type="email" name="email" id="email">
            </div>
            <button type="submit" class="btn btn-primary mt-2" style="width: 100%"><%= language.getProperty("forgot_password_submit") %></button>
        </form>
    </c:if>
</div>
<%@ include file="../master/foot.jsp" %>


