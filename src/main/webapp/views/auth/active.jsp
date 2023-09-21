<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container col-9 mb-3 mt-3">
  <div class="card text-center">
      <h1>${error}${success}${warning}${info}</h1>
  </div>
</div>
<%@ include file="../master/foot.jsp" %>