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

public class LocationController {
    @WebServlet("/admin/location-management")
    public static class LocationManagement extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String sql = "select * from provinces;";
            ArrayList<MyObject> provinces_list = DB.getData(sql, new String[]{"id", "name"});
            sql = "select districts.*, count(properties.id) as numbers from districts left join properties on districts.id = properties.district_id\n" +
                    "group by districts.id, name, province_id";
            ArrayList<MyObject> districts_list = DB.getData(sql, new String[]{"id", "name", "province_id", "numbers"});
            for (int i = 0; i < provinces_list.size(); i++) {
                int temp = 0;
                for (int j = 0; j < districts_list.size(); j++) {
                    if (provinces_list.get(i).getId().equals(districts_list.get(j).getProvince_id())){
                        temp += Integer.parseInt(districts_list.get(j).getNumbers());
                    }
                }
                provinces_list.get(i).numbers = String.valueOf(temp);
            }
            req.setAttribute("provinces_list", provinces_list);
            req.setAttribute("districts_list", districts_list);
            if (req.getSession().getAttribute("previous_province") !=null){
                req.setAttribute("previous_province", req.getSession().getAttribute("previous_province"));
            }
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
            req.getSession().setAttribute("previous_province", province_id);
            resp.sendRedirect(req.getContextPath() + "/admin/location-management");
        }

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String district_id = req.getParameter("district_id");
            System.out.println(district_id);
            String sql = "delete districts where id = ?";
            String[] vars = new String[]{district_id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("delete_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("delete_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/location-management");
        }
    }
    @WebServlet("/admin/delete-province")
    public static class DeleteProvince extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "delete districts where province_id = ?;delete provinces where id = ?";
            String[] vars = new String[]{id, id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("delete_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("delete_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/location-management");
        }
    }
}
