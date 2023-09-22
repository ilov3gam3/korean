package com.example.korean.Controller;

import com.example.korean.Database.DB;
import com.example.korean.Database.MyObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Properties;

public class AdminController {
    @WebServlet("/admin")
    public static class AdminHome extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/admin/admin-panel.jsp").forward(req, resp);
        }
    }

    @WebServlet("/user-management")
    public static class UserManagement extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            ArrayList<MyObject> list = DB.getData("select * from users",  new String[]{"id", "name", "email", "avatar", "phone", "dob", "national_id", "front_id_card", "back_id_card", "is_verified", "cards_verified", "is_admin"});
            req.setAttribute("list", list);
            req.getRequestDispatcher("/views/admin/user-management.jsp").forward(req, resp);
        }
    }

    @WebServlet("/change-verified-card")
    public static class ChangeVerifiedCards extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String national_id = req.getParameter("national_id");
            String status = req.getParameter("status");
            if (status.equals("verified")){
                status = "true";
            }
            if (status.equals("un_verified")){
                status = "false";
            }
            String sql = "update users set cards_verified = ? where national_id = ?";
            boolean check = DB.executeUpdate(sql, new String[]{status, national_id});
            Properties language = (Properties) req.getAttribute("language");
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_sucess"));
            } else {
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect("/user-management");
        }
    }
}
