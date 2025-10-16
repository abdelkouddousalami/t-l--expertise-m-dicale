package com.example.medicale.dao;

import com.example.medicale.entity.VitalSigns;
import com.example.medicale.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.Optional;

public class VitalSignsDao {

    public void save(VitalSigns vitalSigns) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(vitalSigns);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving vital signs", e);
        } finally {
            em.close();
        }
    }

    public Optional<VitalSigns> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            VitalSigns vitalSigns = em.find(VitalSigns.class, id);
            return Optional.ofNullable(vitalSigns);
        } finally {
            em.close();
        }
    }

    public List<VitalSigns> findByPatientId(Long patientId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT v FROM VitalSigns v WHERE v.patient.id = :patientId ORDER BY v.recordedAt DESC", VitalSigns.class)
                    .setParameter("patientId", patientId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public Optional<VitalSigns> findLatestByPatientId(Long patientId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            List<VitalSigns> results = em.createQuery("SELECT v FROM VitalSigns v WHERE v.patient.id = :patientId ORDER BY v.recordedAt DESC", VitalSigns.class)
                    .setParameter("patientId", patientId)
                    .setMaxResults(1)
                    .getResultList();
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } finally {
            em.close();
        }
    }

    public void update(VitalSigns vitalSigns) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(vitalSigns);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating vital signs", e);
        } finally {
            em.close();
        }
    }
}


