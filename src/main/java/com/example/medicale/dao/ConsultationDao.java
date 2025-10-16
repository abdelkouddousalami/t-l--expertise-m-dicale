package com.example.medicale.dao;

import com.example.medicale.entity.Consultation;
import com.example.medicale.enums.ConsultationStatus;
import com.example.medicale.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

public class ConsultationDao {

    public void save(Consultation consultation) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(consultation);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving consultation", e);
        } finally {
            em.close();
        }
    }

    public Optional<Consultation> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {

            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c " +
                "LEFT JOIN FETCH c.patient " +
                "LEFT JOIN FETCH c.generaliste " +
                "WHERE c.id = :id",
                Consultation.class
            );
            query.setParameter("id", id);

            List<Consultation> results = query.getResultList();
            return results.isEmpty() ? Optional.empty() : Optional.of(results.get(0));
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByPatientId(Long patientId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT c FROM Consultation c WHERE c.patient.id = :patientId ORDER BY c.consultationDate DESC", Consultation.class)
                    .setParameter("patientId", patientId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByGeneralisteId(Long generalisteId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT c FROM Consultation c " +
                "LEFT JOIN FETCH c.patient " +
                "LEFT JOIN FETCH c.generaliste " +
                "WHERE c.generaliste.id = :generalisteId " +
                "ORDER BY c.consultationDate DESC", Consultation.class)
                    .setParameter("generalisteId", generalisteId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findByStatus(ConsultationStatus status) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT c FROM Consultation c WHERE c.status = :status ORDER BY c.consultationDate DESC", Consultation.class)
                    .setParameter("status", status)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Consultation> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery("SELECT c FROM Consultation c ORDER BY c.consultationDate DESC", Consultation.class).getResultList();
        } finally {
            em.close();
        }
    }

    public void update(Consultation consultation) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(consultation);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating consultation", e);
        } finally {
            em.close();
        }
    }

    public void delete(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Consultation consultation = em.find(Consultation.class, id);
            if (consultation != null) {
                em.remove(consultation);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error deleting consultation", e);
        } finally {
            em.close();
        }
    }
}
