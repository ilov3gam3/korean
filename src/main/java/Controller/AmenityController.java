package Controller;

import Database.DB;
import Database.MyObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Properties;

public class AmenityController {
    @WebServlet("/admin/amenities")
    public static class AmenityIndex extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String sql = "select * from amenities";
            String[] fields = new String[]{"id", "name_vn", "name_kr"};
            ArrayList<MyObject> amenities = DB.getData(sql, fields);
            req.setAttribute("amenities", amenities);
            req.getRequestDispatcher("/views/admin/amenities.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String name_vn = req.getParameter("name_vn");
            String name_kr = req.getParameter("name_kr");
            String sql = "insert into amenities(name_vn, name_kr) values (?, ?);";
            String[] vars = new String[]{name_vn, name_kr};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("add_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("add_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/amenities");
        }
    }
}
