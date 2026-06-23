package dao.users;

import bean.users.Users;
import java.sql.*;
import java.time.LocalDateTime;

public class UserDao {

    // 改为接收 Connection，不再自行获取和关闭连接
    public Users findByEmail(Connection conn, String email) throws SQLException {
        String sql = "SELECT id, username, email, password_hash, role, status, created_at, updated_at " +
                "FROM users WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public Users findById(Connection conn, Integer id) throws SQLException {
        String sql = "SELECT id, username, email, password_hash, role, status, created_at, updated_at " +
                "FROM users WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public int insertUser(Connection conn, Users user) throws SQLException {
        String sql = "INSERT INTO users(username, email, password_hash, role, status, created_at, updated_at) " +
                "VALUES(?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
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

    public int updateUser(Connection conn, Users user) throws SQLException {
        String sql = "UPDATE users SET username = ?, email = ?, password_hash = ?, role = ?, status = ?, updated_at = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
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