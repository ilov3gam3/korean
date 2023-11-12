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

public class NearLocationController {
    @WebServlet("/admin/near-by-locations")
    public static class NearLocationIndex extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String sql = "select * from nearby_locations;";
            String[] fields = new String[]{"id", "name_vn", "name_kr"};
            ArrayList<MyObject> locations = DB.getData(sql, fields);
            req.setAttribute("locations", locations);
            req.getRequestDispatcher("/views/admin/near-location-controller.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String name_vn = req.getParameter("name_vn");
            String name_kr = req.getParameter("name_kr");
            String sql = "insert into nearby_locations(name_vn, name_kr) values (?, ?);";
            String[] vars = new String[]{name_vn, name_kr};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("add_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("add_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/near-by-locations");
        }
    }
}
