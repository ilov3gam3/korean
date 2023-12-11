<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="Database.DB" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<%ArrayList<MyObject> counts = DB.getData("SELECT SUM(CASE WHEN hidden = 1 THEN 1 ELSE 0 END) AS hidden_count, SUM(CASE WHEN hidden = 0 THEN 1 ELSE 0 END) AS not_hidden_count FROM properties where user_id = ?", new String[]{user.id}, new String[]{"hidden_count", "not_hidden_count"}); %>
<% ArrayList<MyObject> properties = (ArrayList<MyObject>) request.getAttribute("properties");%>
<% ArrayList<MyObject> images = (ArrayList<MyObject>) request.getAttribute("images");%>
<% ArrayList<MyObject> property_near_location = (ArrayList<MyObject>) request.getAttribute("property_near_location");%>
<% ArrayList<MyObject> property_amenities = (ArrayList<MyObject>) request.getAttribute("property_amenities");%>
<% ArrayList<MyObject> number_of_property = (ArrayList<MyObject>) request.getAttribute("number_of_property");%>
<% ArrayList<MyObject> subs = (ArrayList<MyObject>) request.getAttribute("subs");%>
<div id="app">
    <div class="container mt-2">
        <%if(subs.size() != 0){ %>
            <h4><%=language.getProperty("view_properties_max_property").replace("123", subs.get(0).getNumber_of_property())%></h4>
            <h4><%=language.getProperty("view_properties_total_property")%>: <%=Integer.parseInt(counts.get(0).getHidden_count()) + Integer.parseInt(counts.get(0).getNot_hidden_count())%></h4>
            <h4 id="hidden_prop"></h4>
            <h4 id="not_hidden_prop"></h4>
        <% } else { %>
            <h4><%=language.getProperty("view_properties_total_property")%>: <%=Integer.parseInt(counts.get(0).getHidden_count()) + Integer.parseInt(counts.get(0).getNot_hidden_count())%></h4>
            <h4 id="hidden_prop"></h4>
            <h4 id="not_hidden_prop"></h4>
        <% } %>
    </div>
