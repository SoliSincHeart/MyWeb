package service.blogpost;

import bean.blogpost.Comment;
import dao.blogpost.CommentDao;
import dao.blogpost.PostDao;
import util.JdbcUtil;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * 评论业务逻辑层。
 * 负责处理评论的发表与删除，同时维护对应文章的评论计数。
 * 所有写操作均使用数据库事务保证一致性。
 */
public class CommentService {
    private final CommentDao commentDao = new CommentDao();
    private final PostDao postDao = new PostDao();

    /**
     * 发表评论。
     * 在同一个事务中完成：插入评论记录 + 对应文章的评论数 +1。
     *
     * @param postId  文章ID（必填）
     * @param userId  评论者用户ID（必填）
     * @param author  评论者显示名称（必填，不能为空串）
     * @param content 评论内容（必填，不能为空串）
     * @return 新插入评论的自增主键ID
     * @throws IllegalArgumentException 参数为空或不合法
     * @throws SQLException              数据库操作失败（事务已回滚）
     */
    public Integer addComment(Integer postId, Integer userId, String author, String content) throws SQLException {
        // 基础参数校验，避免空指针和无效数据
        if (postId == null || userId == null || author == null || author.trim().isEmpty()
                || content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("参数不能为空");
        }

        Connection conn = null;
        try {
            conn = JdbcUtil.getConnection();
            conn.setAutoCommit(false); // 开启事务

            // 构建评论对象并设置属性
            Comment comment = new Comment();
            comment.setPostId(postId);
            comment.setUserId(userId);
            comment.setAuthor(author.trim());       // 去除首尾空格
            comment.setContent(content.trim());

            // 插入评论，获取自增ID
            Integer id = commentDao.insert(conn, comment);
            // 文章评论数 +1
            postDao.incrementComments(conn, postId);

            conn.commit(); // 提交事务
            return id;
        } catch (Exception e) {
            JdbcUtil.rollbackQuietly(conn); // 出现异常静默回滚
            throw e;                         // 继续向上抛出，由上层处理
        } finally {
            JdbcUtil.close(conn);           // 归还连接
        }
    }

    /**
     * 删除评论。
     * 仅允许评论作者本人或管理员执行删除。事务内完成：校验权限、删除评论、文章评论数 -1。
     *
     * @param commentId     要删除的评论ID（必填）
     * @param currentUserId 当前登录用户ID（必填）
     * @param isAdmin       当前用户是否为管理员
     * @return 删除是否成功（true 表示成功删除）
     * @throws IllegalArgumentException 参数为空或评论不存在
     * @throws SecurityException        无权限删除
     * @throws SQLException              数据库异常（事务已回滚）
     */
    public boolean deleteComment(Integer commentId, Integer currentUserId, boolean isAdmin) throws SQLException {
        if (commentId == null || currentUserId == null) {
            throw new IllegalArgumentException("参数不能为空");
        }

        Connection conn = null;
        try {
            conn = JdbcUtil.getConnection();
            conn.setAutoCommit(false);

            // 查询评论是否存在
            Comment comment = commentDao.findById(conn, commentId);
            if (comment == null) {
                throw new IllegalArgumentException("评论不存在");
            }

            // 权限验证：非作者且非管理员则拒绝
            if (!comment.getUserId().equals(currentUserId) && !isAdmin) {
                throw new SecurityException("无权删除");
            }

            Integer postId = comment.getPostId();
            boolean deleted = commentDao.deleteById(conn, commentId);
            if (deleted) {
                // 评论删除成功，对应文章评论数 -1
                postDao.decrementComments(conn, postId);
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