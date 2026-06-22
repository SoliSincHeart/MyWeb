package service;

import bean.Users;
import dao.UserDao;

import java.sql.SQLException;
import java.time.LocalDateTime;

public class UserService {

    private final UserDao userDao = new UserDao();

    public Users login(String email, String password) {
        try {
            Users user = userDao.findByEmail(email);
            if (user == null) return null;
            if (!password.equals(user.getPasswordHash())) return null;
            if (user.isDisabled()) return null;
            return user;
        } catch (SQLException e) {
            // 生产环境应记录日志
            e.printStackTrace();
            return null;
        }
    }

    public boolean register(String username, String email, String password) {
        try {
            if (userDao.findByEmail(email) != null) return false;
            Users user = new Users();
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(password);
            user.setRole("user");
            user.setStatus(1);
            user.setCreatedAt(LocalDateTime.now());
            user.setUpdatedAt(LocalDateTime.now());
            return userDao.insertUser(user) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean checkEmailExists(String email) {
        try {
            return userDao.findByEmail(email) != null;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}