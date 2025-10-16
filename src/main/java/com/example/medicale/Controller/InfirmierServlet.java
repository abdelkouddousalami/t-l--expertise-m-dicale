package com.example.medicale.Controller;

import com.example.medicale.entity.Patient;
import com.example.medicale.entity.VitalSigns;
import com.example.medicale.entity.User;
import com.example.medicale.service.InfirmierService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@WebServlet("/nurse/*")
public class InfirmierServlet extends HttpServlet {

    private InfirmierService infirmierService;

    @Override
    public void init() {
        infirmierService = new InfirmierService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null || action.equals("/")) {
            action = "/register";
        }

        switch (action) {
            case "/register":
                showRegisterForm(request, response);
                break;
            case "/patients":
                showTodayPatients(request, response);
                break;
            case "/search":
                searchPatient(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/nurse/register");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getPathInfo();

        if (action == null) {
            action = "/register";
        }

        switch (action) {
            case "/register":
                registerPatient(request, response);
                break;
            case "/addVitals":
                addVitalSigns(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/nurse/register");
                break;
        }
    }

    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/nurse/patient-register.jsp").forward(request, response);
    }

    private void showTodayPatients(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Patient> patients = infirmierService.getTodayPatients();
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("/jsp/nurse/patients-today.jsp").forward(request, response);
    }

    private void searchPatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String ssn = request.getParameter("ssn");

        if (ssn != null && !ssn.trim().isEmpty()) {
            Optional<Patient> patientOpt = infirmierService.findPatientBySsn(ssn);

            if (patientOpt.isPresent()) {
                request.setAttribute("patient", patientOpt.get());
                request.setAttribute("found", true);
            } else {
                request.setAttribute("found", false);
                request.setAttribute("message", "Patient not found");
            }
        }

        request.getRequestDispatcher("/jsp/nurse/patient-register.jsp").forward(request, response);
    }

    private void registerPatient(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User nurse = (User) session.getAttribute("user");

        try {
            Patient patient = new Patient();
            patient.setFirstName(request.getParameter("firstName"));
            patient.setLastName(request.getParameter("lastName"));
            patient.setDob(LocalDate.parse(request.getParameter("dob")));
            patient.setSsn(request.getParameter("ssn"));
            patient.setPhone(request.getParameter("phone"));
            patient.setAddress(request.getParameter("address"));
            patient.setMedicalHistory(request.getParameter("medicalHistory"));
            patient.setAllergies(request.getParameter("allergies"));
            patient.setCurrentTreatments(request.getParameter("currentTreatments"));
            patient.setMutuelle(request.getParameter("mutuelle"));

            VitalSigns vitalSigns = new VitalSigns();
            vitalSigns.setNurse(nurse);
            vitalSigns.setBloodPressure(request.getParameter("bloodPressure"));
            vitalSigns.setHeartRate(Integer.parseInt(request.getParameter("heartRate")));
            vitalSigns.setTemperature(Float.parseFloat(request.getParameter("temperature")));
            vitalSigns.setRespiratoryRate(Integer.parseInt(request.getParameter("respiratoryRate")));

            String weight = request.getParameter("weight");
            if (weight != null && !weight.trim().isEmpty()) {
                vitalSigns.setWeight(Float.parseFloat(weight));
            }

            String height = request.getParameter("height");
            if (height != null && !height.trim().isEmpty()) {
                vitalSigns.setHeight(Float.parseFloat(height));
            }

            infirmierService.registerPatient(patient, vitalSigns);

            request.setAttribute("success", "Patient registered successfully");
            response.sendRedirect(request.getContextPath() + "/nurse/patients");

        } catch (Exception e) {
            request.setAttribute("error", "Error registering patient: " + e.getMessage());
            request.getRequestDispatcher("/jsp/nurse/patient-register.jsp").forward(request, response);
        }
    }

    private void addVitalSigns(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User nurse = (User) session.getAttribute("user");

        try {
            Long patientId = Long.parseLong(request.getParameter("patientId"));
            Optional<Patient> patientOpt = infirmierService.findPatientById(patientId);

            if (patientOpt.isPresent()) {
                VitalSigns vitalSigns = new VitalSigns();
                vitalSigns.setNurse(nurse);
                vitalSigns.setBloodPressure(request.getParameter("bloodPressure"));
                vitalSigns.setHeartRate(Integer.parseInt(request.getParameter("heartRate")));
                vitalSigns.setTemperature(Float.parseFloat(request.getParameter("temperature")));
                vitalSigns.setRespiratoryRate(Integer.parseInt(request.getParameter("respiratoryRate")));

                String weight = request.getParameter("weight");
                if (weight != null && !weight.trim().isEmpty()) {
                    vitalSigns.setWeight(Float.parseFloat(weight));
                }

                String height = request.getParameter("height");
                if (height != null && !height.trim().isEmpty()) {
                    vitalSigns.setHeight(Float.parseFloat(height));
                }

                infirmierService.addVitalSigns(patientOpt.get(), vitalSigns);

                response.sendRedirect(request.getContextPath() + "/nurse/patients");
            } else {
                request.setAttribute("error", "Patient not found");
                request.getRequestDispatcher("/jsp/nurse/patient-register.jsp").forward(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "Error adding vital signs: " + e.getMessage());
            request.getRequestDispatcher("/jsp/nurse/patient-register.jsp").forward(request, response);
        }
    }
}
