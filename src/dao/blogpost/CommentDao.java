package dao.blogpost;

import bean.blogpost.Comment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 评论数据访问对象，负责 comments 表的所有数据库操作。
 * 所有方法都需要外部传入数据库连接，不负责事务的开启/提交/回滚。
 */
public class CommentDao {

    /**
     * 向数据库插入一条新评论，并返回生成的自增主键ID。
     *
     * @param conn    数据库连接
     * @param comment 要插入的评论对象（postId, userId, author, content 必须有效）
     * @return 新评论的ID，如果插入失败则返回 null
     * @throws SQLException 数据库操作异常
     */
    public Integer insert(Connection conn, Comment comment) throws SQLException {
        String sql = "INSERT INTO comments (post_id, user_id, author, content) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, comment.getPostId());
            ps.setInt(2, comment.getUserId());
            ps.setString(3, comment.getAuthor());
            ps.setString(4, comment.getContent());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return null;
    }

    /**
     * 根据评论ID删除一条评论。
     *
     * @param conn 数据库连接
     * @param id   要删除的评论ID
     * @return 是否成功删除（影响行数 > 0）
     * @throws SQLException 数据库操作异常
     */
    public boolean deleteById(Connection conn, Integer id) throws SQLException {
        String sql = "DELETE FROM comments WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * 根据文章ID查询该文章下的所有评论，按创建时间升序排列（最早的在最前）。
     *
     * @param conn   数据库连接
     * @param postId 文章ID
     * @return 评论列表（可能为空列表）
     * @throws SQLException 数据库操作异常
     */
    public List<Comment> listByPostId(Connection conn, Integer postId) throws SQLException {
        String sql = "SELECT * FROM comments WHERE post_id = ? ORDER BY created_at ASC";
        List<Comment> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Comment c = new Comment();
                    c.setId(rs.getInt("id"));
                    c.setPostId(rs.getInt("post_id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setAuthor(rs.getString("author"));
                    c.setContent(rs.getString("content"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(c);
                }
            }
        }
        return list;
    }

    /**
     * 根据评论ID查询单条评论，不存在则返回 null。
     *
     * @param conn 数据库连接
     * @param id   评论ID
     * @return 评论对象，或 null
     * @throws SQLException 数据库操作异常
     */
    public Comment findById(Connection conn, Integer id) throws SQLException {
        String sql = "SELECT * FROM comments WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Comment c = new Comment();
                    c.setId(rs.getInt("id"));
                    c.setPostId(rs.getInt("post_id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setAuthor(rs.getString("author"));
                    c.setContent(rs.getString("content"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    return c;
                }
            }
        }
        return null;
    }
}