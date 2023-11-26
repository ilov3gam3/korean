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
            ArrayList<MyObject> list = DB.getData("select * from users",  new String[]{"id", "name", "email", "avatar", "phone", "dob", "national_id", "front_id_card", "back_id_card", "is_verified", "cards_verified", "is_admin", "nationality"});
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

    @WebServlet("/admin/update-user")
    public static class UpdateUser extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String update_name = req.getParameter("update_name");
            String update_email = req.getParameter("update_email");
            String update_phone = req.getParameter("update_phone");
            String update_nationality = req.getParameter("update_nationality");
            String update_dob = req.getParameter("update_dob");
            String id = req.getParameter("id");
            String sql = "update users set name = ?, email = ?, phone = ?, nationality = ?, dob = ? where id = ?";
            String[] vars = new String[]{update_name, update_email, update_phone, update_nationality, update_dob, id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/user-management");
        }
    }
    @WebServlet("/admin/change-admin")
    public static class ChangeAdmin extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "update users set is_admin = ~is_admin where id = ?";
            String[] vars = new String[]{id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/user-management");
        }
    }

    @WebServlet("/admin/change-verify-email")
    public static class ChangeVerifyEmail extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "update users set is_verified = ~is_verified where id = ?";
            String[] vars = new String[]{id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/user-management");
        }
    }
    @WebServlet("/admin/update-province")
    public static class UpdateProvince extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("update_province_id");
            String name = req.getParameter("update_province_name");
            String sql = "update provinces set name = ? where id = ?";
            String[] vars = new String[]{name, id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/location-management");
        }
    }
    @WebServlet("/admin/update-district")
    public static class UpdateDistrict extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("update_district_id");
            String name = req.getParameter("update_district_name");
            String sql = "update districts set name = ? where id = ?";
            String[] vars = new String[]{name, id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/location-management");
        }
    }
}
