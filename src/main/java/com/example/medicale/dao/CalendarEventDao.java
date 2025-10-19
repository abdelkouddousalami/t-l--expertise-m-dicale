package com.example.medicale.dao;

import com.example.medicale.entity.CalendarEvent;
import com.example.medicale.entity.CalendarEvent.EventType;
import com.example.medicale.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class CalendarEventDao {

    public void save(CalendarEvent event) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(event);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving calendar event", e);
        } finally {
            em.close();
        }
    }

    public void saveAll(List<CalendarEvent> events) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            for (CalendarEvent event : events) {
                em.persist(event);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error saving calendar events", e);
        } finally {
            em.close();
        }
    }

    public Optional<CalendarEvent> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            CalendarEvent event = em.find(CalendarEvent.class, id);
            return Optional.ofNullable(event);
        } finally {
            em.close();
        }
    }

    public List<CalendarEvent> findBySpecialistId(Long specialistId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT e FROM CalendarEvent e WHERE e.specialist.id = :specialistId ORDER BY e.startTime", 
                CalendarEvent.class)
                .setParameter("specialistId", specialistId)
                .getResultList();
        } finally {
            em.close();
        }
    }

    public List<CalendarEvent> findBySpecialistIdAndDateRange(Long specialistId, LocalDateTime startDate, LocalDateTime endDate) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT e FROM CalendarEvent e WHERE e.specialist.id = :specialistId " +
                "AND e.startTime >= :startDate AND e.endTime <= :endDate ORDER BY e.startTime", 
                CalendarEvent.class)
                .setParameter("specialistId", specialistId)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .getResultList();
        } finally {
            em.close();
        }
    }

    public List<CalendarEvent> findBySpecialistIdAndDate(Long specialistId, LocalDate date) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            LocalDateTime startOfDay = date.atStartOfDay();
            LocalDateTime endOfDay = date.atTime(23, 59, 59);
            
            return em.createQuery(
                "SELECT e FROM CalendarEvent e WHERE e.specialist.id = :specialistId " +
                "AND e.startTime >= :startOfDay AND e.startTime <= :endOfDay ORDER BY e.startTime", 
                CalendarEvent.class)
                .setParameter("specialistId", specialistId)
                .setParameter("startOfDay", startOfDay)
                .setParameter("endOfDay", endOfDay)
                .getResultList();
        } finally {
            em.close();
        }
    }

    public List<CalendarEvent> findBySpecialistIdAndEventType(Long specialistId, EventType eventType) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT e FROM CalendarEvent e WHERE e.specialist.id = :specialistId " +
                "AND e.eventType = :eventType ORDER BY e.startTime", 
                CalendarEvent.class)
                .setParameter("specialistId", specialistId)
                .setParameter("eventType", eventType)
                .getResultList();
        } finally {
            em.close();
        }
    }

    public List<CalendarEvent> findUpcomingEventsBySpecialistId(Long specialistId, int limit) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            LocalDateTime now = LocalDateTime.now();
            return em.createQuery(
                "SELECT e FROM CalendarEvent e WHERE e.specialist.id = :specialistId " +
                "AND e.startTime > :now ORDER BY e.startTime", 
                CalendarEvent.class)
                .setParameter("specialistId", specialistId)
                .setParameter("now", now)
                .setMaxResults(limit)
                .getResultList();
        } finally {
            em.close();
        }
    }

    public List<CalendarEvent> findTodayEventsBySpecialistId(Long specialistId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            LocalDate today = LocalDate.now();
            LocalDateTime startOfDay = today.atStartOfDay();
            LocalDateTime endOfDay = today.atTime(23, 59, 59);
            
            return em.createQuery(
                "SELECT e FROM CalendarEvent e WHERE e.specialist.id = :specialistId " +
                "AND e.startTime >= :startOfDay AND e.startTime <= :endOfDay ORDER BY e.startTime", 
                CalendarEvent.class)
                .setParameter("specialistId", specialistId)
                .setParameter("startOfDay", startOfDay)
                .setParameter("endOfDay", endOfDay)
                .getResultList();
        } finally {
            em.close();
        }
    }

    public List<CalendarEvent> findConflictingEvents(Long specialistId, LocalDateTime startTime, LocalDateTime endTime, Long excludeEventId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            String query = "SELECT e FROM CalendarEvent e WHERE e.specialist.id = :specialistId " +
                          "AND ((e.startTime <= :startTime AND e.endTime > :startTime) " +
                          "OR (e.startTime < :endTime AND e.endTime >= :endTime) " +
                          "OR (e.startTime >= :startTime AND e.endTime <= :endTime))";
            
            if (excludeEventId != null) {
                query += " AND e.id != :excludeEventId";
            }
            
            TypedQuery<CalendarEvent> typedQuery = em.createQuery(query, CalendarEvent.class)
                .setParameter("specialistId", specialistId)
                .setParameter("startTime", startTime)
                .setParameter("endTime", endTime);
            
            if (excludeEventId != null) {
                typedQuery.setParameter("excludeEventId", excludeEventId);
            }
            
            return typedQuery.getResultList();
        } finally {
            em.close();
        }
    }

    public void update(CalendarEvent event) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(event);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error updating calendar event", e);
        } finally {
            em.close();
        }
    }

    public void delete(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            CalendarEvent event = em.find(CalendarEvent.class, id);
            if (event != null) {
                em.remove(event);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Error deleting calendar event", e);
        } finally {
            em.close();
        }
    }

    public long countEventsBySpecialistAndDateRange(Long specialistId, LocalDateTime startDate, LocalDateTime endDate) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT COUNT(e) FROM CalendarEvent e WHERE e.specialist.id = :specialistId " +
                "AND e.startTime >= :startDate AND e.endTime <= :endDate", 
                Long.class)
                .setParameter("specialistId", specialistId)
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate)
                .getSingleResult();
        } finally {
            em.close();
        }
    }

    public long countEventsBySpecialistAndEventType(Long specialistId, EventType eventType) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT COUNT(e) FROM CalendarEvent e WHERE e.specialist.id = :specialistId " +
                "AND e.eventType = :eventType", 
                Long.class)
                .setParameter("specialistId", specialistId)
                .setParameter("eventType", eventType)
                .getSingleResult();
        } finally {
            em.close();
        }
    }
}