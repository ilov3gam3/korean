<%@ page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<% ArrayList<MyObject> bookings =( ArrayList<MyObject>) request.getAttribute("bookings"); %>
<div class="container-fluid col-12 mb-3 d-flex justify-content-center">
  <table class="table table-bordered table-striped col-12" id="my_table">
    <thead>
    <tr>
      <th scope="col">#</th>
      <th><%= language.getProperty("your_bookings_username") %></th>
      <th><%= language.getProperty("your_bookings_property_name") %></th>
      <th><%= language.getProperty("your_bookings_from_date") %></th>
      <th><%= language.getProperty("your_bookings_to_date") %></th>
      <th><%= language.getProperty("your_bookings_note") %></th>
      <th><%= language.getProperty("your_bookings_is_received") %></th>
      <th><%= language.getProperty("your_bookings_is_returned") %></th>
      <th><%= language.getProperty("your_bookings_created_at") %></th>
      <th><%= language.getProperty("amenities_action") %></th>
    </tr>
    </thead>
    <tbody>
    <% for (int i = 0; i < bookings.size(); i++) { %>
    <tr>
      <td><%=bookings.get(i).getId()%></td>
      <td><%=bookings.get(i).getUsername()%></td>
      <td>
        <%=lang.equals("vn") ? bookings.get(i).getName_vn() : bookings.get(i).getName_kr()%>
      </td>
      <td><%=bookings.get(i).getFrom_date()%></td>
      <td><%=bookings.get(i).getTo_date()%></td>
      <td><%=bookings.get(i).getNote()%></td>
      <td>
        <a href="${pageContext.request.contextPath}/user/change-is-received?id=<%=bookings.get(i).getId()%>">
          <%if (bookings.get(i).getIs_received().equals("0")){ %>
          <button class="btn btn-danger">Chưa nhận phòng</button>
          <% } else { %>
          <button class="btn btn-primary">Đã nhận phòng</button>
          <% } %>
        </a>
      </td>
      <td>
        <a href="${pageContext.request.contextPath}/user/change-is-returned?id=<%=bookings.get(i).getId()%>">
          <% if (bookings.get(i).getIs_returned().equals("0")) { %>
          <button class="btn btn-danger">Chưa trả phòng</button>
          <% } else { %>
          <button class="btn btn-primary">Đã trả phòng</button>
          <% } %>
        </a>
      </td>
      <td><%=bookings.get(i).getCreated_at()%></td>
      <td>
        <a href="${pageContext.request.contextPath}/user/delete-booking?id=<%=bookings.get(i).getId()%>">
          <button class="btn btn-danger"><%=language.getProperty("amenities_delete")%></button>
        </a>
      </td>
    </tr>
    <% } %>
    </tbody>
  </table>
</div>
<%@ include file="../master/foot.jsp" %>
