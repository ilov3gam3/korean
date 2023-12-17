package Controller;

import Database.DB;
import Database.MyObject;
import Init.Config;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class SubscribeController {
    @WebServlet("/admin/view-all-plans")
    public static class ViewPlans extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String sql = "select subscribe_plans.*, count(subscriptions.id) as numbers from subscribe_plans left join subscriptions on subscribe_plans.id = subscriptions.subscribe_plans_id\n" +
                    "group by subscribe_plans.id, name_vn, name_kr, subscribe_plans.number_of_property, subscribe_plans.price_per_month, subscribe_plans.number_of_comments, subscribe_plans.number_of_words_per_cmt, hidden";
            String[] fields = new String[]{"id", "name_vn", "name_kr", "number_of_property", "price_per_month", "number_of_comments", "number_of_words_per_cmt", "hidden", "numbers"};
            ArrayList<MyObject> plans = DB.getData(sql, fields);

            sql = "select priority_plans.*, count(subscriptions.id) as numbers from priority_plans left join subscriptions on priority_plans.id = subscriptions.priority_plans_id\n" +
                    "group by priority_plans.id, priority_plans.priority, hidden, priority_plans.price_per_property";
            fields = new String[]{"id", "priority", "hidden", "price_per_property", "numbers"};
            ArrayList<MyObject> priority_plans = DB.getData(sql, fields);
            req.setAttribute("plans",plans);
            req.setAttribute("priority_plans",priority_plans);
            req.getRequestDispatcher("/views/admin/plans.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String name_vn = req.getParameter("name_vn");
            String name_kr = req.getParameter("name_kr");
            String number_of_property = req.getParameter("number_of_property");
            String price_per_month = req.getParameter("price_per_month");
            String number_of_comments = req.getParameter("number_of_comments");
            String number_of_words_per_cmt = req.getParameter("number_of_words_per_cmt");
            String[] vars = new String[]{name_vn, name_kr, number_of_property, price_per_month, number_of_comments, number_of_words_per_cmt};
            String sql = "insert into subscribe_plans(name_vn, name_kr, number_of_property, price_per_month, number_of_comments, number_of_words_per_cmt, hidden) values (?, ?, ?, ?, ?, ?, 'false')";
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|"+language.getProperty("add_success"));
            } else {
                req.getSession().setAttribute("mess", "error|"+language.getProperty("add_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/view-all-plans");
        }
    }

    @WebServlet("/user/upgrade-account")
    @MultipartConfig(
            fileSizeThreshold = 1024 * 1024, // 1 MB
            maxFileSize = 1024 * 1024 * 50,      // 10 MB
            maxRequestSize = 1024 * 1024 * 50  // 10 MB
    )
    public static class UserUpgradeAccount extends HttpServlet{
        public static Date[] calculateDatesAfterXMonths(int x) {
            Calendar calendar = Calendar.getInstance();
            Date currentDate = calendar.getTime();
            calendar.add(Calendar.MONTH, x);
            calendar.add(Calendar.DAY_OF_MONTH, -1); // Subtract 1 day to get the last day of the month
            Date futureDate = calendar.getTime();
            return new Date[]{currentDate, futureDate};
        }
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String sql = "select * from subscribe_plans where hidden = 'false'";
            String[] fields = new String[]{"id", "name_vn", "name_kr", "number_of_property", "price_per_month", "number_of_comments", "number_of_words_per_cmt", "hidden"};
            ArrayList<MyObject> plans = DB.getData(sql, fields);
            LocalDateTime currentDateTime = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String current_date = currentDateTime.format(formatter);
            sql = "select * from subscriptions where user_id = ? and from_date < ? and to_date > ? and vnp_TransactionStatus = '00'";
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String[] vars = new String[]{user.id, current_date, current_date};
            fields = new String[]{"id", "from_date", "to_date", "number_of_property"};
            ArrayList<MyObject> subs = DB.getData(sql, vars, fields);
            ArrayList<MyObject> priority_plans = DB.getData("select * from priority_plans where hidden = 'false'", new String[]{"id", "priority", "price_per_property"});
            req.setAttribute("plans",plans);
            req.setAttribute("subs",subs);
            req.setAttribute("priority_plans",priority_plans);
            req.getRequestDispatcher("/views/user/upgrade.jsp").forward(req, resp);
        }
        static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        public static boolean checkSubs(String user_id){
            LocalDateTime currentDateTime = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String current_date = currentDateTime.format(formatter);
            String sql = "select * from subscriptions where user_id = ? and from_date < ? and to_date > ? and vnp_TransactionStatus = '00'";
            String[] vars = new String[]{user_id, current_date, current_date};
            String[] fields = new String[]{"id", "from_date", "to_date"};
            return DB.getData(sql, vars, fields).size() == 0;
        }
        // status code: 00 success
        // status code: 0 pending
        // status code: 02 cancel
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            com.google.gson.JsonObject job = new JsonObject();
            if (checkSubs(user.id)){
                String choosing_priority = req.getParameter("choosing_priority");
                if (choosing_priority.equals("0")){
                    String plan_id = req.getParameter("plan_id");
                    int months = Integer.parseInt(req.getParameter("months"));
                    String sql = "select * from subscribe_plans where id = ?";
                    String[] vars = new String[]{plan_id};
                    String[] fields = new String[]{"id", "name_vn", "name_kr", "number_of_property", "price_per_month", "number_of_comments", "number_of_words_per_cmt"};
                    ArrayList<MyObject> plans  = DB.getData(sql, vars, fields);
                    int price = Integer.parseInt(plans.get(0).getPrice_per_month());
                    int discount = 0;
                    if (months == 1 || months == 2 || months == 3){
                        discount = 0;
                    } else if (months == 4 || months == 5 || months == 6){
                        discount = 5;
                    } else if (months == 7 || months == 8 || months == 9){
                        discount = 10;
                    } else if(months == 10 || months == 11 || months == 12){
                        discount = 15;
                    }
                    //==================
                    String vnp_Version = "2.1.0";
                    String vnp_Command = "pay";
                    String orderType = "other";
                    long amount = (long) (price * months * (1 - (float)(discount) / 100));
                    String bankCode = req.getParameter("bankCode");
                    String vnp_TxnRef = Config.getRandomNumber(8);
                    String vnp_IpAddr = Config.getIpAddress(req);
                    String vnp_TmnCode = Config.vnp_TmnCode;
                    Map<String, String> vnp_Params = new HashMap<>();
                    vnp_Params.put("vnp_Version", vnp_Version);
                    vnp_Params.put("vnp_Command", vnp_Command);
                    vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
                    vnp_Params.put("vnp_Amount", amount + "00");
                    vnp_Params.put("vnp_CurrCode", "VND");

                    if (bankCode != null && !bankCode.isEmpty()) {
                        vnp_Params.put("vnp_BankCode", bankCode);
                    }
                    vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
                    String vnp_OrderInfo = String.valueOf(UUID.randomUUID());
                    vnp_OrderInfo += "|" + System.currentTimeMillis();
                    vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
                    vnp_Params.put("vnp_OrderType", orderType);

                    String locate = req.getParameter("language");
                    if (locate != null && !locate.isEmpty()) {
                        vnp_Params.put("vnp_Locale", locate);
                    } else {
                        vnp_Params.put("vnp_Locale", "vn");
                    }
                    vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl);
                    vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

                    Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
                    SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
                    SimpleDateFormat sqlFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    String vnp_CreateDate = formatter.format(cld.getTime());
                    vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

                    cld.add(Calendar.MINUTE, 15);
                    String vnp_ExpireDate = formatter.format(cld.getTime());
                    vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

                    List fieldNames = new ArrayList(vnp_Params.keySet());
                    Collections.sort(fieldNames);
                    StringBuilder hashData = new StringBuilder();
                    StringBuilder query = new StringBuilder();
                    Iterator itr = fieldNames.iterator();
                    //========================================
                    sql = "insert into subscriptions(user_id, subscribe_plans_id, from_date, to_date, number_of_property, price_per_month, number_of_comments, number_of_words_per_cmt, discount, price_to_pay, vnp_TxnRef, vnp_OrderInfo, create_order_at, vnp_TransactionStatus) values (?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?, 0)";
                    Date[] dates = calculateDatesAfterXMonths(months);
                    try {
                        vars = new String[]{user.id, plan_id,dateFormat.format(dates[0]), dateFormat.format(dates[1]), plans.get(0).getNumber_of_property(), plans.get(0).getPrice_per_month(), plans.get(0).getNumber_of_comments(), plans.get(0).getNumber_of_words_per_cmt(), String.valueOf(discount),String.valueOf(amount), vnp_TxnRef, vnp_OrderInfo,  sqlFormatter.format(formatter.parse(vnp_CreateDate))};
                    } catch (ParseException e) {
                        throw new RuntimeException(e);
                    }
                    //========================================
                    DB.executeUpdate(sql, vars);
                    while (itr.hasNext()) {
                        String fieldName = (String) itr.next();
                        String fieldValue = (String) vnp_Params.get(fieldName);
                        if ((fieldValue != null) && (fieldValue.length() > 0)) {
                            //Build hash data
                            hashData.append(fieldName);
                            hashData.append('=');
                            hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                            //Build query
                            query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                            query.append('=');
                            query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                            if (itr.hasNext()) {
                                query.append('&');
                                hashData.append('&');
                            }
                        }
                    }
                    String queryUrl = query.toString();
                    String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
                    queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
                    String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
                    job.addProperty("code", "00");
                    job.addProperty("message", "success");
                    job.addProperty("data", paymentUrl);
                }
                else {
                    String plan_id = req.getParameter("plan_id");
                    int months = Integer.parseInt(req.getParameter("months"));
                    String sql = "select * from subscribe_plans where id = ?";
                    String[] vars = new String[]{plan_id};
                    String[] fields = new String[]{"id", "name_vn", "name_kr", "number_of_property", "price_per_month", "number_of_comments", "number_of_words_per_cmt"};
                    ArrayList<MyObject> plans  = DB.getData(sql, vars, fields);
                    int price = Integer.parseInt(plans.get(0).getPrice_per_month());
                    //==================
                    sql = "select * from priority_plans where id = ?";
                    vars = new String[]{choosing_priority};
                    fields = new String[]{"id", "priority", "hidden", "price_per_property"};
                    ArrayList<MyObject> priorities  = DB.getData(sql, vars, fields);
                    //==================
                    int price_per_property = Integer.parseInt(priorities.get(0).getPrice_per_property());
                    int number_of_property = Integer.parseInt(plans.get(0).getNumber_of_property());
                    int discount = 0;
                    if (months == 1 || months == 2 || months == 3){
                        discount = 0;
                    } else if (months == 4 || months == 5 || months == 6){
                        discount = 5;
                    } else if (months == 7 || months == 8 || months == 9){
                        discount = 10;
                    } else if(months == 10 || months == 11 || months == 12){
                        discount = 15;
                    }
                    //==================
                    String vnp_Version = "2.1.0";
                    String vnp_Command = "pay";
                    String orderType = "other";
                    long amount = (long) (((long) price * months + (long) price_per_property * number_of_property) * (1 - (float)(discount) / 100));
                    String bankCode = req.getParameter("bankCode");
                    String vnp_TxnRef = Config.getRandomNumber(8);
                    String vnp_IpAddr = Config.getIpAddress(req);
                    String vnp_TmnCode = Config.vnp_TmnCode;
                    Map<String, String> vnp_Params = new HashMap<>();
                    vnp_Params.put("vnp_Version", vnp_Version);
                    vnp_Params.put("vnp_Command", vnp_Command);
                    vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
                    vnp_Params.put("vnp_Amount", amount + "00");
                    vnp_Params.put("vnp_CurrCode", "VND");

                    if (bankCode != null && !bankCode.isEmpty()) {
                        vnp_Params.put("vnp_BankCode", bankCode);
                    }
                    vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
                    String vnp_OrderInfo = String.valueOf(UUID.randomUUID());
                    vnp_OrderInfo += "|" + System.currentTimeMillis();
                    vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
                    vnp_Params.put("vnp_OrderType", orderType);

                    String locate = req.getParameter("language");
                    if (locate != null && !locate.isEmpty()) {
                        vnp_Params.put("vnp_Locale", locate);
                    } else {
                        vnp_Params.put("vnp_Locale", "vn");
                    }
                    vnp_Params.put("vnp_ReturnUrl", Config.vnp_ReturnUrl);
                    vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

                    Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
                    SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
                    SimpleDateFormat sqlFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    String vnp_CreateDate = formatter.format(cld.getTime());
                    vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

                    cld.add(Calendar.MINUTE, 15);
                    String vnp_ExpireDate = formatter.format(cld.getTime());
                    vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

                    List fieldNames = new ArrayList(vnp_Params.keySet());
                    Collections.sort(fieldNames);
                    StringBuilder hashData = new StringBuilder();
                    StringBuilder query = new StringBuilder();
                    Iterator itr = fieldNames.iterator();
                    //========================================
                    sql = "insert into subscriptions(user_id, subscribe_plans_id, from_date, to_date, number_of_property, price_per_month, number_of_comments, number_of_words_per_cmt, discount, price_to_pay, vnp_TxnRef, vnp_OrderInfo, create_order_at, vnp_TransactionStatus, priority_plans_id, priority, price_per_property) values (?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?, ?, 0, ? , ?, ?)";
                    Date[] dates = calculateDatesAfterXMonths(months);
                    try {
                        vars = new String[]{user.id, plan_id,dateFormat.format(dates[0]), dateFormat.format(dates[1]), plans.get(0).getNumber_of_property(), plans.get(0).getPrice_per_month(), plans.get(0).getNumber_of_comments(), plans.get(0).getNumber_of_words_per_cmt(), String.valueOf(discount),String.valueOf(amount), vnp_TxnRef, vnp_OrderInfo,  sqlFormatter.format(formatter.parse(vnp_CreateDate)), priorities.get(0).getId(), priorities.get(0).getPriority(), priorities.get(0).getPrice_per_property()};
                    } catch (ParseException e) {
                        throw new RuntimeException(e);
                    }
                    //========================================
                    DB.executeUpdate(sql, vars);
                    while (itr.hasNext()) {
                        String fieldName = (String) itr.next();
                        String fieldValue = (String) vnp_Params.get(fieldName);
                        if ((fieldValue != null) && (fieldValue.length() > 0)) {
                            //Build hash data
                            hashData.append(fieldName);
                            hashData.append('=');
                            hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                            //Build query
                            query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                            query.append('=');
                            query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                            if (itr.hasNext()) {
                                query.append('&');
                                hashData.append('&');
                            }
                        }
                    }
                    String queryUrl = query.toString();
                    String vnp_SecureHash = Config.hmacSHA512(Config.secretKey, hashData.toString());
                    queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
                    String paymentUrl = Config.vnp_PayUrl + "?" + queryUrl;
                    job.addProperty("code", "00");
                    job.addProperty("message", "success");
                    job.addProperty("data", paymentUrl);
                }

            } else {
                Properties language = (Properties) req.getAttribute("language");
                job.addProperty("code", "01");
                job.addProperty("message", "error");
                job.addProperty("data", language.getProperty("has_subs"));
            }
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/user/vnpay-result")
    public static class VNPAYResult extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            SimpleDateFormat sqlFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String amount = req.getParameter("vnp_Amount").replaceFirst("00", "");
            String paid_at = req.getParameter("vnp_PayDate");
            try {
                paid_at = sqlFormatter.format(formatter.parse(paid_at));
            } catch (ParseException e) {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("something_error"));
                resp.sendRedirect(req.getContextPath() + "/user/recharge-balance");
            }
            String vnp_TransactionStatus = req.getParameter("vnp_TransactionStatus");
            String vnp_TransactionNo = req.getParameter("vnp_TransactionNo");
            String vnp_BankTranNo = req.getParameter("vnp_BankTranNo");
            String vnp_CardType = req.getParameter("vnp_CardType");
            String vnp_BankCode = req.getParameter("vnp_BankCode");
            String vnp_OrderInfo = req.getParameter("vnp_OrderInfo");
            String vnp_TxnRef = req.getParameter("vnp_TxnRef");

            String sql = "update subscriptions set vnp_BankCode = ?, vnp_TransactionNo = ?, vnp_TransactionStatus = ?, vnp_CardType = ?, vnp_BankTranNo = ?, paid_at = ? where user_id = ? and price_to_pay = ? and vnp_TxnRef = ? and vnp_OrderInfo = ?";
            String[] vars = new String[]{vnp_BankCode, vnp_TransactionNo, vnp_TransactionStatus, vnp_CardType, vnp_BankTranNo, paid_at, user.id, amount, vnp_TxnRef, vnp_OrderInfo};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                if (vnp_TransactionStatus.equals("00")){
                    req.getSession().setAttribute("mess", "success|" + language.getProperty("pay_success"));
                } else {
                    req.getSession().setAttribute("mess", "warning|" + language.getProperty("pay_error"));
                }
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("system_error"));
            }
            resp.sendRedirect(req.getContextPath() + "/user/upgrade-account");
        }
    }

    @WebServlet("/admin/change-plan-status")
    public static class ChangePlanStatus extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "update subscribe_plans set hidden = ~hidden where id = ?";
            boolean check = DB.executeUpdate(sql, new String[]{id});
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "warning|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/view-all-plans");
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "delete from subscribe_plans where id = ?";
            String[] vars = new String[]{id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("delete_success"));
            } else {
                req.getSession().setAttribute("mess", "warning|" + language.getProperty("delete_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/view-all-plans");
        }
    }

    @WebServlet("/admin/view-all-subscriptions")
    public static class ViewAllSubs extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String sql = "select subscriptions.*, subscribe_plans.name_vn as subscribe_plans_name_vn, subscribe_plans.name_kr as subscribe_plans_name_kr, users.name as username from subscriptions inner join subscribe_plans on subscriptions.subscribe_plans_id = subscribe_plans.id inner join users on subscriptions.user_id = users.id order by subscriptions.id desc";
            String[] fields = new String[]{"id", "user_id", "subscribe_plans_id", "from_date", "to_date", "number_of_property", "price_per_month", "number_of_comments", "number_of_words_per_cmt", "discount", "price_to_pay", "vnp_BankCode", "vnp_TransactionNo", "vnp_TransactionStatus", "vnp_OrderInfo", "vnp_TxnRef", "vnp_CardType", "vnp_BankTranNo", "create_order_at", "paid_at", "subscribe_plans_name_vn", "subscribe_plans_name_kr", "username", "priority", "price_per_property", "priority_plans_id"};
            ArrayList<MyObject> subs = DB.getData(sql, fields);
            req.setAttribute("subs", subs);
            req.getRequestDispatcher("/views/admin/view-subs.jsp").forward(req, resp);
        }
    }

    @WebServlet("/user/transaction")
    public static class UserTransaction extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            MyObject user = (MyObject)req.getSession().getAttribute("login");
            String sql = "select subscriptions.*, subscribe_plans.name_vn as subscribe_plans_name_vn, subscribe_plans.name_kr as subscribe_plans_name_kr, users.name as username from subscriptions inner join subscribe_plans on subscriptions.subscribe_plans_id = subscribe_plans.id inner join users on subscriptions.user_id = users.id where user_id = ?";
            String[] vars = new String[]{user.id};
            String[] fields = new String[]{"id", "user_id", "subscribe_plans_id", "from_date", "to_date", "number_of_property", "price_per_month", "number_of_comments", "number_of_words_per_cmt", "discount", "price_to_pay", "vnp_BankCode", "vnp_TransactionNo", "vnp_TransactionStatus", "vnp_OrderInfo", "vnp_TxnRef", "vnp_CardType", "vnp_BankTranNo", "create_order_at", "paid_at", "subscribe_plans_name_vn", "subscribe_plans_name_kr", "username", "priority", "price_per_property", "priority_plans_id"};
            ArrayList<MyObject> subs = DB.getData(sql,vars, fields);
            req.setAttribute("subs", subs);
            req.getRequestDispatcher("/views/user/view-subs.jsp").forward(req, resp);
        }
    }

    @WebServlet("/user/get-subs")
    public static class UserGetSubs extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            LocalDateTime currentDateTime = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String current_date = currentDateTime.format(formatter);
            MyObject user = (MyObject)req.getSession().getAttribute("login");
            com.google.gson.JsonObject job = new JsonObject();
            if (user.getIs_admin().equals("1")){
                job.addProperty("number_of_comments", String.valueOf(Integer.MAX_VALUE));
                job.addProperty("number_of_words_per_cmt", String.valueOf(Integer.MAX_VALUE));
                job.addProperty("commented", "0");
                job.addProperty("is_admin", true);
            }else {
                String sql = "select subscriptions.*, users.name as username from subscriptions inner join users on subscriptions.user_id = users.id where user_id = ? and from_date < ? and to_date > ? and vnp_TransactionStatus = '00'";
                String[] vars = new String[]{user.id, current_date, current_date};
                ArrayList<MyObject> subs = DB.getData(sql, vars, new String[]{"number_of_comments", "number_of_words_per_cmt", "from_date", "to_date"});
                if (subs.size() == 0){
                    job.addProperty("number_of_comments", "0");
                    job.addProperty("number_of_words_per_cmt", "0");
                    job.addProperty("commented", "0");
                } else {
                    sql = "select count(id) as count_comment from comments where user_id = ? and ? < created_at and created_at < ?";
                    vars = new String[]{user.id, subs.get(0).getFrom_date(), subs.get(0).getTo_date()};
                    ArrayList<MyObject> count_comments = DB.getData(sql, vars, new String[]{"count_comment"});
                    job.addProperty("number_of_comments", subs.get(0).getNumber_of_comments());
                    job.addProperty("number_of_words_per_cmt", subs.get(0).getNumber_of_words_per_cmt());
                    job.addProperty("commented", count_comments.get(0).getCount_comment());
                }
                job.addProperty("is_admin", false);
            }
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/admin/change-priority-status")
    public static class ChangePriority_status extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "update priority_plans set hidden = ~hidden where id = ?";
            boolean check = DB.executeUpdate(sql, new String[]{id});
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "warning|" + language.getProperty("update_id_card_fail"));
            }
            req.getSession().setAttribute("show_priority", true);
            resp.sendRedirect(req.getContextPath() + "/admin/view-all-plans");
        }
    }

    @WebServlet("/admin/delete-plan")
    public static class DeletePlan extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "delete subscribe_plans where id = ?";
            boolean check = DB.executeUpdate(sql, new String[]{id});
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("delete_success"));
            } else {
                req.getSession().setAttribute("mess", "warning|" + language.getProperty("delete_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/view-all-plans");
        }
    }

    @WebServlet("/admin/delete-priority")
    public static class DeletePriorityPlan extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "delete from priority_plans where id = ?";
            boolean check = DB.executeUpdate(sql, new String[]{id});
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("delete_success"));
            } else {
                req.getSession().setAttribute("mess", "warning|" + language.getProperty("delete_fail"));
            }
            req.getSession().setAttribute("show_priority", "true");
            resp.sendRedirect(req.getContextPath() + "/admin/view-all-plans");
        }
    }

    @WebServlet("/admin/add-priority")
    public static class AddPriority extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String priority = req.getParameter("priority");
            String price = req.getParameter("price");
            String sql = "insert into priority_plans(priority, hidden, price_per_property) values (?, 'false', ?)";
            String[] vars = new String[]{priority, price};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|"+language.getProperty("add_success"));
            } else {
                req.getSession().setAttribute("mess", "error|"+language.getProperty("add_fail"));
            }
            req.getSession().setAttribute("show_priority", "true");
            resp.sendRedirect(req.getContextPath() + "/admin/view-all-plans");
        }
    }

    @WebServlet("/admin/update-plan")
    public static class UpdatePlan extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String name_vn = req.getParameter("name_vn");
            String name_kr = req.getParameter("name_kr");
            String number_of_property = req.getParameter("number_of_property");
            String price_per_month = req.getParameter("price_per_month");
            String number_of_comments = req.getParameter("number_of_comments");
            String number_of_words_per_cmt = req.getParameter("number_of_words_per_cmt");
            String id = req.getParameter("id");
            String sql = "update subscribe_plans set name_vn = ?, name_kr = ?, number_of_property= ?, price_per_month= ?, number_of_comments= ?, number_of_words_per_cmt= ? where id = ?";
            String[] vars = new String[]{name_vn, name_kr, number_of_property, price_per_month, number_of_comments, number_of_words_per_cmt, id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|"+language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|"+language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/view-all-plans");
        }
    }

    @WebServlet("/admin/update-priority-plan")
    public static class UpdatePriorityPlan extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String priority = req.getParameter("priority");
            String price_per_property = req.getParameter("price_per_property");
            String id = req.getParameter("id");
            String sql = "update priority_plans set priority = ?, price_per_property = ? where id = ?";
            String[] vars = new String[]{priority, price_per_property, id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|"+language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|"+language.getProperty("update_id_card_fail"));
            }
            req.getSession().setAttribute("show_priority", "true");
            resp.sendRedirect(req.getContextPath() + "/admin/view-all-plans");
        }
    }

    @WebServlet("/user/cancel-subscription")
    public static class CancelSubscription extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String sql = "update subscriptions set vnp_TransactionStatus = -1 where id = ? and user_id = ?";
            String[] vars = new String[]{id, user.id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("canceled_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("canceled_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/user/transaction");
        }
    }
}
