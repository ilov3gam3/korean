<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container-fluid col-12 mb-3 d-flex justify-content-center">
    <div class="row col-11 ">
        <div class="col-md-5">
            <h2><%= language.getProperty("location_province_title") %></h2>
            <form action="" method="post">
                <div class="form-group">
                    <label for="province_name"><%= language.getProperty("location_province_label") %></label>
                    <input class="form-control" type="text" name="province_name" id="province_name">
                </div>
                <div class="col-md-12 d-grid gap-2 mt-2">
                    <button class="btn btn-primary"><%= language.getProperty("location_add_button") %></button>
                </div>
            </form>

            <h2><%= language.getProperty("location_district_title") %></h2>
            <form action="${pageContext.request.contextPath}/admin/add-districts" method="post">
                <div class="form-group">
                    <label for="district_name"><%= language.getProperty("location_district_label") %></label>
                    <input class="form-control" type="text" name="district_name" id="district_name">
                </div>
                <div class="form-group">
                    <label for="province_id"><%= language.getProperty("location_choose_province") %></label>
                    <select class="form-control" name="province_id" id="province_id">
                        <c:forEach var="item" items="${provinces_list}">
                            <option value="${item.getId()}">${item.getName()}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-12 d-grid gap-2 mt-2">
                    <button class="btn btn-primary"><%= language.getProperty("location_add_button") %></button>
                </div>
            </form>
        </div>

        <div class="col-md-7">
            <h2><%= language.getProperty("location_list") %></h2>
            <table class="table table-bordered table-striped col-12" id="my_table">
                <thead>
                <tr>
                    <th scope="col">#</th>
                    <th><%= language.getProperty("location_province_label") %></th>
                    <th><%= language.getProperty("location_district_title") %></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${provinces_list}">
                    <tr>
                        <td>${item.getId()}</td>
                        <td>${item.getName()}</td>
                        <td class="">
                            <c:forEach var="item2" items="${districts_list}">
                                <c:if test="${item2.getProvince_id() == item.getId()}">
                                    <button class="btn btn-primary m-1">${item2.getName()}</button>
                                </c:if>
                            </c:forEach>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="../master/foot.jsp" %>
