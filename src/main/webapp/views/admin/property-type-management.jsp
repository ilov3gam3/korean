<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container-fluid col-12 mb-3 d-flex justify-content-center">
    <div class="row col-11 ">
        <div class="col-md-12">
            <h2><%= language.getProperty("property_type_title") %></h2>
            <button type="button" data-bs-toggle="modal" data-bs-target="#addModal" class="btn btn-primary mb-2 ml-2">
                <%= language.getProperty("property_type_add_new") %>
            </button>
            <table class="table table-bordered table-striped col-12" id="my_table">
                <thead>
                <tr>
                    <th scope="col">#</th>
                    <th><%= language.getProperty("property_type_vn_name") %></th>
                    <th><%= language.getProperty("property_type_kr_name") %></th>
                    <th><%= language.getProperty("property_type_vn_des") %></th>
                    <th><%= language.getProperty("property_type_kr_des") %></th>
                    <th><%= language.getProperty("property_type_numbers") %></th>
                    <th class="col-1"><%= language.getProperty("amenities_edit") %></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${property_list}">
                    <tr>
                        <td>${item.getId()}</td>
                        <td>${item.getName_vn()}</td>
                        <td>${item.getName_kr()}</td>
                        <td>${item.getDescription_vn()}</td>
                        <td>${item.getDescription_kr()}</td>
                        <td>${item.getNumbers()}</td>
                        <td class="col-1">
                            <button style="width: 100%" onclick="showEditModal('${item.getId()}', '${item.getName_vn()}', '${item.getName_kr()}', '${item.getDescription_vn()}', '${item.getDescription_kr()}')" type="button" data-bs-toggle="modal" data-bs-target="#editModal" class="btn btn-warning"><%= language.getProperty("amenities_edit") %></button>
                            <form action="${pageContext.request.contextPath}/admin/update-property" method="get">
                                <input type="hidden" name="id" value="${item.getId()}">
                                <button type="submit" style="width: 100%" class="mt-1 btn btn-danger">
                                    <%= language.getProperty("add_property_clear_form") %>
                                </button>
                            </form>
                        </td>
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
                    <form action="${pageContext.request.contextPath}/admin/property-type-management" method="post">
                        <div class="form-group m-1">
                            <label for="name_vi"><%= language.getProperty("property_type_vn_name") %></label>
                            <div class="row">
                                <div class="col-md-9">
                                    <input class="form-control" type="text" name="name_vi" id="name_vi">
                                </div>
                                <div class="col-md-3">
                                    <button class="btn btn-primary" type="button" id="trans_to_kr" style="width: 100%;">
                                        <%= language.getProperty("property_type_tran2kr") %></button>
                                </div>
                            </div>
                        </div>
                        <div class="form-group m-1">
                            <label for="name_kr"><%= language.getProperty("property_type_kr_name") %></label>
                            <div class="row">
                                <div class="col-md-9">
                                    <input class="form-control" type="text" name="name_kr" id="name_kr">
                                </div>
                                <div class="col-md-3">
                                    <button class="btn btn-primary" type="button" id="trans_to_vn" style="width: 100%;">
                                        <%= language.getProperty("property_type_tran2vn") %></button>
                                </div>
                            </div>

                        </div>
                        <div class="form-group m-1">
                            <div class="row  mt-1 mb-1">
                                <div class="col-9">
                                    <label for="description_vi"><%= language.getProperty("property_type_vn_des") %></label>
                                </div>
                                <div class="col-3">
                                    <button class="btn btn-primary" type="button" id="trans_des_to_kr" style="width: 100%"><%= language.getProperty("property_type_tran2kr") %></button>
                                </div>
                            </div>
                            <textarea class="form-control" name="description_vi" id="description_vi" rows="8"
                                      style="width: 100%"></textarea>
                        </div>
                        <div class="form-group m-1">
                            <div class="row mt-1 mb-1">
                                <div class="col-9">
                                    <label for="description_kr"><%= language.getProperty("property_type_kr_des") %></label>
                                </div>
                                <div class="col-3">
                                    <button class="btn btn-primary" type="button" id="trans_des_to_vn" style="width: 100%"><%= language.getProperty("property_type_tran2vn") %></button>
                                </div>
                            </div>

                            <textarea class="form-control" name="description_kr" id="description_kr" rows="8"
                                      style="width: 100%"></textarea>
                        </div>
                        <div class="col-md-12 d-grid gap-2 mt-2">
                            <button class="btn btn-primary"><%= language.getProperty("property_type_add_new") %></button>
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
                    <form action="${pageContext.request.contextPath}/admin/update-property" method="post">
                        <input type="hidden" id="id" name="id">
                        <div class="form-group m-1">
                            <label for="name_vi"><%= language.getProperty("property_type_vn_name") %></label>
                            <div class="row">
                                <div class="col-md-9">
                                    <input class="form-control" type="text" name="update_name_vi" id="update_name_vi">
                                </div>
                                <div class="col-md-3">
                                    <button class="btn btn-primary" type="button" id="update_trans_to_kr" style="width: 100%;">
                                        <%= language.getProperty("property_type_tran2kr") %></button>
                                </div>
                            </div>
                        </div>
                        <div class="form-group m-1">
                            <label for="name_kr"><%= language.getProperty("property_type_kr_name") %></label>
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
                        <div class="form-group m-1">
                            <div class="row  mt-1 mb-1">
                                <div class="col-9">
                                    <label for="description_vi"><%= language.getProperty("property_type_vn_des") %></label>
                                </div>
                                <div class="col-3">
                                    <button class="btn btn-primary" type="button" id="update_trans_des_to_kr" style="width: 100%"><%= language.getProperty("property_type_tran2kr") %></button>
                                </div>
                            </div>
                            <textarea class="form-control" name="update_description_vi" id="update_description_vi" rows="8"
                                      style="width: 100%"></textarea>
                        </div>
                        <div class="form-group m-1">
                            <div class="row mt-1 mb-1">
                                <div class="col-9">
                                    <label for="description_kr"><%= language.getProperty("property_type_kr_des") %></label>
                                </div>
                                <div class="col-3">
                                    <button class="btn btn-primary" type="button" id="update_trans_des_to_vn" style="width: 100%"><%= language.getProperty("property_type_tran2vn") %></button>
                                </div>
                            </div>

                            <textarea class="form-control" name="update_description_kr" id="update_description_kr" rows="8"
                                      style="width: 100%"></textarea>
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
    var addModal = $("#addModal");
    addModal.on('show.bs.modal', function () {
        // $("#navbar").attr("hidden", true)
    })
    addModal.on('hidden.bs.modal', function () {
        // $("#navbar").attr("hidden", false)
    })
    var editModal = $("#editModal");
    editModal.on('show.bs.modal', function () {
        // $("#navbar").attr("hidden", true)
    })
    editModal.on('hidden.bs.modal', function () {
        // $("#navbar").attr("hidden", false)
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
        await translate($("#name_vi").val(), 'ko')
        $("#name_kr").val(translated_text)
        translated_text = ''
    })
    $("#trans_to_vn").on('click', async function () {
        await translate($("#name_kr").val(), 'vi')
        $("#name_vi").val(translated_text)
        translated_text = ''
    })
    $("#trans_des_to_kr").on('click',async function () {
        await translate($("#description_vi").val(), 'ko')
        $("#description_kr").val(translated_text)
        translated_text = ''
    })
    $("#trans_des_to_vn").on('click',async function () {
        await translate($("#description_kr").val(), 'vi')
        $("#description_vi").val(translated_text)
        translated_text = ''
    })


    $("#update_trans_to_kr").on('click', async function () {
        await translate($("#update_name_vi").val(), 'ko')
        $("#update_name_kr").val(translated_text)
        translated_text = ''
    })
    $("#update_trans_to_vn").on('click', async function () {
        await translate($("#update_name_kr").val(), 'vi')
        $("#update_name_vi").val(translated_text)
        translated_text = ''
    })
    $("#update_trans_des_to_kr").on('click',async function () {
        await translate($("#update_description_vi").val(), 'ko')
        $("#update_description_kr").val(translated_text)
        translated_text = ''
    })
    $("#update_trans_des_to_vn").on('click',async function () {
        await translate($("#update_description_kr").val(), 'vi')
        $("#update_description_vi").val(translated_text)
        translated_text = ''
    })
    function showEditModal(id, name_vn, name_kr, des_vn, des_kr) {
        $("#id").val(id);
        $("#update_name_vi").val(name_vn)
        $("#update_name_kr").val(name_kr)
        $("#update_description_vi").val(des_vn)
        $("#update_description_kr").val(des_kr)
    }
</script>
