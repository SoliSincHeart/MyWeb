package service.blogpost;

import bean.blogpost.Comment;
import dao.blogpost.CommentDao;
import dao.blogpost.PostDao;
import util.JdbcUtil;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * 评论业务逻辑层。
 */
public class CommentService {
    private CommentDao commentDao = new CommentDao();
    private PostDao postDao = new PostDao();

    /**
     * 发表评论并同步更新文章评论计数。
     */
    public Integer addComment(Integer postId, Integer userId, String author, String content) throws SQLException {
        //参数非空校验
        if (postId == null || userId == null || author == null || author.trim().isEmpty() ||
                content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("参数不完整");
        }

        //获取连接并开启事务
        try (Connection conn = JdbcUtil.getConnection()) {
            conn.setAutoCommit(false);

            //构建评论对象并插入
            Comment comment = new Comment();
            comment.setPostId(postId);
            comment.setUserId(userId);
            comment.setAuthor(author.trim());
            comment.setContent(content.trim());
            Integer id = commentDao.insert(conn, comment);

            //同步更新文章的评论计数
            postDao.incrementComments(conn, postId);

            //提交事务
            conn.commit();
            return id;
        } //连接自动关闭，异常由调用方处理
    }

    /**
     * 删除评论（需本人或管理员权限），同步更新评论计数。
     */
    public boolean deleteComment(Integer commentId, Integer currentUserId, boolean isAdmin) throws SQLException {
        //获取连接（未显式事务，生产环境建议开启）
        try (Connection conn = JdbcUtil.getConnection()) {
            //查询评论并校验存在性
            Comment comment = commentDao.findById(conn, commentId);
            if (comment == null) throw new IllegalArgumentException("评论不存在");

            //权限检查：必须为评论者本人或管理员
            if (!comment.getUserId().equals(currentUserId) && !isAdmin) {
                throw new SecurityException("无权限删除");
            }

            //删除评论
            Integer postId = comment.getPostId();
            boolean deleted = commentDao.deleteById(conn, commentId);

            //同步递减文章的评论计数
            if (deleted) {
                postDao.decrementComments(conn, postId);
            }
            return deleted;
        }
    }
}