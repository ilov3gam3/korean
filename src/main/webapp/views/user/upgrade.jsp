<%@ page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<%ArrayList<MyObject> plans = (ArrayList<MyObject>) request.getAttribute("plans");%>
<%ArrayList<MyObject> subs = (ArrayList<MyObject>) request.getAttribute("subs");%>
<%ArrayList<MyObject> priority_plans = (ArrayList<MyObject>) request.getAttribute("priority_plans");%>
<div id="app" class="container-fluid col-12 mb-3 d-flex justify-content-center">
  <div class="row col-11 ">
    <div class="col-md-12">
      <div class="col-12 row">
        <h2 class="text-center mt-3"><%= language.getProperty("upgrade_title") %></h2>
      </div>
      <div class="col-12 row">
        <h3 class="col-12 text-center">
          <% if(subs.size() != 0){ %>
            <%String name = "";%>
            <% for (int i = 0; i < plans.size(); i++) {
              if (plans.get(i).getId().equals(subs.get(0).getId())){
                if (lang.equals("vn")){
                  name = plans.get(i).getName_vn();
                } else {
                  name = plans.get(i).getName_kr();
                }
              }
            } %>
            Bạn đang đăng kí gói <%=name%> từ ngày <%=subs.get(0).getFrom_date()%> tới ngày <%=subs.get(0).getTo_date()%>
          <% } %>
        </h3>
        <div class="col-6">
          <% for (int i = 0; i < plans.size(); i++) { %>
          <button v-on:click="change_choose(<%=plans.get(i).getId()%>, <%=plans.get(i).getPrice_per_month()%>, <%=plans.get(i).getNumber_of_property()%>)" type="button"
                  style="width: 100%" class="m-1 btn btn-outline-success btn-lg"
                  :class="{'m-1 btn btn-outline-success btn-lg' : choosing !== <%=plans.get(i).getId()%>, 'm-1 btn btn-success btn-lg' : choosing === <%=plans.get(i).getId()%>}">
            <span class="text-dark">
              <% if (lang.equals("vn")) { %>
              <%=plans.get(i).getName_vn().toUpperCase(java.util.Locale.ROOT)%>
            <% } else { %>
              <%=plans.get(i).getName_kr().toUpperCase(java.util.Locale.ROOT)%>
            <% } %>
            ,<%=plans.get(i).getNumber_of_property()%> <%=language.getProperty("upgrade_property")%>,
            <%=plans.get(i).getNumber_of_comments()%> <%=language.getProperty("upgrade_comment")%>,
            <%=plans.get(i).getNumber_of_words_per_cmt()%> <%=language.getProperty("upgrade_words")%>,
            <%=language.getProperty("upgrade_price")%> <%=plans.get(i).getPrice_per_month()%>đ
            </span>
          </button>
          <% } %>
          <%=language.getProperty("upgrade_choose_priority")%>>
          <% for (int i = 0; i < priority_plans.size(); i++) { %>
          <button v-on:click="change_choose_priority(<%=priority_plans.get(i).getId()%>, <%=priority_plans.get(i).getPrice_per_property()%>)" type="button" style="width: 100%" class="m-1 btn btn-outline-success btn-lg"
                  :class="{'m-1 btn btn-outline-success btn-lg' : choosing_priority !== <%=priority_plans.get(i).getId()%>, 'm-1 btn btn-success btn-lg' : choosing_priority === <%=priority_plans.get(i).getId()%>}"
          >
            <span class="text-dark"><%=language.getProperty("upgrade_priority")%><%=priority_plans.get(i).getPriority()%>, giá <%=priority_plans.get(i).getPrice_per_property()%>đ/1 <%=language.getProperty("upgrade_property")%></span>
          </button>
          <% } %>
        </div>
        <div class="col-6">
            <div class="form-group">
              <label for="month"><%=language.getProperty("upgrade_month")%></label>
              <input type="number" class="form-control input-group-lg" min="1" max="12" id="month" v-model="months">
            </div>
            <div v-if="choosing != 0 && price != 0" class="form-group mt-3">
              <%=language.getProperty("upgrade_amount_have_to_pay")%>: {{price}} x {{months}} + {{price_priority}} x {{number_of_property}} (-{{discount}}%) = {{(price * months + price_priority * number_of_property) * (1-discount/100)}}
              <form v-on:submit="form_submit(event)" action="${pageContext.request.contextPath}/user/upgrade-account" method="post">
                <input type="hidden" v-model="months" name="months">
                <input type="hidden" v-model="choosing" name="plan_id">
                <button type="submit" class="btn btn-primary"><%=language.getProperty("upgrade_pay")%></button>
              </form>
            </div>
        </div>
      </div>
    </div>
  </div>
</div>
<%@ include file="../master/foot.jsp" %>
<script src="https://pay.vnpay.vn/lib/vnpay/vnpay.min.js"></script>
<script>
  var app = new Vue({
    el: "#app",
    data:{
      choosing: 0,
      months : 1,
      amount_to_pay: 0,
      price : 0,
      number_of_property: 0,
      discount: 0,

      choosing_priority: 0,
      price_priority: 0,

    },
    created(){
    },
    methods:{
      change_choose(id, price, x){
        this.choosing = id
        this.price = price
        this.number_of_property = x
      },
      change_choose_priority(id, price){
        this.choosing_priority = id;
        this.price_priority = price
      },
      form_submit(e){
        e.preventDefault();
        const data = new FormData();
        data.append("months", this.months)
        data.append("plan_id", this.choosing)
        data.append("choosing_priority", this.choosing_priority)
        axios.post("${pageContext.request.contextPath}/user/upgrade-account", data,{
            headers: {
                'Content-Type': 'multipart/form-data'
            }
        })
                .then((res)=>{
                  if (res.data.code === '00'){
                      if (window.vnpay) {
                          vnpay.open({width: 768, height: 600, url: res.data.data});
                      } else {
                          location.href = res.data.data;
                      }
                  } else if (res.data.code === '01'){
                      toastr.warning(res.data.data)
                  }
                })
      },
    },
    watch: {
      months: function(newValue, oldValue) {
        if (newValue == 1 || newValue == 2 || newValue == 3){
          this.discount = 0
        } else if (newValue == 4 || newValue == 5 || newValue == 6){
          this.discount = 5
        } else if (newValue == 7 || newValue == 8 || newValue == 9){
          this.discount = 10
        } else if(newValue == 10 || newValue == 11 || newValue == 12){
          this.discount = 15
        }
      },
      months_priority: function(newValue, oldValue) {
        if (newValue == 1 || newValue == 2 || newValue == 3){
          this.discount_priority = 0
        } else if (newValue == 4 || newValue == 5 || newValue == 6){
          this.discount_priority = 5
        } else if (newValue == 7 || newValue == 8 || newValue == 9){
          this.discount_priority = 10
        } else if(newValue == 10 || newValue == 11 || newValue == 12){
          this.discount_priority = 15
        }
      }
    }
  })
</script>