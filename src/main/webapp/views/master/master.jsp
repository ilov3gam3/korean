<%@ include file="head.jsp" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Navbar Start -->
        <div class="container-fluid nav-bar bg-transparent">
            <nav class="navbar navbar-expand-lg navbar-light py-0 px-4">
                <a href="${pageContext.request.contextPath}/" class="navbar-brand d-flex align-items-center text-center">
                    <div class="icon p-2 me-2">
                        <img class="img-fluid" src="${pageContext.request.contextPath}/assets/img/icon-deal.png" alt="Icon" style="width: 30px; height: 30px;">
                    </div>
                    <h1 class="m-0 text-primary">Makaan</h1>
                </a>
                <button type="button" class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarCollapse">
                    <div class="navbar-nav ms-auto">
                        <a href="index.html" class="nav-item nav-link active">Home</a>
                        <a href="about.html" class="nav-item nav-link">About</a>
                        <div class="nav-item dropdown">
                            <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Property</a>
                            <div class="dropdown-menu rounded-0 m-0">
                                <a href="property-list.html" class="dropdown-item">Property List</a>
                                <a href="property-type.html" class="dropdown-item">Property Type</a>
                                <a href="property-agent.html" class="dropdown-item">Property Agent</a>
                            </div>
                        </div>
                        <div class="nav-item dropdown">
                            <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Pages</a>
                            <div class="dropdown-menu rounded-0 m-0">
                                <a href="testimonial.html" class="dropdown-item">Testimonial</a>
                                <a href="404.html" class="dropdown-item">404 Error</a>
                            </div>
                        </div>
                        <a href="contact.html" class="nav-item nav-link">Contact</a>
                    </div>
                    <div class="ml-1">
                        <button class="btn btn-primary ml-1 mr-1">Add Property</button>
                        <button class="btn btn-primary ml-1 mr-1">Login</button>
                        <a href="${pageContext.request.contextPath}/register">
                            <button class="btn btn-primary ml-1 mr-1">Sign up</button>
                        </a>
                    </div>
                </div>
            </nav>
        </div>
        <!-- Navbar End -->
        <div class="container col-6 mb-3">
            <h1>Form đăng kí</h1>
            <form action="${pageContext.request.contextPath}/register" method="post" class="m-1">
                <div class="form-group">
                    <label for="username">Nhập username</label>
                    <input class="form-control" type="text" id="username" placeholder="Username">
                </div>
                <div class="form-group">
                    <label for="password">Nhập mật khẩu</label>
                    <input class="form-control" type="password" id="password" placeholder="Password">
                </div>
                <div class="form-group">
                    <label for="phone">Nhập số điện thoại</label>
                    <input class="form-control" type="text" id="phone" placeholder="Phone">
                </div>
                <div class="form-group">
                    <label for="dob">Nhập ngày sinh</label>
                    <input class="form-control" type="date" id="dob" placeholder="Date of birth">
                </div>
                <div class="d-grid gap-2 m-1">
                    <buton class="btn btn-primary">Đăng kí</buton>
                </div>
            </form>
        </div>
<%@ include file="foot.jsp" %>


