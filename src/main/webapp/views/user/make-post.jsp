<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container col-12">
  <form action="${pageContext.request.contextPath}/user/add-post" method="post">
    <div class="form-group">
      <label for="title"><%=language.getProperty("make_post_title")%></label>
      <input type="text" class="form-control" name="title" id="title">
    </div>
    <div class="form-group">
      <label for="content"><%=language.getProperty("make_post_content")%></label>
      <textarea class="form-control" name="content" id="content" style="width: 100%" rows="10"></textarea>
    </div>
    <div class="form-group mt-2">
      <button class="btn btn-primary" style="width: 100%"><%=language.getProperty("make_post_post")%></button>
    </div>
  </form>
</div>
<%@ include file="../master/foot.jsp" %>
