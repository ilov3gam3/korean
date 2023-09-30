<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container-fluid col-12 mb-3">
    <div class="row col-11  d-flex justify-content-center">
        <div class="col-md-6">
            <h2>Thêm loại</h2>
            <form action="/property-type-management" method="post">
                <div class="form-group">
                    <label for="name">tên </label>
                    <input class="form-control" type="text" name="name" id="name">
                </div>
                <div class="col-md-12 d-grid gap-2 mt-2">
                    <button class="btn btn-primary">Thêm</button>
                </div>
            </form>
        </div>

        <div class="col-md-6">
            <h2>Danh sách</h2>
            <table class="table table-bordered table-striped col-12" id="my_table">
                <thead>
                <tr>
                    <th scope="col">#</th>
                    <th>Tên </th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${property_list}">
                    <tr>
                        <td>${item.getId()}</td>
                        <td>${item.getName()}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="../master/foot.jsp" %>
