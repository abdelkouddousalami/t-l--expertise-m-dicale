package com.example.medicale.util;

import com.example.medicale.enums.Role;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class SessionFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();


        boolean isPublicPath = uri.endsWith(".css") ||
                               uri.endsWith(".js") ||
                               uri.endsWith(".png") ||
                               uri.endsWith(".jpg") ||
                               uri.contains("/auth") ||
                               uri.contains("/register");

        if (isPublicPath) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (!isLoggedIn) {
            httpResponse.sendRedirect(contextPath + "/auth");
            return;
        }


        Role userRole = (Role) session.getAttribute("role");

        if (uri.contains("/nurse/") && userRole != Role.INFIRMIER) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        if (uri.contains("/generaliste/") && userRole != Role.GENERALISTE) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        if (uri.contains("/specialist/") && userRole != Role.SPECIALISTE) {
            httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        chain.doFilter(request, response);
    }
}
