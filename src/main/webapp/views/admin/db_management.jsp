<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<a href="/admin/manage-database"><button>re create all tables (reset)</button></a><br>
<c:choose>
    <c:when test="${db_exists eq true}">
        <p>db already exist</p>
    </c:when>
    <c:when test="${db_exists eq false}">
        <p>db not exist</p>
    </c:when>
</c:choose>

<c:choose>
    <c:when test="${status eq true}">
        <p>tạo db thành công</p>
    </c:when>
    <c:when test="${status eq false}">
        <p>thất bại</p>
    </c:when>
</c:choose>
<form action="/manage-database" method="post">
    <button>create a database files</button>
</form>
</body>
</html>
