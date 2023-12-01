<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/views/master/head.jsp" %>
<div class="container">
    <div class="col-lg-12 text-start text-lg-center wow slideInRight" data-wow-delay="0.1s">
        <ul class="nav nav-pills d-inline-flex justify-content-end mb-5">
            <li class="nav-item me-2">
                <a class="btn btn-outline-primary active" data-bs-toggle="pill" href="#tab-1">Featured</a>
            </li>
            <li class="nav-item me-2">
                <a class="btn btn-outline-primary" data-bs-toggle="pill" href="#tab-2">For Sell</a>
            </li>
            <li class="nav-item me-0">
                <a class="btn btn-outline-primary" data-bs-toggle="pill" href="#tab-3">For Rent</a>
            </li>
        </ul>
    </div>
    <div class="tab-content">
        <div id="tab-1" class="tab-pane fade show p-0 active">
            tab1
        </div>
        <div id="tab-2" class="tab-pane fade show p-0">
            tab2
        </div>
        <div id="tab-3" class="tab-pane fade show p-0">
            tab3
        </div>
    </div>
</div>
<%@ include file="/views/master/foot.jsp" %>
