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
                    <th><%= language.getProperty("view_subs_from") %>, <%= language.getProperty("view_subs_to") %></th>
                    <th><%=language.getProperty("view_subs_plan_info")%></th>
                    <th><%=language.getProperty("view_subs_priority_plan_info")%></th>
                    <th><%= language.getProperty("view_subs_price_to_pay") %> (<%= language.getProperty("view_subs_discount") %>)</th>
                    <th><%= language.getProperty("view_subs_create_at") %>,<%= language.getProperty("view_subs_pay_at") %> </th>
                    <th><%= language.getProperty("view_subs_status") %></th>
                    <th><%= language.getProperty("view_subs_bank_info") %></th>
                </tr>
                </thead>
                <tbody>
                    <% for (int i = 0; i < subs.size(); i++) { %>
                        <tr <%=subs.get(i).getVnp_TransactionStatus().equals("00") ? "class=\"table-success\"" : ""%>>
                            <td><%=subs.get(i).getId()%></td>
                            <td><%=lang.equals("vn") ? subs.get(i).getSubscribe_plans_name_vn() : subs.get(i).getSubscribe_plans_name_kr()%></td>
                            <td><%=subs.get(i).getFrom_date()%><br><%=subs.get(i).getTo_date()%></td>
                            <td>
                                <%= language.getProperty("view_subs_num_of_prop") %>: <%=subs.get(i).getNumber_of_property()%><br>
                                <%= language.getProperty("view_subs_price_per_month") %>: <%=subs.get(i).getPrice_per_month()%><br>
                                <%= language.getProperty("view_subs_comments") %>: <%=subs.get(i).getNumber_of_comments()%><br>
                                <%= language.getProperty("view_subs_words_in_comment") %>: <%=subs.get(i).getNumber_of_words_per_cmt()%><br>
                            </td>
                            <td>
                                <% if (subs.get(i).getPriority() !=null){ %>
                                    <%=language.getProperty("view_subs_priority")%>: <%=subs.get(i).getPriority()%><br>
                                    <%=language.getProperty("view_subs_priority_price_per_prop")%>: <%=subs.get(i).getPrice_per_property()%>
                                <% } else { %>
                                    <%=language.getProperty("view_subs_no_priority")%>
                                <% } %>
                            </td>
                            <td><%=subs.get(i).getPrice_to_pay()%>₫ (- <%=subs.get(i).getDiscount()%>%)</td>
                            <td><%=subs.get(i).getCreate_order_at()%> <br><%=subs.get(i).getPaid_at() == null ? language.getProperty("no_paid") : subs.get(i).getPaid_at()%></td>
                            <td><%=subs.get(i).getVnp_TransactionStatus().equals("00") ? "<button class='btn btn-success'>"+language.getProperty("view_subs_status_success")+"</button>" : "<span class='btn btn-danger'>"+language.getProperty("view_subs_status_fail")+"</span>"%></td>
                            <td>
                                <% if (subs.get(i).getVnp_TransactionStatus().equals("00")){ %>
                                    <%=language.getProperty("view_subs_bank_code")%>: <%=subs.get(i).getVnp_BankCode()%><br>
                                    <%=language.getProperty("view_subs_transaction_number")%>: <%=subs.get(i).getVnp_TransactionNo()%><br>
                                    <%=language.getProperty("view_subs_transaction_status_code")%>: <%=subs.get(i).getVnp_TransactionStatus()%><br>
                                    <%=language.getProperty("view_subs_transaction_card_type")%>: <%=subs.get(i).getVnp_CardType()%>
                                <% } else { %>
                                    <%=language.getProperty("view_subs_transaction_no_paid")%>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
</div>
<%@ include file="../master/foot.jsp" %>
