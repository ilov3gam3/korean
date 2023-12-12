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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Properties;

public class BookingController {
    @WebServlet("/user/book")
    public static class UserBook extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String p_id = req.getParameter("p_id");
            LocalDateTime currentDateTime = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String current_date = currentDateTime.format(formatter);
            String sql = "select * from bookings where from_date > ? and property_id = ?";
            String[] vars = new String[]{current_date, p_id};
            String[] fields = new String[]{"id", "user_id", "property_id", "from_date", "to_date", "note", "is_received", "is_returned", "created_at"};
            ArrayList<MyObject> bookings = DB.getData(sql, vars, fields);
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string = objectMapper.writeValueAsString(bookings);
            job.addProperty("bookings", json_string);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String from_date = req.getParameter("from_date");
            String to_date = req.getParameter("to_date");
            String note = req.getParameter("note");
            String p_id = req.getParameter("p_id");
            LocalDateTime currentDateTime = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String current_date = currentDateTime.format(formatter);
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String sql = "insert into bookings(user_id, property_id, from_date, to_date, note, is_received, is_returned, created_at) values (?, ?, ?, ?, ?, 'false', 'false', ?)";
            String[] vars = new String[]{user.id, p_id, from_date, to_date, note, current_date};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("book_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("book_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/view-property?id=" + p_id);
        }
    }
    @WebServlet("/user/your-bookings")
    public static class YourBooking extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String sql = "select bookings.*, users.name as username, properties.name_vn as name_vn, properties.name_kr as name_kr from bookings inner join properties on bookings.property_id = properties.id inner join users on bookings.user_id = users.id where properties.user_id = ? order by id desc;";
            String[] vars = new String[]{user.id};
            String[] fields = new String[]{"id", "user_id", "property_id", "from_date", "to_date", "note", "is_received", "is_returned", "created_at", "username", "name_vn", "name_kr"};
            ArrayList<MyObject> bookings = DB.getData(sql, vars, fields);
            req.setAttribute("bookings", bookings);
            req.getRequestDispatcher("/views/user/your-bookings.jsp").forward(req, resp);
        }
    }

    @WebServlet("/user/change-is-received")
    public static class ChangeReceived extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String id = req.getParameter("id");
            String sql = "update bookings set is_received = ~is_received where id = ?";
            String[] vars = new String[]{id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/user/your-bookings");
        }
    }

    @WebServlet("/user/change-is-returned")
    public static class ChangeReturned extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "update bookings set is_returned = ~is_returned where id = ?";
            String[] vars = new String[]{id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/user/your-bookings");
        }
    }

    @WebServlet("/user/delete-booking")
    public static class DeleteBooking extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "delete from bookings where id = ?";
            String[] vars = new String[]{id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/user/your-bookings");
        }
    }

    @WebServlet("/user/your-booked")
    public static class YourBooked extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String sql = "select bookings.*, properties.name_vn as name_vn, properties.name_kr as name_kr, reviews.id as review_id from bookings inner join properties on bookings.property_id = properties.id left join reviews on bookings.id = reviews.booking_id where bookings.user_id = ? order by id desc";
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String[] vars = new String[]{user.id};
            String[] fields = new String[]{"id", "user_id", "property_id", "from_date", "to_date", "note", "is_received", "is_returned", "created_at", "name_vn", "name_kr", "review_id"};
            ArrayList<MyObject> bookings = DB.getData(sql, vars, fields);
            req.setAttribute("bookings", bookings);
            req.getRequestDispatcher("/views/user/view-booked.jsp").forward(req, resp);
        }
    }
}
