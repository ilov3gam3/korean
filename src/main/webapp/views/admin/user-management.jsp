<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<div class="container-fluid col-12 mb-3">
    <h2 class="ml-5"><%=language.getProperty("admin.user_mana")%></h2>
    <table class="table table-bordered table-striped col-12" id="my_table">
        <thead>
        <tr>
            <th scope="col">#</th>
            <th><%=language.getProperty("admin.name")%></th>
            <th><%=language.getProperty("admin.email")%></th>
            <th><%=language.getProperty("admin.phone")%></th>
            <th><%=language.getProperty("admin.dob")%></th>
            <th><%=language.getProperty("admin.avatar")%></th>
            <th><%=language.getProperty("admin.is_admin")%></th>
            <th><%=language.getProperty("admin.is_verified_mail")%></th>
            <th><%=language.getProperty("admin.national_id")%></th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="item" items="${list}">
            <tr>
                <td>${item.getId()}</td>
                <td>${item.getName()}</td>
                <td>${item.getEmail()}</td>
                <td>${item.getPhone()}</td>
                <td>${item.getDob()}</td>
                <td>
                    <img src="${item.getAvatar()}" alt="user avatar"
                         style="width: 100px; height: 100px; object-fit: cover">
                </td>
                <c:choose>
                    <c:when test="${item.getIs_verified() == '1'}">
                        <td><%=language.getProperty("admin.yes")%></td>
                    </c:when>
                    <c:otherwise>
                        <td><%=language.getProperty("admin.no")%></td>
                    </c:otherwise>
                </c:choose>
                <c:choose>
                    <c:when test="${item.getIs_admin() == '1'}">
                        <td><%=language.getProperty("admin.yes")%></td>
                    </c:when>
                    <c:otherwise>
                        <td><%=language.getProperty("admin.no")%></td>
                    </c:otherwise>
                </c:choose>
                <td>
                    <div class="col-md-12 text-center">
                            ${item.getNational_id()}
                    </div>
                    <div class="col-md-12 text-center">
                        <button class="btn btn-${item.getCards_verified() == 1 ? 'primary' : 'danger'}"
                                onclick="show_cards('${item.getFront_id_card()}', '${item.getBack_id_card()}', '${item.getNational_id()}', '${item.getCards_verified()}')"
                                style="width: 100%;"><%=language.getProperty("admin.view_cards")%>
                        </button>
                    </div>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
<!-- Modal -->
<div class="modal fade" id="card_modal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Modal title</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form action="/admin/change-verified-card" method="post" >
                <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="national_id"><%=language.getProperty("admin.national_id")%></label>
                                <input class="form-control" type="text" name="national_id" id="national_id">
                            </div>
                        </div>
                        <div class="col-md-6 d-flex align-items-end">
                            <div class="form-group" style="width: 100%">
                                <label id="info_cards_verified"></label>
<%--                                <input type="submit" class="btn btn-primary form-control" style="width: 100%" id="btn_verified" value="Xác nhận" hidden>--%>
                                <button type="submit" class="btn btn-primary" style="width: 100%" id="btn_verified" value="verified" name="status" hidden><%=language.getProperty("admin.confirm")%></button>
                                <button type="submit" class="btn btn-danger" style="width: 100%" id="btn_remove_verified" value="un_verified" name="status" hidden><%=language.getProperty("admin.un_confirm")%></button>
<%--                                <input type="submit" class="btn btn-danger form-control" style="width: 100%" id="btn_remove_verified" value="Bỏ xác nhận" hidden>--%>
                            </div>
                        </div>
                </div>
                </form>
                <div class="row">
                    <div class="col-md-6">
                        <p><%=language.getProperty("admin.front")%></p>
                        <img src="" alt="" style="width: 100%;" id="front">
                        <p class="text-danger" hidden id="no_front"><%=language.getProperty("admin.no_front")%></p>
                    </div>
                    <div class="col-md-6">
                        <p><%=language.getProperty("admin.back")%></p>
                        <img src="" alt="" style="width: 100%;" id="back">
                        <p class="text-danger" hidden id="no_back"><%=language.getProperty("admin.no_back")%></p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Save changes</button>
            </div>
        </div>
    </div>
</div>
<%@ include file="../master/foot.jsp" %>
<script>
    var myModal = new bootstrap.Modal(document.getElementById("card_modal"))
    let table = new DataTable('#my_table');
    function show_cards(front, back, id, card_verified) {
        if (card_verified === '1'){
            $("#info_cards_verified").text("<%=language.getProperty("admin.national_id_verified")%>")
            $("#info_cards_verified").attr('class', 'text-primary')
            $("#btn_remove_verified").removeAttr('hidden')
        }
        if (card_verified === '0'){
            $("#info_cards_verified").text("<%=language.getProperty("admin.national_id_un_verified")%>")
            $("#info_cards_verified").attr('class', 'text-danger')
            $("#btn_verified").removeAttr('hidden')
        }
        $("#national_id").val(id);
        $("#front").attr('src', front)
        $("#back").attr('src', back)
        if (front === ''){
            $("#no_front").removeAttr('hidden')
        }
        if (back === ''){
            $("#no_back").removeAttr('hidden')
        }
        myModal.show()
    }
    $("#card_modal").on("hidden.bs.modal", function () {
        $("#no_front").attr('hidden', true)
        $("#no_back").attr('hidden', true)
        $("#front").attr('src', '')
        $("#back").attr('src', '')
        $("#national_id").val('');
        $("#btn_remove_verified").attr('hidden', true)
        $("#btn_verified").attr('hidden', true)
    });
</script>