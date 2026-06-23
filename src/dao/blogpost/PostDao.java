package dao.blogpost;

import bean.blogpost.Post;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDao {
    public Integer insert(Connection conn, Post post) throws SQLException {
        String sql = "INSERT INTO posts (title, content, author_id) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getContent());
            ps.setInt(3, post.getAuthorId());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return null;
    }

    public boolean update(Connection conn, Post post) throws SQLException {
        String sql = "UPDATE posts SET title=?, content=?, updated_at=NOW() WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getContent());
            ps.setInt(3, post.getId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean deleteById(Connection conn, Integer id) throws SQLException {
        String sql = "DELETE FROM posts WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public Post findById(Connection conn, Integer id) throws SQLException {
        String sql = "SELECT p.*, u.username AS author_name FROM posts p " +
                "LEFT JOIN users u ON p.author_id = u.id WHERE p.id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    public List<Post> listDesc(Connection conn, int limit, int offset) throws SQLException {
        String sql = "SELECT p.*, u.username AS author_name FROM posts p " +
                "LEFT JOIN users u ON p.author_id = u.id " +
                "ORDER BY p.created_at DESC LIMIT ? OFFSET ?";
        List<Post> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public void incrementViews(Connection conn, Integer postId) throws SQLException {
        String sql = "UPDATE posts SET views_count = views_count + 1 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        }
    }

    public void incrementLikes(Connection conn, Integer postId) throws SQLException {
        String sql = "UPDATE posts SET likes_count = likes_count + 1 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        }
    }

    public void decrementLikes(Connection conn, Integer postId) throws SQLException {
        String sql = "UPDATE posts SET likes_count = likes_count - 1 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        }
    }

    public void incrementComments(Connection conn, Integer postId) throws SQLException {
        String sql = "UPDATE posts SET comments_count = comments_count + 1 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        }
    }

    public void decrementComments(Connection conn, Integer postId) throws SQLException {
        String sql = "UPDATE posts SET comments_count = comments_count - 1 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        }
    }

    private Post mapRow(ResultSet rs) throws SQLException {
        Post p = new Post();
        p.setId(rs.getInt("id"));
        p.setTitle(rs.getString("title"));
        p.setContent(rs.getString("content"));
        p.setAuthorId(rs.getInt("author_id"));
        p.setLikesCount(rs.getInt("likes_count"));
        p.setViewsCount(rs.getInt("views_count"));
        p.setCommentsCount(rs.getInt("comments_count"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        p.setAuthorName(rs.getString("author_name"));
        return p;
    }
}