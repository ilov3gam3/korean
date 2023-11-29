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
        <h3>tên tiếng việt:  <%=property.getName_vn()%></h3>
        <h3>tên tiếng hàn:  <%=property.getName_kr()%></h3>
        <p>mô tả tiếng việt: <%=property.getDescription_vn()%></p>
        <p>mô tả tiếng hàn: <%=property.getDescription_kr()%></p>
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
            Số tầng: <%=property.getFloor_numbers()%>
          </div>
          <div class="col-3">
            Ở tầng: <%=property.getAt_floor()%>
          </div>
          <div class="col-3">
            Số phòng tắm: <%=property.getBathrooms()%>
          </div>
          <div class="col-3">
            Số phòng ngủ: <%=property.getBedrooms()%>
          </div>
        </div>
        <div class="col-12 row">
          <div class="col-9">
            <p style="margin-top: 4px">Địa chỉ: <%=property.getAddress()%>, <%=property.getDistrict_name()%>, <%=property.getProvince_name()%></p>
          </div>
          <div class="col-3">
            <% if (property.getFor_sale().equals("1")){%>
              <% if (property.getSold().equals("1")){ %>
                <button class="btn btn-success" style="width: 100%">Đã bán</button>
              <% } else { %>
                <button class="btn btn-warning" style="width: 100%">Chưa bán</button>
              <% } %>
            <%} else { %>
            <button class="btn btn-primary" style="width: 100%">Cho thuê</button>
            <% } %>
          </div>
        </div>
        <div class="col-12 row">
          <div class="col-9">
            <p>Tiện ích:
              <% for (int j = 0; j < amenities.size(); j++) {%>
                  <%if (lang.equals("kr")){ %>
                    <%=amenities.get(j).getName_kr()%>,
                  <% } else { %>
                    <%=amenities.get(j).getName_vn()%>,
                  <% } %>
              <% } %>
            </p>
            <p>Ở gần:
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
          <p>Số điện thoại: <%=property.getPhone()%></p>
          <p>Email: <%=property.getEmail()%></p>
        </div>
      </div>
    </div>
    <div class="col-12 row">
      <%=property.getGg_map_api()%>
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
