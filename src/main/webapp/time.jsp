<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<c:out value="${time}"/>
<c:forEach var="item" items="${list}">
    <p>${item.getId()} : ${item.getEmail()} : ${item.getName()}</p>
</c:forEach>
</body>
</html>
