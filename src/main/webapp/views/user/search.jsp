<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/views/master/head.jsp" %>
<div id="app">
  <div  class="container-fluid bg-primary mb-5 wow fadeIn" data-wow-delay="0.1s" style="padding: 15px;max-width: 95%; margin: auto;">
    <div class="row g-2">
      <div class="col-md-4">
        <input v-model="keyword" type="text" class="form-control border-0 py-3" placeholder="Search Keyword">
      </div>
      <div class="col-md-4">
        <select name="property_type_id" v-model="form_choosing_property_type_id" class="form-select border-0 py-3">
          <option value="0" selected><%=language.getProperty("search_property_type")%></option>
          <template v-for="(value, key) in property_types">
            <option :value="value.id">{{lang == 'vn' ? value.name_vn : value.name_kr}}</option>
          </template>
        </select>
      </div>
      <div class="col-md-4">
        <div class="dropdown">
          <div class="form-control border-0 py-3 scrollmenu" aria-labelledby="amenities" id="near_locations" data-bs-toggle="dropdown">
            <p style="margin: 0" v-if="user_choose_near_locations.length == 0"><%= language.getProperty("add_property_choose_nearby") %></p>
            <template v-if="user_choose_near_locations.length != 0" v-for="(value, key) in user_choose_near_locations">
              <% if (lang.equals("kr")) { %>
              <button v-on:click="remove_near_location(value.id)" style='height: 28px; border: 0;padding-left: 6px; padding-right: 6px; padding-top: 1px; padding-bottom: 1px; margin-bottom: 1px' class='btn btn-primary'>{{value.name_kr}}</button>&nbsp;
              <% } else { %>
              <button v-on:click="remove_near_location(value.id)" style='height: 28px; border: 0;padding-left: 6px; padding-right: 6px; padding-top: 1px; padding-bottom: 1px; margin-bottom: 1px' class='btn btn-primary'>{{value.name_vn}}</button>&nbsp;
              <% } %>
            </template>
          </div>
          <ul style="max-height: 400px;overflow-y: scroll" class="dropdown-menu col-12">
            <template v-for="(value, key) in near_locations">
              <% if (lang.equals("kr")) { %>
              <li v-on:click="choose_near_location(value.id)" class="dropdown-item">{{value.name_kr}}</li>
              <% } else { %>
              <li v-on:click="choose_near_location(value.id)" class="dropdown-item">{{value.name_vn}}</li>
              <% } %>
            </template>
          </ul>
        </div>
      </div>
      <div class="col-md-4">
        <div class="dropdown">
          <div  class="form-control border-0 py-3 scrollmenu" aria-labelledby="amenities" id="amenities" data-bs-toggle="dropdown">
            <p style="margin: 0" v-if="user_choose_amenity.length == 0"><%= language.getProperty("add_property_choose_amenities") %></p>
            <template v-if="user_choose_amenity.length != 0" v-for="(value, key) in user_choose_amenity">
              <% if (lang.equals("kr")) { %>
              <button v-on:click="remove_amenity(value.id)" style='height: 28px; border: 0;padding-left: 6px; padding-right: 6px; padding-top: 1px; padding-bottom: 1px; margin-bottom: 1px' class='btn btn-primary'>{{value.name_kr}}</button>&nbsp;
              <% } else { %>
              <button v-on:click="remove_amenity(value.id)" style='height: 28px; border: 0;padding-left: 6px; padding-right: 6px; padding-top: 1px; padding-bottom: 1px; margin-bottom: 1px' class='btn btn-primary'>{{value.name_vn}}</button>&nbsp;
              <% } %>
            </template>
          </div>
          <ul style="max-height: 400px;overflow-y: scroll" class="dropdown-menu col-12">
            <template v-for="(value, key) in amenities">
              <% if (lang.equals("kr")) { %>
              <li v-on:click="choose_amenity(value.id)" class="dropdown-item">{{value.name_kr}}</li>
              <% } else { %>
              <li v-on:click="choose_amenity(value.id)" class="dropdown-item">{{value.name_vn}}</li>
              <% } %>
            </template>
          </ul>
        </div>
      </div>
      <div class="col-md-3">
        <select name="province_id" v-model="form_choosing_province_id" class="form-select border-0 py-3">
          <option value="0" selected><%=language.getProperty("search_province")%></option>
          <template v-for="(value, key) in provinces">
            <option :value="value.id">{{value.name}}</option>
          </template>
        </select>
      </div>
      <div class="col-md-3">
        <select name="district_id" v-model="form_choosing_district_id" class="form-select border-0 py-3">
          <option value="0" selected><%=language.getProperty("search_district")%></option>
          <template v-for="(value, key) in districts">
            <option v-if="form_choosing_province_id == value.province_id" :value="value.id">{{value.name}}</option>
          </template>
        </select>
      </div>
      <div class="col-md-2">
        <button v-on:click="search()" class="btn btn-dark border-0 w-100 py-3">Search</button>
      </div>
    </div>
  </div>
  <div class="container-xxl py-5">
    <div class="container">
      <div class="row g-0 gx-5 align-items-end">
        <div class="col-lg-6">
          <div class="text-start mx-auto mb-5 wow slideInLeft" data-wow-delay="0.1s">
            <h1 class="mb-3"><%=language.getProperty("search_result")%></h1>
            <p>Eirmod sed ipsum dolor sit rebum labore magna erat. Tempor ut dolore lorem kasd vero ipsum sit eirmod sit diam justo sed rebum.</p>
          </div>
        </div>
        <div class="col-lg-6 text-start text-lg-end wow slideInRight" data-wow-delay="0.1s">
          <ul class="nav nav-pills d-inline-flex justify-content-end mb-5">
            <li class="nav-item me-2">
              <a :class="{'btn btn-outline-primary active': for_sale == -1, 'btn btn-outline-primary': for_sale != -1}" v-on:click="change_type(-1)"><%=language.getProperty("search_all")%></a>
            </li>
            <li class="nav-item me-2">
              <a :class="{'btn btn-outline-primary active': for_sale == 0, 'btn btn-outline-primary': for_sale != 0}" v-on:click="change_type(0)"><%=language.getProperty("search_rent")%></a>
            </li>
            <li class="nav-item me-0">
              <a :class="{'btn btn-outline-primary active': for_sale == 1, 'btn btn-outline-primary': for_sale != 1}" v-on:click="change_type(1)"><%=language.getProperty("search_sale")%></a>
            </li>
          </ul>
        </div>
      </div>
      <div class="tab-content">
        <div id="tab-1" class="tab-pane fade show p-0 active">
          <div class="row g-4">
            <template v-for="(value, key) in properties">
              <div class="col-lg-4 col-md-6 wow fadeInUp">
                <div class="property-item rounded overflow-hidden">
                  <div class="position-relative overflow-hidden">
                    <a href=""><img class="img-fluid" :src="context + value.thumbnail" alt=""></a>
                    <div class="bg-primary rounded text-white position-absolute start-0 top-0 m-4 py-1 px-3">{{value.for_sale == '1' ? '<%=language.getProperty("search_sale")%>' : '<%=language.getProperty("search_rent")%>'}}</div>
                    <div class="bg-white rounded-top text-primary position-absolute start-0 bottom-0 mx-4 pt-1 px-3">{{lang == 'vn' ? value.property_type_name_vn : value.property_type_name_kr}}</div>
                  </div>
                  <div class="p-4 pb-0">
                    <h5 class="text-primary mb-3">{{Number(value.price).toLocaleString()}}₫</h5>
                    <a class="d-block h5 mb-2" href="">{{lang == 'vn' ? value.name_vn : value.name_kr}}</a>
                    <p><i class="fa fa-map-marker-alt text-primary me-2"></i>{{value.address}}, {{getDistrictName(value.district_id)}}, {{getProvinceName(value.province_id)}}</p>
                  </div>
                  <div class="d-flex border-top">
                    <small class="flex-fill text-center border-end py-2"><i class="fa fa-ruler-combined text-primary me-2"></i>{{value.area}} m²</small>
                    <small class="flex-fill text-center border-end py-2"><i class="fa fa-bed text-primary me-2"></i>{{value.bedrooms}} <%=language.getProperty("search_bedrooms")%></small>
                    <small class="flex-fill text-center py-2"><i class="fa fa-bath text-primary me-2"></i>{{value.bathrooms}} <%=language.getProperty("search_bathrooms")%></small>
                  </div>
                </div>
              </div>
            </template>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<%@ include file="/views/master/foot.jsp" %>
