package com.example.korean.Controller;

import com.example.korean.Database.DB;
import com.example.korean.Database.MyObject;
import com.example.korean.Init.Config;
import com.example.korean.Init.SendMail;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Properties;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public class UserController {
    @WebServlet("/register")
    public static class RegisterController extends HttpServlet {

        public static boolean checkEmail(String email) {
            return DB.getData("select * from users where email = ?", new String[]{email}, new String[]{"id"}).size() == 0;
        }

        public static boolean checkPhone(String phone) {
            return DB.getData("select * from users where email = ?", new String[]{phone}, new String[]{"id"}).size() == 0;
        }

        public static boolean checkNational_id(String national_id) {
            return DB.getData("select * from users where national_id = ?", new String[]{national_id}, new String[]{"id"}).size() == 0;
        }

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            if (req.getSession().getAttribute("load_reg_form") != null){
                MyObject load_reg_form = (MyObject) req.getSession().getAttribute("load_reg_form");
                req.setAttribute("load_form", load_reg_form);
                req.getSession().removeAttribute("load_reg_form");
            }
            req.getRequestDispatcher("views/auth/register.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String national_id = req.getParameter("national_id");
            String name = req.getParameter("name");
            String password = req.getParameter("password");
            String dob = req.getParameter("dob");
            boolean check_email = checkEmail(email);
            boolean check_phone = checkPhone(phone);
            boolean check_national_id = checkNational_id(national_id);
            boolean error = check_email && check_phone && check_national_id;
            Properties language = (Properties) req.getAttribute("language");
            if (!error) {
                String err_mess = "";
                if (!check_email) {
                    err_mess += language.getProperty("email");
                }
                if (!check_phone) {
                    err_mess += err_mess.equals("") ? language.getProperty("phone") : ", " + language.getProperty("phone");
                }
                if (!check_national_id) {
                    err_mess += err_mess.equals("") ? language.getProperty("national_id") : ", " + language.getProperty("national_id");
                }
                req.getSession().setAttribute("mess", "warning|" + err_mess + " " + language.getProperty("duplicated") + ".");
                MyObject load_form = new MyObject();
                load_form.email = email;
                load_form.name = name;
                load_form.phone = phone;
                load_form.dob = dob;
                load_form.national_id = national_id;
                req.getSession().setAttribute("load_reg_form", load_form);
                resp.sendRedirect("/register");
            } else {
                String uuid = UUID.randomUUID().toString();
                String sql = "insert into users(name, email, password, avatar, phone, dob, national_id,  hash, is_admin, is_verified, cards_verified) values(?, ?, ?, '/files/default-avatar.webp', ?, ?, ?, ?, 'false', 'false', 'false');";
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
                String[] vars = new String[]{name, email, password, phone, dob, national_id, uuid};
                boolean status = DB.executeUpdate(sql, vars);
                if (status) {
                    req.getSession().setAttribute("mess", "success|" + language.getProperty("create_account_success"));
                    resp.sendRedirect("/login");
                } else {
                    req.getSession().setAttribute("mess", "error|" + language.getProperty("create_account_fail"));
                    MyObject load_form = new MyObject();
                    load_form.email = email;
                    load_form.name = name;
                    load_form.phone = phone;
                    load_form.dob = dob;
                    load_form.national_id = national_id;
                    req.getSession().setAttribute("load_reg_form", load_form);
                    resp.sendRedirect("/register");
                }
            }
        }
    }

    @WebServlet("/login")
    public static class LoginController extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            if (req.getSession().getAttribute("load_log_form") != null){
                MyObject load_log_form = (MyObject) req.getSession().getAttribute("load_log_form");
                req.setAttribute("load_form", load_log_form);
                req.getSession().removeAttribute("load_log_form");
            }
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String sql = "select * from users where email = ? and password = ?";
            String[] vars = new String[]{email, password};
            String[] fields = new String[]{"id", "name", "email", "password", "avatar", "phone", "dob", "national_id", "front_id_card", "back_id_card", "hash", "is_verified", "is_admin"};
            ArrayList<MyObject> list = DB.getData(sql, vars, fields);
            Properties language = (Properties) req.getAttribute("language");
            if (list.size() == 0) {
                req.getSession().setAttribute("mess", "warning|" + language.getProperty("login_fail"));
                resp.sendRedirect("/login");
            } else {
                if (list.get(0).is_verified.equals("false")){
                    req.getSession().setAttribute("mess", "success|" + language.getProperty("account_not_verified"));
                    req.getSession().setAttribute("load_log_form", email);
                    resp.sendRedirect("/login");
                } else {
                    req.getSession().setAttribute("mess", "success|" + language.getProperty("login_success"));
                    req.getSession().setAttribute("login", list.get(0));
                    resp.sendRedirect("/");
                }
            }
        }
    }

    @WebServlet("/change-language")
    public static class ChangeLanguage extends HttpServlet {
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
    public static class Active extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String key = req.getParameter("key");
            boolean check_key = DB.getData("select * from users where hash = ? ;", new String[]{key}, new String[]{"id"}).size() == 0;
            Properties language = (Properties) req.getAttribute("language");
            if (check_key) {
                req.setAttribute("warning", language.getProperty("no_hash"));
            } else {
                boolean make_verified = DB.executeUpdate("update users set is_verified = ?, hash = '' where hash = ?", new String[]{"true", key});
                if (make_verified) {
                    req.setAttribute("success", language.getProperty("verified_success"));
                } else {
                    req.setAttribute("error", language.getProperty("verified_error"));
                }
            }
            req.getRequestDispatcher("/views/auth/active.jsp").forward(req, resp);
        }
    }

    @WebServlet("/user/logout")
    public static class Logout extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getSession().removeAttribute("login");
            resp.sendRedirect("/");
        }
    }

    @WebServlet("/user/profile")
    public static class Profile extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
