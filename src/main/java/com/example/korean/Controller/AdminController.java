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

    @WebServlet("/admin/user-management")
    public static class UserManagement extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            ArrayList<MyObject> list = DB.getData("select * from users",  new String[]{"id", "name", "email", "avatar", "phone", "dob", "national_id", "front_id_card", "back_id_card", "is_verified", "cards_verified", "is_admin"});
            req.setAttribute("list", list);
            req.getRequestDispatcher("/views/admin/user-management.jsp").forward(req, resp);
        }
    }

    @WebServlet("/admin/change-verified-card")
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
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/user-management");
        }
    }

    @WebServlet("/admin/location-management")
    public static class LocationManagement extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String sql = "select * from provinces;";
            ArrayList<MyObject> provinces_list = DB.getData(sql, new String[]{"id", "name"});
            sql = "select * from districts;";
            ArrayList<MyObject> districts_list = DB.getData(sql, new String[]{"id", "name", "province_id"});
            req.setAttribute("provinces_list", provinces_list);
            req.setAttribute("districts_list", districts_list);
            req.getRequestDispatcher("/views/admin/location-management.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String name = req.getParameter("province_name");
            boolean check = DB.executeUpdate("insert into provinces(name) values(?);", new String[]{name});
            if (check){
                req.getSession().setAttribute("mess", "success|"+language.get("add_success"));
            } else {
                req.getSession().setAttribute("mess", "error|"+language.get("add_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/location-management");
        }
    }

    @WebServlet("/admin/add-districts")
    public static class AddDistricts extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String district_name = req.getParameter("district_name");
            String province_id = req.getParameter("province_id");
            String sql = "insert into districts(name, province_id) values(?, ?)";
            boolean check = DB.executeUpdate(sql, new String[]{district_name, province_id});
            if (check){
                req.getSession().setAttribute("mess", "success|"+language.getProperty("add_success"));
            } else {
                req.getSession().setAttribute("mess", "error|"+language.getProperty("add_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/location-management");
        }
    }
}
