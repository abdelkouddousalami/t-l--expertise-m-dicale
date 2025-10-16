package com.example.medicale.service;

import com.example.medicale.dao.ExpertiseRequestDao;
import com.example.medicale.dao.SlotDao;
import com.example.medicale.dao.SpecialistProfileDao;
import com.example.medicale.dao.ConsultationDao;
import com.example.medicale.entity.ExpertiseRequest;
import com.example.medicale.entity.Slot;
import com.example.medicale.entity.SpecialistProfile;
import com.example.medicale.entity.User;
import com.example.medicale.entity.Consultation;
import com.example.medicale.enums.ConsultationStatus;
import com.example.medicale.enums.Priority;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class SpecialisteService {

    private SpecialistProfileDao specialistProfileDao;
    private SlotDao slotDao;
    private ExpertiseRequestDao expertiseRequestDao;
    private ConsultationDao consultationDao;

    public SpecialisteService() {
        this.specialistProfileDao = new SpecialistProfileDao();
        this.slotDao = new SlotDao();
        this.expertiseRequestDao = new ExpertiseRequestDao();
        this.consultationDao = new ConsultationDao();
    }

    public void createOrUpdateProfile(SpecialistProfile profile) {
        Optional<SpecialistProfile> existingProfile = specialistProfileDao.findBySpecialistId(profile.getSpecialist().getId());
        if (existingProfile.isPresent()) {
            profile.setId(existingProfile.get().getId());
            specialistProfileDao.update(profile);
        } else {
            specialistProfileDao.save(profile);
        }
    }

    public Optional<SpecialistProfile> getProfileBySpecialistId(Long specialistId) {
        return specialistProfileDao.findBySpecialistId(specialistId);
    }


    public void generateSlots(User specialist, int daysAhead) {
        List<Slot> slots = new ArrayList<>();
        LocalDateTime now = LocalDateTime.now();

        for (int day = 0; day < daysAhead; day++) {

            LocalDateTime date = now.plusDays(day);

            LocalTime[] slotTimes = {
                LocalTime.of(9, 0), LocalTime.of(9, 30), LocalTime.of(10, 0),
                LocalTime.of(10, 30), LocalTime.of(11, 0), LocalTime.of(11, 30),
                LocalTime.of(14, 0), LocalTime.of(14, 30), LocalTime.of(15, 0),
                LocalTime.of(15, 30), LocalTime.of(16, 0), LocalTime.of(16, 30)
            };

            for (LocalTime time : slotTimes) {
                LocalDateTime startTime = LocalDateTime.of(date.toLocalDate(), time);
                if (startTime.isAfter(now)) {
                    Slot slot = new Slot();
                    slot.setSpecialist(specialist);
                    slot.setStartTime(startTime);
                    slot.setEndTime(startTime.plusMinutes(30));
                    slot.setAvailable(true);
                    slots.add(slot);
                }
            }
        }


        if (!slots.isEmpty()) {
            slotDao.saveAll(slots);
        }
    }

    public List<Slot> getSpecialistSlots(Long specialistId) {
        return slotDao.findBySpecialistId(specialistId)
                .stream()
                .sorted((s1, s2) -> s1.getStartTime().compareTo(s2.getStartTime()))
                .collect(Collectors.toList());
    }

    public List<ExpertiseRequest> getExpertiseRequests(Long specialistId) {
        return expertiseRequestDao.findBySpecialistId(specialistId)
                .stream()
                .sorted((e1, e2) -> {
                    int priorityComparison = e1.getPriority().compareTo(e2.getPriority());
                    if (priorityComparison != 0) {
                        return priorityComparison;
                    }
                    return e2.getRequestDate().compareTo(e1.getRequestDate());
                })
                .collect(Collectors.toList());
    }


    public List<ExpertiseRequest> getExpertiseRequestsByStatus(Long specialistId, Boolean completed) {
        return expertiseRequestDao.findBySpecialistIdAndCompleted(specialistId, completed);
    }


    public List<ExpertiseRequest> filterRequestsByPriority(Long specialistId, Priority priority) {
        return expertiseRequestDao.findBySpecialistId(specialistId).stream()
                .filter(request -> request.getPriority() == priority)
                .sorted((r1, r2) -> r2.getRequestDate().compareTo(r1.getRequestDate()))
                .collect(Collectors.toList());
    }


    public Optional<ExpertiseRequest> findExpertiseById(Long expertiseId) {
        return expertiseRequestDao.findById(expertiseId);
    }


    public void respondToExpertise(Long expertiseId, String response, String recommendations) {
        Optional<ExpertiseRequest> expertiseOpt = expertiseRequestDao.findById(expertiseId);
        if (expertiseOpt.isPresent()) {
            ExpertiseRequest expertise = expertiseOpt.get();
            expertise.setSpecialistResponse(response);
            expertise.setRecommendations(recommendations);
            expertise.setResponseDate(LocalDateTime.now());
            expertise.setCompleted(true);
            expertiseRequestDao.update(expertise);


            Consultation consultation = expertise.getConsultation();
            consultation.setStatus(ConsultationStatus.OPEN);
            consultationDao.update(consultation);
        }
    }

    public void cancelSlot(Long slotId) {
        Optional<Slot> slotOpt = slotDao.findById(slotId);
        if (slotOpt.isPresent()) {
            Slot slot = slotOpt.get();
            slot.setAvailable(true);
            slotDao.update(slot);
        }
    }


    public long getTotalRequests(Long specialistId) {
        return expertiseRequestDao.findBySpecialistId(specialistId).size();
    }

    public long getCompletedRequests(Long specialistId) {
        return expertiseRequestDao.findBySpecialistIdAndCompleted(specialistId, true).size();
    }

    public long getPendingRequests(Long specialistId) {
        return expertiseRequestDao.findBySpecialistIdAndCompleted(specialistId, false).size();
    }

    public long getUrgentRequests(Long specialistId) {
        return expertiseRequestDao.findBySpecialistId(specialistId).stream()
                .filter(request -> request.getPriority() == Priority.URGENTE)
                .count();
    }
}