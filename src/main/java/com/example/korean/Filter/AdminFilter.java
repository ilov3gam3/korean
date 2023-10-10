package com.example.korean.Filter;

import com.example.korean.Database.MyObject;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.Properties;


public class AdminFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        MyObject user = (MyObject) req.getSession().getAttribute("login");
        Properties language = (Properties) req.getAttribute("language");
        if (user.getIs_admin().equals("1")){
            chain.doFilter(request, response);
        } else {
            req.getSession().setAttribute("mess", "error|" + language.getProperty("login_as_admin_pls"));
            resp.sendRedirect("/login");
        }
    }
}
