package service.users;

import bean.users.Users;
import dao.users.UserDao;
import util.JdbcUtil;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;

public class UserService {
    private final UserDao userDao = new UserDao();

    public Users login(String email, String password) {
        // 使用一个连接完成查找操作
        try (Connection conn = JdbcUtil.getConnection()) {
            Users user = userDao.findByEmail(conn, email);
            if (user == null) return null;
            if (!password.equals(user.getPasswordHash())) return null;
            if (user.isDisabled()) return null;
            return user;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean register(String username, String email, String password) {
        try (Connection conn = JdbcUtil.getConnection()) {
            // 检查邮箱是否已存在
            if (userDao.findByEmail(conn, email) != null) {
                return false;
            }
            Users user = new Users();
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(password);   // 实际项目中此处应进行哈希处理
            user.setRole("user");
            user.setStatus(1);
            user.setCreatedAt(LocalDateTime.now());
            user.setUpdatedAt(LocalDateTime.now());
            return userDao.insertUser(conn, user) > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean checkEmailExists(String email) {
        try (Connection conn = JdbcUtil.getConnection()) {
            return userDao.findByEmail(conn, email) != null;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}