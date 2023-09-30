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

public class PropertyTypeController {
    @WebServlet("/property-type-management")
    public static class PropertyTypeManagement extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            ArrayList<MyObject> property_list = DB.getData("select * from property_types", new String[]{"id", "name"});
            req.setAttribute("property_list", property_list);
            req.getRequestDispatcher("/views/admin/property-type-management.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String name = req.getParameter("name");
            boolean check = DB.executeUpdate("insert into property_types (name) values (?)", new String[]{name});
            if (check){
                req.getSession().setAttribute("mess", "success|OK");
            } else {
                req.getSession().setAttribute("mess", "error|No OK");
            }
            resp.sendRedirect("/property-type-management");
        }
    }
}
