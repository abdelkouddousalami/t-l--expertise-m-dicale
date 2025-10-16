package com.example.medicale.util;

import com.example.medicale.dao.MedicalActDao;
import com.example.medicale.dao.UserDao;
import com.example.medicale.entity.MedicalAct;
import com.example.medicale.entity.User;
import com.example.medicale.enums.Role;
import java.math.BigDecimal;
import java.util.Optional;

public class DataInitializer {

    public static void initializeData() {
        try {
            initializeMedicalActs();
            initializeDefaultUsers();
            System.out.println("[OK] Données de base initialisées avec succès");
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Erreur lors de l'initialisation des données", e);
        }
    }

    private static void initializeMedicalActs() {
        MedicalActDao medicalActDao = new MedicalActDao();


        if (!medicalActDao.findAll().isEmpty()) {
            System.out.println("[INFO] Les actes médicaux existent déjà");
            return;
        }


        String[][] acts = {
            {"Consultation générale", "Consultation générale de base", "50.00", "Consultation"},
            {"Consultation spécialisée", "Consultation avec un spécialiste", "80.00", "Consultation"},
            {"Prise de tension", "Mesure de la tension artérielle", "15.00", "Examen"},
            {"Electrocardiogramme", "ECG standard", "25.00", "Examen"},
            {"Prise de sang", "Prélèvement sanguin", "20.00", "Analyse"},
            {"Radiographie", "Radiographie standard", "35.00", "Imagerie"},
            {"Echographie", "Echographie standard", "45.00", "Imagerie"}
        };

        for (String[] actData : acts) {
            try {
                MedicalAct act = new MedicalAct();
                act.setName(actData[0]);
                act.setDescription(actData[1]);
                act.setCost(new BigDecimal(actData[2]));
                act.setCategory(actData[3]);

                medicalActDao.save(act);
                System.out.println("[INFO] Acte médical ajouté: " + act.getName());
            } catch (Exception e) {
                System.err.println("[ERREUR] Impossible d'ajouter l'acte médical: " + actData[0]);
            }
        }
    }

    private static void initializeDefaultUsers() {
        UserDao userDao = new UserDao();


        Optional<User> adminOpt = userDao.findByUsername("admin");
        if (adminOpt.isEmpty()) {
            User admin = new User();
            admin.setUsername("admin");
            admin.setEmail("admin@medical.com");
            admin.setFullName("Admin System");
            admin.setRole(Role.GENERALISTE);
            admin.setPasswordHash("admin123");

            try {
                userDao.save(admin);
                System.out.println("[INFO] Utilisateur admin créé avec succès");
            } catch (Exception e) {
                System.err.println("[ERREUR] Impossible de créer l'utilisateur admin");
            }
        }


        Optional<User> nurseOpt = userDao.findByUsername("nurse");
        if (nurseOpt.isEmpty()) {
            User nurse = new User();
            nurse.setUsername("nurse");
            nurse.setEmail("nurse@medical.com");
            nurse.setFullName("Infirmier Test");
            nurse.setRole(Role.INFIRMIER);
            nurse.setPasswordHash("nurse123");

            try {
                userDao.save(nurse);
                System.out.println("[INFO] Utilisateur infirmier créé avec succès");
            } catch (Exception e) {
                System.err.println("[ERREUR] Impossible de créer l'utilisateur infirmier");
            }
        }


        Optional<User> specialistOpt = userDao.findByUsername("specialist");
        if (specialistOpt.isEmpty()) {
            User specialist = new User();
            specialist.setUsername("specialist");
            specialist.setEmail("specialist@medical.com");
            specialist.setFullName("Specialiste Test");
            specialist.setRole(Role.SPECIALISTE);
            specialist.setPasswordHash("specialist123");

            try {
                userDao.save(specialist);
                System.out.println("[INFO] Utilisateur spécialiste créé avec succès");
            } catch (Exception e) {
                System.err.println("[ERREUR] Impossible de créer l'utilisateur spécialiste");
            }
        }
    }
}