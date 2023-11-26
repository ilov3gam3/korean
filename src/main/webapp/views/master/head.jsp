<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.Properties" %>
<%@ page import="Database.MyObject" %>
<% Properties language = (Properties) request.getAttribute("language"); %>
<% String lang = language.get("lang").toString(); %>
<% MyObject user = (MyObject) session.getAttribute("login"); %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <title>Makaan - Real Estate HTML Template</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta content="" name="keywords">
    <meta content="" name="description">
    <link rel="shortcut icon" href="${pageContext.request.contextPath}/assets/img/icon-deal.png"/>

    <!-- Favicon -->
    <link href="img/favicon.ico" rel="icon">

    <!-- Google Web Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Inter:wght@700;800&display=swap"
          rel="stylesheet">

    <!-- Icon Font Stylesheet -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"
          integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="${pageContext.request.contextPath}/assets/lib/animate/animate.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">

    <!-- Template Stylesheet -->
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/toastr.js/latest/toastr.css"
          integrity="sha512-3pIirOrwegjM6erE5gPSwkUzO+3cTjpnV9lexlNZqvupR64iZBnOOTiiLPb9M36zpMScbmUNIcHUqKD47M719g=="
          crossorigin="anonymous" referrerpolicy="no-referrer"/>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/chosen.css"/>
    <style>
        .search-choice-close{
            color: red;
        }
    </style>
</head>

<body>
<div class="" style="max-width: 85%; margin: auto;">
    <div class="container-fluid card p-0">
        <!-- Spinner Start -->
                <div id="spinner"
                     class="show position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                    <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                        <span class="sr-only">Loading...</span>
                    </div>
                </div>
        <!-- Spinner End -->
        <!-- Navbar Start -->
        <div class="container-fluid nav-bar bg-transparent mb-2" id="navbar">
            <nav class="navbar navbar-expand-lg bg-white navbar-light py-0 px-4">
                <a href="${pageContext.request.contextPath}/"
                   class="navbar-brand d-flex align-items-center text-center">
                    <div class="icon p-2 me-2">
                        <img class="img-fluid" src="${pageContext.request.contextPath}/assets/img/icon-deal.png"
                             alt="Icon"
                             style="width: 30px; height: 30px;">
                    </div>
                    <h1 class="m-0 text-primary">Makaan</h1>
                </a>
                <button type="button" class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarCollapse">
                    <div class="navbar-nav ms-auto">
                        <a href="${pageContext.request.contextPath}/"
                           class="nav-item nav-link active"><%= language.getProperty("head.home") %>
                        </a>

                        <div class="nav-item dropdown">
                            <a href="#" class="nav-link dropdown-toggle"
                               data-bs-toggle="dropdown"><%= language.getProperty("head.language") %>
                            </a>
                            <div class="dropdown-menu rounded-0 m-0">
                                <a href="${pageContext.request.contextPath}/change-language?user_lang=vn&current_url=<%= request.getAttribute("current_url") %>"
                                   class="dropdown-item"><%= language.getProperty("head.vietnamese") %>
                                </a>
                                <a href="${pageContext.request.contextPath}/change-language?user_lang=kr&current_url=<%= request.getAttribute("current_url") %>"
                                   class="dropdown-item"><%= language.getProperty("head.korean") %>
                                </a>
                            </div>
                        </div>

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
                        <a href="contact.html" class="nav-item nav-link"><%= language.getProperty("head.contact") %>

                        </a>
                    </div>
                    <% if (user != null) { %>
                        <% if (user.getIs_admin().equals("1")) { %>
                        <a href="${pageContext.request.contextPath}/admin" class="btn btn-primary"
                           style="margin-right: 15px;"><%= language.getProperty("head.admin") %>
                        </a>
                        <%} else {%>
                        <a href="${pageContext.request.contextPath}/user/add-property" class="btn btn-primary"
                           style="margin-right: 15px;">Add Property</a>
                        <%} %>
                    <%} %>
                    <% if (user == null) { %>
                    <a class="ml-1" href="${pageContext.request.contextPath}/register">
                        <button class="btn btn-warning"
                                style="margin-right: 5px"><%= language.getProperty("head.register") %>
                        </button>
                    </a>
                    <a href="${pageContext.request.contextPath}/login">
                        <button class="btn btn-primary"><%= language.getProperty("head.sign_up") %>
                        </button>
                    </a>
                    <%} else {%>
                    <div class="d-flex align-items-center ml-1">
                        <img src="<%=user.avatar.startsWith("http") ? user.avatar : request.getContextPath() + user.avatar%>" alt="user avatar"
                             style="width: 40px; height: 40px; object-fit: cover; border-radius: 50%">
                    </div>
                    <div class="nav-item dropdown">
                        <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown"><%=user.name%>
                        </a>
                        <div class="dropdown-menu rounded-0 m-0">
                            <a href="${pageContext.request.contextPath}/user/profile"
                               class="dropdown-item"><%= language.getProperty("head.profile") %>
                            </a>


                            <% if (user.getIs_admin().equals("0")) { %>
                            <a href="${pageContext.request.contextPath}/user/your-property"
                               class="dropdown-item"><%= language.getProperty("head.your_property") %>
                            </a>
                            <a href="${pageContext.request.contextPath}/user/upgrade-account"
                               class="dropdown-item"><%= language.getProperty("head.subscribe") %>
                            </a>
                            <%} else {%>

                            <%} %>
                            <a href="${pageContext.request.contextPath}/user/logout"
                               class="dropdown-item"><%= language.getProperty("head.logout") %>
                            </a>
                        </div>
                    </div>
                    <%}%>

                </div>
            </nav>
        </div>
        <!-- Navbar End -->