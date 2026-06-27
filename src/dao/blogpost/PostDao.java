package dao.blogpost;

import bean.blogpost.Post;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 文章数据访问对象，负责 posts 表的增删改查以及计数字段的原子更新。
 * 所有方法均接收外部 Connection，调用方需要自行管理事务。
 */
public class PostDao {

    /**
     * 新增文章，返回数据库自动生成的文章ID。
     *
     * @param conn 数据库连接
     * @param post 包含标题、内容和作者ID的文章对象
     * @return 新文章的ID，失败返回 null
     * @throws SQLException 数据库操作异常
     */
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

    /**
     * 更新文章的标题和内容，并自动将 updated_at 更新为当前时间。
     *
     * @param conn 数据库连接
     * @param post 包含文章ID、新标题和新内容的对象
     * @return 是否更新成功
     * @throws SQLException 数据库操作异常
     */
    public boolean update(Connection conn, Post post) throws SQLException {
        String sql = "UPDATE posts SET title=?, content=?, updated_at=NOW() WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getContent());
            ps.setInt(3, post.getId());
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * 根据ID删除文章。
     *
     * @param conn 数据库连接
     * @param id   文章ID
     * @return 是否删除成功
     * @throws SQLException 数据库操作异常
     */
    public boolean deleteById(Connection conn, Integer id) throws SQLException {
        String sql = "DELETE FROM posts WHERE id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * 根据文章ID查询文章详细信息，包括通过 LEFT JOIN users 获取作者用户名。
     *
     * @param conn 数据库连接
     * @param id   文章ID
     * @return 文章对象，包含 authorName 字段；未找到则返回 null
     * @throws SQLException 数据库操作异常
     */
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

    /**
     * 分页查询文章列表，按创建时间倒序（最新在前），同时查询作者用户名。
     *
     * @param conn   数据库连接
     * @param limit  每页记录数
     * @param offset 偏移量（从0开始）
     * @return 文章列表
     * @throws SQLException 数据库操作异常
     */
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

    /**
     * 将指定文章的浏览数加一。通常在查看文章详情时调用，无需事务保护，可单独提交。
     */
    public void incrementViews(Connection conn, Integer postId) throws SQLException {
        String sql = "UPDATE posts SET views_count = views_count + 1 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        }
    }

    /**
     * 将指定文章的点赞数加一。需在点赞事务中与插入点赞记录保持一致性。
     */
    public void incrementLikes(Connection conn, Integer postId) throws SQLException {
        String sql = "UPDATE posts SET likes_count = likes_count + 1 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        }
    }

    /**
     * 将指定文章的点赞数减一（不小于0）。需在取消点赞事务中与删除点赞记录保持一致性。
     */
    public void decrementLikes(Connection conn, Integer postId) throws SQLException {
        String sql = "UPDATE posts SET likes_count = likes_count - 1 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        }
    }

    /**
     * 评论数加一，在新评论插入事务中调用。
     */
    public void incrementComments(Connection conn, Integer postId) throws SQLException {
        String sql = "UPDATE posts SET comments_count = comments_count + 1 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        }
    }

    /**
     * 评论数减一，在删除评论事务中调用。
     */
    public void decrementComments(Connection conn, Integer postId) throws SQLException {
        String sql = "UPDATE posts SET comments_count = comments_count - 1 WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        }
    }

    /**
     * 将 ResultSet 的当前行映射为 Post 对象，避免重复代码。
     */
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