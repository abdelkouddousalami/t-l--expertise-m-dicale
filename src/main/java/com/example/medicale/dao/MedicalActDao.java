package com.example.medicale.dao;

import com.example.medicale.entity.MedicalAct;
import com.example.medicale.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.Optional;

public class MedicalActDao {

    public void save(MedicalAct medicalAct) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(medicalAct);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving medical act", e);
        } finally {
            em.close();
        }
    }

    public Optional<MedicalAct> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            MedicalAct medicalAct = em.find(MedicalAct.class, id);
            return Optional.ofNullable(medicalAct);
        } finally {
            em.close();
        }
    }

    public List<MedicalAct> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT m FROM MedicalAct m ORDER BY m.category, m.name", MedicalAct.class).getResultList();
        } finally {
            em.close();
        }
    }

    public List<MedicalAct> findByCategory(String category) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT m FROM MedicalAct m WHERE m.category = :category ORDER BY m.name", MedicalAct.class)
                    .setParameter("category", category)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public void update(MedicalAct medicalAct) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(medicalAct);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating medical act", e);
        } finally {
            em.close();
        }
    }
}
