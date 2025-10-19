package com.example.medicale.service;

import com.example.medicale.dao.*;
import com.example.medicale.entity.*;
import com.example.medicale.enums.ConsultationStatus;
import com.example.medicale.enums.Role;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class GeneralisteService {

    private PatientDao patientDao;
    private ConsultationDao consultationDao;
    private MedicalActDao medicalActDao;
    private SpecialistProfileDao specialistProfileDao;
    private SlotDao slotDao;
    private ExpertiseRequestDao expertiseRequestDao;
    private PatientQueueDao patientQueueDao;
    private UserDao userDao;

    public GeneralisteService() {
        this.patientDao = new PatientDao();
        this.consultationDao = new ConsultationDao();
        this.medicalActDao = new MedicalActDao();
        this.specialistProfileDao = new SpecialistProfileDao();
        this.slotDao = new SlotDao();
        this.expertiseRequestDao = new ExpertiseRequestDao();
        this.patientQueueDao = new PatientQueueDao();
        this.userDao = new UserDao();
    }

    public List<Patient> getAllPatients() {
        return patientDao.findAll();
    }

    public Optional<Consultation> findConsultationById(Long consultationId) {
        return consultationDao.findById(consultationId);
    }

    public BigDecimal calculateTotalCost(Long consultationId) {

        return new BigDecimal("100.00");
    }

    public List<MedicalAct> getAllMedicalActs() {
        return medicalActDao.findAll();
    }

    public void createConsultation(Consultation consultation) {
        consultation.setConsultationDate(LocalDateTime.now());
        consultation.setStatus(ConsultationStatus.OPEN);
        consultationDao.save(consultation);
    }

    public void updateConsultation(Consultation consultation) {
        consultationDao.update(consultation);
    }

    public void closeConsultation(Long consultationId, String diagnosis, String prescription) {
        Optional<Consultation> consultationOpt = consultationDao.findById(consultationId);
        if (consultationOpt.isPresent()) {
            Consultation consultation = consultationOpt.get();
            consultation.setDiagnosis(diagnosis);
            consultation.setPrescription(prescription);
            consultation.setStatus(ConsultationStatus.TERMINEE);
            consultationDao.update(consultation);
        }
    }

    public List<SpecialistProfile> findSpecialistsBySpeciality(String speciality) {
        return specialistProfileDao.findBySpeciality(speciality);
    }

    public List<SpecialistProfile> getAllSpecialists() {
        return specialistProfileDao.findAll();
    }

    public List<User> getAllSpecialistUsers() {
        List<User> users = userDao.findByRole(Role.SPECIALISTE);
        System.out.println("[DEBUG] GeneralisteService.getAllSpecialistUsers() - Found " + users.size() + " users with SPECIALISTE role");
        for (User user : users) {
            System.out.println("[DEBUG] - User: " + user.getFullName() + " (ID: " + user.getId() + ", Username: " + user.getUsername() + ")");
        }
        return users;
    }

    public List<Slot> getAvailableSlots(Long specialistId) {
        return slotDao.findAvailableBySpecialistId(specialistId);
    }

    public void createExpertiseRequest(ExpertiseRequest expertiseRequest, Long consultationId) {
        Optional<Consultation> consultationOpt = consultationDao.findById(consultationId);
        if (consultationOpt.isPresent()) {
            expertiseRequest.setConsultation(consultationOpt.get());
            expertiseRequest.setRequestDate(LocalDateTime.now());
            expertiseRequest.setCompleted(false);


            if (expertiseRequest.getSlot() != null && expertiseRequest.getSlot().getId() != null) {
                Optional<Slot> slotOpt = slotDao.findById(expertiseRequest.getSlot().getId());
                if (slotOpt.isPresent()) {
                    Slot slot = slotOpt.get();
                    slot.setAvailable(false);
                    slotDao.update(slot);
                }
            }

            expertiseRequestDao.save(expertiseRequest);
        }
    }

    public List<Patient> getTodayPatientQueue() {
        return patientQueueDao.getPatientQueueForToday();
    }

    public List<Consultation> getConsultationsByGeneraliste(Long generalisteId) {
        return consultationDao.findByGeneralisteId(generalisteId);
    }

    public List<ExpertiseRequest> getPendingExpertiseRequestsByGeneraliste(Long generalisteId) {
        return expertiseRequestDao.findPendingByGeneralisteId(generalisteId);
    }
}