package service.blogpost;

import dao.blogpost.LikeDao;
import dao.blogpost.PostDao;
import util.JdbcUtil;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * 点赞业务逻辑层。
 * 负责处理点赞与取消点赞，同步更新文章的点赞计数。
 * 所有写操作均在事务中完成，避免计数错误。
 */
public class LikeService {
    private final LikeDao likeDao = new LikeDao();
    private final PostDao postDao = new PostDao();

    /**
     * 点赞文章。
     * 检查重复点赞，写入点赞记录并增加文章点赞数。
     *
     * @param userId 点赞用户ID（必填）
     * @param postId 文章ID（必填）
     * @return 是否成功（true 表示本次操作成功插入了点赞记录）
     * @throws IllegalArgumentException 参数为空
     * @throws IllegalStateException   已点过赞（重复操作）
     * @throws SQLException              数据库异常（事务回滚）
     */
    public boolean likePost(Integer userId, Integer postId) throws SQLException {
        if (userId == null || postId == null) {
            throw new IllegalArgumentException("参数不能为空");
        }

        Connection conn = null;
        try {
            conn = JdbcUtil.getConnection();
            conn.setAutoCommit(false);

            // 检查是否已点赞，防止重复数据
            if (likeDao.existsByUserAndPost(conn, userId, postId)) {
                throw new IllegalStateException("已点赞");
            }

            // 插入点赞记录
            boolean inserted = likeDao.insert(conn, userId, postId);
            if (inserted) {
                // 文章点赞数 +1
                postDao.incrementLikes(conn, postId);
            }

            conn.commit();
            return inserted;
        } catch (Exception e) {
            JdbcUtil.rollbackQuietly(conn);
            throw e;
        } finally {
            JdbcUtil.close(conn);
        }
    }

    /**
     * 取消点赞。
     * 验证是否已点赞，删除点赞记录并减少文章点赞数。
     *
     * @param userId 用户ID（必填）
     * @param postId 文章ID（必填）
     * @return 是否成功（true 表示成功删除点赞记录）
     * @throws IllegalArgumentException 参数为空
     * @throws IllegalStateException   尚未点赞，无法取消
     * @throws SQLException              数据库异常（事务回滚）
     */
    public boolean unlikePost(Integer userId, Integer postId) throws SQLException {
        if (userId == null || postId == null) {
            throw new IllegalArgumentException("参数不能为空");
        }

        Connection conn = null;
        try {
            conn = JdbcUtil.getConnection();
            conn.setAutoCommit(false);

            // 确认存在点赞记录才允许取消
            if (!likeDao.existsByUserAndPost(conn, userId, postId)) {
                throw new IllegalStateException("尚未点赞");
            }

            boolean deleted = likeDao.deleteByUserAndPost(conn, userId, postId);
            if (deleted) {
                postDao.decrementLikes(conn, postId);
            }

            conn.commit();
            return deleted;
        } catch (Exception e) {
            JdbcUtil.rollbackQuietly(conn);
            throw e;
        } finally {
            JdbcUtil.close(conn);
        }
    }
}