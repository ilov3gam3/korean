package Controller;

import Database.DB;
import Database.MyObject;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Properties;

public class PropertyTypeController {
    @WebServlet("/admin/property-type-management")
    public static class PropertyTypeManagement extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            ArrayList<MyObject> property_list = DB.getData("select property_types.*, count(properties.id) as numbers from property_types left join properties on property_types.id = properties.property_type\n" +
                    "group by property_types.id, property_types.name_vn, property_types.name_kr, property_types.description_vn, property_types.description_kr", new String[]{"id", "name_vn","name_kr", "description_vn", "description_kr", "numbers"});
            req.setAttribute("property_list", property_list);
            req.getRequestDispatcher("/views/admin/property-type-management.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String name_vi = req.getParameter("name_vi");
            String name_kr = req.getParameter("name_kr");
            String description_vi = req.getParameter("description_vi");
            String description_kr = req.getParameter("description_kr");
            boolean check = DB.executeUpdate("insert into property_types (name_vn, name_kr, description_vn, description_kr) values (?, ?, ?, ?)", new String[]{name_vi,name_kr, description_vi, description_kr});
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("add_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("add_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/property-type-management");
        }
    }

    @WebServlet("/admin/update-property")
    public static class UpdateProperty extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String update_name_vi = req.getParameter("update_name_vi");
            String update_name_kr = req.getParameter("update_name_kr");
            String update_description_vi = req.getParameter("update_description_vi");
            String update_description_kr = req.getParameter("update_description_kr");
            String sql = "update property_types set name_vn = ?, name_kr = ?, description_vn = ?, description_kr = ? where id = ?";
            String[] vars = new String[]{update_name_vi, update_name_kr, update_description_vi, update_description_kr, id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/property-type-management");
        }

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "delete from property_types where id = ?";
            String[] vars = new String[]{id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("delete_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("delete_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/property-type-management");
        }
    }
    @WebServlet("/get-type-description")
    public static class GetTypeDes extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String id = req.getParameter("id");
            String sql =  "select * from property_types where id = ?";
            String[] vars = new String[]{id};
            String[] fields = new String[]{"id", "name_vn","name_kr", "description_vn", "description_kr"};
            ArrayList<MyObject> types = DB.getData(sql, vars, fields);
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string = objectMapper.writeValueAsString(types.size() == 1 ? types.get(0) : "");
            job.addProperty("type_des", json_string);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }
}
