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

public class PostController {
    @WebServlet("/user/add-post")
    public static class AddPost extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/user/make-post.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String title = req.getParameter("title");
            String content = req.getParameter("content");
            String sql = "insert into posts(user_id, title, content, is_verified, created_at) values (?, ?, ?, ?, ?)";
            LocalDateTime currentTime = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String formattedTime = currentTime.format(formatter);
            String[] vars = new String[]{user.id, title, content, "false", formattedTime};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("add_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("add_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/user/add-post");
        }
    }
    @WebServlet("/user/your-posts")
    public static class YourPosts extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String sql = "select * from posts where user_id = ?";
            String[] vars = new String[]{user.id};
            String[] fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at"};
            ArrayList<MyObject> posts = DB.getData(sql, vars, fields);
            req.setAttribute("posts", posts);
            req.getRequestDispatcher("/views/user/your-posts.jsp").forward(req, resp);
        }
    }

    @WebServlet("/admin/view-posts")
    public static class AdminViewPosts extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String sql = "select posts.*, users.name as username from posts inner join users on posts.user_id = users.id order by id desc";
            String[] fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username"};
            ArrayList<MyObject> posts = DB.getData(sql, fields);
            req.setAttribute("posts", posts);
            req.getRequestDispatcher("/views/admin/your-posts.jsp").forward(req, resp);
        }

        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            Properties language = (Properties) req.getAttribute("language");
            String id = req.getParameter("id");
            String sql = "update posts set is_verified = ~is_verified where id = ?";
            String[] vars = new String[]{id};
            boolean check = DB.executeUpdate(sql, vars);
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/view-posts");
        }
    }

    @WebServlet("/posts")
    public static class Posts extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            req.getRequestDispatcher("/views/posts.jsp").forward(req, resp);
        }
    }

    /*@WebServlet("/get-posts")
    @MultipartConfig(
            fileSizeThreshold = 1024 * 1024, // 1 MB
            maxFileSize = 1024 * 1024 * 50,      // 10 MB
            maxRequestSize = 1024 * 1024 * 50  // 10 MB
    )
    public static class GetPosts extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String last_id = req.getParameter("last_id");
            String first_id = req.getParameter("first_id");
            ArrayList<MyObject> posts;
            String sql;
            MyObject user = req.getSession().getAttribute("login") == null ? null : (MyObject) req.getSession().getAttribute("login");
            String[] vars;
            String[] fields;
            if (last_id.equals("0")){
                if (user == null){
                    sql = "select top 5 posts.*, users.name as username, users.avatar as avatar\n" +
                            "from posts\n" +
                            "         inner join users on posts.user_id = users.id\n" +
                            "order by posts.id desc;";
                    vars = new String[]{};
                    fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username", "avatar"};
                } else {
                    sql = "select top 5 posts.*, users.name as username, users.avatar as avatar, likes.id as like_id\n" +
                            "from posts\n" +
                            "         inner join users on posts.user_id = users.id\n" +
                            "         left join likes on posts.id = likes.post_id and likes.user_id = ?\n" +
                            "order by posts.id desc";
                    vars = new String[]{user.id};
                    fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username", "avatar", "like_id"};
                }
            } else {
                if (first_id == null){
                    if (user == null){
                        sql = "select top 5 posts.*, users.name as username, users.avatar as avatar\n" +
                                "from posts\n" +
                                "         inner join users on posts.user_id = users.id\n" +
                                "where posts.id < ?\n" +
                                "order by id desc";
                        vars = new String[]{last_id};
                        fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username", "avatar"};
                    } else {
                        sql = "select top 5 posts.*, users.name as username, users.avatar as avatar, likes.id as like_id\n" +
                                "from posts\n" +
                                "         inner join users on posts.user_id = users.id\n" +
                                "         left join likes on posts.id = likes.post_id and likes.user_id = ?\n" +
                                "where posts.id < ?\n" +
                                "order by id desc";
                        vars = new String[]{user.id, last_id};
                        fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username","avatar", "like_id"};
                    }
                } else { // lấy id từ last tới first
                    if (user == null){
                        sql = "select posts.*, users.name as username, users.avatar as avatar\n" +
                                "from posts\n" +
                                "         inner join users on posts.user_id = users.id\n" +
                                "where posts.id < ? and posts.id > ? \n" +
                                "order by id desc";
                        vars = new String[]{last_id, first_id};
                        fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username", "avatar"};
                    } else {
                        sql = "select posts.*, users.name as username, users.avatar as avatar, likes.id as like_id\n" +
                                "from posts\n" +
                                "         inner join users on posts.user_id = users.id\n" +
                                "         left join likes on posts.id = likes.post_id and likes.user_id = ?\n" +
                                "where posts.id < ? and posts.id > ?\n" +
                                "order by id desc";
                        vars = new String[]{user.id, last_id, first_id};
                        fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username","avatar", "like_id"};
                    }
                }

            }
            posts = DB.getData(sql, vars, fields);
            if (posts.size() != 0){
                String ids = "(";
                for (int i = 0; i < posts.size(); i++) {
                    if (i == posts.size() - 1){
                        ids += posts.get(i).getId();
                    } else {
                        ids += posts.get(i).getId() + ", ";
                    }
                    if (posts.get(i).getLike_id() == null){
                        posts.get(i).like_id = "0";
                    }
                }
                ids += ")";
                sql = "select posts.*, count(likes.id) as count_like, count(comments.id) as count_comment from posts left join likes on posts.id = likes.post_id left join comments on posts.id = comments.post_id where posts.id in x\n" +
                        "group by posts.id, posts.user_id, title, posts.content, is_verified, posts.created_at\n" +
                        "order by posts.id desc";
                sql = sql.replace("x", ids);
                ArrayList<MyObject> counts = DB.getData(sql, new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "count_like", "count_comment"});
                for (int i = 0; i < counts.size(); i++) {
                    if (counts.get(i).getId().equals(posts.get(i).getId())){
                        posts.get(i).count_like = counts.get(i).count_like;
                        posts.get(i).count_comment = counts.get(i).count_comment;
                    }
                }
            }
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string = objectMapper.writeValueAsString(posts);
            job.addProperty("posts", json_string);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }*/
    @WebServlet("/get-posts")
    @MultipartConfig(
            fileSizeThreshold = 1024 * 1024, // 1 MB
            maxFileSize = 1024 * 1024 * 50,      // 10 MB
            maxRequestSize = 1024 * 1024 * 50  // 10 MB
    )
    public static class GetPosts extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String last_id = req.getParameter("last_id");
            ArrayList<MyObject> posts;
            String sql;
            MyObject user = req.getSession().getAttribute("login") == null ? null : (MyObject) req.getSession().getAttribute("login");
            String[] vars;
            String[] fields;
            if (last_id.equals("0")){
                if (user == null){
                    sql = "select top 5 posts.*, users.name as username, users.avatar as avatar\n" +
                            "from posts\n" +
                            "         inner join users on posts.user_id = users.id where posts.is_verified = 'true'\n" +
                            "order by posts.id desc;";
                    vars = new String[]{};
                    fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username", "avatar"};
                } else {
                    sql = "select top 5 posts.*, users.name as username, users.avatar as avatar, likes.id as like_id\n" +
                            "from posts\n" +
                            "         inner join users on posts.user_id = users.id\n" +
                            "         left join likes on posts.id = likes.post_id and likes.user_id = ? where posts.is_verified = 'true'\n" +
                            "order by posts.id desc";
                    vars = new String[]{user.id};
                    fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username", "avatar", "like_id"};
                }
            } else {
                if (user == null){
                        sql = "select top 5 posts.*, users.name as username, users.avatar as avatar\n" +
                                "from posts\n" +
                                "         inner join users on posts.user_id = users.id\n" +
                                "where posts.id < ? and posts.is_verified = 'true'\n" +
                                "order by id desc";
                        vars = new String[]{last_id};
                        fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username", "avatar"};
                    } else {
                        sql = "select top 5 posts.*, users.name as username, users.avatar as avatar, likes.id as like_id\n" +
                                "from posts\n" +
                                "         inner join users on posts.user_id = users.id\n" +
                                "         left join likes on posts.id = likes.post_id and likes.user_id = ?\n" +
                                "where posts.id < ? and posts.is_verified = 'true'\n" +
                                "order by id desc";
                        vars = new String[]{user.id, last_id};
                        fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username","avatar", "like_id"};
                    }
            }
            posts = DB.getData(sql, vars, fields);
            if (posts.size() != 0){
                String ids = "(";
                for (int i = 0; i < posts.size(); i++) {
                    if (i == posts.size() - 1){
                        ids += posts.get(i).getId();
                    } else {
                        ids += posts.get(i).getId() + ", ";
                    }
                    if (posts.get(i).getLike_id() == null){
                        posts.get(i).like_id = "0";
                    }
                }
                ids += ")";
                sql = "select posts.*, count(DISTINCT likes.id) as count_like, count(DISTINCT comments.id) as count_comment from posts left join likes on posts.id = likes.post_id left join comments on posts.id = comments.post_id where posts.id in x\n" +
                        "group by posts.id, posts.user_id, title, posts.content, is_verified, posts.created_at\n" +
                        "order by posts.id desc";
                sql = sql.replace("x", ids);
                ArrayList<MyObject> counts = DB.getData(sql, new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "count_like", "count_comment"});
                for (int i = 0; i < counts.size(); i++) {
                    if (counts.get(i).getId().equals(posts.get(i).getId())){
                        posts.get(i).count_like = counts.get(i).count_like;
                        posts.get(i).count_comment = counts.get(i).count_comment;
                    }
                }
            }
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string = objectMapper.writeValueAsString(posts);
            job.addProperty("posts", json_string);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/user/like-post")
    public static class LikePost extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String post_id = req.getParameter("id");
            Properties language = (Properties) req.getAttribute("language");
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String sql = "select * from likes where user_id = ? and post_id = ?";
            String[] vars = new String[]{user.id, post_id};
            ArrayList<MyObject> likes = DB.getData(sql, vars, new String[]{"id"});
            String message;
            if (likes.size() == 0){
                sql = "insert into likes(user_id, post_id) values (?, ?)";
                message = language.getProperty("post_pls_liked");
            } else {
                sql = "delete from likes where user_id = ? and post_id = ?";
                message = language.getProperty("post_pls_disliked");
            }
            boolean check = DB.executeUpdate(sql, vars);
            com.google.gson.JsonObject job = new JsonObject();
            if (check){
                job.addProperty("status", true);
                job.addProperty("message", message);
            } else {
                job.addProperty("status", false);
                job.addProperty("message", language.getProperty("something_error"));
            }
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/get-one-post")
    public static class getOnePost extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String last_id = req.getParameter("id");
            ArrayList<MyObject> posts;
            String sql;
            MyObject user = req.getSession().getAttribute("login") == null ? null : (MyObject) req.getSession().getAttribute("login");
            String[] vars;
            String[] fields;
            if (user == null){
                sql = "select top 5 posts.*, users.name as username, users.avatar as avatar\n" +
                        "from posts\n" +
                        "         inner join users on posts.user_id = users.id\n" +
                        "where posts.id = ?\n" +
                        "order by id desc";
                vars = new String[]{last_id};
                fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username", "avatar"};
            } else {
                sql = "select top 5 posts.*, users.name as username, users.avatar as avatar, likes.id as like_id\n" +
                        "from posts\n" +
                        "         inner join users on posts.user_id = users.id\n" +
                        "         left join likes on posts.id = likes.post_id and likes.user_id = ?\n" +
                        "where posts.id = ?\n" +
                        "order by id desc";
                vars = new String[]{user.id, last_id};
                fields = new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "username","avatar", "like_id"};
            }
            posts = DB.getData(sql, vars, fields);
            if (posts.size() != 0){
                String ids = "(";
                for (int i = 0; i < posts.size(); i++) {
                    if (i == posts.size() - 1){
                        ids += posts.get(i).getId();
                    } else {
                        ids += posts.get(i).getId() + ", ";
                    }
                    if (posts.get(i).getLike_id() == null){
                        posts.get(i).like_id = "0";
                    }
                }
                ids += ")";
                sql = "select posts.*, count(DISTINCT likes.id) as count_like, count(DISTINCT comments.id) as count_comment from posts left join likes on posts.id = likes.post_id left join comments on posts.id = comments.post_id where posts.id in x\n" +
                        "group by posts.id, posts.user_id, title, posts.content, is_verified, posts.created_at\n" +
                        "order by posts.id desc";
                sql = sql.replace("x", ids);
                ArrayList<MyObject> counts = DB.getData(sql, new String[]{"id", "user_id", "title", "content", "is_verified", "created_at", "count_like", "count_comment"});
                for (int i = 0; i < counts.size(); i++) {
                    if (counts.get(i).getId().equals(posts.get(i).getId())){
                        posts.get(i).count_like = counts.get(i).count_like;
                        posts.get(i).count_comment = counts.get(i).count_comment;
                    }
                }
            }
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string = objectMapper.writeValueAsString(posts.get(0));
            job.addProperty("posts", json_string);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/user/comment")
    @MultipartConfig(
            fileSizeThreshold = 1024 * 1024, // 1 MB
            maxFileSize = 1024 * 1024 * 50,      // 10 MB
            maxRequestSize = 1024 * 1024 * 50  // 10 MB
    )
    public static class UserComment extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String post_id = req.getParameter("post_id");
            String comment = req.getParameter("comment");
            Properties language = (Properties) req.getAttribute("language");
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String sql = "insert into comments(user_id, post_id, content, created_at) values (?, ?, ?, ?)";
            LocalDateTime currentDateTime = LocalDateTime.now();
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            String current_date = currentDateTime.format(formatter);
            String[] vars = new String[]{user.id, post_id, comment, current_date};
            boolean check = DB.executeUpdate(sql, vars);
            com.google.gson.JsonObject job = new JsonObject();
            if (check){
                job.addProperty("status", true);
                job.addProperty("message", language.getProperty("post_comment_success"));
            } else {
                job.addProperty("status", false);
                job.addProperty("message", language.getProperty("post_comment_fail"));
            }
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/get-comments")
    public static class GetComments extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String post_id = req.getParameter("post_id");
            String sql = "select comments.*, users.name as username, users.avatar as avatar from comments inner join users on comments.user_id = users.id where post_id = ? order by id desc";
            String[] vars = new String[]{post_id};
            String[] fields = new String[]{"id", "user_id", "post_id", "content", "created_at", "username", "avatar"};
            ArrayList<MyObject> comments = DB.getData(sql, vars, fields);
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string = objectMapper.writeValueAsString(comments);
            job.addProperty("comments", json_string);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/get-likes")
    public static class GetLikes extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String post_id = req.getParameter("post_id");
            String sql = "select likes.*, users.name as username, users.avatar as avatar from likes inner join users on likes.user_id = users.id where post_id = ?";
            String[] vars = new String[]{post_id};
            String[] fields = new String[]{"id", "user_id", "post_id", "username", "avatar"};
            ArrayList<MyObject> likes = DB.getData(sql, vars, fields);
            com.google.gson.JsonObject job = new JsonObject();
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_NULL);
            objectMapper.setSerializationInclusion(JsonInclude.Include.NON_EMPTY);
            String json_string = objectMapper.writeValueAsString(likes);
            job.addProperty("likes", json_string);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/admin/update-post")
    public static class AdminGetPost extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String id = req.getParameter("id");
            String title = req.getParameter("title");
            String content = req.getParameter("content");
            String sql = "update posts set title = ?, content = ? where id = ?";
            String[] vars = new String[]{title, content, id};
            boolean check = DB.executeUpdate(sql, vars);
            Properties language = (Properties) req.getAttribute("language");
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("update_id_card_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("update_id_card_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/view-posts");
        }

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String id = req.getParameter("id");
            String sql = "delete from comments where post_id = ?\n" +
                    "delete from likes where post_id = ?\n" +
                    "delete from posts where id = ?";
            String[] vars = new String[]{id, id, id};
            boolean check = DB.executeUpdate(sql, vars);
            Properties language = (Properties) req.getAttribute("language");
            if (check){
                req.getSession().setAttribute("mess", "success|" + language.getProperty("delete_success"));
            } else {
                req.getSession().setAttribute("mess", "error|" + language.getProperty("delete_fail"));
            }
            resp.sendRedirect(req.getContextPath() + "/admin/view-posts");
        }
    }

    @WebServlet("/admin/update-comments")
    @MultipartConfig(
            fileSizeThreshold = 1024 * 1024, // 1 MB
            maxFileSize = 1024 * 1024 * 50,      // 10 MB
            maxRequestSize = 1024 * 1024 * 50  // 10 MB
    )
    public static class AdminUpdateComment extends HttpServlet{
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String id = req.getParameter("id");
            String content = req.getParameter("content");
            String sql = "update comments set content = ? where id = ?";
            String[] vars = new String[]{content, id};
            boolean check = DB.executeUpdate(sql, vars);
            com.google.gson.JsonObject job = new JsonObject();
            job.addProperty("status", check);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }

        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            String id = req.getParameter("id");
            String sql = "delete from comments where id = ?";
            String[] vars = new String[]{id};
            boolean check = DB.executeUpdate(sql, vars);
            com.google.gson.JsonObject job = new JsonObject();
            job.addProperty("status", check);
            Gson gson = new Gson();
            resp.getWriter().write(gson.toJson(job));
        }
    }

    @WebServlet("/user/get-free_commets")
    public static class GetFreeComments extends HttpServlet{
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            MyObject user = (MyObject) req.getSession().getAttribute("login");
            String sql = "";
        }
    }
}

