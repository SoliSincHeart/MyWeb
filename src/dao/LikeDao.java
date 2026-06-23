package dao;

import util.JdbcUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LikeDao {

    public boolean insert(Connection conn, Integer userId, Integer postId) throws SQLException {
        String sql = "INSERT INTO user_post_likes (user_id, post_id) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteByUserAndPost(Connection conn, Integer userId, Integer postId) throws SQLException {
        String sql = "DELETE FROM user_post_likes WHERE user_id = ? AND post_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean existsByUserAndPost(Connection conn, Integer userId, Integer postId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM user_post_likes WHERE user_id = ? AND post_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        }
        return false;
    }
}