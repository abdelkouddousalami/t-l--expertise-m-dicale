package com.example.medicale.Controller;

import com.example.medicale.entity.*;
import com.example.medicale.enums.Priority;
import com.example.medicale.service.GeneralisteService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@WebServlet("/generaliste/*")
public class GeneralisteServlet extends HttpServlet {

    private GeneralisteService generalisteService;

    @Override
    public void init() {
        generalisteService = new GeneralisteService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null || action.equals("/")) {
            action = "/consultations";
        }

        switch (action) {
            case "/dashboard":
                showDashboard(request, response);
                break;
            case "/queue":
                showPatientQueue(request, response);
                break;
            case "/consultations":
                showConsultations(request, response);
                break;
            case "/consultation/new":
                showNewConsultationForm(request, response);
                break;
            case "/consultation/view":
                viewConsultation(request, response);
                break;
            case "/expertise/request":
                showExpertiseRequestForm(request, response);
                break;
            case "/specialists":
                listSpecialists(request, response);
                break;
            case "/slots":
                showAvailableSlots(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/generaliste/dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/generaliste/consultations");
            return;
        }

        switch (action) {
            case "/consultation/create":
                createConsultation(request, response);
                break;
            case "/consultation/update":
                updateConsultation(request, response);
                break;
            case "/consultation/close":
                closeConsultation(request, response);
                break;
            case "/expertise/create":
                createExpertiseRequest(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/generaliste/consultations");
                break;
        }
    }

    private void showConsultations(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Patient> patients = generalisteService.getAllPatients();
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("/jsp/generaliste/consultation-new.jsp").forward(request, response);
    }

    private void showNewConsultationForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Patient> patients = generalisteService.getAllPatients();
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("/jsp/generaliste/consultation-new.jsp").forward(request, response);
    }

    private void viewConsultation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long consultationId = Long.parseLong(request.getParameter("id"));
        Optional<Consultation> consultationOpt = generalisteService.findConsultationById(consultationId);

