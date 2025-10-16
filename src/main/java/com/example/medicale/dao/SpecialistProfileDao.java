package com.example.medicale.dao;

import com.example.medicale.entity.SpecialistProfile;
import com.example.medicale.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import java.util.List;
import java.util.Optional;

public class SpecialistProfileDao {

    public void save(SpecialistProfile profile) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(profile);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving specialist profile", e);
        } finally {
            em.close();
        }
    }

    public Optional<SpecialistProfile> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            SpecialistProfile profile = em.find(SpecialistProfile.class, id);
            return Optional.ofNullable(profile);
        } finally {
            em.close();
        }
    }

    public Optional<SpecialistProfile> findBySpecialistId(Long specialistId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            SpecialistProfile profile = em.createQuery("SELECT s FROM SpecialistProfile s WHERE s.specialist.id = :specialistId", SpecialistProfile.class)
                    .setParameter("specialistId", specialistId)
                    .getSingleResult();
            return Optional.of(profile);
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    public List<SpecialistProfile> findBySpeciality(String speciality) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT s FROM SpecialistProfile s WHERE s.speciality = :speciality AND s.available = true ORDER BY s.consultationFee", SpecialistProfile.class)
                    .setParameter("speciality", speciality)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<SpecialistProfile> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT s FROM SpecialistProfile s ORDER BY s.speciality", SpecialistProfile.class).getResultList();
        } finally {
            em.close();
        }
    }

    public void update(SpecialistProfile profile) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(profile);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating specialist profile", e);
        } finally {
            em.close();
        }
    }
}