<% for (int i = 0; i < properties.size(); i++) { %>
    <div class="p-2 mb-4 bg-body-tertiary rounded-3">
        <div class="container-fluid py-5">
            <div class="col-12 row">
                <div class="col-4">
                    <div class="row col-12">
                        <div class="row">
                            <%String thumb_nail_id = "";%>
                                <% for (int j = 0; j < images.size(); j++) { %>
                                <% if (images.get(j).getProperty_id().equals(properties.get(i).getId()) && images.get(j).getIs_thumb_nail().equals("1")){%>
                                <img id="thumb_nail_<%=properties.get(i).getId()%>" class="p-0 img-thumbnail border-4 border-dark" src="${pageContext.request.contextPath}<%=images.get(j).getPath()%>" alt="" style="max-width: 100%; object-fit: cover">
                                <%thumb_nail_id = images.get(j).getId();%>
                                <% } %>
                            <% } %>
                        </div>
                        <div class="row" id="small_imgs_<%=properties.get(i).getId()%>">
                            <% String img_json = "["; %>
                            <% for (int j = 0; j < images.size(); j++) { %>
                                <% if (images.get(j).getProperty_id().equals(properties.get(i).getId())){%>
                                <% img_json += "{'id': '"+images.get(j).getId()+"', 'path': '"+images.get(j).getPath()+"', 'is_thumbnail' : '"+images.get(j).getIs_thumb_nail()+"'},"; %>
                                <img id="small_<%=images.get(j).getId()%>" onclick="changePreview('<%=thumb_nail_id%>', '<%=images.get(j).getId()%>', '<%=images.get(j).getPath()%>', '<%=properties.get(i).getId()%>')" hidden="hidden" class="small_images m-1 p-0 img-thumbnail <%=images.get(j).getIs_thumb_nail().equals("1") ? "border-3 border-primary" : ""%>" src="${pageContext.request.contextPath}<%=images.get(j).getPath()%>" alt="">
                                <% }%>
                            <% } %>
                            <% img_json += "]";%>
                        </div>
                        <form>
                            <button type="button" data-bs-toggle="modal" data-bs-target="#editImageModal" v-on:click="change_img(<%=img_json%>, <%=properties.get(i).getId()%>)" class="btn btn-primary mb-1" style="width: 100%"><%=language.getProperty("view_properties_update_img")%></button>
                        </form>
                        <form id="form_thumb_nail_<%=properties.get(i).getId()%>" hidden="hidden" action="${pageContext.request.contextPath}/user/change-thumb-nail" method="post" >
                            <input type="hidden" name="p_id" value="<%=properties.get(i).getId()%>">
                            <input hidden="hidden" type="text" id="make_thumb_nail_id_<%=properties.get(i).getId()%>" name="img_id">
                            <button type="submit" style="width: 100%" class="btn btn-primary"><%=language.getProperty("view_properties_set_default_img")%></button>
                        </form>
                    </div>
                </div>
                <div class="col-8">
                    <h3>tên tiếng việt:  <%=properties.get(i).getName_vn()%></h3>
                    <h3>tên tiếng hàn:  <%=properties.get(i).getName_kr()%></h3>
                    <p>mô tả tiếng việt: <%=properties.get(i).getDescription_vn()%></p>
                    <p>mô tả tiếng hàn: <%=properties.get(i).getDescription_kr()%></p>
                    <div class="col-12 row">
                        <div class="col-3">
                            Loại nhà ở:
                            <% if (lang.equals("vn")) {%>
                            <%=properties.get(i).getProperty_type_name_vn()%>
                            <% } else { %>
                            <%=properties.get(i).getProperty_type_name_kr()%>
                            <% } %>
                        </div>
                        <div class="col-3">
                            <%=language.getProperty("add_property_type")%>:
                            <%if (properties.get(i).getFor_sale().equals("1")){%>
                            <%=language.getProperty("add_property_type_sale")%>
                            <% } else { %>
                            <%=properties.get(i).getProperty_type_name_kr()%>
                            <%=language.getProperty("add_property_type_rent")%>:
                            <% } %>
                        </div>
                        <div class="col-3">
                            <%NumberFormat formatter = new DecimalFormat("#0");%>
                            <%=language.getProperty("add_property_price")%>: <%=formatter.format(Double.parseDouble(properties.get(i).getPrice()))%> ₫
                        </div>
                        <div class="col-3">
                            <%=language.getProperty("add_property_area")%>: <%=properties.get(i).getArea()%> m²
                        </div>
                    </div>
                    <div class="col-12 row">
                        <div class="col-3">
                            Số tầng: <%=properties.get(i).getFloor_numbers()%>
                        </div>
                        <div class="col-3">
                            Ở tầng: <%=properties.get(i).getAt_floor()%>
                        </div>
                        <div class="col-3">
                            Số phòng tắm: <%=properties.get(i).getBathrooms()%>
                        </div>
                        <div class="col-3">
                            Số phòng ngủ: <%=properties.get(i).getBedrooms()%>
                        </div>
                    </div>
                    <div class="col-12 row">
                        <div class="col-6">
                            <p style="margin-top: 4px">Địa chỉ: <%=properties.get(i).getAddress()%>, <%=properties.get(i).getDistrict_name()%>, <%=properties.get(i).getProvince_name()%></p>
                        </div>
                        <div class="col-3">
                            <% if (properties.get(i).getHidden().equals("1")) {%>
                            <button id="hidden_btn_id_<%=properties.get(i).getId()%>" onclick="changeHidden('<%=properties.get(i).getId()%>')" title="Hiện nhà ở này" class="btn btn-danger" style="width: 100%">Đang bị ẩn</button>
                            <% } else { %>
                            <button id="hidden_btn_id_<%=properties.get(i).getId()%>" onclick="changeHidden('<%=properties.get(i).getId()%>')" title="Ẩn nhà ở này" class="btn btn-success" style="width: 100%">Đang hiển thị</button>
                            <% } %>
                        </div>
                        <div class="col-3">
                            <% if (properties.get(i).getFor_sale().equals("1")){%>
                            <% if (properties.get(i).getSold().equals("1")){ %>
                            <button id="btn_sold_<%=properties.get(i).getId()%>" onclick="changeSold('<%=properties.get(i).getId()%>')" class="btn btn-success" style="width: 100%">Đã bán</button>
                            <% } else { %>
                            <button id="btn_sold_<%=properties.get(i).getId()%>" onclick="changeSold('<%=properties.get(i).getId()%>')" class="btn btn-warning" style="width: 100%">Chưa bán</button>
                            <% } %>
                            <%} else { %>
                            <button class="btn btn-dark" disabled style="width: 100%">Cho thuê</button>
                            <% } %>
                        </div>
                    </div>
                    <div class="col-12 row">
                        <div class="col-9">
                            <p>Tiện ích:
                                <% String temp_amenities = ""; %>
                                <% for (int j = 0; j < property_amenities.size(); j++) {%>
                                <% if (property_amenities.get(j).getProperty_id().equals(properties.get(i).getId())){
                                    temp_amenities += property_amenities.get(j).getAmenity_id() + "|"; %>
                                <%if (lang.equals("kr")){ %>
                                <%=property_amenities.get(j).getAmenity_name_kr()%>,
                                <% } else { %>
                                <%=property_amenities.get(j).getAmenity_name_vn()%>,
                                <% } %>
                                <% } %>
                                <% } %>
                            </p>
                            <p>Ở gần:
                                <% String temp_near_locations = ""; %>
                                <% for (int j = 0; j < property_near_location.size(); j++) {%>
                                <% if (property_near_location.get(j).getProperty_id().equals(properties.get(i).getId())){
                                    temp_near_locations += property_near_location.get(j).getNear_location_id() + "|";%>
                                <%if (lang.equals("kr")){ %>
                                <%=property_near_location.get(j).getNearby_location_name_kr()%>,
                                <% } else { %>
                                <%=property_near_location.get(j).getNearby_location_name_vn()%>,
                                <% } %>
                                <% } %>
                                <% } %>
                            </p>
                            <button v-on:click="view_map('<%=properties.get(i).gg_map_api.replace("\"", "`")%>')" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#viewMapModel">Xem bản đồ</button>
                        </div>
                        <div class="col-3">
                            <button v-on:click="addValueModalVue('<%=temp_amenities%>', '<%=temp_near_locations%>')" onclick="addValueModal('<%=properties.get(i).getName_vn()%>', '<%=properties.get(i).getName_kr()%>', '<%=properties.get(i).getDescription_vn()%>', '<%=properties.get(i).getDescription_kr()%>', '<%=properties.get(i).getId()%>', '<%=formatter.format(Double.parseDouble(properties.get(i).getPrice()))%>', '<%=properties.get(i).getArea()%>', '<%=properties.get(i).getFloor_numbers()%>', '<%=properties.get(i).getAt_floor()%>', '<%=properties.get(i).getAddress()%>', '<%=properties.get(i).getBathrooms()%>', '<%=properties.get(i).getBedrooms()%>','<%=properties.get(i).getFor_sale()%>', '<%=properties.get(i).getProvince_id()%>', '<%=properties.get(i).getDistrict_id()%>', '<%=properties.get(i).getProperty_type()%>', '<%=properties.get(i).getGg_map_api().replace("\"", "`")%>')" data-bs-toggle="modal" data-bs-target="#editModal" style="width: 100%" class="btn btn-warning">Chỉnh sửa</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
