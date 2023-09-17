package com.example.korean.Controller;

import com.example.korean.Database.DB;
import com.example.korean.Database.MyObject;
import com.example.korean.Init.Config;
import com.example.korean.Init.Language;
import com.example.korean.Init.SendMail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Properties;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class UserController {
    @WebServlet("/register")
    public static class RegisterController extends HttpServlet {

        public static boolean checkEmail(String email){
            return DB.getData("select * from users where email = ?", new String[]{email}, new String[]{"id"}).size() == 0;
        }

        public static boolean checkPhone(String phone){
            return DB.getData("select * from users where email = ?", new String[]{phone}, new String[]{"id"}).size() == 0;
        }
        public static boolean checkNational_id(String national_id){
            return DB.getData("select * from users where national_id = ?", new String[]{national_id}, new String[]{"id"}).size() == 0;
        }
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("views/auth/register.jsp").forward(req, resp);
        }
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String national_id = req.getParameter("national_id");
            boolean check_email = checkEmail(email);
            boolean check_phone = checkPhone(phone);
            boolean check_national_id = checkNational_id(national_id);
            boolean error = check_email && check_phone && check_national_id;
            Properties language = (Properties) req.getAttribute("language");
            if (!error){
                String err_mess = "";
                if (!check_email){
                    err_mess += language.getProperty("email");
                }
                if (!check_phone){
                    err_mess += err_mess.equals("") ? language.getProperty("phone") : ", " + language.getProperty("phone");
                }
                if (!check_national_id){
                    err_mess += err_mess.equals("") ? language.getProperty("national_id") : ", " + language.getProperty("national_id");
                }
                req.getSession().setAttribute("mess", "warning|"+err_mess+" "+language.getProperty("duplicated")+".");
            } else {
                String name = req.getParameter("name");
                String password = req.getParameter("password");
                String dob = req.getParameter("dob");
                String uuid = UUID.randomUUID().toString();
                String sql = "insert into users(name, email, password, avatar, phone, dob, national_id,  hash, is_admin, is_verified) values(?, ?, ?, '/files/default-avatar.webp', ?, ?, ?, ?, 'false', 'false');";


                ExecutorService executorService = Executors.newSingleThreadExecutor();
                executorService.submit(() -> {
                    try {
                        String html = language.getProperty("register_mail").replace("name", name).replace("app", Config.config.get("app_name").toString()).replace("host", Config.config.get("app_host").toString()).replace("uuid", uuid);
                        SendMail.send(email, language.getProperty("register_mail_subject"), html);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                });
                executorService.shutdown();
                String[] vars = new String[]{name, email, password, phone, dob, national_id,uuid};
                boolean status = DB.executeUpdate(sql, vars);
                if (status){
                    req.getSession().setAttribute("mess", "success|"+language.getProperty("create_account_success"));
                } else {
                    req.getSession().setAttribute("mess", "error|"+language.getProperty("create_account_fail"));
                }
            }
            resp.sendRedirect("/register");
        }
    }

    @WebServlet("/login")
    public static class LoginController extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            long startTime = System.nanoTime();

            ArrayList<MyObject> arrayList = DB.getData("select * from users where email = ?", new String[]{"tranquangminh116@gmail.com"}, new String[]{"id", "email", "name"});
            long endTime = System.nanoTime();

            // Calculate the execution time in milliseconds
            long executionTimeMillis = (endTime - startTime) / 1_000_000;
            req.setAttribute("time", executionTimeMillis);
            req.setAttribute("list", arrayList);
            req.getRequestDispatcher("/time.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        }
    }

    @WebServlet("/change-language")
    public static class ChangeLanguage extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String user_lang = req.getParameter("user_lang");
            String current_url = req.getParameter("current_url");
            Cookie targetCookie = new Cookie("lang", user_lang);
            resp.addCookie(targetCookie);
            resp.sendRedirect(current_url);
        }
    }

    @WebServlet("/active")
    public static class Active extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String key = req.getParameter("key");
            boolean check_key = DB.getData("select * from users where hash = ? ;", new String[]{key}, new String[]{"id"}).size() == 0;
            Properties language = (Properties) req.getAttribute("language");
            if (check_key){
                req.getSession().setAttribute("mess", "error|"+ language.getProperty("no_hash") );
            } else {

            }
        }
    }
}
