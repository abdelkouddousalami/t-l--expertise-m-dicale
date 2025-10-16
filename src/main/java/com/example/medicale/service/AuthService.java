package com.example.medicale.service;

import com.example.medicale.dao.UserDao;
import com.example.medicale.entity.User;
import com.example.medicale.util.BCryptUtil;
import java.util.Optional;

public class AuthService {

    private UserDao userDao;

    public AuthService() {
        this.userDao = new UserDao();
    }

    public Optional<User> authenticate(String username, String password) {
        Optional<User> userOpt = userDao.findByUsername(username);

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (BCryptUtil.checkPassword(password, user.getPasswordHash())) {
                return Optional.of(user);
            }
        }

        return Optional.empty();
    }

    public void register(User user) {
        String hashedPassword = BCryptUtil.hashPassword(user.getPasswordHash());
        user.setPasswordHash(hashedPassword);
        userDao.save(user);
    }
}
