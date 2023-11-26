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
            String sql = "select amenities.*, count(properties.id) as numbers from amenities left join property_amenities on amenities.id = property_amenities.amenity_id left join properties on property_amenities.property_id = properties.id\n" +
                    "group by amenities.id, amenities.name_vn, amenities.name_kr";
            String[] fields = new String[]{"id", "name_vn", "name_kr", "numbers"};
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
    @WebServlet("/admin/update-amenity")
    public static class UpdateAmenity extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String id = req.getParameter("a_id");
            String name_kr = req.getParameter("name_kr");
            String name_vn = req.getParameter("name_vn");
            String sql = "update amenities set name_vn = ?, name_kr = ? where id = ?";
            boolean check = DB.executeUpdate(sql, new String[]{name_vn, name_kr, id});
            Properties language = (Properties) req.getAttribute("language");
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/amenities");
        }

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("a_id");
            String sql = "delete amenities where id = ?";
            String[] vars = new String[]{id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("delete_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("delete_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/amenities");
        }
    }
}
