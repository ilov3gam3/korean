<%@ page import="java.util.ArrayList" %>
<%@ page import="Database.DB" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<%ArrayList<MyObject> counts = DB.getData("SELECT SUM(CASE WHEN hidden = 1 THEN 1 ELSE 0 END) AS hidden_count, SUM(CASE WHEN hidden = 0 THEN 1 ELSE 0 END) AS not_hidden_count FROM properties where user_id = ?", new String[]{user.id}, new String[]{"hidden_count", "not_hidden_count"}); %>
<% ArrayList<MyObject> subs = (ArrayList<MyObject>) request.getAttribute("subs");%>
<div class="col-12 mb-3  d-flex justify-content-center">
    <div class="row col-11  d-flex justify-content-center">
        <h2><%= language.getProperty("add_property_title") %>
        </h2>
            <h4><%=language.getProperty("add_property_number_of_property")%>: <%=Integer.parseInt(counts.get(0).getHidden_count()) + Integer.parseInt(counts.get(0).getNot_hidden_count())%>, <%=language.getProperty("plans_hidden_true")%>: <%=counts.get(0).getHidden_count()%>, <%=language.getProperty("add_property_showing")%>: <%=counts.get(0).getNot_hidden_count()%></h4>
            <h4><%=language.getProperty("add_property_can_add").replace("123", String.valueOf(Integer.parseInt(subs.get(0).getNumber_of_property()) - Integer.parseInt(counts.get(0).getNot_hidden_count())))%></h4>
        <form onsubmit="handle_form_submit(event)" id="my_form">
            <div class="col-12">
                <div class="row">
                    <div class="col-md-6">
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
                    <div class="col-md-6">
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
            </div>
            <div class="col-12">
                <div class="row">
                    <div class="col-md-6">
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
                    <div class="col-md-6">
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
            </div>
            <div id="app">
                <div class="col-12">
                    <div class="row">
                        <div class="col-md-4">
                            <label for="property_type"><%= language.getProperty("add_property_choose_type") %></label>
                            <select required class="form-control" name="property_type" id="property_type">
                                <option value=""><%= language.getProperty("add_property_choose_type") %></option>
                                <%--<% ArrayList<MyObject> property_list = (ArrayList<MyObject>) request.getAttribute("property_list");%>
                                <% if (lang.equals("kr")) { %>
                                    <% for (int i = 0; i < property_list.size(); i++) { %>
                                        <option value="<%=property_list.get(i).getId()%>"><%=property_list.get(i).getName_kr()%></option>
                                    <% } %>
                                <% } else { %>
                                    <% for (int i = 0; i < property_list.size(); i++) { %>
                                    <option value="<%=property_list.get(i).getId()%>"><%=property_list.get(i).getName_vn()%></option>
                                    <% } %>
                                <% } %>--%>
                                <template v-for="(value, key) in property_types">
                                    <%if (lang.equals("kr")){ %>
                                    <option :value="value.id">{{value.name_kr}}</option>
                                    <% } %>
                                    <%if (lang.equals("vn")){ %>
                                    <option :value="value.id">{{value.name_vn}}</option>
                                    <% } %>
                                </template>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="province_id"><%= language.getProperty("add_property_choose_province") %></label>
                            <select data-placeholder="<%=language.getProperty("add_property_choose_province")%>" required class="form-control" name="province_id" id="province_id" onchange="change_district(this.value)">
                                <option value=""><%= language.getProperty("add_property_choose_province") %></option>
                                <%--                            <c:forEach var="province" items="${provinces_list}">--%>
                                <%--                                <option value="${province.getId()}">${province.getName()}</option>--%>
                                <%--                            </c:forEach>--%>
                                <template v-for="(value, key) in provinces">
                                    <option :value="value.id">{{value.name}}</option>
                                </template>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="district_id"><%= language.getProperty("add_property_choose_district") %></label>
                            <select required class="form-control" name="district_id" id="district_id">

                            </select>
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="row">
                        <div class="col-8">
                            <label for="address"><%= language.getProperty("add_property_address") %></label>
                            <input required type="text" class="form-control" name="address" id="address">
                        </div>
                        <div class="col-2">
                            <label for="floor_numbers"><%= language.getProperty("add_property_number_floor") %></label>
                            <input required type="number" class="form-control" name="floor_numbers" min="1" id="floor_numbers">
                        </div>
                        <div class="col-2">
                            <label for="at_floor"><%= language.getProperty("add_property_at_floor") %></label>
                            <input required type="number" class="form-control" name="at_floor" min="1" id="at_floor">
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="row">
                        <div class="col-md-2">
                            <label for="bedrooms"><%= language.getProperty("add_property_bed_room") %></label>
                            <input type="number" class="form-control" name="bedrooms" id="bedrooms">
                        </div>
                        <div class="col-md-2">
                            <label for="bathrooms"><%= language.getProperty("add_property_bath_room") %></label>
                            <input type="number" class="form-control" name="bathrooms" id="bathrooms">
                        </div>
                        <div class="col-md-2">
                            <label for="area"><%= language.getProperty("add_property_area") %>(m²)</label>
                            <input type="number" class="form-control" name="area" id="area">
                        </div>
                        <div class="col-md-2 mt-3">
                            <label><%= language.getProperty("add_property_type") %></label><br>
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
                        <div class="col-md-2">
                            <label for="price"><%= language.getProperty("add_property_price") %></label>
                            <input type="number" class="form-control" name="price" id="price">
                        </div>
                        <div class="col-2">
                            <label for="imgs"><%= language.getProperty("add_property_add_img") %></label>
                            <label for="imgs" class="btn btn-primary" style="width: 100%;"><%= language.getProperty("add_property_add_img") %></label><br>
                            <input hidden="hidden" type="file" multiple onchange="choose_multiple_img(event)" id="imgs" accept="image/*">
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="row">
                        <div class="col-5">
                            <label ><%= language.getProperty("add_property_choose_amenities") %></label>
                            <input type="hidden" name="amenity_id" v-model="user_choose_amenity_str">
