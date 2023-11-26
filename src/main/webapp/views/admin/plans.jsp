<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container-fluid col-12 mb-3 d-flex justify-content-center">
  <div class="row col-11 ">
    <div class="col-md-12">
      <h2><%= language.getProperty("plans_add_new_plan") %></h2>
      <button type="button" data-bs-toggle="modal" data-bs-target="#addModal" class="btn btn-primary mb-2 ml-2">
        <%= language.getProperty("amenities_add") %>
      </button>
      <table class="table table-bordered table-striped col-12" id="my_table">
        <thead>
        <tr>
          <th scope="col">#</th>
          <th><%= language.getProperty("plans_name_vn") %></th>
          <th><%= language.getProperty("plans_name_kr") %></th>
          <th><%= language.getProperty("plans_number_of_property") %></th>
          <th><%= language.getProperty("plans_price_per_month") %></th>
          <th><%= language.getProperty("plans_number_of_comments") %></th>
          <th><%= language.getProperty("plans_number_of_words_per_cmt") %></th>
          <th><%= language.getProperty("plans_numbers") %></th>
          <th class="col-2"><%= language.getProperty("plans_hidden_status") %></th>
          <th class="col-1"><%=language.getProperty("amenities_edit")%></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="plan" items="${plans}">
          <tr>
            <td>${plan.getId()}</td>
            <td>${plan.getName_vn()}</td>
            <td>${plan.getName_kr()}</td>
            <td>${plan.getNumber_of_property()}</td>
            <td>${plan.getPrice_per_month()}</td>
            <td>${plan.getNumber_of_comments()}</td>
            <td>${plan.getNumber_of_words_per_cmt()}</td>
            <td class="text-center">${plan.getNumbers()}</td>
            <td class="col-2">
              <a href="${pageContext.request.contextPath}/admin/change-plan-status?id=${plan.getId()}">
                <c:choose>
                  <c:when test="${plan.getHidden() == '1'}">
                    <button style="width: 100%" class="btn btn-danger"><%=language.getProperty("plans_hidden_true")%></button>
                  </c:when>
                  <c:otherwise>
                    <button style="width: 100%" class="btn btn-primary"><%=language.getProperty("plans_hidden_false")%></button>
                  </c:otherwise>
                </c:choose>
              </a>
            </td>
            <th class="col-1">
              <button style="width: 100%" class="btn btn-warning">
                <%=language.getProperty("amenities_edit")%>
              </button>
              <form onsubmit="deleteAction(event, ${plan.getNumbers()})" action="${pageContext.request.contextPath}/admin/change-plan-status" method="post">
                <input type="hidden" name="id" value="${plan.getId()}">
                <button style="width: 100%" type="submit" class="mt-1 btn btn-danger">
                  <%=language.getProperty("amenities_delete")%>
                </button>
              </form>
            </th>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>
<div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-xl ">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel"><%= language.getProperty("property_type_add_new") %></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="col-md-12">
          <form action="" method="post">
            <div class="row">
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("property_type_vn_name") %></label>
                  <div class="row">
                    <input required class="form-control" type="text" name="name_vn">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("property_type_kr_name") %></label>
                  <div class="row">
                    <input required class="form-control" type="text" name="name_kr">
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("plans_number_of_property") %></label>
                  <div class="row">
                    <input required class="form-control" type="number" name="number_of_property" >
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("plans_price_per_month") %></label>
                  <div class="row">
                    <input required class="form-control" type="number" name="price_per_month">
                  </div>

                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("plans_number_of_comments") %></label>
                  <div class="row">
                    <input required class="form-control" type="number" name="number_of_comments">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("plans_number_of_words_per_cmt") %></label>
                  <div class="row">
                    <input required class="form-control" type="number" name="number_of_words_per_cmt">
                  </div>
                </div>
              </div>
            </div>
            <div class="col-md-12 d-grid gap-2 mt-2">
              <button class="btn btn-primary"><%= language.getProperty("near_location_add") %></button>
            </div>
          </form>
        </div>
      </div>
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
          <form action="${pageContext.request.contextPath}/admin/update-amenity" method="post">
            <input type="hidden" id="a_id">
            <div class="form-group m-1">
              <label for="update_name_vn"><%= language.getProperty("property_type_vn_name") %></label>
              <div class="row">
                <div class="col-md-9">
                  <input class="form-control" type="text" name="update_name_vn" id="update_name_vn">
                </div>
                <div class="col-md-3">
                  <button class="btn btn-primary" type="button" id="update_trans_to_kr" style="width: 100%;">
                    <%= language.getProperty("property_type_tran2kr") %></button>
                </div>
              </div>
            </div>
            <div class="form-group m-1">
              <label for="update_name_kr"><%= language.getProperty("property_type_kr_name") %></label>
              <div class="row">
                <div class="col-md-9">
                  <input class="form-control" type="text" name="update_name_kr" id="update_name_kr">
                </div>
                <div class="col-md-3">
                  <button class="btn btn-primary" type="button" id="update_trans_to_vn" style="width: 100%;">
                    <%= language.getProperty("property_type_tran2vn") %></button>
                </div>
              </div>

            </div>
            <div class="col-md-12 d-grid gap-2 mt-2">
              <button class="btn btn-primary"><%= language.getProperty("amenities_edit") %></button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="../master/foot.jsp" %>
<script>
  function deleteAction(e, numbers) {
    if (numbers !== 0){
      e.preventDefault();
      toastr.warning("<%=language.getProperty("plans_delete_warn")%>".replace("z", numbers))
    }
  }
</script>
