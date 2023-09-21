<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="col-12 mb-3 d-flex justify-content-center">
    <h2></h2>
    <table class="table table-bordered table-striped" id="my_table">
        <thead>
            <tr>
                <th scope="col">#</th>
                <th>Tên</th>
                <th>Email</th>
                <th>Điện thoại</th>
                <th>Ngày sinh</th>
                <th>Ảnh đại diện</th>
                <th>Là admin</th>
                <th>Đã xác thực</th>
                <th>Căn cước công dân</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${list}">
                <tr>
                    <td>${item.getId()}</td>
                    <td>${item.getName()}</td>
                    <td>${item.getEmail()}</td>
                    <td>${item.getPhone()}</td>
                    <td>${item.getDob()}</td>
                    <td>
                        <img src="${item.getAvatar()}" alt="user avatar" style="width: 100px; height: 100px; object-fit: cover">
                    </td>
                    <td>${item.getIs_admin() == '1' ? "có" : "không"}</td>
                    <td>${item.getIs_verified() == '1' ? "có" : "không"}</td>
                    <td>${item.getNational_id()}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
<%@ include file="../master/foot.jsp" %>
