package com.example.medicale.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class BCryptUtil {

    private static final int SALT_LENGTH = 16;
    private static final SecureRandom random = new SecureRandom();

    public static String hashPassword(String plainPassword) {
        try {

            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);


            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashedPassword = md.digest(plainPassword.getBytes(StandardCharsets.UTF_8));


            byte[] combined = new byte[salt.length + hashedPassword.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hashedPassword, 0, combined, salt.length, hashedPassword.length);


            return Base64.getEncoder().encodeToString(combined);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        try {

            byte[] combined = Base64.getDecoder().decode(hashedPassword);


            byte[] salt = new byte[SALT_LENGTH];
            System.arraycopy(combined, 0, salt, 0, SALT_LENGTH);


            byte[] hash = new byte[combined.length - SALT_LENGTH];
            System.arraycopy(combined, SALT_LENGTH, hash, 0, hash.length);


            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] testHash = md.digest(plainPassword.getBytes(StandardCharsets.UTF_8));


            return MessageDigest.isEqual(hash, testHash);
        } catch (Exception e) {
            return false;
        }
    }
}
