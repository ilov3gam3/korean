<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.DecimalFormat" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/views/master/head.jsp" %>
<% MyObject property = (MyObject) request.getAttribute("property");%>
<% ArrayList<MyObject> images = (ArrayList<MyObject>) request.getAttribute("images");%>
<% ArrayList<MyObject> near_locations = (ArrayList<MyObject>) request.getAttribute("near_locations");%>
<% ArrayList<MyObject> amenities = (ArrayList<MyObject>) request.getAttribute("amenities");%>
<div id="app">
  <div class="p-5 mb-4 bg-body-tertiary rounded-3">
    <div class="container-fluid py-5">
      <div class="col-12 row">
        <div class="col-5">
          <div class="row col-12">
            <div class="row">
              <%String thumb_nail_id = "";%>
              <% for (int j = 0; j < images.size(); j++) { %>
              <% if (images.get(j).getProperty_id().equals(property.getId()) && images.get(j).getIs_thumb_nail().equals("1")){%>
              <img id="thumb_nail_<%=property.getId()%>" class="p-0 img-thumbnail border-4 border-dark" src="${pageContext.request.contextPath}<%=images.get(j).getPath()%>" alt="" style="max-width: 100%; object-fit: cover">
              <%thumb_nail_id = images.get(j).getId();%>
              <% } %>
              <% } %>
            </div>
            <div class="row" id="small_imgs">
              <% for (int j = 0; j < images.size(); j++) { %>
              <% if (images.get(j).getProperty_id().equals(property.getId())){%>
              <img id="small_<%=images.get(j).getId()%>" onclick="changePreview('<%=thumb_nail_id%>', '<%=images.get(j).getId()%>', '<%=images.get(j).getPath()%>', '<%=property.getId()%>')" hidden="hidden" class="small_images m-1 p-0 img-thumbnail <%=images.get(j).getIs_thumb_nail().equals("1") ? "border-3 border-primary" : ""%>" src="${pageContext.request.contextPath}<%=images.get(j).getPath()%>" alt="">
              <% }%>
              <% } %>
            </div>
          </div>
        </div>
        <div class="col-7">
          <h3><%=language.getProperty("amenities_name_vn")%>:  <%=property.getName_vn()%></h3>
          <h3><%=language.getProperty("amenities_name_kr")%>:  <%=property.getName_kr()%></h3>
          <p><%=language.getProperty("property_type_vn_des")%>: <%=property.getDescription_vn()%></p>
          <p><%=language.getProperty("property_type_kr_des")%>: <%=property.getDescription_kr()%></p>
          <div class="col-12 row">
            <div class="col-3">
              Loại nhà ở:
              <% if (lang.equals("vn")) {%>
              <%=property.getProperty_type_name_vn()%>
              <% } else { %>
              <%=property.getProperty_type_name_kr()%>
              <% } %>
            </div>
            <div class="col-3">
              <%=language.getProperty("add_property_type")%>:
              <%if (property.getFor_sale().equals("1")){%>
              <%=language.getProperty("add_property_type_sale")%>
              <% } else { %>
              <%=property.getProperty_type_name_kr()%>
              <%=language.getProperty("add_property_type_rent")%>:
              <% } %>
            </div>
            <div class="col-3">
              <%NumberFormat formatter = new DecimalFormat("#0");%>
              <%=language.getProperty("add_property_price")%>: <%=formatter.format(Double.parseDouble(property.getPrice()))%> ₫
            </div>
            <div class="col-3">
              <%=language.getProperty("add_property_area")%>: <%=property.getArea()%> m²
            </div>
          </div>
          <div class="col-12 row">
            <div class="col-3">
              <%=language.getProperty("add_property_number_floor")%>: <%=property.getFloor_numbers()%>
            </div>
            <div class="col-3">
              <%=language.getProperty("add_property_at_floor")%>: <%=property.getAt_floor()%>
            </div>
            <div class="col-3">
              <%=language.getProperty("add_property_bath_room")%>: <%=property.getBathrooms()%>
            </div>
            <div class="col-3">
              <%=language.getProperty("add_property_bed_room")%>: <%=property.getBedrooms()%>
            </div>
          </div>
          <div class="col-12 row">
            <div class="col-9">
              <p style="margin-top: 4px"><%=language.getProperty("add_property_address")%>: <%=property.getAddress()%>, <%=property.getDistrict_name()%>, <%=property.getProvince_name()%></p>
            </div>
            <div class="col-3">
              <% if (property.getFor_sale().equals("1")){%>
                <% if (property.getSold().equals("1")){ %>
                  <button class="btn btn-success" style="width: 100%"><%=language.getProperty("view_sold")%></button>
                <% } else { %>
                  <button class="btn btn-warning" style="width: 100%"><%=language.getProperty("view_not_sold")%></button>
                <% } %>
              <%} else { %>
              <button class="btn btn-primary" style="width: 100%"><%=language.getProperty("add_property_type_rent")%></button>
              <% } %>
            </div>
          </div>
          <div class="col-12 row">
            <div class="col-9">
              <p><%=language.getProperty("admin_panel_amenity")%>:
                <% for (int j = 0; j < amenities.size(); j++) {%>
                <%if (lang.equals("kr")){ %>
                <%=amenities.get(j).getName_kr()%>,
                <% } else { %>
                <%=amenities.get(j).getName_vn()%>,
                <% } %>
                <% } %>
              </p>
              <p><%=language.getProperty("add_property_choose_nearby")%>:
                <% for (int j = 0; j < near_locations.size(); j++) {%>
                <%if (lang.equals("kr")){ %>
                <%=near_locations.get(j).getName_kr()%>,
                <% } else { %>
                <%=near_locations.get(j).getName_vn()%>,
                <% } %>
                <% } %>
              </p>
            </div>
          </div>
          <div class="col-12 row">
            <p><%=language.getProperty("phone")%>: <%=property.getPhone()%></p>
            <p><%=language.getProperty("email")%>: <%=property.getEmail()%></p>
          </div>
          <% if (property.getFor_sale().equals("0")){%>
          <div class="col-12 row">
            <button v-on:click="load_bookings()" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#bookModal">Đặt phòng</button>
          </div>
          <% } %>
        </div>
      </div>
      <div class="col-12 row">
        <div class="col-lg-12 text-start text-lg-center wow slideInRight" data-wow-delay="0.1s">
          <ul class="nav nav-pills d-inline-flex justify-content-end mb-1 mt-3">
            <li class="nav-item me-2">
              <a class="btn btn-outline-primary active" data-bs-toggle="pill" href="#view_map"><%=language.getProperty("view_properties_view_map")%></a>
            </li>
            <li class="nav-item me-2">
              <a class="btn btn-outline-primary" v-on:click="get_reviews()" data-bs-toggle="pill" href="#reviews"><%=language.getProperty("view_properties_view_reviwes")%></a>
            </li>
          </ul>
        </div>
        <div class="tab-content mt-1">
          <div id="view_map" class="tab-pane fade show p-0 active">
            <div class="col-12 row">
              <%=property.getGg_map_api()%>
            </div>
          </div>
          <div id="reviews" class="tab-pane fade show p-0">
            <template v-for="(value, key) in reviews">
              <div class="col-12">
                <img style="width: 40px; height: 40px; object-fit: cover; border-radius: 50%"
                     :src="value.avatar.startsWith('http') ? value.avatar : '${pageContext.request.contextPath}' + value.avatar"
                     alt="">
                {{value.username}}
                ({{value.created_at}}) <span style="font-weight: bold" class="bold">{{value.stars}}</span> <img style="max-height: 20px" src="${pageContext.request.contextPath}/assets/img/star-yellow.png" alt="">
                <h6 style="text-indent: 50px; font-weight: bold">{{value.content}}</h6>
              </div>
            </template>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="modal fade" id="bookModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl ">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" ><%= language.getProperty("property_type_add_new") %></h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <form action="${pageContext.request.contextPath}/user/book" method="post">
            <input type="hidden" name="p_id" value="<%=request.getParameter("id")%>">
            <div class="form-group">
              <template v-for="(value,key) in bookings">
                <button type="button" class="btn btn-primary">{{value.from_date}} - {{value.to_date}}</button>
              </template>
            </div>
            <div class="form-group">
              <label for="from_date">Từ ngày</label>
              <input v-on:change="check_from_date()" v-model="from_date" class="form-control" type="date" id="from_date" name="from_date">
            </div>
            <div class="form-group">
              <label for="to_date">Đến ngày</label>
              <input v-on:change="check_to_date()" v-model="to_date" class="form-control" type="date" id="to_date" name="to_date">
            </div>
            <div class="form-group">
              <label for="note">Ghi chú</label>
              <textarea class="form-control" name="note" id="note" style="width: 100%" rows="10"></textarea>
            </div>
            <div class="form-group col-12 mt-2 d-flex justify-content-center">
              <button class="btn btn-primary col-6" type="submit">Đặt phòng</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="/views/master/foot.jsp" %>
