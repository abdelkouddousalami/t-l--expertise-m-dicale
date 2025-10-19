package com.example.medicale.Controller;

import com.example.medicale.entity.*;
import com.example.medicale.enums.Priority;
import com.example.medicale.service.SpecialisteService;
import com.example.medicale.service.GeneralisteService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;
import java.util.Optional;
import java.util.Map;

@WebServlet("/specialist/*")
public class SpecialisteServlet extends HttpServlet {

    private SpecialisteService specialisteService;
    private GeneralisteService generalisteService;

    @Override
    public void init() {
        specialisteService = new SpecialisteService();
        generalisteService = new GeneralisteService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null || action.equals("/")) {
            action = "/requests";
        }

        switch (action) {
            case "/profile":
                showProfile(request, response);
                break;
            case "/slots":
                showSlots(request, response);
                break;
            case "/requests":
                showExpertiseRequests(request, response);
                break;
            case "/request/view":
                viewExpertiseRequest(request, response);
                break;
            case "/calendar":
                showCalendar(request, response);
                break;
            case "/calendar/month":
                showMonthlyCalendar(request, response);
                break;
            case "/calendar/week":
                showWeeklyCalendar(request, response);
                break;
            case "/slots/available":
                getAvailableSlots(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/specialist/requests");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/specialist/requests");
            return;
        }

        switch (action) {
            case "/profile/save":
                saveProfile(request, response);
                break;
            case "/slots/generate":
                generateSlots(request, response);
                break;
            case "/request/respond":
                respondToExpertise(request, response);
                break;
            case "/calendar/sync":
                syncCalendarWithSlots(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/specialist/requests");
                break;
        }
    }

    private void showProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User specialist = (User) session.getAttribute("user");

        Optional<SpecialistProfile> profileOpt = specialisteService.getProfileBySpecialistId(specialist.getId());

        if (profileOpt.isPresent()) {
            request.setAttribute("profile", profileOpt.get());
        }

