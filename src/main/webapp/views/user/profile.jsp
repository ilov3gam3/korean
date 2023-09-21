<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="col-12 mb-3  d-flex justify-content-center">
    <div class="row col-11  d-flex justify-content-center">
        <h2><%= language.getProperty("profile.your_data") %>
        </h2>
        <div class="col-md-6">
            <form action="" method="post">
                <div class="form-group mt-1 mb-1">
                    <label for="name"><%= language.getProperty("register.name.label") %>
                    </label>
                    <input required class="form-control" type="text" name="name" id="name" readonly
                           value="<%= user.name %>">
                </div>
                <div class="form-group mt-1 mb-1">
                    <label for="email"><%= language.getProperty("register.email.label") %>
                    </label>
                    <input required class="form-control" type="text" name="email" id="email" readonly
                           value="<%= user.email %>">
                </div>
                <div class="form-group mt-1 mb-1">
                    <label for="phone"><%= language.getProperty("register.phone.label") %>
                    </label>
                    <input required class="form-control" type="text" name="phone" id="phone" readonly
                           value="<%= user.phone %>">
                </div>
                <div class="form-group mt-1 mb-1">
                    <label for="dob"><%= language.getProperty("register.dob.label") %>
                    </label>
                    <input required class="form-control" type="date" name="dob" id="dob" readonly
                           value="<%= user.dob %>">
                </div>
                <div class="form-group mt-1 mb-1">
                    <label for="national_id"><%= language.getProperty("register.national_id.label") %>
                    </label>
                    <input required class="form-control" type="text" name="national_id" id="national_id" readonly
                           value="<%= user.national_id %>">
                </div>
            </form>
        </div>
        <div class="col-md-6">
            <form action="/change-avatar" method="post" class="mb-3" enctype="multipart/form-data">
                <div class="row ">
                    <div class="col-4">
                        <h4><%= language.getProperty("profile.avatar") %>
                        </h4>
                    </div>
                    <div class="col-4">
                        <label for="image" style="width: 100%" class="btn btn-primary"><%= language.getProperty("profile.change_avatar") %></label>
                        <input hidden type="file" name="image" id="image">
                    </div>
                    <div class="col-md-4">
                        <button class="btn btn-success" style="width: 100%" id="submit_button" hidden type="submit"><%= language.getProperty("profile.update") %></button>
                    </div>
                </div>
            </form>
            <div class="container-fluid d-flex justify-content-center m-2">
                <img src="<%= user.avatar %>" alt="user avatar" id="previewImage" style="max-width: 100%">
            </div>
            <form class="mb-3 mt-3" action="/update-cards" method="post" enctype="multipart/form-data">
                <input type="hidden" value="front" name="side">
                <div class="row">
                    <div class="col-4">
                        <h4><%= language.getProperty("profile.front_id_card") %></h4>
                    </div>
                    <div class="col-4">
                        <label for="front" style="width: 100%" class="btn btn-primary"><%= language.getProperty("profile.change_front") %></label>
                    </div>
                    <div class="col-4">
                        <button class="btn btn-primary" style="width: 100%" id="submit_front" hidden><%= language.getProperty("profile.update") %></button>
                    </div>
                </div>
                <input type="file" name="image" hidden id="front">
                <% if (user.getFront_id_card() == null) { %>
                    <h4 class="text-center text-danger"><%= language.getProperty("profile.no_img") %></h4>
                <div class="container-fluid d-flex justify-content-center m-2">
                    <img hidden id="previewImageFront"
                         style="max-width: 100%">
                </div>
                <% } else { %>
                    <div class="container-fluid d-flex justify-content-center m-2">
                        <img src="<%= user.front_id_card %>" alt="user avatar" id="previewImageFront"
                             style="max-width: 100%">
                    </div>
                <% } %>

            </form>
            <form action="/update-cards" method="post" enctype="multipart/form-data">
                <input type="hidden" value="back" name="side">
                <div class="row">
                    <div class="col-4">
                        <h4><%= language.getProperty("profile.back_id_card") %></h4>
                    </div>
                    <div class="col-4">
                        <label for="back" style="width: 100%" class="btn btn-primary"><%= language.getProperty("profile.change_back") %></label>
                    </div>
                    <div class="col-4">
                        <button class="btn btn-primary" style="width: 100%" id="submit_back" hidden><%= language.getProperty("profile.update") %></button>
                    </div>
                </div>
                <input type="file" name="image" hidden id="back">
                <% if (user.getBack_id_card() == null) { %>
                    <h4 class="text-center text-danger"><%= language.getProperty("profile.no_img") %></h4>
                <div class="container-fluid d-flex justify-content-center m-2">
                    <img hidden id="previewImageBack" style="max-width: 100%">
                </div>
                <% } else { %>
                    <div class="container-fluid d-flex justify-content-center m-2">
                        <img src="<%= user.back_id_card %>" alt="user avatar" id="previewImageBack" style="max-width: 100%">
                    </div>
                <% } %>

            </form>
        </div>
    </div>
</div>
<%@ include file="../master/foot.jsp" %>
<script>
    document.getElementById('image').addEventListener('change', function (e) {
        var file = e.target.files[0];
        var reader = new FileReader();
        reader.onload = function (e) {
            document.getElementById('previewImage').setAttribute('src', e.target.result);
        }
        var button = document.getElementById("submit_button");

        if (button) {
            button.removeAttribute("hidden");
        }
        reader.readAsDataURL(file);
    });

    document.getElementById('front').addEventListener('change', function (e) {
        var file = e.target.files[0];
        var reader = new FileReader();
        reader.onload = function (e) {
            document.getElementById('previewImageFront').setAttribute('src', e.target.result);
            document.getElementById('previewImageFront').removeAttribute('hidden');
        }
        var button = document.getElementById("submit_front");

        if (button) {
            button.removeAttribute("hidden");
        }
        reader.readAsDataURL(file);
    });

    document.getElementById('back').addEventListener('change', function (e) {
        var file = e.target.files[0];
        var reader = new FileReader();
        reader.onload = function (e) {
            document.getElementById('previewImageBack').setAttribute('src', e.target.result);
            document.getElementById('previewImageBack').removeAttribute('hidden');
        }
        var button = document.getElementById("submit_back");

        if (button) {
            button.removeAttribute("hidden");
        }
        reader.readAsDataURL(file);
    });
</script>


