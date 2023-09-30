<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="col-12 mb-3 d-flex justify-content-center">
    <div class="row col-8">
            <div class="gap-2 col-md-6">
                <a href="/user-management">
                    <div class="d-grid">
                        <button class="btn btn-primary"><%= language.getProperty("admin.user_mana") %></button>
                    </div>
                </a>
            </div>
            <div class="d-grid gap-2 col-md-6">
                <a href="/location-management">
                    <div class="d-grid">
                        <button class="btn btn-primary">Địa điểm</button>
                    </div>
                </a>
            </div>
    </div>
</div>
<div class="col-12 mb-3 d-flex justify-content-center">
    <div class="row col-8">
        <div class="gap-2 col-md-6">
            <a href="/">
                <div class="d-grid">
                    <button class="btn btn-primary">Các loại tài sản</button>
                </div>
            </a>
        </div>
        <div class="d-grid gap-2 col-md-6">
            <a href="/">
                <div class="d-grid">
                    <button class="btn btn-primary"><%= language.getProperty("admin.user_mana") %></button>
                </div>
            </a>
        </div>
    </div>
</div>
<%@ include file="../master/foot.jsp" %>
