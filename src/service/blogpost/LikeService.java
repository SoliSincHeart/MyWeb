package service.blogpost;

import dao.blogpost.LikeDao;
import dao.blogpost.PostDao;
import util.JdbcUtil;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * 点赞业务逻辑层。
 */
public class LikeService {
    private LikeDao likeDao = new LikeDao();
    private PostDao postDao = new PostDao();

    /**
     * 点赞操作（需事务保证点赞记录与计数同步）。
     */
    public boolean likePost(Integer userId, Integer postId) throws SQLException {
        //参数校验
        if (userId == null || postId == null) throw new IllegalArgumentException("参数不完整");

        //获取连接并开启事务
        try (Connection conn = JdbcUtil.getConnection()) {
            conn.setAutoCommit(false);

            //检查是否已点赞，避免重复操作
            if (likeDao.existsByUserAndPost(conn, userId, postId)) {
                throw new IllegalStateException("已点赞");
            }

            //插入点赞记录
            boolean inserted = likeDao.insert(conn, userId, postId);

            //同步递增文章点赞数
            if (inserted) {
                postDao.incrementLikes(conn, postId);
            }

            //提交事务
            conn.commit();
            return inserted;
        }
    }

    /**
     * 取消点赞操作（需事务保证点赞记录与计数同步）。
     */
    public boolean unlikePost(Integer userId, Integer postId) throws SQLException {
        //参数校验
        if (userId == null || postId == null) throw new IllegalArgumentException("参数不完整");

        //获取连接并开启事务
        try (Connection conn = JdbcUtil.getConnection()) {
            conn.setAutoCommit(false);

            //检查是否已点赞，防止无效操作
            if (!likeDao.existsByUserAndPost(conn, userId, postId)) {
                throw new IllegalStateException("尚未点赞");
            }

            //删除点赞记录
            boolean deleted = likeDao.deleteByUserAndPost(conn, userId, postId);

            //同步递减文章点赞数
            if (deleted) {
                postDao.decrementLikes(conn, postId);
            }

            //提交事务
            conn.commit();
            return deleted;
        }
    }
}