<script>
  const contextPath = '${pageContext.request.contextPath}'
  const width = $("#small_imgs").width();
  const each_img_width = Math.floor(width/4);
  var all_small_imgs = []
  const small_image_items = $(".small_images").css({"object-fit": "cover", "max-width": (each_img_width-10) + "px"})
  $(".small_images").attr("hidden", false)
  function changePreview(property_thumb_nail_id, img_id, path, property_id) {
    $("#thumb_nail_" + property_id).attr("src", contextPath + path)
    $("#make_thumb_nail_id_" + property_id).val(img_id)
    if (img_id != property_thumb_nail_id){
      $("#form_thumb_nail_" + property_id).attr("hidden", false)
    } else {
      $("#form_thumb_nail_" + property_id).attr("hidden", true)
    }
    all_small_imgs = $("#small_imgs img")
    for (let i = 0; i < all_small_imgs.length; i++) {
      var temp = $(all_small_imgs[i]).attr("id").split("_")[1]
      if (temp !== property_thumb_nail_id){
        $(all_small_imgs[i]).removeClass("border-3 border-warning")
      }
    }
    if (img_id !== property_thumb_nail_id){
      $("#small_" + img_id).addClass("border-3 border-warning")
    }
  }
</script>
<script>
  var app = new Vue({
    el: "#app",
    data:{
      bookings : [],
      from_date: null,
      to_date: null,
      currentDate : new Date(),
      reviews: ''
    },
    created(){
    },
    methods:{
      load_bookings(){
        console.log(1)
        axios.get('<%=request.getContextPath()%>/user/book?p_id=' + <%=request.getParameter("id")%>)
                .then((res)=>{
                  this.bookings = JSON.parse(res.data.bookings)
                })
      },
      check_from_date(){
        if (this.currentDate.setHours(0, 0, 0, 0) > Date.parse(this.from_date)){
          toastr.warning("phải lớn hơn ngày hiện tại")
          this.from_date = null
        }
        if (this.to_date !== null){
          if (Date.parse(this.from_date) > Date.parse(this.to_date)){
            toastr.warning("ngày kết thúc phải lớn hơn ngày bắt đầu")
            this.from_date = null
          }
        }
        if (this.from_date !== null && this.to_date !== null){
          this.check_dup()
        }
      },
      check_to_date(){
        if (this.from_date !== null){
          if (Date.parse(this.from_date) > Date.parse(this.to_date)){
            toastr.warning("ngày kết thúc phải lớn hơn ngày bắt đầu")
            this.to_date = null
          }
        }
        if (this.from_date !== null && this.to_date !== null){
          this.check_dup()
        }
      },
      check_dup(){
        for (let i = 0; i < this.bookings.length; i++) {
          const startDate = Date.parse(this.bookings[i].from_date);
          const endDate = Date.parse(this.bookings[i].to_date);
          if (Date.parse(this.from_date) >= startDate && Date.parse(this.from_date) <= endDate || Date.parse(this.to_date) >= startDate && Date.parse(this.to_date) <= endDate){
            toastr.warning("Ngày đã bị trùng")
          }
        }
      },
      get_reviews(){
        axios.get('${pageContext.request.contextPath}/get-reviews?p_id=' + <%=request.getParameter("id")%>)
                .then((res)=>{
                  this.reviews = JSON.parse(res.data.reviews)
                })
      }
    },
  })
</script>