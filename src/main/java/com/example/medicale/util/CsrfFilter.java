package com.example.medicale.util;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

@WebFilter("/*")
public class CsrfFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);


        if ("GET".equalsIgnoreCase(httpRequest.getMethod())) {
            if (session == null) {
                session = httpRequest.getSession(true);
            }
            if (session.getAttribute("csrfToken") == null) {
                String csrfToken = UUID.randomUUID().toString();
                session.setAttribute("csrfToken", csrfToken);
            }
        }


        if ("POST".equalsIgnoreCase(httpRequest.getMethod())) {
            String sessionToken = (session != null) ? (String) session.getAttribute("csrfToken") : null;
            String requestToken = httpRequest.getParameter("csrfToken");


            if (!httpRequest.getRequestURI().contains("/auth") &&
                !httpRequest.getRequestURI().contains("/register")) {
                if (sessionToken == null || !sessionToken.equals(requestToken)) {
                    httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid CSRF Token");
                    return;
                }
            }
        }

        chain.doFilter(request, response);
    }
}
