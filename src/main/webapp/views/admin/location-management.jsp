<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container-fluid col-12 mb-3 d-flex justify-content-center">
    <div class="row col-11 ">
        <div class="col-md-4">
            <h2><%= language.getProperty("location_province_title") %></h2>
            <form action="" method="post">
                <div class="form-group">
                    <label for="province_name"><%= language.getProperty("location_province_label") %></label>
                    <input required class="form-control" type="text" name="province_name" id="province_name">
                </div>
                <div class="col-md-12 d-grid gap-2 mt-2">
                    <button class="btn btn-primary"><%= language.getProperty("location_add_button") %></button>
                </div>
            </form>
            <h2><%= language.getProperty("location_district_title") %></h2>
            <form action="${pageContext.request.contextPath}/admin/add-districts" method="post">
                <div class="form-group">
                    <label for="district_name"><%= language.getProperty("location_district_label") %></label>
                    <input required class="form-control" type="text" name="district_name" id="district_name">
                </div>
                <div class="form-group">
                    <label for="province_id"><%= language.getProperty("location_choose_province") %></label>
                    <select class="form-control" name="province_id" id="province_id">
                        <option value="" selected disabled><%= language.getProperty("location_choose_province") %></option>
                        <c:forEach var="item" items="${provinces_list}">
                            <option ${previous_province == item.getId() ? "selected" : ""} value="${item.getId()}">${item.getName()}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-12 d-grid gap-2 mt-2">
                    <button class="btn btn-primary"><%= language.getProperty("location_add_button") %></button>
                </div>
            </form>
        </div>

        <div class="col-md-8">
            <h2><%= language.getProperty("location_list") %></h2>
            <table class="table table-bordered table-striped col-12" id="my_table">
                <thead>
                <tr>
                    <th scope="col">#</th>
                    <th><%= language.getProperty("location_province_label") %></th>
                    <th><%= language.getProperty("location_district_title") %></th>
                    <th class="col-2"><%= language.getProperty("amenities_edit") %></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${provinces_list}">
                    <tr>
                        <td>${item.getId()}</td>
                        <td>${item.getName()}(${item.getNumbers()})</td>
                        <td class="">
                            <c:forEach var="item2" items="${districts_list}">
                                <c:if test="${item2.getProvince_id() == item.getId()}">
                                    <button class="btn btn-primary m-1">${item2.getName()}(${item2.getNumbers()})</button>
                                </c:if>
                            </c:forEach>
                        </td>
                        <td class="col-2">
                            <button style="width: 100%" onclick="showEditModal('${item.getId()}', '${item.getName()}', [<c:forEach var="item2" items="${districts_list}"><c:if test="${item2.getProvince_id() == item.getId()}">{'district_id': '${item2.getId()}', 'name': '${item2.getName()}', 'numbers': ${item2.getNumbers()}},</c:if></c:forEach>])" type="button" data-bs-toggle="modal" data-bs-target="#editModal" class="btn btn-warning">
                                <%= language.getProperty("amenities_edit") %>
                            </button>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl ">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" ><%= language.getProperty("property_type_add_new") %></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="col-md-12">
                    <form action="${pageContext.request.contextPath}/admin/update-province" method="post">
                        <input type="hidden" id="update_province_id" name="update_province_id">
                        <div class="col-12 row">
                            <div class="col-6">
                                <div class="form-group">
                                    <label for="update_province_name"><%= language.getProperty("location_update_province") %></label>
                                    <input required type="text" class="form-control input-group-lg" id="update_province_name" name="update_province_name">
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="col-12 row">
                                    <div class="col-6">
                                        <label class="col-12" for="update_province_name"><%=language.getProperty("location_update_province")%></label>
                                        <button type="submit" style="width: 100%" class="btn btn-success"><%=language.getProperty("location_update_province")%></button>
                                    </div>
                                    <div class="col-6">
                                        <label class="col-12" for="update_province_name"><%=language.getProperty("location_delete_province")%></label>
                                        <a id="a_del_url" >
                                            <button type="button" style="width: 100%" class="btn btn-danger"><%=language.getProperty("location_delete_province")%></button>
                                        </a>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </form>
                    <div id="update_districts">

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="../master/foot.jsp" %>
<script>
    var editModal = $("#editModal");
    editModal.on('show.bs.modal', function () {
        $("#navbar").attr("hidden", true)
    })
    editModal.on('hidden.bs.modal', function () {
        $("#navbar").attr("hidden", false)
    })
    function showEditModal(province_id, province_name, districts) {
        $("#update_province_id").val(province_id)
        $("#update_province_name").val(province_name)
        $("#a_del_url").attr("href", "<%=request.getContextPath()%>/admin/delete-province?id=" + province_id)
        var html = ""
        var label = '<%= language.getProperty("location_update_district") %>'
        var label2 = '<%= language.getProperty("location_delete_district") %>'
        var del_url = '${pageContext.request.contextPath}/admin/add-districts'
        var context = '<%=request.getContextPath()%>'
        for (let i = 0; i < districts.length; i++) {
            html += "<form method='post' action='"+context+"/admin/update-district'>" +
                "<input required type='hidden' name='update_district_id' value='"+districts[i].district_id+"'>" +
                "<div class='col-12 row'>" +
                "<div class='col-6'>" +
                "<div class='form-group'>" +
                "<label for='update_district_name'>"+label+"</label>" +
                "<input required type='text' class='form-control input-group-sm' id='update_district_name' name='update_district_name' value='"+districts[i].name+"'>" +
                "</div>" +
                "</div>" +
                "<div class='col-6'>" +
                "<div class='col-12 row'>" +
                "<div class='col-6'>" +
                "<label class='col-12' for='update_province_name'>"+label+"</label>" +
                "<button type='submit' style='width: 100%' class='btn btn-success'>"+label+"</button>" +
                "</div>" +
                "<div class='col-6'>" +
                "<label class='col-12' for='update_province_name'>"+label2+"</label>" +
                "<a href='"+del_url+"?district_id="+districts[i].district_id+"'>" +
                "<button type='button' style='width: 100%' class='btn btn-danger'>"+label2+"</button>" +
                "</a>" +
                "</div>" +
                "</div>" +
                "</div>" +
                "</div>" +
                "</form>"
        }
        $("#update_districts").html(html)
    }
</script>