
//CREATE TABLE `users` (
//        `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
//        `username` VARCHAR(50) NOT NULL COMMENT '用户名',
//        `email` VARCHAR(100) NOT NULL COMMENT '邮箱（用于登录）',
//        `password_hash` VARCHAR(255) NOT NULL COMMENT '密码哈希',
//        `role` ENUM('admin', 'user') NOT NULL DEFAULT 'user' COMMENT '角色：admin-管理员，user-普通注册用户',
//        `status` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '状态：1-正常，0-禁用（禁用的用户不能评论）',
//        `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
//        `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
//        PRIMARY KEY (`id`),
//        UNIQUE KEY `uk_email` (`email`),
//        UNIQUE KEY `uk_username` (`username`)
//        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='博客用户表';

package dao;

import bean.Users;
import util.JdbcUtil;

import java.sql.*;
import java.time.LocalDateTime;

public class UserDao {

    public Users findByEmail(String email) throws SQLException {
        String sql = "SELECT id, username, email, password_hash, role, status, created_at, updated_at " +
                "FROM users WHERE email = ?";
        try (Connection conn = JdbcUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
                return null;
            }
        }
    }

    public Users findById(Integer id) throws SQLException {
        String sql = "SELECT id, username, email, password_hash, role, status, created_at, updated_at " +
                "FROM users WHERE id = ?";
        try (Connection conn = JdbcUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
                return null;
            }
        }
    }

    public int insertUser(Users user) throws SQLException {
        String sql = "INSERT INTO users(username, email, password_hash, role, status, created_at, updated_at) " +
                "VALUES(?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = JdbcUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole());
            ps.setInt(5, user.getStatus());
            LocalDateTime now = LocalDateTime.now();
            ps.setTimestamp(6, Timestamp.valueOf(user.getCreatedAt() != null ? user.getCreatedAt() : now));
            ps.setTimestamp(7, Timestamp.valueOf(user.getUpdatedAt() != null ? user.getUpdatedAt() : now));
            return ps.executeUpdate();
        }
    }

    public int updateUser(Users user) throws SQLException {
        String sql = "UPDATE users SET username = ?, email = ?, password_hash = ?, role = ?, status = ?, updated_at = ? WHERE id = ?";
        try (Connection conn = JdbcUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole());
            ps.setInt(5, user.getStatus());
            ps.setTimestamp(6, Timestamp.valueOf(user.getUpdatedAt() != null ? user.getUpdatedAt() : LocalDateTime.now()));
            ps.setInt(7, user.getId());
            return ps.executeUpdate();
        }
    }

    private Users mapRow(ResultSet rs) throws SQLException {
        Users user = new Users();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setRole(rs.getString("role"));
        user.setStatus(rs.getInt("status"));
        Timestamp createdAt = rs.getTimestamp("created_at");
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        if (createdAt != null) user.setCreatedAt(createdAt.toLocalDateTime());
        if (updatedAt != null) user.setUpdatedAt(updatedAt.toLocalDateTime());
        return user;
    }
}