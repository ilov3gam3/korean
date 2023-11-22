<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="col-12 mb-3 d-flex justify-content-center">
    <div class="row col-8">
            <div class="gap-2 col-md-6">
                <a href="${pageContext.request.contextPath}/admin/user-management">
                    <div class="d-grid">
                        <button class="btn btn-primary"><%= language.getProperty("admin.user_mana") %></button>
                    </div>
                </a>
            </div>
            <div class="d-grid gap-2 col-md-6">
                <a href="${pageContext.request.contextPath}/admin/location-management">
                    <div class="d-grid">
                        <button class="btn btn-primary"><%= language.getProperty("admin_panel_location") %></button>
                    </div>
                </a>
            </div>
    </div>
</div>
<div class="col-12 mb-3 d-flex justify-content-center">
    <div class="row col-8">
        <div class="gap-2 col-md-6">
            <a href="${pageContext.request.contextPath}/admin/property-type-management">
                <div class="d-grid">
                    <button class="btn btn-primary"><%= language.getProperty("admin_panel_property_type") %></button>
                </div>
            </a>
        </div>
        <div class="gap-2 col-md-6">
            <a href="${pageContext.request.contextPath}/admin/near-by-locations">
                <div class="d-grid">
                    <button class="btn btn-primary"><%= language.getProperty("admin_panel_near_location") %></button>
                </div>
            </a>
        </div>
    </div>
</div>
<div class="col-12 mb-3 d-flex justify-content-center">
    <div class="row col-8">
        <div class="gap-2 col-md-6">
            <a href="${pageContext.request.contextPath}/admin/amenities">
                <div class="d-grid">
                    <button class="btn btn-primary"><%= language.getProperty("admin_panel_location") %></button>
                </div>
            </a>
        </div>
        <div class="gap-2 col-md-6">
            <a href="${pageContext.request.contextPath}/admin/near-by-locations">
                <div class="d-grid">
                    <button class="btn btn-primary">sắp ra mắt</button>
                </div>
            </a>
        </div>
    </div>
</div>
<%@ include file="../master/foot.jsp" %>
