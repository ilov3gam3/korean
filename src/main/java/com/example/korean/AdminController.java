package com.example.korean;

import com.example.korean.Database.DB;
import com.example.korean.Database.MyObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

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
}
