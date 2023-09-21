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
    private boolean shouldExclude(String requestURI) {
        // Define the routes you want to exclude from filtering
        return requestURI.equals("/assets") || requestURI.equals("/files") || requestURI.equals("/views");
    }
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        if (shouldExclude(request.getRequestURI())){
            chain.doFilter(request, response);
        } else {
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
            request.setAttribute("current_url", request.getRequestURI());
            chain.doFilter(request, response);
        }
    }
}