        if (consultationOpt.isPresent()) {
            Consultation consultation = consultationOpt.get();
            request.setAttribute("consultation", consultation);

            BigDecimal totalCost = generalisteService.calculateTotalCost(consultationId);
            request.setAttribute("totalCost", totalCost);

            List<MedicalAct> medicalActs = generalisteService.getAllMedicalActs();
            request.setAttribute("medicalActs", medicalActs);

            request.getRequestDispatcher("/jsp/generaliste/consultation-view.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/generaliste/consultations");
        }
    }

    private void createConsultation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User generaliste = (User) session.getAttribute("user");

        try {
            Long patientId = Long.parseLong(request.getParameter("patientId"));
            String motif = request.getParameter("motif");
            String observations = request.getParameter("observations");
            String symptoms = request.getParameter("symptoms");
            String clinicalExam = request.getParameter("clinicalExam");

            Consultation consultation = new Consultation();
            consultation.setGeneraliste(generaliste);

            Patient patient = new Patient();
            patient.setId(patientId);
            consultation.setPatient(patient);

            consultation.setMotif(motif);
            consultation.setObservations(observations);
            consultation.setSymptoms(symptoms);
            consultation.setClinicalExam(clinicalExam);

            generalisteService.createConsultation(consultation);

            response.sendRedirect(request.getContextPath() + "/generaliste/consultation/view?id=" + consultation.getId());

        } catch (Exception e) {
            request.setAttribute("error", "Error creating consultation: " + e.getMessage());
            showNewConsultationForm(request, response);
        }
    }

    private void updateConsultation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long consultationId = Long.parseLong(request.getParameter("consultationId"));
            Optional<Consultation> consultationOpt = generalisteService.findConsultationById(consultationId);

            if (consultationOpt.isPresent()) {
                Consultation consultation = consultationOpt.get();

                consultation.setObservations(request.getParameter("observations"));
                consultation.setSymptoms(request.getParameter("symptoms"));
                consultation.setClinicalExam(request.getParameter("clinicalExam"));

                generalisteService.updateConsultation(consultation);

                response.sendRedirect(request.getContextPath() + "/generaliste/consultation/view?id=" + consultationId);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Error updating consultation: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/generaliste/consultations");
        }
    }

    private void closeConsultation(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long consultationId = Long.parseLong(request.getParameter("consultationId"));
            String diagnosis = request.getParameter("diagnosis");
            String prescription = request.getParameter("prescription");

            generalisteService.closeConsultation(consultationId, diagnosis, prescription);

            response.sendRedirect(request.getContextPath() + "/generaliste/consultation/view?id=" + consultationId);

        } catch (Exception e) {
            request.setAttribute("error", "Error closing consultation: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/generaliste/consultations");
        }
    }

    private void showExpertiseRequestForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long consultationId = Long.parseLong(request.getParameter("consultationId"));
        String speciality = request.getParameter("speciality");

        // Get all users with SPECIALISTE role
        List<User> specialistUsers = generalisteService.getAllSpecialistUsers();
        // Also get specialist profiles for additional info
        List<SpecialistProfile> specialists = generalisteService.getAllSpecialists();

        // Debug logging
        System.out.println("[DEBUG] Expertise request for consultation ID: " + consultationId);
        System.out.println("[DEBUG] Requested speciality: " + speciality);
        System.out.println("[DEBUG] Found specialist users: " + specialistUsers.size());
        System.out.println("[DEBUG] Found specialist profiles: " + specialists.size());
        
        if (specialistUsers.isEmpty()) {
            System.out.println("[WARNING] No users with SPECIALISTE role found!");
        } else {
            for (User user : specialistUsers) {
                System.out.println("[DEBUG] Specialist user: " + user.getFullName() + " (ID: " + user.getId() + ")");
            }
        }

        request.setAttribute("consultationId", consultationId);
        request.setAttribute("speciality", speciality);
        request.setAttribute("specialistUsers", specialistUsers);
        request.setAttribute("specialists", specialists);

        request.getRequestDispatcher("/jsp/generaliste/expertise-request.jsp").forward(request, response);
    }

    private void listSpecialists(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String speciality = request.getParameter("speciality");
        List<SpecialistProfile> specialists = generalisteService.findSpecialistsBySpeciality(speciality);

        request.setAttribute("specialists", specialists);
        request.setAttribute("speciality", speciality);

        response.setContentType("application/json");
        response.getWriter().write("[]");
    }

    private void showAvailableSlots(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Long specialistId = Long.parseLong(request.getParameter("specialistId"));
        List<Slot> slots = generalisteService.getAvailableSlots(specialistId);

        request.setAttribute("slots", slots);
        request.setAttribute("specialistId", specialistId);

        response.setContentType("application/json");
        response.getWriter().write("[]");
    }

    private void createExpertiseRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Long consultationId = Long.parseLong(request.getParameter("consultationId"));
            Long specialistId = Long.parseLong(request.getParameter("specialistId"));
            Long slotId = Long.parseLong(request.getParameter("slotId"));
            String speciality = request.getParameter("speciality");
            String question = request.getParameter("question");
            String additionalData = request.getParameter("additionalData");
            String priorityStr = request.getParameter("priority");

            ExpertiseRequest expertiseRequest = new ExpertiseRequest();

            User specialist = new User();
            specialist.setId(specialistId);
            expertiseRequest.setSpecialist(specialist);

            Slot slot = new Slot();
            slot.setId(slotId);
            expertiseRequest.setSlot(slot);

            expertiseRequest.setSpecialityRequested(speciality);
            expertiseRequest.setQuestion(question);
            expertiseRequest.setAdditionalData(additionalData);
            expertiseRequest.setPriority(Priority.valueOf(priorityStr));

            generalisteService.createExpertiseRequest(expertiseRequest, consultationId);

            response.sendRedirect(request.getContextPath() + "/generaliste/consultation/view?id=" + consultationId);

        } catch (Exception e) {
            request.setAttribute("error", "Error creating expertise request: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/generaliste/consultations");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User generaliste = (User) session.getAttribute("user");

        if (generaliste == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }


        List<Patient> todayPatients = generalisteService.getTodayPatientQueue();


        List<Consultation> myConsultations = generalisteService.getConsultationsByGeneraliste(generaliste.getId());


        List<ExpertiseRequest> pendingRequests = generalisteService.getPendingExpertiseRequestsByGeneraliste(generaliste.getId());

        request.setAttribute("todayPatients", todayPatients);
        request.setAttribute("myConsultations", myConsultations);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("generaliste", generaliste);

        request.getRequestDispatcher("/jsp/generaliste/dashboard.jsp").forward(request, response);
    }

    private void showPatientQueue(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Patient> queuePatients = generalisteService.getTodayPatientQueue();
        request.setAttribute("queuePatients", queuePatients);
        request.getRequestDispatcher("/jsp/generaliste/queue.jsp").forward(request, response);
    }
}
