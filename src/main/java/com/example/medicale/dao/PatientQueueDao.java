package com.example.medicale.dao;

import com.example.medicale.entity.Patient;
import com.example.medicale.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

public class PatientQueueDao {

    public List<Patient> getPatientQueueForToday() {
        try (EntityManager em = HibernateUtil.getEntityManager()) {
            LocalDateTime startOfDay = LocalDate.now().atStartOfDay();
            LocalDateTime endOfDay = LocalDate.now().plusDays(1).atStartOfDay();

            String jpql = "FROM Patient p WHERE p.arrivalTime >= :startOfDay AND p.arrivalTime < :endOfDay";
            List<Patient> patients = em.createQuery(jpql, Patient.class)
                    .setParameter("startOfDay", startOfDay)
                    .setParameter("endOfDay", endOfDay)
                    .getResultList();


            return patients.stream()
                    .sorted((p1, p2) -> p1.getArrivalTime().compareTo(p2.getArrivalTime()))
                    .collect(Collectors.toList());
        }
    }

    public List<Patient> getPatientQueueByDate(LocalDate date) {
        try (EntityManager em = HibernateUtil.getEntityManager()) {
            LocalDateTime startOfDay = date.atStartOfDay();
            LocalDateTime endOfDay = date.plusDays(1).atStartOfDay();

            String jpql = "FROM Patient p WHERE p.arrivalTime >= :startOfDay AND p.arrivalTime < :endOfDay";
            List<Patient> patients = em.createQuery(jpql, Patient.class)
                    .setParameter("startOfDay", startOfDay)
                    .setParameter("endOfDay", endOfDay)
                    .getResultList();


            return patients.stream()
                    .filter(p -> p.getArrivalTime() != null)
                    .sorted((p1, p2) -> p1.getArrivalTime().compareTo(p2.getArrivalTime()))
                    .collect(Collectors.toList());
        }
    }

    public void addPatientToQueue(Patient patient) {
        if (patient.getArrivalTime() == null) {
            patient.setArrivalTime(LocalDateTime.now());
        }


        HibernateUtil.executeInTransaction(em -> {
            em.merge(patient);
        });
    }
}
