package com.example.medicale.dao;

import com.example.medicale.entity.Patient;
import com.example.medicale.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class PatientDao {

    public void save(Patient patient) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(patient);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving patient", e);
        } finally {
            em.close();
        }
    }

    public Optional<Patient> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            Patient patient = em.find(Patient.class, id);
            return Optional.ofNullable(patient);
        } finally {
            em.close();
        }
    }

    public Optional<Patient> findBySsn(String ssn) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            Patient patient = em.createQuery("SELECT p FROM Patient p WHERE p.ssn = :ssn", Patient.class)
                    .setParameter("ssn", ssn)
                    .getSingleResult();
            return Optional.of(patient);
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public List<Patient> findByDate(LocalDate date) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            LocalDateTime startOfDay = date.atStartOfDay();
            LocalDateTime endOfDay = date.atTime(23, 59, 59);
            return em.createQuery(
                "SELECT DISTINCT p FROM Patient p " +
                "LEFT JOIN FETCH p.vitalSignsList v " +
                "WHERE p.arrivalTime BETWEEN :start AND :end " +
                "ORDER BY p.arrivalTime, v.recordedAt DESC", Patient.class)
                    .setParameter("start", startOfDay)
                    .setParameter("end", endOfDay)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Patient> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Patient p ORDER BY p.arrivalTime DESC", Patient.class).getResultList();
        } finally {
            em.close();
        }
    }

    public void update(Patient patient) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(patient);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating patient", e);
        } finally {
            em.close();
        }
    }

    public void delete(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Patient patient = em.find(Patient.class, id);
            if (patient != null) {
                em.remove(patient);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error deleting patient", e);
        } finally {
            em.close();
        }
    }
}