<% } %>
<div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-xl ">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel"><%= language.getProperty("property_type_add_new") %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="col-md-12">
                        <form action="${pageContext.request.contextPath}/user/update-property" method="post">
                            <input type="hidden" name="p_id" id="update_form_p_id">
                            <div class="col-12">
                                <div class="col-md-12">
                                    <div class="form-group mt-1 mb-1">
                                        <label for="name_vn"><%= language.getProperty("add_property_name_vn") %></label>
                                        <div class="row">
                                            <div class="col-8">
                                                <input required class="form-control" type="text" name="name_vn" id="name_vn">
                                            </div>
                                            <div class="col-4">
                                                <button type="button" id="trans_to_kr" class="btn btn-primary" style="width: 100%"><%= language.getProperty("add_property_tran2kr") %></button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-group mt-1 mb-1">
                                        <label for="name_kr"><%= language.getProperty("add_property_name_kr") %></label>
                                        <div class="row">
                                            <div class="col-md-8">
                                                <input required class="form-control" type="text" name="name_kr" id="name_kr">
                                            </div>
                                            <div class="col-md-4">
                                                <button type="button" id="trans_to_vn" class="btn btn-primary" style="width: 100%"><%= language.getProperty("add_property_tran2vn") %></button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="col-md-12">
                                    <div class="form-group mt-1 mb-1">
                                        <div class="row">
                                            <div class="col-8">
                                                <label for="description_vi"><%= language.getProperty("add_property_des_vn") %></label>
                                            </div>
                                            <div class="col-4">
                                                <button type="button" id="trans_des_to_kr" class="btn btn-primary" style="width: 100%"><%= language.getProperty("add_property_tran2kr") %></button>
                                            </div>
                                        </div>
                                        <textarea required class="form-control" name="description_vi" id="description_vi" rows="8"
                                                  style="width: 100%"></textarea>
                                    </div>
                                </div>
                                <div class="col-md-12">
                                    <div class="form-group mt-1 mb-1">
                                        <div class="row">
                                            <div class="col-8">
                                                <label for="description_kr"><%= language.getProperty("add_property_des_kr") %></label>
                                            </div>
                                            <div class="col-4">
                                                <button type="button" id="trans_des_to_vi" class="btn btn-primary" style="width: 100%"><%= language.getProperty("add_property_tran2vn") %></button>
                                            </div>
                                        </div>
                                        <textarea required class="form-control" name="description_kr" id="description_kr" rows="8"
                                                  style="width: 100%"></textarea>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 row">
                                <div class="col-3">
                                    <label><%= language.getProperty("add_property_type") %></label>
                                    <div class="row">
                                        <div class="col-md-6">
                                            <input type="radio" id="yes" name="sale" value="true">
                                            <label for="yes"><%= language.getProperty("add_property_type_sale") %></label>
                                        </div>
                                        <div class="col-md-6">
                                            <input type="radio" id="no" name="sale" value="false">
                                            <label for="no"><%= language.getProperty("add_property_type_rent") %></label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-3">
                                    <label for="update_property_type"><%= language.getProperty("add_property_choose_type") %></label>
                                    <select required class="form-control" name="property_type" id="update_property_type">
                                        <option value=""><%= language.getProperty("add_property_choose_type") %></option>
                                        <% ArrayList<MyObject> property_list = (ArrayList<MyObject>) request.getAttribute("property_list");%>
                                        <% if (lang.equals("kr")) { %>
                                        <% for (int z = 0; z < property_list.size(); z++) { %>
                                        <option value="<%=property_list.get(z).getId()%>"><%=property_list.get(z).getName_kr()%></option>
                                        <% } %>
                                        <% } else { %>
                                        <% for (int z = 0; z < property_list.size(); z++) { %>
                                        <option value="<%=property_list.get(z).getId()%>"><%=property_list.get(z).getName_vn()%></option>
                                        <% } %>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col-3">
                                    <label for="update_price">Giá</label>
                                    <input type="text" class="form-control" name="update_price" id="update_price">
                                </div>
                                <div class="col-3">
                                    <label for="update_area">Diện tích m²</label>
                                    <input type="text" class="form-control" name="update_area" id="update_area">
                                </div>
                            </div>
                            <div class="col-12 row">
                                <div class="col-3">
                                    <label for="update_province_id"><%= language.getProperty("add_property_choose_province") %></label>
                                    <select data-placeholder="Chọn thành phố" required class="form-control" name="province_id" id="update_province_id" onchange="change_district(this.value)">
                                        <option value=""><%= language.getProperty("add_property_choose_province") %></option>
                                        <c:forEach var="province" items="${provinces_list}">
                                            <option value="${province.getId()}">${province.getName()}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-3">
                                    <label for="update_district_id"><option value=""><%= language.getProperty("add_property_choose_district") %></option></label>
                                    <select required class="form-control" name="district_id" id="update_district_id">

                                    </select>
                                </div>
                                <div class="col-3">
                                    <label for="update_floor_num"><%= language.getProperty("add_property_number_floor") %></label>
                                    <input required type="number" class="form-control" name="floor_numbers" min="1" id="update_floor_num">
                                </div>
                                <div class="col-3">
                                    <label for="update_at_floor"><%= language.getProperty("add_property_at_floor") %></label>
                                    <input required type="number" class="form-control" name="at_floor" min="1" id="update_at_floor">
                                </div>
                            </div>
                            <div class="col-12 row">
                                <div class="col-8">
                                    <label for="update_address"><%= language.getProperty("add_property_address") %></label>
                                    <input required type="text" class="form-control" name="address" id="update_address">
                                </div>
                                <div class="col-2">
                                    <label for="update_bathrooms"><%= language.getProperty("add_property_bath_room") %></label>
                                    <input type="number" class="form-control" name="bathrooms" id="update_bathrooms">
                                </div>
                                <div class="col-2">
                                    <label for="update_bedrooms"><%= language.getProperty("add_property_bed_room") %></label>
                                    <input type="number" class="form-control" name="bedrooms" id="update_bedrooms">
                                </div>
                            </div>
                            <div class="col-12 row">
                                <div class="col-6">
                                    <input type="hidden" name="amenity_id" v-model="user_choose_amenity_str">
<%--                                    <input type="hidden" name="amenity_id" :value="user_choose_amenity_str">--%>
                                    <label ><%= language.getProperty("add_property_choose_amenities") %></label>
                                    <div class="dropdown">
                                        <div class="form-control" aria-labelledby="amenities" id="amenities" data-bs-toggle="dropdown">
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
                                <div class="col-6">
                                    <label ><%= language.getProperty("add_property_choose_nearby") %></label>
                                    <input type="hidden" name="nearby_location_id" :value="user_choose_near_locations_str">
                                    <div class="dropdown">
                                        <div class="form-control" aria-labelledby="amenities" id="near_locations" data-bs-toggle="dropdown">
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
                            </div>
                            <div class="col-12 row">
                                <div class="form-group">
                                    <label for="gg_map_api"><%=language.getProperty("gg_map_api")%> <a target="_blank" href="https://www.google.com/search?q=h%C6%B0%E1%BB%9Bng+d%E1%BA%ABn+l%E1%BA%A5y+link+google+map&oq=h%C6%B0%E1%BB%9Bng+d%E1%BA%ABn+l%E1%BA%A5y+link+google+map&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIICAEQABgWGB4yCAgCEAAYFhge0gEJMTE2MDdqMGoxqAIAsAIA&sourceid=chrome&ie=UTF-8"><%=language.getProperty("gg_map_api_tut")%></a></label>
                                    <input id="gg_map_api" name="gg_map_api" type="text" class="form-control">
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary mt-2" style="width: 100%">Cập nhật</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
<div class="modal fade" id="editImageModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-xl ">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><%= language.getProperty("property_type_add_new") %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="col-md-12">
                        <div class="row">
                            <template v-for="(value, key) in change_img_json">
                                <div class="col-4">
                                    <button v-on:click="remove_img(value.id)" type="button" class="btn-close" aria-label="Close"></button>
                                    <img v-on:click="make_thumb_nail(key)" :class="{'border-4 border-primary': value.is_thumbnail == '1'}" style="width: 100%; max-height: 300px; object-fit: cover" class="m-1 img-thumbnail" :id="value.id" :src="contextPath + value.path" alt="">
                                </div>
                            </template>
                        </div>
                    </div>
                </div>
                <div class="modal-body">
                    <div class="col-md-12">
                        <div class="row">
                            <template v-for="(value, key) in preview_images">
                                <div class="col-4">
                                    <img style="width: 100%; max-height: 300px; object-fit: cover" :src="value" alt="">
                                </div>
                            </template>
                        </div>
                    </div>
                </div>

                <div class="modal-body">
                    <form action="${pageContext.request.contextPath}/user/update-property-image" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="p_id" v-model="p_id">
                        <input type="hidden" name="remove" :value="to_remove_img_id.join(',')">
                        <label class="btn btn-secondary float-start" for="addImg"><%=language.getProperty("add_property_add_img")%></label>
                        <input id="addImg" hidden="hidden" name="images" type="file" accept="image/*" multiple v-on:change="inputFile($event)">
                        <button type="submit" class="btn btn-primary float-end"><%=language.getProperty("amenities_edit")%></button>
                    </form>
                </div>
            </div>
        </div>
    </div>
<div class="modal fade" id="viewMapModel" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-xl ">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><%= language.getProperty("property_type_add_new") %></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body col-12 row" id="view_map">

                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="../master/foot.jsp" %>
<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.6.0/axios.min.js" integrity="sha512-WrdC3CE9vf1nBf58JHepuWT4x24uTacky9fuzw2g/3L9JkihgwZ6Cfv+JGTtNyosOhEmttMtEZ6H3qJWfI7gIQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
<script>
    var addModal = $("#editModal");
    var district_json  = JSON.parse('[<c:forEach var="district" items="${districts_list}"> {"id":"${district.getId()}", "name":"${district.getName()}", "province_id":"${district.getProvince_id()}"}, </c:forEach>]'.replace(", ]", "]"))
    addModal.on('show.bs.modal', function () {
        // $("#navbar").attr("hidden", true)
    })
    addModal.on('hidden.bs.modal', function () {
        // $("#navbar").attr("hidden", false)
        $("#name_vn").val('')
        $("#name_kr").val('')
        $("#description_vi").text('')
        $("#description_kr").text('')
        $("#update_form_p_id").val('')
    })
    const contextPath = '${pageContext.request.contextPath}'
    const width = $("#small_imgs_<%=properties.get(0).getId()%>").width();
    const each_img_width = Math.floor(width/4);
    const small_image_items = $(".small_images").css({"object-fit": "cover", "max-width": (each_img_width-8) + "px"})
    var all_small_imgs = []
    var count_hidden = <%=counts.get(0).getHidden_count()%>
    var count_not_hidden = <%=counts.get(0).getNot_hidden_count()%>
    var number_of_property = <%=number_of_property.get(0).getNumber_of_property()%>
    $("#hidden_prop").text("Bị ẩn: " + count_hidden)
    $("#not_hidden_prop").text("Đang hiển thị: " + count_not_hidden)
    $(".small_images").attr("hidden", false)
    function changeHidden(p_id) {
        const payload = new FormData();
        payload.append("p_id", p_id);
        axios.post('${pageContext.request.contextPath}/user/change-hidden', payload,{
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        })
            .then((res)=>{
                if (res.data.status){
                    toastr.success(res.data.message)
                    var hidden_btn = $("#hidden_btn_id_" + p_id)
                    if (hidden_btn.attr("class") === "btn btn-success"){
                        count_not_hidden--
                        count_hidden++
                        $("#hidden_btn_id_" + p_id).attr("class", "btn btn-danger")
                        $("#hidden_btn_id_" + p_id).text("Đang bị ẩn")
                    } else {
                        count_not_hidden++
                        count_hidden--
                        $("#hidden_btn_id_" + p_id).attr("class", "btn btn-success")
                        $("#hidden_btn_id_" + p_id).text("Đang hiển thị")
                    }
                    $("#hidden_prop").text("Bị ẩn: " + count_hidden)
                    $("#not_hidden_prop").text("Đang hiển thị: " + count_not_hidden)
                } else {
                    toastr.error(res.data.message)
                }
            })
    }
    function changeSold(p_id) {
        const payload = new FormData();
        payload.append("p_id", p_id);
        axios.post('${pageContext.request.contextPath}/user/change-sold', payload,{
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        })
            .then((res)=>{
                if (res.data.status){
                    toastr.success("Thay đổi thành công.")
                    var hidden_btn = $("#btn_sold_" + p_id)
                    if (hidden_btn.attr("class") === "btn btn-success"){
                        $("#btn_sold_" + p_id).attr("class", "btn btn-warning")
                        $("#btn_sold_" + p_id).text("Chưa bán")
                    } else {
                        $("#btn_sold_" + p_id).attr("class", "btn btn-success")
                        $("#btn_sold_" + p_id).text("Đã bán")
                    }
                } else {
                    toastr.error("Thay đổi không thành công.")
                }
            })
    }
    function changePreview(property_thumb_nail_id, img_id, path, property_id) {
        $("#thumb_nail_" + property_id).attr("src", contextPath + path)
        $("#make_thumb_nail_id_" + property_id).val(img_id)
        if (img_id != property_thumb_nail_id){
            $("#form_thumb_nail_" + property_id).attr("hidden", false)
        } else {
            $("#form_thumb_nail_" + property_id).attr("hidden", true)
        }
        all_small_imgs = $("#small_imgs_" + property_id + " img")
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
    let detected_language = ''
    let translated_text = ''
    async function translate(text, dest_language) {
        const headers = {
            'content-type': 'application/json',
            'X-RapidAPI-Key': '8c097a023emshc05d42ee306c7ffp15496bjsn2774e3429545',
            'X-RapidAPI-Host': 'microsoft-translator-text.p.rapidapi.com'
        }
        params = {
            'to[0]': dest_language,
            'api-version': '3.0',
            profanityAction: 'NoAction',
            textType: 'plain'
        }
        const data = [
            {
                Text: text
            }
        ]
        await axios.post('https://microsoft-translator-text.p.rapidapi.com/translate', data, {
            headers: headers,
            params: params
        })
            .then((res) => {
                detected_language = res.data[0].detectedLanguage.language
                translated_text = res.data[0].translations[0].text
            })
    }
    $("#trans_to_kr").on('click', async function () {
        await translate($("#name_vn").val(), 'ko')
        $("#name_kr").val(translated_text)
        translated_text = ''
    });
    $("#trans_to_vn").on('click', async function () {
        await translate($("#name_kr").val(), 'vi')
        $("#name_vn").val(translated_text)
        translated_text = ''
    });$("#trans_des_to_kr").on('click',async function () {
        await translate($("#description_vi").val(), 'ko')
        $("#description_kr").val(translated_text)
        translated_text = ''
    })
    $("#trans_des_to_vi").on('click',async function () {
        await translate($("#description_kr").val(), 'vi')
        $("#description_vi").val(translated_text)
        translated_text = ''
    })
    function addValueModal(name_vn, name_kr, des_vn, des_kr, p_id, price, area, floor_num, at_floor, address, bathrooms, bedrooms, for_sale, province_id, district_id, property_type, map) {
        $("#name_vn").val(name_vn)
        $("#name_kr").val(name_kr)
        $("#description_vi").text(des_vn)
        $("#description_kr").text(des_kr)
        $("#update_form_p_id").val(p_id)
        $("#update_price").val(price)
        $("#update_area").val(area)
        $("#update_floor_num").val(floor_num)
        $("#update_at_floor").val(at_floor)
        $("#update_address").val(address)
        $("#update_bathrooms").val(bathrooms)
        $("#update_bedrooms").val(bedrooms)
        if (for_sale === '1'){
            $("#yes").prop("checked", true)
        } else {
            $("#no").prop("checked", true)
        }
        $("#update_province_id").val(province_id)
        change_district(province_id)
        $("#update_district_id").val(district_id)
        $("#update_property_type").val(property_type)
        $("#gg_map_api").val(map.replaceAll("`", "\""))
    }
    function change_district(selectedProvince) {
        var district_select = document.getElementById("update_district_id")
        while (district_select.options.length > 0) {
            district_select.remove(0);
        }
        district_select.innerHTML = '<option value="">Chọn quận huyện</option>';
        if (selectedProvince){
            for (let i = 0; i < district_json.length; i++) {

                if (district_json[i].province_id === selectedProvince){
                    var option = document.createElement("option");
                    option.text = district_json[i].name;
                    option.value = district_json[i].id;
                    district_select.appendChild(option);
                }
            }
        }
    }
</script>
<script>
var app = new Vue({
    el: "#app",
    data:{
        provinces: [],
        districts: [],
        near_locations: [],
        near_locations_fix: [],
        property_types: [],
        amenities: [],
        amenities_fix: [],
        user_choose_amenity: [],
        user_choose_amenity_str: [],
        user_choose_near_locations: [],
        user_choose_near_locations_str: [],
        change_img_json : [],
        contextPath: '<%=request.getContextPath()%>',
        to_remove_img_id: [],
        files : [],
        preview_images: [],
        p_id: 0,
        gg_map_api: ''
    },
    created(){
        this.getAllData();
    },
    methods:{
        getAllData(){
            axios.get('<%=request.getContextPath()%>/api/get-amenities')
                .then((res)=>{
                    this.amenities = JSON.parse(res.data.amenities)
                    for (let i = 0; i < this.amenities.length; i++) {
                        this.amenities_fix.push(this.amenities[i])
                    }
                })
            axios.get('<%=request.getContextPath()%>/api/get-near-locations')
                .then((res)=>{
                    this.near_locations = JSON.parse(res.data.locations)
                    for (let i = 0; i < this.near_locations.length; i++) {
                        this.near_locations_fix.push(this.near_locations[i])
                    }
                })
        },
        choose_amenity(id){
            this.user_choose_amenity_str += id + "|"
            for (let i = 0; i < this.amenities.length; i++) {
                if (this.amenities[i].id === id){
                    this.user_choose_amenity.push(this.amenities[i])
                    this.amenities.splice(i, 1)
                }
            }
        },
        remove_amenity(id){
            this.user_choose_amenity_str = this.user_choose_amenity_str.replace(id + "|", "")
            for (let i = 0; i < this.user_choose_amenity.length; i++) {
                if (this.user_choose_amenity[i].id === id){
                    this.amenities.push(this.user_choose_amenity[i])
                    this.user_choose_amenity.splice(i, 1)
                }
            }
        },
        choose_near_location(id){
            this.user_choose_near_locations_str += id + "|"
            for (let i = 0; i < this.near_locations.length; i++) {
                if (this.near_locations[i].id === id){
                    this.user_choose_near_locations.push(this.near_locations[i])
                    this.near_locations.splice(i, 1)
                }
            }
        },
        remove_near_location(id){
            this.user_choose_near_locations_str = this.user_choose_near_locations_str.replace(id + "|", "")
            for (let i = 0; i < this.user_choose_near_locations.length; i++) {
                if (this.user_choose_near_locations[i].id === id){
                    this.near_locations.push(this.user_choose_near_locations[i])
                    this.user_choose_near_locations.splice(i,1)
                }
            }
        },
        addValueModalVue(amenities, near_locations){
            this.amenities = []
            for (let i = 0; i < this.amenities_fix.length; i++) {
                this.amenities.push(this.amenities_fix[i])
            }
            this.near_locations = []
            for (let i = 0; i < this.near_locations_fix.length; i++) {
                this.near_locations.push(this.near_locations_fix[i])
            }
            this.user_choose_amenity = []
            this.user_choose_amenity_str = ""
            this.user_choose_near_locations = []
            this.user_choose_near_locations_str = ""
            const amenities_arr = amenities.slice(0, -1).split("|");
            const near_locations_arr = near_locations.slice(0, -1).split("|");
            for (let i = 0; i < amenities_arr.length; i++) {
                this.choose_amenity(amenities_arr[i])
            }
            for (let i = 0; i < near_locations_arr.length; i++) {
                this.choose_near_location(near_locations_arr[i])
            }
        },
        change_img(img_json, p_id){
            this.p_id = p_id
            this.change_img_json = img_json
            this.to_remove_img_id = []
        },
        remove_img(id){
            this.to_remove_img_id.push(id)
            for (let i = 0; i < this.change_img_json.length; i++) {
                if (this.change_img_json[i].id === id){
                    this.change_img_json.splice(i,1);
                }
            }
        },
        inputFile(e){
            this.files = e.target.files
            for (let i = 0; i < this.files.length; i++) {
                const file = this.files[i]
                if (file.type.startsWith("image/")){
                    const reader = new FileReader();
                    reader.onload = (e) => {
                        this.preview_images.push(e.target.result);
                    };
                    reader.readAsDataURL(file);
                }
            }
        },
        make_thumb_nail(key){
            for (let i = 0; i < this.change_img_json.length; i++) {
                this.change_img_json[i].is_thumbnail = '0'
            }
            this.change_img_json[key].is_thumbnail = '1'
        },
        view_map(link){
            $("#view_map").html(link.replaceAll("`", "\""))
        }
    }
})
</script>