<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="col-12 mb-3  d-flex justify-content-center">
    <div class="row col-11  d-flex justify-content-center">
        <h2><%= language.getProperty("profile.your_data") %>
        </h2>
        <div class="col-md-6">
            <form action="" method="post">
                <div class="form-group mt-1 mb-1">
                    <label for="name">Tên chỗ nghỉ</label>
                    <input required class="form-control" type="text" name="name" id="name">
                </div>
            </form>
        </div>
        <div class="col-md-6">
            <form action="" method="post">
                <div class="form-group mt-1 mb-1">
                    <label for="name">Tên chỗ nghỉ</label>
                    <input required class="form-control" type="text" name="name" id="name">
                </div>
            </form>
        </div>
    </div>
</div>
<%@ include file="../master/foot.jsp" %>