/*            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String sql = "select files.* from files inner join users on files.id = users.front_id_card or files.id = users.back_id_card where users.id = ?";
            String[] vars = new String[]{user.id};
            String[] fields = new String[]{"id", "path"};
            ArrayList<MyObject> id_cards = DB.getData(sql, vars, fields);
            if (id_cards.size() != 0){
                for (int i = 0; i < id_cards.size(); i++) {
                    if (id_cards.get(i).id.equals(user.front_id_card)){
                        id_cards.get(i).description = "front";
                    } else {
                        id_cards.get(i).description = "back";
                    }
                    System.out.println(id_cards.get(i).path + "|" + id_cards.get(i).description);
                }
                req.setAttribute("id_cards", id_cards);
            }*/
            req.getRequestDispatcher("/views/user/profile.jsp").forward(req, resp);
        }
    }

    @WebServlet("/login-google")
    public static class GoogleLogin extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String code = req.getParameter("code");
            JSONObject json = new JSONObject();
            json.put("code", code);
            json.put("client_id", Config.config.getProperty("client_id"));
            json.put("client_secret", Config.config.getProperty("client_secret"));
            json.put("redirect_uri", Config.config.getProperty("redirect_uri"));
            json.put("grant_type", "authorization_code");
            try {
                HttpClient httpClient = HttpClients.createDefault();
                HttpPost httpPost = new HttpPost(new URI("https://oauth2.googleapis.com/token"));
                httpPost.setHeader("Content-Type", "application/json");
                httpPost.setEntity(new StringEntity(json.toString(), ContentType.APPLICATION_JSON));
                HttpResponse response = httpClient.execute(httpPost);
                HttpEntity responseEntity = response.getEntity();

                if (responseEntity != null) {
                    String responseString = EntityUtils.toString(responseEntity);
                    ObjectMapper objectMapper = new ObjectMapper();
                    try {
                        JsonNode jsonResponse = objectMapper.readTree(responseString);
                        String access_token = jsonResponse.get("access_token").asText();
                        HttpClient httpGetClient = HttpClients.createDefault();
                        HttpGet httpGet = new HttpGet("https://www.googleapis.com/oauth2/v1/userinfo?access_token=" + access_token);
                        try {
                            HttpResponse responseFromGet = httpGetClient.execute(httpGet);
                            HttpEntity responseEntityFromGet = responseFromGet.getEntity();

                            if (responseEntityFromGet != null) {
                                String responseStringFromGet = EntityUtils.toString(responseEntityFromGet);
                                objectMapper = new ObjectMapper();
                                jsonResponse = objectMapper.readTree(responseStringFromGet);
                                String email = jsonResponse.get("email").asText();
                                boolean checkMail = RegisterController.checkEmail(email);
                                if (checkMail) { // chưa có acc
                                    String name = jsonResponse.get("name").asText();
                                    String avatar = jsonResponse.get("picture").asText();
                                    req.setAttribute("email", email);
                                    req.setAttribute("name", name);
                                    req.setAttribute("avatar", avatar);
                                    req.getRequestDispatcher("/views/auth/add-more-info.jsp").forward(req, resp);
                                } else {
                                    MyObject user = DB.getData("select * from users where email = ?", new String[]{email}, new String[]{"id", "name", "email", "password", "avatar", "phone", "dob", "national_id", "front_id_card", "back_id_card", "hash", "is_verified", "is_admin"}).get(0);
                                    req.getSession().setAttribute("login", user);
                                    req.getSession().setAttribute("mess", "success|" + language.getProperty("login_success"));
                                    resp.sendRedirect("/");
                                }

                            }
                        } catch (IOException e) {
                            e.printStackTrace();
                            req.getSession().setAttribute("mess", "success|" + language.getProperty("login_fail"));
                        }

                    } catch (IOException e) {
                        e.printStackTrace();
                        req.getSession().setAttribute("mess", "success|" + language.getProperty("login_fail"));
                    }
                }
            } catch (URISyntaxException e) {
                e.printStackTrace();
                req.getSession().setAttribute("mess", "success|" + language.getProperty("login_fail"));
            }
        }
    }

    @WebServlet("/add-more-info")
    public static class AddMoreInfo extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String national_id = req.getParameter("national_id");
            boolean check_email = RegisterController.checkEmail(email);
            boolean check_phone = RegisterController.checkPhone(phone);
            boolean check_national_id = RegisterController.checkNational_id(national_id);
            boolean error = check_email && check_phone && check_national_id;
            Properties language = (Properties) req.getAttribute("language");
            if (!error) {
                String err_mess = "";
                if (!check_email) {
                    err_mess += language.getProperty("email");
                }
                if (!check_phone) {
                    err_mess += err_mess.equals("") ? language.getProperty("phone") : ", " + language.getProperty("phone");
                }
                if (!check_national_id) {
                    err_mess += err_mess.equals("") ? language.getProperty("national_id") : ", " + language.getProperty("national_id");
                }
                req.getSession().setAttribute("mess", "warning|" + err_mess + " " + language.getProperty("duplicated") + ".");
            } else {
                String name = req.getParameter("name");
                String password = req.getParameter("password");
                String dob = req.getParameter("dob");
                String avatar = req.getParameter("avatar");
                String uuid = UUID.randomUUID().toString();
                String sql = "insert into users(name, email, password, avatar, phone, dob, national_id,  hash, is_admin, is_verified, cards_verified) values(?, ?, ?, ?, ?, ?, ?, ?, 'false', 'true', 'false');";
                String[] vars = new String[]{name, email, password, avatar, phone, dob, national_id, uuid};
                boolean status = DB.executeUpdate(sql, vars);
                if (status) {
                    req.getSession().setAttribute("mess", "success|" + language.getProperty("login_success"));
                    MyObject user = DB.getData("select * from users where email = ?", new String[]{email}, new String[]{"id", "name", "email", "password", "avatar", "phone", "dob", "national_id", "front_id_card", "back_id_card", "hash", "is_verified", "is_admin"}).get(0);
                    req.getSession().setAttribute("login", user);
                    resp.sendRedirect("/");
                } else {
                    req.getSession().setAttribute("mess", "error|" + language.getProperty("login_fail"));
                    resp.sendRedirect("/login");
                }
            }
        }
    }

    @WebServlet("/user/change-avatar")
    @MultipartConfig(
            fileSizeThreshold = 1024 * 1024, // 1 MB
            maxFileSize = 1024 * 1024 * 10,      // 10 MB
            maxRequestSize = 1024 * 1024 * 10  // 10 MB
    )
    public static class ChangeAvatar extends HttpServlet{
        public static String generateUniqueFileName(String originalFileName) {
            String extension = "";
            int dotIndex = originalFileName.lastIndexOf('.');
            if (dotIndex >= 0 && dotIndex < originalFileName.length() - 1) {
                extension = originalFileName.substring(dotIndex + 1);
            }
            String uniquePart = UUID.randomUUID().toString();
            return uniquePart + "." + extension;
        }
        private static String getFileName(Part part) {
            String contentDisposition = part.getHeader("content-disposition");
            String[] tokens = contentDisposition.split(";");
            for (String token : tokens) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf('=') + 1).trim()
                            .replace("\"", "");
                }
            }
            return null;
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            try {
                Part filePart = req.getPart("image");
                String fileName = getFileName(filePart);
                assert fileName != null;
                String newFileName = generateUniqueFileName(fileName);
                String uploadDir = req.getServletContext().getRealPath("/") + "files";
                Path filePath = Paths.get(uploadDir, newFileName);
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
                MyObject user = (MyObject) req.getSession().getAttribute("login");
                String sql = "update users set avatar = ? where id = ?";
                boolean check_update = DB.executeUpdate(sql, new String[]{"/files/" + newFileName, user.id});
                if (check_update){
                    req.getSession().setAttribute("mess", "success|" + language.getProperty("update_avatar_success"));
                    user.avatar = "/files/" + newFileName;
                    req.getSession().setAttribute("login", user);
                } else {
                    req.getSession().setAttribute("mess", "error|" + language.getProperty("update_avatar_fail"));
                }
            }catch (Exception e){
                e.printStackTrace();
                req.setAttribute("error", language.getProperty("update_avatar_fail"));
            }
            resp.sendRedirect("/user/profile");
        }
    }

    @WebServlet("/user/update-cards")
    @MultipartConfig(
            fileSizeThreshold = 1024 * 1024, // 1 MB
            maxFileSize = 1024 * 1024 * 10,      // 10 MB
            maxRequestSize = 1024 * 1024 * 10  // 10 MB
    )
    public static class UpdateCards extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            System.out.println(req.getParameter("side"));
            Properties language = (Properties) req.getAttribute("language");
            try {
                Part filePart = req.getPart("image");
                String fileName = ChangeAvatar.getFileName(filePart);
                assert fileName != null;
                String newFileName = ChangeAvatar.generateUniqueFileName(fileName);
                String uploadDir = req.getServletContext().getRealPath("/") + "files";
                Path filePath = Paths.get(uploadDir, newFileName);
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
                }
                MyObject user = (MyObject) req.getSession().getAttribute("login");
                String sql = "";
                if (req.getParameter("side").equals("front")){
                    sql = "update users set front_id_card = ? where id = ?";
                    boolean check = DB.executeUpdate(sql, new String[]{"/files/" + newFileName, user.id});
                    if (check){
                        user.front_id_card = "/files/" + newFileName;
                        req.getSession().setAttribute("mess", "success|" + language.getProperty("update_avatar_success"));
                    } else {
                        req.getSession().setAttribute("mess", "error|" + language.getProperty("update_avatar_success"));
                    }
                } else {
                    sql = "update users set back_id_card = ? where id = ?";
                    boolean check = DB.executeUpdate(sql, new String[]{"/files/" + newFileName, user.id});
                    if (check){
                        user.back_id_card= "/files/" + newFileName;
                        req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_sucess"));
                    } else {
                        req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
                    }
                }

            }catch (Exception e){
                e.printStackTrace();
                req.setAttribute("error", language.getProperty("update_avatar_fail"));
            }
            resp.sendRedirect("/user/profile");
        }
    }
}
