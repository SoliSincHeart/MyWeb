package service;

import bean.Users;
import dao.UserDao;

import java.time.LocalDateTime;

public class UserService {

    private final UserDao userDao = new UserDao();

    public Users login(String email, String password) {
        Users user = userDao.findByEmail(email);
        if (user == null) {
            return null;
        }

        if (!password.equals(user.getPasswordHash())) {
            return null;
        }

        if (user.isDisabled()) {
            return null;
        }

        return user;
    }

    public boolean register(String username, String email, String password) {
        if (checkEmailExists(email)) {
            return false;
        }

        Users user = new Users();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(password);
        user.setRole("user");
        user.setStatus(1);
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());

        return userDao.insertUser(user) > 0;
    }

    public boolean checkEmailExists(String email) {
        return userDao.findByEmail(email) != null;
    }
}