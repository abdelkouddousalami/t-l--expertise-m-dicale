package com.example.medicale.dao;

import com.example.medicale.entity.ExpertiseRequest;
import com.example.medicale.enums.Priority;
import com.example.medicale.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import java.util.List;
import java.util.Optional;

public class ExpertiseRequestDao {

    public void save(ExpertiseRequest expertiseRequest) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(expertiseRequest);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving expertise request", e);
        } finally {
            em.close();
        }
    }

    public Optional<ExpertiseRequest> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            ExpertiseRequest expertiseRequest = em.find(ExpertiseRequest.class, id);
            return Optional.ofNullable(expertiseRequest);
        } finally {
            em.close();
        }
    }

    public List<ExpertiseRequest> findBySpecialistId(Long specialistId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT e FROM ExpertiseRequest e WHERE e.specialist.id = :specialistId ORDER BY e.requestDate DESC", ExpertiseRequest.class)
                    .setParameter("specialistId", specialistId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<ExpertiseRequest> findBySpecialistIdAndCompleted(Long specialistId, Boolean completed) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT e FROM ExpertiseRequest e WHERE e.specialist.id = :specialistId AND e.completed = :completed ORDER BY e.requestDate DESC", ExpertiseRequest.class)
                    .setParameter("specialistId", specialistId)
                    .setParameter("completed", completed)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<ExpertiseRequest> findByPriority(Priority priority) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT e FROM ExpertiseRequest e WHERE e.priority = :priority ORDER BY e.requestDate DESC", ExpertiseRequest.class)
                    .setParameter("priority", priority)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<ExpertiseRequest> findPendingByGeneralisteId(Long generalisteId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT e FROM ExpertiseRequest e " +
                "LEFT JOIN FETCH e.consultation c " +
                "LEFT JOIN FETCH c.patient " +
                "LEFT JOIN FETCH c.generaliste " +
                "WHERE e.consultation.generaliste.id = :generalisteId " +
                "AND e.completed = false " +
                "ORDER BY e.requestDate DESC", ExpertiseRequest.class)
                .setParameter("generalisteId", generalisteId)
                .getResultList();
        } finally {
            em.close();
        }
    }

    public void update(ExpertiseRequest expertiseRequest) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(expertiseRequest);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating expertise request", e);
        } finally {
            em.close();
        }
    }
}