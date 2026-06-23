package service;

import dao.LikeDao;
import dao.PostDao;
import util.JdbcUtil;

import java.sql.Connection;
import java.sql.SQLException;

public class LikeService {

    private LikeDao likeDao = new LikeDao();
    private PostDao postDao = new PostDao();

    public boolean likePost(Integer userId, Integer postId) throws SQLException {
        if (userId == null || postId == null) throw new IllegalArgumentException("参数不完整");
        try (Connection conn = JdbcUtil.getConnection()) {
            conn.setAutoCommit(false);
            // 检查是否已点赞
            if (likeDao.existsByUserAndPost(conn, userId, postId)) {
                throw new IllegalStateException("已点赞");
            }
            boolean inserted = likeDao.insert(conn, userId, postId);
            if (inserted) {
                postDao.incrementLikes(conn, postId);
            }
            conn.commit();
            return inserted;
        }
    }

    public boolean unlikePost(Integer userId, Integer postId) throws SQLException {
        if (userId == null || postId == null) throw new IllegalArgumentException("参数不完整");
        try (Connection conn = JdbcUtil.getConnection()) {
            conn.setAutoCommit(false);
            if (!likeDao.existsByUserAndPost(conn, userId, postId)) {
                throw new IllegalStateException("尚未点赞");
            }
            boolean deleted = likeDao.deleteByUserAndPost(conn, userId, postId);
            if (deleted) {
                postDao.decrementLikes(conn, postId);
            }
            conn.commit();
            return deleted;
        }
    }
}