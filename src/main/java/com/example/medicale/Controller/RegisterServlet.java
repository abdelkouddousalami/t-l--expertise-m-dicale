package com.example.medicale.Controller;

import com.example.medicale.entity.User;
import com.example.medicale.enums.Role;
import com.example.medicale.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private AuthService authService;

    @Override
    public void init() {
        authService = new AuthService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");


        if (username == null || username.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Tous les champs sont obligatoires");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Le mot de passe doit contenir au moins 6 caractères");
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
            return;
        }

        try {

            User user = new User();
            user.setUsername(username);
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPasswordHash(password);
            user.setRole(Role.INFIRMIER);

            authService.register(user);

            request.setAttribute("success", "Inscription réussie! Vous pouvez maintenant vous connecter.");
            request.getRequestDispatcher("/jsp/login.jsp").forward(request, response);
        } catch (Exception e) {
            String errorMessage = "Erreur lors de l'inscription";
            if (e.getMessage() != null && e.getMessage().contains("Duplicate")) {
                errorMessage = "Ce nom d'utilisateur ou email est déjà utilisé";
            }
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("/jsp/register.jsp").forward(request, response);
        }
    }
}
