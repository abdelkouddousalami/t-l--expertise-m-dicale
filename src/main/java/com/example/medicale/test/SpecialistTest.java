package com.example.medicale.test;

import com.example.medicale.dao.UserDao;
import com.example.medicale.dao.SpecialistProfileDao;
import com.example.medicale.entity.User;
import com.example.medicale.entity.SpecialistProfile;
import com.example.medicale.enums.Role;
import com.example.medicale.util.DataInitializer;
import java.util.List;

/**
 * Simple test class to verify specialists are created properly
 */
public class SpecialistTest {
    
    public static void main(String[] args) {
        System.out.println("=== Testing Specialist Creation ===");
        
        try {
            // Initialize data
            System.out.println("1. Initializing data...");
            DataInitializer.initializeData();
            
            // Test UserDao
            System.out.println("\n2. Testing UserDao...");
            UserDao userDao = new UserDao();
            List<User> specialistUsers = userDao.findByRole(Role.SPECIALISTE);
            System.out.println("Found " + specialistUsers.size() + " users with SPECIALISTE role:");
            
            for (User user : specialistUsers) {
                System.out.println("- " + user.getFullName() + " (ID: " + user.getId() + ", Username: " + user.getUsername() + ")");
            }
            
            // Test SpecialistProfileDao
            System.out.println("\n3. Testing SpecialistProfileDao...");
            SpecialistProfileDao profileDao = new SpecialistProfileDao();
            List<SpecialistProfile> profiles = profileDao.findAll();
            System.out.println("Found " + profiles.size() + " specialist profiles:");
            
            for (SpecialistProfile profile : profiles) {
                System.out.println("- " + profile.getSpecialist().getFullName() + " - " + profile.getSpeciality() + " (" + profile.getConsultationFee() + "€)");
            }
            
            System.out.println("\n=== Test Completed Successfully ===");
            
        } catch (Exception e) {
            System.err.println("Error during test: " + e.getMessage());
            e.printStackTrace();
        }
    }
}