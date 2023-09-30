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

public class PropertyType {
    @WebServlet("/property-type-management")
    public static class PropertyTypeManagement extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            ArrayList<MyObject> property_list = DB.getData("select * from property_type", new String[]{"id", "name"});
            req.setAttribute("property_list", property_list);
            req.getRequestDispatcher("/views/admin/property-type-management.jsp");
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String name = req.getParameter("name");
            boolean check = DB.executeUpdate("insert into property_type(name) values (?)")
        }
    }
}
