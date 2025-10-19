package com.example.medicale.Controller;

import com.example.medicale.dao.UserDao;
import com.example.medicale.dao.SpecialistProfileDao;
import com.example.medicale.entity.User;
import com.example.medicale.entity.SpecialistProfile;
import com.example.medicale.enums.Role;
import com.example.medicale.util.DataInitializer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/test/specialists")
public class SpecialistTestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html><head><title>Specialist Test</title></head><body>");
        out.println("<h1>Specialist Test Results</h1>");
        
        try {
            // Force re-initialization if requested
            String reinit = request.getParameter("reinit");
            if ("true".equals(reinit)) {
                out.println("<h2>Re-initializing data...</h2>");
                DataInitializer.initializeData();
                out.println("<p style='color: green;'>Data re-initialization completed!</p>");
            }
            
            // Test users with SPECIALISTE role
            UserDao userDao = new UserDao();
            List<User> specialistUsers = userDao.findByRole(Role.SPECIALISTE);
            
            out.println("<h2>Users with SPECIALISTE Role (" + specialistUsers.size() + ")</h2>");
            if (specialistUsers.isEmpty()) {
                out.println("<p style='color: red;'>NO SPECIALIST USERS FOUND!</p>");
                out.println("<p><a href='?reinit=true'>Click here to re-initialize data</a></p>");
            } else {
                out.println("<ul>");
                for (User user : specialistUsers) {
                    out.println("<li><strong>" + user.getFullName() + "</strong> (ID: " + user.getId() + ", Username: " + user.getUsername() + ", Email: " + user.getEmail() + ")</li>");
                }
                out.println("</ul>");
            }
            
            // Test specialist profiles
            SpecialistProfileDao profileDao = new SpecialistProfileDao();
            List<SpecialistProfile> profiles = profileDao.findAll();
            
            out.println("<h2>Specialist Profiles (" + profiles.size() + ")</h2>");
            if (profiles.isEmpty()) {
                out.println("<p style='color: orange;'>No specialist profiles found.</p>");
            } else {
                out.println("<ul>");
                for (SpecialistProfile profile : profiles) {
                    out.println("<li><strong>" + profile.getSpecialist().getFullName() + "</strong> - " + 
                               profile.getSpeciality() + " (" + profile.getConsultationFee() + "€, " + 
                               profile.getConsultationDuration() + " min)</li>");
                }
                out.println("</ul>");
            }
            
            out.println("<hr>");
            out.println("<p><a href='?reinit=true'>Re-initialize Data</a> | ");
            out.println("<a href='" + request.getContextPath() + "/generaliste/consultation/view?id=19'>Test Consultation Page</a></p>");
            
        } catch (Exception e) {
            out.println("<h2 style='color: red;'>Error</h2>");
            out.println("<pre>" + e.getMessage() + "</pre>");
            e.printStackTrace(out);
        }
        
        out.println("</body></html>");
    }
}