<script>
  var app = new Vue({
    el: "#app",
    data:{
      amenities: [],
      property_types: [],
      near_locations: [],
      provinces: [],
      districts: [],
      properties: [],

      form_choosing_province_id: 0,
      form_choosing_district_id: 0,
      form_choosing_property_type_id: 0,
      keyword: '',
      for_sale: -1,

      user_choose_amenity: [],
      user_choose_near_locations: [],
      lang: '<%=lang%>',
      context: '<%=request.getContextPath()%>'
    },
    created(){
      this.getAllData();
    },
    methods:{
      getAllData(){
        axios.get('<%=request.getContextPath()%>/api/get-amenities')
                .then((res)=>{
                  this.amenities = JSON.parse(res.data.amenities)
                })
        axios.get('<%=request.getContextPath()%>/api/get-property-types')
                .then((res)=>{
                  this.property_types = JSON.parse(res.data.property_type_list)
                })
        axios.get('<%=request.getContextPath()%>/api/get-near-locations')
                .then((res)=>{
                  this.near_locations = JSON.parse(res.data.locations)
                })
        axios.get('<%=request.getContextPath()%>/api/get-locations')
                .then((res)=>{
                  this.provinces = JSON.parse(res.data.provinces_list)
                  this.districts = JSON.parse(res.data.districts_list)
                })
      },
      choose_amenity(id){
        for (let i = 0; i < this.amenities.length; i++) {
          if (this.amenities[i].id === id){
            this.user_choose_amenity.push(this.amenities[i])
            this.amenities.splice(i, 1)
          }
        }
      },
      remove_amenity(id){
        for (let i = 0; i < this.user_choose_amenity.length; i++) {
          if (this.user_choose_amenity[i].id === id){
            this.amenities.push(this.user_choose_amenity[i])
            this.user_choose_amenity.splice(i, 1)
          }
        }
      },
      choose_near_location(id){
        for (let i = 0; i < this.near_locations.length; i++) {
          if (this.near_locations[i].id === id){
            this.user_choose_near_locations.push(this.near_locations[i])
            this.near_locations.splice(i, 1)
          }
        }
      },
      remove_near_location(id){
        for (let i = 0; i < this.user_choose_near_locations.length; i++) {
          if (this.user_choose_near_locations[i].id === id){
            this.near_locations.push(this.user_choose_near_locations[i])
            this.user_choose_near_locations.splice(i,1)
          }
        }
      },
      search(){
        const form = new FormData();
        form.append("property_type_id", this.form_choosing_property_type_id)
        form.append("province_id", this.form_choosing_province_id)
        form.append("district_id", this.form_choosing_district_id)
        form.append("keyword", this.keyword)
        form.append("amenities", this.user_choose_amenity.map(item => item.id).join(","))
        form.append("near_locations", this.user_choose_near_locations.map(item => item.id).join(","))
        form.append("for_sale", this.for_sale)
        axios.post('<%=request.getContextPath()%>/search', form, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        }).then((res)=>{
          this.properties = JSON.parse(res.data.properties)
          console.log(this.properties)
        })
      },
      getProvinceName(id){
        for (let i = 0; i < this.provinces.length; i++) {
          if (this.provinces[i].id == id){
            return this.provinces[i].name
          }
        }
      },
      getDistrictName(id){
        for (let i = 0; i < this.districts.length; i++) {
          if (this.districts[i].id == id){
            return this.districts[i].name
          }
        }
      },
      change_type(value){
        this.for_sale = value
        this.search()
      }
    }
  })
</script>