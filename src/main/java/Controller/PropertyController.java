package Controller;

import Database.DB;
import Database.MyObject;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Properties;

public class PropertyController {
    @WebServlet("/user/add-property")
    @MultipartConfig(
            fileSizeThreshold = 1024 * 1024, // 1 MB
            maxFileSize = 1024 * 1024 * 50,      // 10 MB
            maxRequestSize = 1024 * 1024 * 50  // 10 MB
    )
    public static class AddProperty extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            ArrayList<MyObject> districts_list = DB.getData("select * from districts;", new String[]{"id", "name", "province_id"});
            req.setAttribute("districts_list", districts_list);
            req.getRequestDispatcher("/views/user/add-property.jsp").forward(req, resp);
        }
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String name_vn = req.getParameter("name_vn").replace("'", "`").replace("\"", "`");
            String name_kr = req.getParameter("name_kr").replace("'", "`").replace("\"", "`");
            String description_vi = req.getParameter("description_vi").replace("'", "`").replace("\"", "`");
            String description_kr = req.getParameter("description_kr").replace("'", "`").replace("\"", "`");
            String property_type = req.getParameter("property_type");
            String district_id = req.getParameter("district_id");
            String address = req.getParameter("address");
            String floor_numbers = req.getParameter("floor_numbers");
            String at_floor = req.getParameter("at_floor");
            String bedrooms = req.getParameter("bedrooms");
            String bathrooms = req.getParameter("bathrooms");
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String area = req.getParameter("area");
            String sale = req.getParameter("sale");
            String price = req.getParameter("price");
            String amenity_id = req.getParameter("amenity_id");
            String nearby_location_id = req.getParameter("nearby_location_id");
            amenity_id = amenity_id.substring(0, amenity_id.length() - 1);
            nearby_location_id = nearby_location_id.substring(0, nearby_location_id.length() - 1);
            LocalDateTime currentTime = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String formattedTime = currentTime.format(formatter);
            String sql_insert_property = "insert into properties(name_vn, name_kr, property_type, description_vn, description_kr, price, floor_numbers, at_floor, district_id, address, bedrooms, bathrooms, area, user_id, hidden, for_sale, sold, created_at) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'false', ?, 'false', ?)";
            String[] insert_property_paras =        new String[]{name_vn, name_kr, property_type, description_vi, description_kr, price, floor_numbers, at_floor, district_id, address, bedrooms, bathrooms, area, user.id, sale, formattedTime};
            int property_id = DB.insertGetLastId(sql_insert_property, insert_property_paras);

            String uploadDir = req.getServletContext().getRealPath("/") + "files";
            String sql_img = "";
            for(Part p : req.getParts())
            {
                if (p.getName().startsWith("file_")){
                    String fileName = UserController.ChangeAvatar.getFileName(p);
                    assert fileName != null;
                    String newFileName = UserController.ChangeAvatar.generateUniqueFileName(fileName);
                    Path filePath = Paths.get(uploadDir, newFileName);
                    try (InputStream fileContent = p.getInputStream()) {
                        Files.copy(fileContent, filePath, StandardCopyOption.REPLACE_EXISTING);
                    }
                    sql_img += "insert into property_images(property_id, path, is_thumb_nail) values ("+property_id+", '/files/"+newFileName+"', '"+ (p.getName().endsWith("thumb") ? "true" : "false") +"'); ";
                }

            }
            DB.executeUpdate(sql_img);
            String sql_insert_property_amenities = "";
            String[] amenity_array = amenity_id.split("\\|");
            for (int i = 0; i < amenity_array.length; i++) {
                sql_insert_property_amenities += "insert into property_amenities(property_id, amenity_id) values ("+property_id+", ?)";
            }
            DB.executeUpdate(sql_insert_property_amenities, amenity_array);


            String sql_insert_near_locations = "";
            String[] near_location_array = nearby_location_id.split("\\|");
            for (int i = 0; i < near_location_array.length; i++) {
                sql_insert_near_locations += "insert into property_near_location(property_id, near_location_id) values ("+property_id+", ?)";
            }
            DB.executeUpdate(sql_insert_near_locations, near_location_array);
            com.google.gson.JsonObject job = new JsonObject();
            job.addProperty("code", "00");
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }
    @WebServlet("/your-property")
    public static class YourProperty extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        }
    }

    @WebServlet("/user/your-property")
    public static class ViewUserProperty extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String sql = "select properties.*, property_types.name_vn as property_type_name_vn, property_types.name_kr as property_type_name_kr, districts.name as district_name, provinces.name as province_name, provinces.id as province_id from properties inner join property_types on properties.property_type = property_types.id inner join districts on properties.district_id = districts.id inner join provinces on districts.province_id = provinces.id where user_id = ? order by properties.id desc;";
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String[] vars = new String[]{user.getId()};
            String[] fields = new String[]{"id", "name_vn", "name_kr", "property_type_name_vn", "property_type_name_kr", "description_vn", "description_kr", "price", "floor_numbers", "at_floor", "district_id", "address", "bedrooms", "bathrooms", "area", "hidden", "for_sale", "sold", "created_at", "district_name", "province_name", "province_id", "property_type"};
            ArrayList<MyObject> properties = DB.getData(sql, vars, fields);
            ArrayList<MyObject> property_near_location = DB.getData("select property_near_location.*, nearby_locations.name_vn as nearby_location_name_vn, nearby_locations.name_kr as nearby_location_name_kr from nearby_locations inner join property_near_location on nearby_locations.id = property_near_location.near_location_id inner join properties on property_near_location.property_id = properties.id where properties.user_id = ?", new String[]{user.id}, new String[]{"id", "property_id", "near_location_id", "nearby_location_name_vn", "nearby_location_name_kr"});
            ArrayList<MyObject> images = DB.getData("select property_images.* from property_images inner join properties on property_images.property_id = properties.id where user_id = ?", vars, new String[]{"id", "property_id", "path", "is_thumb_nail"});
            ArrayList<MyObject> property_amenities = DB.getData("select property_amenities.*, amenities.name_kr as amenity_name_kr, amenities.name_vn as amenity_name_vn from property_amenities inner join properties on property_amenities.property_id = properties.id inner join amenities on property_amenities.amenity_id = amenities.id where properties.user_id = ?", new String[]{user.id}, new String[]{"id", "property_id", "amenity_id", "amenity_name_kr", "amenity_name_vn"});
            ArrayList<MyObject> property_list = DB.getData("select * from property_types", new String[]{"id", "name_vn","name_kr", "description_vn", "description_kr"});
            ArrayList<MyObject> provinces_list = DB.getData("select * from provinces;", new String[]{"id", "name"});
            ArrayList<MyObject> districts_list = DB.getData("select * from districts;", new String[]{"id", "name", "province_id"});
            ArrayList<MyObject> amenities = DB.getData("select * from amenities", new String[]{"id", "name_vn", "name_kr"});
            ArrayList<MyObject> locations = DB.getData("select * from nearby_locations;", new String[]{"id", "name_vn", "name_kr"});
            req.setAttribute("property_list", property_list); //thực ra là type list, đặt lộn tên
            req.setAttribute("property_near_location", property_near_location);
            req.setAttribute("property_amenities", property_amenities);
            req.setAttribute("properties", properties);
            req.setAttribute("images", images);
            req.setAttribute("locations", locations);
            req.setAttribute("amenities", amenities);
            req.setAttribute("provinces_list", provinces_list);
            req.setAttribute("districts_list", districts_list);
            req.getRequestDispatcher("/views/user/view-properties.jsp").forward(req, resp);
        }
    }

    @WebServlet("/user/change-hidden")
    @MultipartConfig(
            fileSizeThreshold = 1024 * 1024, // 1 MB
            maxFileSize = 1024 * 1024 * 50,      // 10 MB
            maxRequestSize = 1024 * 1024 * 50  // 10 MB
    )
    public static class ChangeHidden extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String p_id = req.getParameter("p_id");
            String sql = "update properties set hidden = ~hidden where id = ? and user_id = ?";
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String[] vars = new String[]{p_id, user.getId()};
            boolean status = DB.executeUpdate(sql, vars);
            JsonObject job = new JsonObject();
            if (status){
                job.addProperty("status", true);
            } else {
                job.addProperty("status", false);
            }
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/user/change-sold")
    @MultipartConfig(
            fileSizeThreshold = 1024 * 1024, // 1 MB
            maxFileSize = 1024 * 1024 * 50,      // 10 MB
            maxRequestSize = 1024 * 1024 * 50  // 10 MB
    )
    public static class ChangeSold extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String p_id = req.getParameter("p_id");
            String sql = "update properties set sold = ~sold where id = ? and user_id = ? and for_sale = 'true'";
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String[] vars = new String[]{p_id, user.getId()};
            boolean status = DB.executeUpdate(sql, vars);
            JsonObject job = new JsonObject();
            if (status){
                job.addProperty("status", true);
            } else {
                job.addProperty("status", false);
            }
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/user/change-thumb-nail")
    public static class ChangeThumbNail extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String img_id = req.getParameter("img_id");
            String p_id = req.getParameter("p_id");
            String sql = "update property_images set is_thumb_nail = 'false' where property_id = ?; update property_images set is_thumb_nail = 'true' where property_id = ? and id = ?";
            String[] vars = new String[]{p_id, p_id, img_id};
            boolean check = DB.executeUpdate(sql, vars);
            Properties language = (Properties) req.getAttribute("language");
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.get("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/user/your-property");

        }
    }

    @WebServlet("/user/update-property")
    public static class UpdateProperty extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String name_vn = req.getParameter("name_vn");
            String name_kr = req.getParameter("name_kr");
            String description_vi = req.getParameter("description_vi");
            String description_kr = req.getParameter("description_kr");
            String p_id = req.getParameter("p_id");
            String property_type = req.getParameter("property_type");
            String district_id = req.getParameter("district_id");
            String address = req.getParameter("address");
            String floor_numbers = req.getParameter("floor_numbers");
            String at_floor = req.getParameter("at_floor");
            String bedrooms = req.getParameter("bedrooms");
            String bathrooms = req.getParameter("bathrooms");
            String update_area = req.getParameter("update_area");
            String sale = req.getParameter("sale");
            String update_price = req.getParameter("update_price");
            String sql = "update properties set name_vn = ?, name_kr = ?, description_vn = ?, description_kr = ?, property_type = ?, district_id = ?, address = ?, floor_numbers = ?, at_floor = ?, bedrooms = ?, bathrooms = ?, area = ?, for_sale = ?, price = ? where id = ?";
            String[] vars = new String[]{name_vn, name_kr, description_vi, description_kr, property_type, district_id, address, floor_numbers, at_floor, bedrooms, bathrooms, update_area, sale, update_price, p_id};
            boolean check = DB.executeUpdate(sql, vars);
            Properties language = (Properties) req.getAttribute("language");
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.get("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/user/your-property");
        }
    }

    @WebServlet("/api/get-amenities")
    public static class GetAmenities extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            ArrayList<MyObject> amenities = DB.getData("select * from amenities", new String[]{"id", "name_vn", "name_kr"});
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string = objectMapper.writeValueAsString(amenities);
            job.addProperty("amenities", json_string);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/api/get-property-types")
    public static class GetPropertyTypes extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            ArrayList<MyObject> property_type_list = DB.getData("select * from property_types", new String[]{"id", "name_vn","name_kr", "description_vn", "description_kr"});
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string = objectMapper.writeValueAsString(property_type_list);
            job.addProperty("property_type_list", json_string);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/api/get-near-locations")
    public static class GetNearLocation extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            ArrayList<MyObject> locations = DB.getData("select * from nearby_locations;", new String[]{"id", "name_vn", "name_kr"});
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string = objectMapper.writeValueAsString(locations);
            job.addProperty("locations", json_string);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/api/get-locations")
    public static class GetLocation extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            ArrayList<MyObject> provinces_list = DB.getData("select * from provinces;", new String[]{"id", "name"});
            ArrayList<MyObject> districts_list = DB.getData("select * from districts;", new String[]{"id", "name", "province_id"});
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string1 = objectMapper.writeValueAsString(provinces_list);
            String json_string2 = objectMapper.writeValueAsString(districts_list);
            job.addProperty("provinces_list", json_string1);
            job.addProperty("districts_list", json_string2);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }
}
