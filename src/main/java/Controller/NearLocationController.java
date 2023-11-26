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

public class NearLocationController {
    @WebServlet("/admin/near-by-locations")
    public static class NearLocationIndex extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String sql = "select nearby_locations.*, count(properties.id) as numbers from nearby_locations left join property_near_location on nearby_locations.id = property_near_location.near_location_id left join properties on property_near_location.property_id = properties.id\n" +
                    "group by nearby_locations.id, nearby_locations.name_vn, nearby_locations.name_kr";
            String[] fields = new String[]{"id", "name_vn", "name_kr", "numbers"};
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
    @WebServlet("/admin/update-near-location")
    public static class UpdateNearLocation extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String update_name_vn = req.getParameter("update_name_vn");
            String update_name_kr = req.getParameter("update_name_kr");
            String sql = "update nearby_locations set name_vn = ?, name_kr = ? where id = ?;";
            String[] vars = new String[]{update_name_vn, update_name_kr, id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("add_fupdate_id_card_failail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/near-by-locations");
        }

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "delete nearby_locations where id = ?";
            String[] vars = new String[]{id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("delete_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("delete_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/near-by-locations");
        }
    }
}