<%--                            <input type="hidden" name="amenity_id" :value="user_choose_amenity_str">--%>
                            <%--<select required data-placeholder="<%= language.getProperty("add_property_choose_amenities") %>" class="chosen-select form-control" multiple name="amenity_id" id="amenity">
                                <% ArrayList<MyObject> amenities = (ArrayList<MyObject>) request.getAttribute("amenities");%>
                                    <% if (lang.equals("kr")) { %>
                                        <% for (int i = 0; i < amenities.size(); i++) { %>
                                            <option value="<%=amenities.get(i).getId()%>"><%=amenities.get(i).getName_kr()%></option>
                                            <% } %>
                                        <% } else { %>
                                            <% for (int i = 0; i < amenities.size(); i++) { %>
                                            <option value="<%=amenities.get(i).getId()%>"><%=amenities.get(i).getName_vn()%></option>
                                            <% } %>
                                    <% } %>
                            </select>--%>
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
                        <div class="col-5">
                            <label ><%= language.getProperty("add_property_choose_nearby") %></label>
                            <input type="hidden" name="nearby_location_id" :value="user_choose_near_locations_str">
                            <%--<select name="nearby_location_id" required data-placeholder="<%= language.getProperty("add_property_choose_nearby") %>" class="chosen-select form-control" multiple name="nearby_location_id" id="nearby_location_id">
                                <% ArrayList<MyObject> locations = (ArrayList<MyObject>) request.getAttribute("locations");%>
                                    <% if (lang.equals("kr")) { %>
                                        <% for (int i = 0; i < locations.size(); i++) { %>
                                        <option value="<%=locations.get(i).getId()%>"><%=locations.get(i).getName_kr()%></option>
                                        <% } %>
                                        <% } else { %>
                                        <% for (int i = 0; i < locations.size(); i++) { %>
                                        <option value="<%=locations.get(i).getId()%>"><%=locations.get(i).getName_vn()%></option>
                                        <% } %>
                                    <% } %>

                            </select>--%>
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
                        <div class="col-1">
                            <label for="add_new"><%= language.getProperty("add_property_add_new") %></label>
                            <button id="add_new" type="submit" class="btn btn-primary" style="width: 100%"><%= language.getProperty("add_property_add_new") %></button>
                        </div>
                        <div class="col-1">
                            <label for="add_new"><%= language.getProperty("add_property_clear_form") %></label>
                            <button id="clear_form" type="button" class="btn btn-primary" style="width: 100%"><%= language.getProperty("add_property_clear_form") %></button>
                        </div>
                    </div>
                </div>
                <div class="col-12">
                    <div class="row">
                        <div class="form-group">
                            <label for="gg_map_api"><%=language.getProperty("gg_map_api")%> <a target="_blank" href="https://www.google.com/search?q=h%C6%B0%E1%BB%9Bng+d%E1%BA%ABn+l%E1%BA%A5y+link+google+map&oq=h%C6%B0%E1%BB%9Bng+d%E1%BA%ABn+l%E1%BA%A5y+link+google+map&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIICAEQABgWGB4yCAgCEAAYFhge0gEJMTE2MDdqMGoxqAIAsAIA&sourceid=chrome&ie=UTF-8"><%=language.getProperty("gg_map_api_tut")%></a></label>
                            <input id="gg_map_api" name="gg_map_api" type="text" class="form-control">
                        </div>
                    </div>
                </div>
                <div class="col-12 mt-1">
                    <div class="row" id="preview_images">
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>
<%@ include file="../master/foot.jsp" %>
<script>
    <%if (subs.size()!=0){ %>
        <% if (Integer.parseInt(subs.get(0).getNumber_of_property()) <= Integer.parseInt(counts.get(0).getNot_hidden_count())) { %>
            var form = document.getElementById("my_form");
            var elements = form.elements;
            for (var i = 0; i < elements.length; i++) {
                elements[i].disabled = true;
            }
        <% } %>
    <% } %>
    <% if (subs.size() == 0) { %>
        var form = document.getElementById("my_form");
        var elements = form.elements;
        for (var i = 0; i < elements.length; i++) {
            elements[i].disabled = true;
        }
    <% } %>

    $("#amenity").chosen();
    $("#nearby_location_id").chosen();
    var addModal = $("#addModal");
    var imgArr = []
    var img_ids = []
    var is_thumb_nail = 0
    addModal.on('show.bs.modal', function () {
        // $("#navbar").attr("hidden", true)
    })
    addModal.on('hidden.bs.modal', function () {
        $("#navbar").attr("hidden", false)
    })
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
    var district_json  = JSON.parse('[<c:forEach var="district" items="${districts_list}"> {"id":"${district.getId()}", "name":"${district.getName()}", "province_id":"${district.getProvince_id()}"}, </c:forEach>]'.replace(", ]", "]"))
    function change_district(selectedProvince) {
        var district_select = document.getElementById("district_id")
        while (district_select.options.length > 0) {
            district_select.remove(0);
        }
        district_select.innerHTML = '<option value=""><%=language.getProperty("add_property_choose_district")%></option>';
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
    function choose_img(e) {
        var file = e.target.files[0];
        imgArr.push(file)
        img_ids.push(imgArr[imgArr.length -1].size + '_' + imgArr[imgArr.length -1].lastModified)
        var reader = new FileReader();
        reader.onload = function (e) {
            if (imgArr.length === 1){
                $("#preview_images").append('<div class="col-4" id="'+imgArr[imgArr.length -1].lastModified + '_' + imgArr[imgArr.length -1].size +'"><button onclick="remove_img(\''+imgArr[imgArr.length -1].lastModified + '_' + imgArr[imgArr.length -1].size +'\')" type="button" class="btn-close" aria-label="Close"></button><img id="'+imgArr[imgArr.length -1].size + '_' + imgArr[imgArr.length -1].lastModified +'" onclick="makeSelected(\''+imgArr[imgArr.length -1].size + '_' + imgArr[imgArr.length -1].lastModified +'\')" class="m-1 img-thumbnail border-4 border-primary" style="width: 100%; max-height: 300px; object-fit: cover" src="'+e.target.result+'" alt=""></div>')
            } else {
                $("#preview_images").append('<div class="col-4" id="'+imgArr[imgArr.length -1].lastModified + '_' + imgArr[imgArr.length -1].size +'"><button onclick="remove_img(\''+imgArr[imgArr.length -1].lastModified + '_' + imgArr[imgArr.length -1].size +'\')" type="button" class="btn-close" aria-label="Close"></button><img id="'+imgArr[imgArr.length -1].size + '_' + imgArr[imgArr.length -1].lastModified +'" onclick="makeSelected(\''+imgArr[imgArr.length -1].size + '_' + imgArr[imgArr.length -1].lastModified +'\')" class="m-1 img-thumbnail" style="width: 100%; max-height: 300px; object-fit: cover" src="'+e.target.result+'" alt=""></div>')
            }
        }
        reader.readAsDataURL(file);
    }
    function choose_multiple_img(e) {
        var img_list = e.target.files
        for (let i = 0; i < img_list.length; i++) {
            var file = img_list[i]
            imgArr.push(file)
            img_ids.push(file.size + '_' + file.lastModified)
            if (imgArr.length === 1){
                $("#preview_images").append('<div class="col-4" id="'+file.lastModified + '_' + file.size +'"><button onclick="remove_img(\''+file.lastModified + '_' + file.size +'\')" type="button" class="btn-close" aria-label="Close"></button><img id="'+file.size + '_' + file.lastModified +'" onclick="makeSelected(\''+file.size + '_' + file.lastModified +'\')" class="m-1 img-thumbnail border-4 border-primary" style="width: 100%; max-height: 300px; object-fit: cover" src="'+URL.createObjectURL(file)+'" alt=""></div>')
                is_thumb_nail = file.size + '_' + file.lastModified
            } else {
                $("#preview_images").append('<div class="col-4" id="'+file.lastModified + '_' + file.size +'"><button onclick="remove_img(\''+file.lastModified + '_' + file.size +'\')" type="button" class="btn-close" aria-label="Close"></button><img id="'+file.size + '_' + file.lastModified +'" onclick="makeSelected(\''+file.size + '_' + file.lastModified +'\')" class="m-1 img-thumbnail" style="width: 100%; max-height: 300px; object-fit: cover" src="'+URL.createObjectURL(file)+'" alt=""></div>')
            }
        }
    }
    function remove_img(id) {
        var div_to_remove = document.getElementById(id);
        if (div_to_remove){
            var parentDiv = document.getElementById("preview_images");
            parentDiv.removeChild(div_to_remove);
        }
        for (let i = 0; i < imgArr.length; i++) {
            if (imgArr[i].lastModified + "_" + imgArr[i].size === id){
                imgArr.splice(i, 1)
                break;
            }
        }
        const img_id_to_remove = id.split("_")[1] + "_" + id.split("_")[0];
        for (let i = 0; i < img_ids.length; i++) {
            if (img_ids[i] == img_id_to_remove){
                img_ids.splice(i,1)
            }
        }
        if (img_ids.length>0){
            document.getElementById(img_ids[0]).className = "m-1 img-thumbnail border-4 border-primary"
            is_thumb_nail = img_ids[0]
        }
    }
    function makeSelected(id) {
        for (let i = 0; i < img_ids.length; i++) {
            document.getElementById(img_ids[i]).className = "m-1 img-thumbnail"
        }
        document.getElementById(id).className = "m-1 img-thumbnail border-4 border-primary"
        is_thumb_nail = id
    }
    function handle_form_submit(e) {
        e.preventDefault();
        const form = document.getElementById("my_form")
        const formData = new FormData(form);
        const form_data_object = new FormData();
        var check = true;
        formData.forEach((value, key) =>{
            if (value === ''){
                check = false;
            }
            form_data_object.append(key, value)
        })
        if (check){
            for (let i = 0; i < imgArr.length; i++) {
                if (imgArr[i].size + "_" + imgArr[i].lastModified === is_thumb_nail){
                    form_data_object.append("file_" + i + "thumb", imgArr[i])
                } else {
                    form_data_object.append("file_" + i, imgArr[i])
                }
            }
            axios.post('${pageContext.request.contextPath}/user/add-property', form_data_object, {
                headers: {
                    'Content-Type': 'multipart/form-data'
                }
            }).then((res)=>{
                if (res.data.code === "00"){
                    toastr.success("<%= language.getProperty("add_success") %>")
                } else {
                    toastr.error("<%= language.getProperty("add_fail") %>")
                }
            })
        } else {
            toastr.warning("<%= language.getProperty("add_property_fill_full_form") %>")
        }
    }
    //======================================//======================================//======================================//======================================

</script>
<script>
var app = new Vue({
    el: "#app",
    data:{
        provinces: [],
        districts: [],
        near_locations: [],
        property_types: [],
        amenities: [],
        user_choose_amenity: [],
        user_choose_amenity_str: [],
        user_choose_near_locations: [],
        user_choose_near_locations_str: [],
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
        }
    }
})
</script>
