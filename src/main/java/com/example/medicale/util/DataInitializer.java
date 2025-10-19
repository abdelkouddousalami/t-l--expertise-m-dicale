package com.example.medicale.util;

import com.example.medicale.dao.MedicalActDao;
import com.example.medicale.dao.UserDao;
import com.example.medicale.dao.SpecialistProfileDao;
import com.example.medicale.entity.MedicalAct;
import com.example.medicale.entity.User;
import com.example.medicale.entity.SpecialistProfile;
import com.example.medicale.enums.Role;
import java.math.BigDecimal;
import java.util.Optional;
import java.util.List;

public class DataInitializer {

    public static void initializeData() {
        try {
            initializeMedicalActs();
            initializeDefaultUsers();
            initializeSpecialistProfiles();
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

    private static void initializeSpecialistProfiles() {
        UserDao userDao = new UserDao();
        SpecialistProfileDao specialistProfileDao = new SpecialistProfileDao();

        System.out.println("[DEBUG] Starting specialist profiles initialization...");

        // Get all users with SPECIALISTE role
        List<User> specialistUsers = userDao.findByRole(Role.SPECIALISTE);
        System.out.println("[DEBUG] Found " + specialistUsers.size() + " users with SPECIALISTE role");

        specialistUsers.forEach(specialist -> {
            System.out.println("[DEBUG] Processing specialist: " + specialist.getFullName() + " (ID: " + specialist.getId() + ")");
            // Check if profile already exists
            Optional<SpecialistProfile> existingProfile = specialistProfileDao.findBySpecialistId(specialist.getId());
            
            if (existingProfile.isEmpty()) {
                System.out.println("[DEBUG] Creating profile for: " + specialist.getFullName());
                SpecialistProfile profile = new SpecialistProfile();
                profile.setSpecialist(specialist);
                
                // Set default values based on specialist name or create varied profiles
                if (specialist.getFullName().toLowerCase().contains("cardio") || specialist.getId() % 5 == 1) {
                    profile.setSpeciality("CARDIOLOGIE");
                    profile.setConsultationFee(new BigDecimal("120.00"));
                    profile.setDescription("Spécialiste en cardiologie et maladies cardiovasculaires");
                } else if (specialist.getFullName().toLowerCase().contains("pneumo") || specialist.getId() % 5 == 2) {
                    profile.setSpeciality("PNEUMOLOGIE");
                    profile.setConsultationFee(new BigDecimal("110.00"));
                    profile.setDescription("Spécialiste en pneumologie et maladies respiratoires");
                } else if (specialist.getFullName().toLowerCase().contains("dermato") || specialist.getId() % 5 == 3) {
                    profile.setSpeciality("DERMATOLOGIE");
                    profile.setConsultationFee(new BigDecimal("100.00"));
                    profile.setDescription("Spécialiste en dermatologie et maladies de la peau");
                } else if (specialist.getFullName().toLowerCase().contains("neuro") || specialist.getId() % 5 == 4) {
                    profile.setSpeciality("NEUROLOGIE");
                    profile.setConsultationFee(new BigDecimal("130.00"));
                    profile.setDescription("Spécialiste en neurologie et troubles du système nerveux");
                } else {
                    profile.setSpeciality("CARDIOLOGIE");
                    profile.setConsultationFee(new BigDecimal("115.00"));
                    profile.setDescription("Spécialiste en médecine interne et cardiologie");
                }
                
                profile.setConsultationDuration(30);
                profile.setAvailable(true);

                try {
                    specialistProfileDao.save(profile);
                    System.out.println("[INFO] Profil spécialiste créé pour: " + specialist.getFullName() + " (" + profile.getSpeciality() + ")");
                } catch (Exception e) {
                    System.err.println("[ERREUR] Impossible de créer le profil pour: " + specialist.getFullName());
                    e.printStackTrace();
                }
            }
        });

        // Create additional specialist users if none exist
        if (specialistUsers.isEmpty()) {
            System.out.println("[DEBUG] No existing specialists found, creating additional specialists...");
            createAdditionalSpecialists(userDao, specialistProfileDao);
        } else {
            System.out.println("[DEBUG] Found existing specialists, skipping additional creation");
        }
    }

    private static void createAdditionalSpecialists(UserDao userDao, SpecialistProfileDao specialistProfileDao) {
        String[][] specialists = {
            {"dr.martin", "martin@medical.com", "Dr. Jean Martin", "CARDIOLOGIE", "120.00", "Cardiologue expérimenté, spécialiste des troubles cardiaques"},
            {"dr.durand", "durand@medical.com", "Dr. Marie Durand", "PNEUMOLOGIE", "110.00", "Pneumologue spécialisée dans les maladies respiratoires"},
            {"dr.bernard", "bernard@medical.com", "Dr. Pierre Bernard", "DERMATOLOGIE", "100.00", "Dermatologue expert en maladies de la peau"},
            {"dr.rousseau", "rousseau@medical.com", "Dr. Sophie Rousseau", "NEUROLOGIE", "130.00", "Neurologue spécialisée en troubles neurologiques"},
            {"dr.moreau", "moreau@medical.com", "Dr. Paul Moreau", "ENDOCRINOLOGIE", "115.00", "Endocrinologue expert en diabète et troubles hormonaux"},
            {"dr.simon", "simon@medical.com", "Dr. Claire Simon", "CARDIOLOGIE", "125.00", "Cardiologue interventionnelle"}
        };

        for (String[] specialistData : specialists) {
            try {
                // Create User
                User specialist = new User();
                specialist.setUsername(specialistData[0]);
                specialist.setEmail(specialistData[1]);
                specialist.setFullName(specialistData[2]);
                specialist.setRole(Role.SPECIALISTE);
                specialist.setPasswordHash("specialist123");

                userDao.save(specialist);

                // Create SpecialistProfile
                SpecialistProfile profile = new SpecialistProfile();
                profile.setSpecialist(specialist);
                profile.setSpeciality(specialistData[3]);
                profile.setConsultationFee(new BigDecimal(specialistData[4]));
                profile.setDescription(specialistData[5]);
                profile.setConsultationDuration(30);
                profile.setAvailable(true);

                specialistProfileDao.save(profile);

                System.out.println("[INFO] Spécialiste créé: " + specialist.getFullName() + " (" + profile.getSpeciality() + ")");
            } catch (Exception e) {
                System.err.println("[ERREUR] Impossible de créer le spécialiste: " + specialistData[2]);
                e.printStackTrace();
            }
        }
    }
}