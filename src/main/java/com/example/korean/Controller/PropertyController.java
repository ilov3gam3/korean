package com.example.korean.Controller;

import com.example.korean.Database.DB;
import com.example.korean.Database.MyObject;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Map;

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
            ArrayList<MyObject> provinces_list = DB.getData("select * from provinces;", new String[]{"id", "name"});
            ArrayList<MyObject> districts_list = DB.getData("select * from districts;", new String[]{"id", "name", "province_id"});
            ArrayList<MyObject> property_list = DB.getData("select * from property_types", new String[]{"id", "name_vn","name_kr", "description_vn", "description_kr"});
            ArrayList<MyObject> amenities = DB.getData("select * from amenities", new String[]{"id", "name_vn", "name_kr"});
            ArrayList<MyObject> locations = DB.getData("select * from nearby_locations;", new String[]{"id", "name_vn", "name_kr"});
            req.setAttribute("locations", locations);
            req.setAttribute("amenities", amenities);
            req.setAttribute("property_list", property_list);
            req.setAttribute("provinces_list", provinces_list);
            req.setAttribute("districts_list", districts_list);
            req.getRequestDispatcher("/views/user/add-property.jsp").forward(req, resp);
        }
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String name_vn = req.getParameter("name_vn");
            String name_kr = req.getParameter("name_kr");
            String description_vi = req.getParameter("description_vi");
            String description_kr = req.getParameter("description_kr");
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
            String amenity_id = "";
            String nearby_location_id = "";
            Map<String, String[]> parameterMap = req.getParameterMap();
            for (Map.Entry<String, String[]> entry : parameterMap.entrySet()) {
                String paramName = entry.getKey();
                String[] paramValues = entry.getValue();
                for (String paramValue : paramValues) {
                    if (paramName.equals("amenity_id")){
                        amenity_id += paramValue + "|";
                    }
                    if (paramName.equals("nearby_location_id")){
                        nearby_location_id += paramValue + "|";
                    }
                }
            }
            amenity_id = amenity_id.substring(0, amenity_id.length() - 1);
            nearby_location_id = nearby_location_id.substring(0, nearby_location_id.length() - 1);
            LocalDateTime currentTime = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String formattedTime = currentTime.format(formatter);
            String sql_insert_property = "insert into properties(name_vn, name_kr, property_type, description_vn, description_kr, price, floor_numbers, at_floor, district_id, address, bedrooms, bathrooms, area, user_id, hidden, for_sale, sold, created_at) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'false', ?, 'false', ?)";
            String[] insert_property_paras = new String[]{name_vn, name_kr, property_type, description_vi, description_kr, property_type, floor_numbers, at_floor, district_id, address, bedrooms, bathrooms, area, user.id, sale, formattedTime};
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
                    sql_img += "insert into property_images(property_id, path, is_thumb_nail) values ("+property_id+", '"+newFileName+"', '"+ (p.getName().endsWith("thumb") ? "true" : "false") +"')";
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
}
