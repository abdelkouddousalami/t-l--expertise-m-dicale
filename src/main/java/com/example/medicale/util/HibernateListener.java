package com.example.medicale.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class HibernateListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("[DEMARRAGE] Initialisation d'Hibernate...");


        HibernateUtil.getEntityManager().close();

        System.out.println("[OK] Hibernate pret!");
        System.out.println("[INFO] Les tables ont ete creees automatiquement par Hibernate");


        try {
            DataInitializer.initializeData();
        } catch (Exception e) {
            System.err.println("[ERREUR] Erreur lors de l'initialisation des donnees");
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("[ARRET] Fermeture d'Hibernate...");
        HibernateUtil.shutdown();
        System.out.println("[OK] Hibernate ferme proprement");
    }
}