        request.getRequestDispatcher("/jsp/specialiste/profile.jsp").forward(request, response);
    }

    private void showSlots(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User specialist = (User) session.getAttribute("user");

        List<Slot> slots = specialisteService.getSpecialistSlots(specialist.getId());
        request.setAttribute("slots", slots);

        request.getRequestDispatcher("/jsp/specialiste/slots.jsp").forward(request, response);
    }

    private void showExpertiseRequests(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User specialist = (User) session.getAttribute("user");

        String filter = request.getParameter("filter");
        String priority = request.getParameter("priority");

        List<ExpertiseRequest> requests;

        if ("completed".equals(filter)) {
            requests = specialisteService.getExpertiseRequestsByStatus(specialist.getId(), true);
        } else if ("pending".equals(filter)) {
            requests = specialisteService.getExpertiseRequestsByStatus(specialist.getId(), false);
        } else if (priority != null && !priority.isEmpty()) {
            requests = specialisteService.filterRequestsByPriority(specialist.getId(), Priority.valueOf(priority));
        } else {
            requests = specialisteService.getExpertiseRequests(specialist.getId());
        }

        request.setAttribute("requests", requests);
        request.getRequestDispatcher("/jsp/specialiste/expertise-requests.jsp").forward(request, response);
    }

    private void viewExpertiseRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long requestId = Long.parseLong(request.getParameter("id"));
        Optional<ExpertiseRequest> expertiseOpt = specialisteService.findExpertiseById(requestId);

        if (expertiseOpt.isPresent()) {
            request.setAttribute("expertise", expertiseOpt.get());
            request.getRequestDispatcher("/jsp/specialiste/expertise-view.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/specialist/requests");
        }
    }

    private void saveProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User specialist = (User) session.getAttribute("user");

        try {
            String speciality = request.getParameter("speciality");
            String feeStr = request.getParameter("consultationFee");
            String description = request.getParameter("description");

            SpecialistProfile profile = new SpecialistProfile();
            profile.setSpecialist(specialist);
            profile.setSpeciality(speciality);
            profile.setConsultationFee(new BigDecimal(feeStr));
            profile.setDescription(description);
            profile.setConsultationDuration(30);
            profile.setAvailable(true);

            specialisteService.createOrUpdateProfile(profile);

            request.setAttribute("success", "Profile saved successfully");
            showProfile(request, response);

        } catch (Exception e) {
            request.setAttribute("error", "Error saving profile: " + e.getMessage());
            showProfile(request, response);
        }
    }

    private void generateSlots(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User specialist = (User) session.getAttribute("user");

        try {
            int daysAhead = 7;
            specialisteService.generateSlots(specialist, daysAhead);

            response.sendRedirect(request.getContextPath() + "/specialist/slots");

        } catch (Exception e) {
            request.setAttribute("error", "Error generating slots: " + e.getMessage());
            showSlots(request, response);
        }
    }

    private void respondToExpertise(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long expertiseId = Long.parseLong(request.getParameter("expertiseId"));
            String specialistResponse = request.getParameter("response");
            String recommendations = request.getParameter("recommendations");

            specialisteService.respondToExpertise(expertiseId, specialistResponse, recommendations);

            response.sendRedirect(request.getContextPath() + "/specialist/requests");

        } catch (Exception e) {
            request.setAttribute("error", "Error responding to expertise: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/specialist/requests");
        }
    }

    // Méthodes pour le calendrier

    private void showCalendar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User specialist = (User) session.getAttribute("user");

        // Par défaut, afficher le calendrier mensuel pour le mois actuel
        YearMonth currentMonth = YearMonth.now();
        Map<String, Object> calendarData = specialisteService.getMonthlyCalendar(specialist.getId(), currentMonth);
        Map<String, Object> stats = specialisteService.getCalendarStatistics(specialist.getId());

        request.setAttribute("calendarData", calendarData);
        request.setAttribute("statistics", stats);
        request.setAttribute("currentMonth", currentMonth);

        request.getRequestDispatcher("/jsp/specialiste/calendar.jsp").forward(request, response);
    }

    private void showMonthlyCalendar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User specialist = (User) session.getAttribute("user");

        String yearMonthStr = request.getParameter("month");
        YearMonth yearMonth = yearMonthStr != null ? YearMonth.parse(yearMonthStr) : YearMonth.now();

        Map<String, Object> calendarData = specialisteService.getMonthlyCalendar(specialist.getId(), yearMonth);
        Map<String, Object> stats = specialisteService.getCalendarStatistics(specialist.getId());

        request.setAttribute("calendarData", calendarData);
        request.setAttribute("statistics", stats);
        request.setAttribute("currentMonth", yearMonth);

        request.getRequestDispatcher("/jsp/specialiste/calendar-month.jsp").forward(request, response);
    }

    private void showWeeklyCalendar(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User specialist = (User) session.getAttribute("user");

        String weekStartStr = request.getParameter("week");
        LocalDate weekStart = weekStartStr != null ? LocalDate.parse(weekStartStr) : LocalDate.now().with(java.time.DayOfWeek.MONDAY);

        Map<String, Object> calendarData = specialisteService.getWeeklyCalendar(specialist.getId(), weekStart);

        // Récupérer tous les utilisateurs avec le rôle SPECIALISTE
        List<User> specialistUsers = generalisteService.getAllSpecialistUsers();
        // Récupérer aussi les profils de spécialistes pour les informations additionnelles
        List<SpecialistProfile> specialists = generalisteService.getAllSpecialists();

        request.setAttribute("calendarData", calendarData);
        request.setAttribute("weekStart", weekStart);
        request.setAttribute("specialistUsers", specialistUsers);
        request.setAttribute("specialists", specialists);

        request.getRequestDispatcher("/jsp/specialiste/calendar-week.jsp").forward(request, response);
    }

    private void syncCalendarWithSlots(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User specialist = (User) session.getAttribute("user");

        try {
            specialisteService.syncCalendarWithSlots(specialist.getId());
            response.sendRedirect(request.getContextPath() + "/specialist/calendar?success=sync");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/specialist/calendar?error=sync");
        }
    }

    private void getAvailableSlots(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long specialistId = Long.parseLong(request.getParameter("specialistId"));
        List<Slot> slots = generalisteService.getAvailableSlots(specialistId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder();
        json.append("[");
        for (int i = 0; i < slots.size(); i++) {
            Slot slot = slots.get(i);
            json.append("{");
            json.append("\"id\":").append(slot.getId()).append(",");
            json.append("\"startTime\":\"").append(slot.getStartTime()).append("\",");
            json.append("\"endTime\":\"").append(slot.getEndTime()).append("\"");
            json.append("}");
            if (i < slots.size() - 1) {
                json.append(",");
            }
        }
        json.append("]");

        response.getWriter().write(json.toString());
    }
}
