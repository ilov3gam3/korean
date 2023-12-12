<%@ page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<%ArrayList<MyObject> priority_plans = (ArrayList<MyObject>) request.getAttribute("priority_plans");%>
<div class="container-fluid col-12 mb-3 d-flex justify-content-center">
  <div class="row col-11 ">
    <div class="col-md-12">
      <div class="col-lg-12 text-start text-lg-center wow slideInRight" data-wow-delay="0.1s">
        <ul class="nav nav-pills d-inline-flex justify-content-end mb-1 mt-3">
          <li class="nav-item me-2">
            <a class="btn btn-outline-primary <%=request.getSession().getAttribute("show_priority") == null ? "active" : ""%>" data-bs-toggle="pill" href="#plans"><%=language.getProperty("post_comment")%></a>
          </li>
          <li class="nav-item me-2">
            <a class="btn btn-outline-primary <%=request.getSession().getAttribute("show_priority") == null ? "" : "active"%>" data-bs-toggle="pill" href="#plans_priority"><%=language.getProperty("post_like")%></a>
          </li>
        </ul>
      </div>
      <div class="tab-content">
        <div id="plans" class="tab-pane fade show p-0 <%=request.getSession().getAttribute("show_priority") == null ? "active" : ""%>">
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
              <th class="col-2"><%=language.getProperty("amenities_edit")%></th>
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
                <th class="col-2">
                  <button onclick="updateValueEdit('${plan.getId()}', '${plan.getName_vn()}', '${plan.getName_kr()}', '${plan.getNumber_of_property()}', '${plan.getPrice_per_month()}', '${plan.getNumber_of_comments()}', '${plan.getNumber_of_words_per_cmt()}')" data-bs-toggle="modal" data-bs-target="#editModal" style="width: 100%" class="btn btn-warning">
                    <%=language.getProperty("amenities_edit")%>
                  </button>
                  <form onsubmit="deleteAction(event, ${plan.getNumbers()})" action="${pageContext.request.contextPath}/admin/delete-plan" method="post">
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
        <div id="plans_priority" class="tab-pane fade show p-0 <%=request.getSession().getAttribute("show_priority") == null ? "" : "active"%>">
          <button type="button" data-bs-toggle="modal" data-bs-target="#addPriorityModal" class="btn btn-primary mb-2 ml-2">
            <%= language.getProperty("plans_add_priority") %>
          </button>
          <table class="table table-bordered table-striped col-12">
            <thead>
            <tr>
              <th scope="col">#</th>
              <th><%= language.getProperty("plans_priority") %></th>
              <th><%= language.getProperty("plans_price_per_property") %></th>
              <th><%= language.getProperty("plans_hidden_status") %></th>
              <th><%= language.getProperty("plans_numbers") %></th>
              <th class="col-2"><%= language.getProperty("amenities_edit") %></th>
            </tr>
            </thead>
            <tbody>
            <% for (int i = 0; i < priority_plans.size(); i++) { %>
              <tr>
                <td><%=priority_plans.get(i).getId()%></td>
                <td><%=priority_plans.get(i).getPriority()%></td>
                <td><%=priority_plans.get(i).getPrice_per_property()%></td>
                <td>
                  <a href="${pageContext.request.contextPath}/admin/change-priority-status?id=<%=priority_plans.get(i).getId()%>">
                    <%if (priority_plans.get(i).getHidden().equals("1")){ %>
                    <button style="width: 100%;" class="btn btn-danger"><%=language.getProperty("plans_hidden_true")%></button>
                    <% } else { %>
                    <button style="width: 100%;" class="btn btn-primary"><%=language.getProperty("plans_hidden_false")%></button>
                    <% } %>
                  </a>
                </td>
                <td><%=priority_plans.get(i).getNumbers()%></td>
                <td class="col-2">
                  <button onclick="updateValueEditPriority('<%=priority_plans.get(i).getId()%>', '<%=priority_plans.get(i).getPriority()%>', '<%=priority_plans.get(i).getPrice_per_property()%>')" data-bs-toggle="modal" data-bs-target="#editPriorityModal" style="width: 100%" class="btn btn-warning mb-1">
                    <%=language.getProperty("amenities_edit")%>
                  </button>
                  <form onsubmit="deleteAction(event, <%=priority_plans.get(i).getNumbers()%>)" action="${pageContext.request.contextPath}/admin/delete-priority" method="get">
                    <input type="hidden" name="id" value="<%=priority_plans.get(i).getId()%>">
                    <button style="width: 100%;" type="submit" class="btn btn-danger"><%=language.getProperty("amenities_delete")%></button>
                  </form>
                </td>
              </tr>
            <% } %>
            </tbody>
          </table>
        </div>
      </div>
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
<div class="modal fade" id="addPriorityModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-xl ">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title"><%= language.getProperty("property_type_add_new") %></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="col-md-12">
          <form action="${pageContext.request.contextPath}/admin/add-priority" method="post">
            <div class="row">
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("plans_priority") %></label>
                  <div class="row">
                    <input required class="form-control" type="number" name="priority">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("plans_price_per_property") %></label>
                  <div class="row">
                    <input required class="form-control" type="number" name="price">
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
          <form action="${pageContext.request.contextPath}/admin/update-plan" method="post">
            <input type="hidden" id="id" name="id">
            <div class="row">
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("property_type_vn_name") %></label>
                  <div class="row">
                    <input required class="form-control" type="text" name="name_vn" id="name_vn">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("property_type_kr_name") %></label>
                  <div class="row">
                    <input required class="form-control" type="text" name="name_kr" id="name_kr">
                  </div>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("plans_number_of_property") %></label>
                  <div class="row">
                    <input required class="form-control" type="number" name="number_of_property" id="number_of_property">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("plans_price_per_month") %></label>
                  <div class="row">
                    <input required class="form-control" type="number" name="price_per_month" id="price_per_month">
                  </div>

                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("plans_number_of_comments") %></label>
                  <div class="row">
                    <input required class="form-control" type="number" name="number_of_comments" id="number_of_comments">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("plans_number_of_words_per_cmt") %></label>
                  <div class="row">
                    <input required class="form-control" type="number" name="number_of_words_per_cmt" id="number_of_words_per_cmt">
                  </div>
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
<div class="modal fade" id="editPriorityModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-xl ">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" ><%= language.getProperty("property_type_add_new") %></h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <div class="col-md-12">
          <form action="${pageContext.request.contextPath}/admin/update-priority-plan" method="post">
            <input type="hidden" id="id_priority" name="id">
            <div class="row">
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("property_type_vn_name") %></label>
                  <div class="row">
                    <input required class="form-control" type="text" name="priority" id="priority">
                  </div>
                </div>
              </div>
              <div class="col-6">
                <div class="form-group m-1">
                  <label ><%= language.getProperty("property_type_kr_name") %></label>
                  <div class="row">
                    <input required class="form-control" type="text" name="price_per_property" id="price_per_property">
                  </div>
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
<%request.getSession().removeAttribute("show_priority");%>
<%@ include file="../master/foot.jsp" %>
<script>
  function deleteAction(e, numbers) {
    if (numbers !== 0){
      e.preventDefault();
      toastr.warning("<%=language.getProperty("plans_delete_warn")%>".replace("z", numbers))
    }
  }
  function updateValueEdit(id, name_vn, name_kr, number_of_property, price_per_month, number_of_comments, number_of_words_per_cmt) {
    $("#id").val(id)
    $("#name_vn").val(name_vn)
    $("#name_kr").val(name_kr)
    $("#number_of_property").val(number_of_property)
    $("#price_per_month").val(price_per_month)
    $("#number_of_comments").val(number_of_comments)
    $("#number_of_words_per_cmt").val(number_of_words_per_cmt)
  }
  function updateValueEditPriority(id, priority, price_per_property) {
    $("#id_priority").val(id)
    $("#priority").val(priority)
    $("#price_per_property").val(price_per_property)
  }
</script>
