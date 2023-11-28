<%@ page import="java.util.ArrayList" %>
<%@page contentType="text/html" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../master/head.jsp" %>
<% ArrayList<MyObject> subs =( ArrayList<MyObject>) request.getAttribute("subs"); %>
<div class="container-fluid col-12 mb-3 d-flex justify-content-center">
    <table class="table table-bordered table-striped col-12" id="my_table">
                <thead>
                <tr>
                    <th scope="col">#</th>
                    <th><%= language.getProperty("view_subs_plan_name") %></th>
                    <th><%= language.getProperty("view_subs_from") %></th>
                    <th><%= language.getProperty("view_subs_to") %></th>
                    <th><%= language.getProperty("view_subs_num_of_prop") %></th>
                    <th><%= language.getProperty("view_subs_price_per_month") %></th>
                    <th><%= language.getProperty("view_subs_comments") %></th>
                    <th><%= language.getProperty("view_subs_words_in_comment") %></th>
                    <th><%= language.getProperty("view_subs_discount") %></th>
                    <th><%= language.getProperty("view_subs_price_to_pay") %></th>
                    <th><%= language.getProperty("view_subs_create_at") %></th>
                    <th><%= language.getProperty("view_subs_pay_at") %></th>
                    <th><%= language.getProperty("view_subs_status") %></th>
                </tr>
                </thead>
                <tbody>
                    <% for (int i = 0; i < subs.size(); i++) { %>
                        <tr <%=subs.get(i).getVnp_TransactionStatus().equals("00") ? "class=\"table-success\"" : ""%>>
                            <td><%=subs.get(i).getId()%></td>
                            <td><%=lang.equals("vn") ? subs.get(i).getSubscribe_plans_name_vn() : subs.get(i).getSubscribe_plans_name_kr()%></td>
                            <td><%=subs.get(i).getFrom_date()%></td>
                            <td><%=subs.get(i).getTo_date()%></td>
                            <td><%=subs.get(i).getNumber_of_property()%></td>
                            <td><%=subs.get(i).getPrice_per_month()%></td>
                            <td><%=subs.get(i).getNumber_of_comments()%></td>
                            <td><%=subs.get(i).getNumber_of_words_per_cmt()%></td>
                            <td><%=subs.get(i).getDiscount()%></td>
                            <td><%=subs.get(i).getPrice_to_pay()%></td>
                            <td><%=subs.get(i).getCreate_order_at()%></td>
                            <td><%=subs.get(i).getPaid_at()%></td>
                            <td><%=subs.get(i).getVnp_TransactionStatus().equals("00") ? "<button class='btn btn-success'>"+language.getProperty("view_subs_status_success")+"</button>" : "<span class='btn btn-danger'>"+language.getProperty("view_subs_status_fail")+"</span>"%></td>
                        </tr>
                    <% } %>

                </tbody>
            </table>
</div>
<%@ include file="../master/foot.jsp" %>
