package com.example.medicale.service;

import com.example.medicale.dao.PatientDao;
import com.example.medicale.dao.VitalSignsDao;
import com.example.medicale.entity.Patient;
import com.example.medicale.entity.VitalSigns;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class InfirmierService {

    private PatientDao patientDao;
    private VitalSignsDao vitalSignsDao;

    public InfirmierService() {
        this.patientDao = new PatientDao();
        this.vitalSignsDao = new VitalSignsDao();
    }

    public Optional<Patient> findPatientBySsn(String ssn) {
        return patientDao.findBySsn(ssn);
    }

    public void registerPatient(Patient patient, VitalSigns vitalSigns) {
        patient.setArrivalTime(LocalDateTime.now());
        patientDao.save(patient);

        vitalSigns.setPatient(patient);
        vitalSigns.setRecordedAt(LocalDateTime.now());
        vitalSignsDao.save(vitalSigns);
    }

    public void addVitalSigns(Patient patient, VitalSigns vitalSigns) {
        vitalSigns.setPatient(patient);
        vitalSigns.setRecordedAt(LocalDateTime.now());
        vitalSignsDao.save(vitalSigns);
    }

    public List<Patient> getTodayPatients() {
        LocalDate today = LocalDate.now();
        List<Patient> patients = patientDao.findByDate(today);


        patients.forEach(patient -> {
            if (patient.getVitalSignsList() != null) {
                patient.getVitalSignsList().sort((v1, v2) -> v2.getRecordedAt().compareTo(v1.getRecordedAt()));
            }
        });

        return patients.stream()
                .sorted((p1, p2) -> p1.getArrivalTime().compareTo(p2.getArrivalTime()))
                .collect(Collectors.toList());
    }

    public Optional<Patient> findPatientById(Long id) {
        return patientDao.findById(id);
    }

    public void updatePatient(Patient patient) {
        patientDao.update(patient);
    }
}

