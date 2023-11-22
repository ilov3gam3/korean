<%@ page import="java.util.Date" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>
<% System.out.println(new Date()); %>
<h1>hello</h1>
<form action="${pageContext.request.contextPath}/user/change-hidden" method="post">
    <input type="text" name="p_id">
    <button type="submit">submit</button>
</form>
</body>
</html>