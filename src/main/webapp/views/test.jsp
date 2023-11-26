<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/views/master/head.jsp" %>
<input type="text" class="form-control" value="123">
<div class="container">
    <div class="dropdown">
        <div class="form-control" aria-labelledby="dropdownMenuButton1" id="dropdownMenuButton1" data-bs-toggle="dropdown">choose sth</div>
        <ul class="dropdown-menu col-12" id="options_list">
        </ul>
    </div>
</div>
<%@ include file="/views/master/foot.jsp" %>
<script>
    var html = "";
    var options = ["Action", "Another action", "Something else here", "a", 'b', 'c']
    var choosen = ""
    html = ''
    for (let i = 0; i < options.length; i++) {
        html += "<li class='dropdown-item' onclick='makeChoose(\""+options[i]+"\")'>"+options[i]+"</li>"
    }
    $("#options_list").html(html)
    function makeChoose(a) {
        choosen += "<button style='height: 28px; border: 0;padding-left: 6px; padding-right: 6px; padding-top: 2px; padding-bottom: 2px' class='btn btn-primary'><span class='text-danger' onclick='removeChosen(\""+a+"\")'>X </span> "+a+"</button>"
        $("#dropdownMenuButton1").html(choosen)
        html = ""
        for (let i = 0; i < options.length; i++) {
            if (options[i] === a){
                options.splice(i,1)
            }
        }
        for (let i = 0; i < options.length; i++) {
            html += "<li class='dropdown-item' onclick='makeChoose(\""+options[i]+"\")'>"+options[i]+"</li>"
        }
        $("#options_list").html(html)
    }
    function removeChosen(a) {

    }
</script>