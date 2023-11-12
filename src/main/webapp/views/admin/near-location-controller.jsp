<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container-fluid col-12 mb-3 d-flex justify-content-center">
    <div class="row col-11 ">
        <div class="col-md-12">
            <h2><%= language.getProperty("near_location_title") %></h2>
            <button type="button" data-bs-toggle="modal" data-bs-target="#addModal" class="btn btn-primary mb-2 ml-2">
                <%= language.getProperty("property_type_add_new") %>
            </button>
            <table class="table table-bordered table-striped col-12" id="my_table">
                <thead>
                <tr>
                    <th scope="col">#</th>
                    <th><%= language.getProperty("near_location_name_vn") %></th>
                    <th><%= language.getProperty("near_location_name_kr") %></th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="location" items="${locations}">
                    <tr>
                        <td>${location.getId()}</td>
                        <td>${location.getName_vn()}</td>
                        <td>${location.getName_kr()}</td>
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
                    <form action="${pageContext.request.contextPath}/admin/near-by-locations" method="post">
                        <div class="form-group m-1">
                            <label for="name_vn"><%= language.getProperty("property_type_vn_name") %></label>
                            <div class="row">
                                <div class="col-md-9">
                                    <input class="form-control" type="text" name="name_vn" id="name_vn">
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
                        <div class="col-md-12 d-grid gap-2 mt-2">
                            <button class="btn btn-primary"><%= language.getProperty("near_location_add") %></button>
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
        $("#navbar").attr("hidden", true)
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

    /*$("#name_vi").on('blur', async function () {
        if ($("#name_vi").val() !== '') {
            await translate($("#name_vi").val(), 'ko')
            if (detected_language !== 'vi') {
                toastr.warning("ngôn ngữ phải là tiếng việt")
            } else {
                if ($("#name_kr").val() === '') {
                    $("#name_kr").val(translated_text)
                    translated_text = ''
                }
            }
        }
    });
    $("#name_kr").on('blur', async function () {
        if ($("#name_kr").val() !== '') {
            await translate($("#name_kr").val(), 'vi')
            if (detected_language !== 'ko') {
                toastr.warning("ngôn ngữ phải là tiếng hàn")
            } else {
                if ($("#name_vi").val() === '') {
                    $("#name_vi").val(translated_text)
                    translated_text = ''
                }
            }
        }
    });*/
    $("#trans_to_kr").on('click', async function () {
        await translate($("#name_vn").val(), 'ko')
        $("#name_kr").val(translated_text)
        translated_text = ''
    })
    $("#trans_to_vn").on('click', async function () {
        await translate($("#name_kr").val(), 'vi')
        $("#name_vn").val(translated_text)
        translated_text = ''
    })
</script>
