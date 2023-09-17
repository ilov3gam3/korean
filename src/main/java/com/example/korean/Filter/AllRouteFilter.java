package com.example.korean.Filter;

import com.example.korean.Init.Language;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
@WebFilter("/*")
public class AllRouteFilter implements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        if (request.getSession().getAttribute("mess") != null){
            String session_mess = (String) request.getSession().getAttribute("mess");
            request.setAttribute(session_mess.split("\\|")[0], session_mess.split("\\|")[1]);
            request.getSession().removeAttribute("mess");
        }
        Cookie[] cookies = request.getCookies();
        String lang = "";
        if (cookies!=null){
            for (Cookie cookie : cookies) {
                String name = cookie.getName();
                if (name.equals("lang")){
                    lang = cookie.getValue();
                }
            }
        }
        lang = lang.equals("") ? "vn" : lang;
        request.setAttribute("language", Language.languages.get(lang));
        chain.doFilter(request, response);
    }
}
