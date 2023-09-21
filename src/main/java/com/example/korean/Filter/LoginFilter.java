package com.example.korean.Filter;

import com.example.korean.Database.MyObject;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Properties;

@WebFilter({"/profile", "/logout", "/change-avatar"})
public class LoginFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        MyObject user = (MyObject) req.getSession().getAttribute("login");
        Properties language = (Properties) req.getAttribute("language");
        if (user !=null){
            chain.doFilter(request, response);
        } else {
            req.getSession().setAttribute("mess", "error|" + language.getProperty("login_pls"));
            resp.sendRedirect("/login");
        }
    }
}
