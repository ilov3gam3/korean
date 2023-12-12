<%@ page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<% ArrayList<MyObject> bookings =( ArrayList<MyObject>) request.getAttribute("bookings"); %>
<div id="app" class="container-fluid col-12 mb-3 d-flex justify-content-center">
  <table class="table table-bordered table-striped col-12" id="my_table">
    <thead>
    <tr>
      <th scope="col">#</th>
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
      <td>
        <%=lang.equals("vn") ? bookings.get(i).getName_vn() : bookings.get(i).getName_kr()%>
      </td>
      <td><%=bookings.get(i).getFrom_date()%></td>
      <td><%=bookings.get(i).getTo_date()%></td>
      <td><%=bookings.get(i).getNote()%></td>
      <td>
          <%if (bookings.get(i).getIs_received().equals("0")){ %>
          <button class="btn btn-danger">Chưa nhận phòng</button>
          <% } else { %>
          <button class="btn btn-primary">Đã nhận phòng</button>
          <% } %>
      </td>
      <td>
          <% if (bookings.get(i).getIs_returned().equals("0")) { %>
          <button class="btn btn-danger">Chưa trả phòng</button>
          <% } else { %>
          <button class="btn btn-primary">Đã trả phòng</button>
          <% } %>
      </td>
      <td><%=bookings.get(i).getCreated_at()%></td>
      <td>
          <%if (bookings.get(i).getIs_received().equals("1") && bookings.get(i).getIs_returned().equals("1")){%>
            <% if (bookings.get(i).getReview_id() == null){ %>
                <button v-on:click="showModal(<%=bookings.get(i).getId()%>)" data-bs-toggle="modal" data-bs-target="#reviewModal" class="btn btn-warning"><%=language.getProperty("your_bookings_review")%></button>
             <% } else { %>
                <button v-on:click="view_review(<%=bookings.get(i).getId()%>)" data-bs-toggle="modal" data-bs-target="#viewReviewModal" class="btn btn-warning"><%=language.getProperty("your_bookings_reviewed_view")%></button>
              <% }%>
          <%} else { %>
            <button onclick="toastr.warning('<%=language.getProperty("your_bookings_not_finish")%>')" class="btn btn-warning"><%=language.getProperty("your_bookings_review")%></button>
        <% } %>
      </td>
    </tr>
    <% } %>
    </tbody>
  </table>
  <div class="modal fade" id="reviewModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl ">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" ><%= language.getProperty("property_type_add_new") %></h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form action="${pageContext.request.contextPath}/user/review" method="post">
            <input type="hidden" name="booking_id" v-model="booking_id">
            <input type="hidden" name="stars" v-model="choosing_star">
            <div class="form-group">
              <label for="review"><%=language.getProperty("your_bookings_review")%></label>
              <textarea required class="form-control" name="review" id="review" style="width: 100%;" rows="10"></textarea>
            </div>
            <div class="form-group d-flex justify-content-center mt-2">
              <div>
                <div class="">
                  <button v-on:click="change_star(1)" type="button" class="btn btn-outline-primary" :class="{'btn btn-primary' : choosing_star !== 1, 'btn btn-primary' : choosing_star === 1}">1 <img style="max-height: 20px" src="${pageContext.request.contextPath}/assets/img/star.png" alt=""></button>
                  <button v-on:click="change_star(2)" type="button" class="btn btn-outline-primary" :class="{'btn btn-primary' : choosing_star !== 2, 'btn btn-primary' : choosing_star === 2}">2 <img style="max-height: 20px" src="${pageContext.request.contextPath}/assets/img/star.png" alt=""></button>
                  <button v-on:click="change_star(3)" type="button" class="btn btn-outline-primary" :class="{'btn btn-primary' : choosing_star !== 3, 'btn btn-primary' : choosing_star === 3}">3 <img style="max-height: 20px" src="${pageContext.request.contextPath}/assets/img/star.png" alt=""></button>
                  <button v-on:click="change_star(4)" type="button" class="btn btn-outline-primary" :class="{'btn btn-primary' : choosing_star !== 4, 'btn btn-primary' : choosing_star === 4}">4 <img style="max-height: 20px" src="${pageContext.request.contextPath}/assets/img/star.png" alt=""></button>
                  <button v-on:click="change_star(5)" type="button" class="btn btn-outline-primary" :class="{'btn btn-primary' : choosing_star !== 5, 'btn btn-primary' : choosing_star === 5}">5 <img style="max-height: 20px" src="${pageContext.request.contextPath}/assets/img/star.png" alt=""></button>
                </div>
                <div class="row mt-2">
                  <button type="submit" class="btn btn-info"><%=language.getProperty("your_bookings_review")%></button>
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
  <div class="modal fade" id="viewReviewModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl ">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" ><%= language.getProperty("property_type_add_new") %></h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form v-if="review !== ''" v-on:submit="update_review($event)">
            <input type="hidden" name="booking_id" v-model="review.booking_id">
            <input type="hidden" name="stars" v-model="review.stars">
            <div class="form-group">
              <label for="review-update"><%=language.getProperty("your_bookings_review")%></label>
              <textarea v-model="review.content" required class="form-control" name="review" id="review-update" style="width: 100%;" rows="10"></textarea>
            </div>
            <div class="form-group d-flex justify-content-center mt-2">
              <div>
                <div class="">
                  <button v-on:click="review.stars = '1'" type="button" class="btn btn-outline-primary" :class="{'btn btn-primary' : review.stars !== '1', 'btn btn-primary' : review.stars === '1'}">1 <img style="max-height: 20px" src="${pageContext.request.contextPath}/assets/img/star.png" alt=""></button>
                  <button v-on:click="review.stars = '2'" type="button" class="btn btn-outline-primary" :class="{'btn btn-primary' : review.stars !== '2', 'btn btn-primary' : review.stars === '2'}">2 <img style="max-height: 20px" src="${pageContext.request.contextPath}/assets/img/star.png" alt=""></button>
                  <button v-on:click="review.stars = '3'" type="button" class="btn btn-outline-primary" :class="{'btn btn-primary' : review.stars !== '3', 'btn btn-primary' : review.stars === '3'}">3 <img style="max-height: 20px" src="${pageContext.request.contextPath}/assets/img/star.png" alt=""></button>
                  <button v-on:click="review.stars = '4'" type="button" class="btn btn-outline-primary" :class="{'btn btn-primary' : review.stars !== '4', 'btn btn-primary' : review.stars === '4'}">4 <img style="max-height: 20px" src="${pageContext.request.contextPath}/assets/img/star.png" alt=""></button>
                  <button v-on:click="review.stars = '5'" type="button" class="btn btn-outline-primary" :class="{'btn btn-primary' : review.stars !== '5', 'btn btn-primary' : review.stars === '5'}">5 <img style="max-height: 20px" src="${pageContext.request.contextPath}/assets/img/star.png" alt=""></button>
                </div>
                <div class="row mt-2">
                  <button type="submit" class="btn btn-info"><%=language.getProperty("your_bookings_review_update")%></button>
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="../master/foot.jsp" %>
<script>
  var app = new Vue({
    el: "#app",
    data:{
      booking_id: 0,
      choosing_star : 0,
      review: ''
    },
    created(){
    },
    methods:{
      showModal(booking_id){
        this.booking_id = booking_id
      },
      change_star(star){
        this.choosing_star = star
      },
      view_review(id){
        axios.get('${pageContext.request.contextPath}/user/get-one-review?booking_id=' + id)
                .then((res)=>{
                  this.review = JSON.parse(res.data.review)
                })
      },
      update_review(e){
        e.preventDefault();
        axios.post('${pageContext.request.contextPath}/user/update-review', this.review,{
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })
                .then((res)=>{
                  console.log(res)
                  if (res.data.status){
                    toastr.success("<%=language.getProperty("update_id_card_success")%>")
                  } else {
                    toastr.warning("<%=language.getProperty("update_id_card_fail")%>")
                  }
                })
      }
    },
  })
</script>