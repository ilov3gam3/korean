<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/views/master/head.jsp" %>
<div class="col-12 mb-3  d-flex justify-content-center">
  <form onsubmit="a(event)" id="my_form1">
    <input type="text" name="1">
    <input type="text" name="2">
    <input type="text" name="3">
    <input type="text" name="4">
    <input type="text" name="5">
    <button type="submit">submit</button>
  </form>
</div>
<%@ include file="/views/master/foot.jsp" %>
<script>
  function a(e) {
    e.preventDefault()
    const form = document.getElementById("my_form1")
    const formData = new FormData(form);
    const form_data_object = {};
    formData.forEach((value, key) =>{
      console.log(key + ":" + value)
    })
  }
</script>
