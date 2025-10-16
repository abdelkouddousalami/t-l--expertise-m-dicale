package com.example.medicale.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;


public class HibernateUtil {

    private static EntityManagerFactory entityManagerFactory;


    static {
        try {

            entityManagerFactory = Persistence.createEntityManagerFactory("default");
            System.out.println("[OK] Hibernate initialise avec succes!");
        } catch (Exception e) {
            System.err.println("[ERREUR] Erreur lors de l'initialisation d'Hibernate: " + e.getMessage());
            e.printStackTrace();
            throw new ExceptionInInitializerError(e);
        }
    }


    public static EntityManager getEntityManager() {
        if (entityManagerFactory == null) {
            throw new IllegalStateException("EntityManagerFactory n'est pas initialise");
        }
        return entityManagerFactory.createEntityManager();
    }


    public static EntityManagerFactory getEntityManagerFactory() {
        return entityManagerFactory;
    }


    public static void shutdown() {
        if (entityManagerFactory != null && entityManagerFactory.isOpen()) {
            entityManagerFactory.close();
            System.out.println("[OK] Hibernate ferme proprement");
        }
    }


    public static void executeInTransaction(TransactionAction action) {
        EntityManager em = getEntityManager();
        try {
            em.getTransaction().begin();
            action.execute(em);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la transaction", e);
        } finally {
            em.close();
        }
    }


    @FunctionalInterface
    public interface TransactionAction {
        void execute(EntityManager em) throws Exception;
    }
}
