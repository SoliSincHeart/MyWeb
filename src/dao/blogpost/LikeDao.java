package dao.blogpost;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * 点赞数据访问对象，负责 user_post_likes 表的增删查操作。
 * 不负责业务逻辑，仅提供基础的数据库交互方法。
 */
public class LikeDao {

    /**
     * 插入一条点赞记录，表示用户对文章进行了点赞。
     *
     * @param conn   数据库连接
     * @param userId 用户ID
     * @param postId 文章ID
     * @return 是否插入成功
     * @throws SQLException 数据库操作异常
     */
    public boolean insert(Connection conn, Integer userId, Integer postId) throws SQLException {
        String sql = "INSERT INTO user_post_likes (user_id, post_id) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * 删除点赞记录，即取消点赞。
     *
     * @param conn   数据库连接
     * @param userId 用户ID
     * @param postId 文章ID
     * @return 是否成功删除
     * @throws SQLException 数据库操作异常
     */
    public boolean deleteByUserAndPost(Connection conn, Integer userId, Integer postId) throws SQLException {
        String sql = "DELETE FROM user_post_likes WHERE user_id = ? AND post_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * 检查指定用户是否已对某篇文章点赞。
     *
     * @param conn   数据库连接
     * @param userId 用户ID
     * @param postId 文章ID
     * @return true 表示已点赞，false 表示未点赞
     * @throws SQLException 数据库操作异常
     */
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