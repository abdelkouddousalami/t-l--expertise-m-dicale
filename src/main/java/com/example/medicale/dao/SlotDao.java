package com.example.medicale.dao;

import com.example.medicale.entity.Slot;
import com.example.medicale.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class SlotDao {

    public void save(Slot slot) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(slot);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving slot", e);
        } finally {
            em.close();
        }
    }

    public Optional<Slot> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            Slot slot = em.find(Slot.class, id);
            return Optional.ofNullable(slot);
        } finally {
            em.close();
        }
    }

    public List<Slot> findBySpecialistId(Long specialistId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT s FROM Slot s WHERE s.specialist.id = :specialistId ORDER BY s.startTime", Slot.class)
                    .setParameter("specialistId", specialistId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Slot> findAvailableBySpecialistId(Long specialistId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            LocalDateTime now = LocalDateTime.now();
            return em.createQuery("SELECT s FROM Slot s WHERE s.specialist.id = :specialistId AND s.available = true AND s.startTime > :now ORDER BY s.startTime", Slot.class)
                    .setParameter("specialistId", specialistId)
                    .setParameter("now", now)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public void update(Slot slot) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(slot);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating slot", e);
        } finally {
            em.close();
        }
    }

    public void saveAll(List<Slot> slots) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            for (Slot slot : slots) {
                em.persist(slot);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving slots", e);
        } finally {
            em.close();
        }
    }
}
