package Controller;

import Database.DB;
import Database.MyObject;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Properties;

public class ReviewController {
    @WebServlet("/user/review")
    public static class Review extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String booking_id = req.getParameter("booking_id");
            String review = req.getParameter("review");
            String stars = req.getParameter("stars");
            String sql = "insert into reviews(user_id, content, stars, booking_id, created_at) values (?, ?, ?, ?, ?)";
            LocalDateTime currentDateTime = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String current_date = currentDateTime.format(formatter);
            String[] vars = new String[]{user.id, review, stars, booking_id, current_date};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("your_bookings_review_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("your_bookings_review_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/user/your-booked");
        }
    }

    @WebServlet("/user/get-one-review")
    public static class GetOneReview extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String booking_id = req.getParameter("booking_id");
            String sql = "select reviews.* from reviews inner join bookings on reviews.booking_id = bookings.id where bookings.id = ?";
            String[] vars = new String[]{booking_id};
            String[] fields = new String[]{"id", "user_id", "content", "stars", "booking_id", "created_at"};
            ArrayList<MyObject> reviews = DB.getData(sql, vars, fields);
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string = objectMapper.writeValueAsString(reviews.get(0));
            job.addProperty("review", json_string);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/user/update-review")
    @MultipartConfig(
            fileSizeThreshold = 1024 * 1024, // 1 MB
            maxFileSize = 1024 * 1024 * 50,      // 10 MB
            maxRequestSize = 1024 * 1024 * 50  // 10 MB
    )
    public static class UpdateReview extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String id = req.getParameter("id");
            String content = req.getParameter("content");
            String stars = req.getParameter("stars");
            String sql = "update reviews set stars = ?, content = ? where id = ?";
            String[] vars = new String[]{stars, content, id};
            boolean check = DB.executeUpdate(sql, vars);
            com.google.gson.JsonObject job = new JsonObject();
            if (check){
                job.addProperty("status", true);
            } else {
                job.addProperty("status", false);
            }
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/get-reviews")
    public static class GetReviews extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String p_id = req.getParameter("p_id");
            String sql = "select reviews.*, users.name as username, users.avatar as avatar from reviews inner join bookings on reviews.booking_id = bookings.id inner join users on reviews.user_id = users.id where bookings.property_id = ?";
            String[] vars = new String[]{p_id};
            String[] fields = new String[]{"id", "user_id", "content", "stars", "booking_id", "created_at", "username", "avatar"};
            ArrayList<MyObject> reviews = DB.getData(sql, vars, fields);
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string = objectMapper.writeValueAsString(reviews);
            job.addProperty("reviews", json_string);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }
}
