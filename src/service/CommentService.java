package service;

import bean.Comment;
import bean.Users;
import dao.CommentDao;
import dao.PostDao;
import util.JdbcUtil;
import util.LoginManager;

import javax.servlet.http.HttpServletRequest;
import java.sql.Connection;
import java.sql.SQLException;

public class CommentService {

    private CommentDao commentDao = new CommentDao();
    private PostDao postDao = new PostDao();

    public Integer addComment(Integer postId, Integer userId, String author, String content) throws SQLException {
        if (postId == null || userId == null || author == null || author.trim().isEmpty() ||
                content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("参数不完整");
        }
        try (Connection conn = JdbcUtil.getConnection()) {
            conn.setAutoCommit(false);
            // 检查文章是否存在（略）
            Comment comment = new Comment();
            comment.setPostId(postId);
            comment.setUserId(userId);
            comment.setAuthor(author.trim());
            comment.setContent(content.trim());
            Integer id = commentDao.insert(conn, comment);
            // 更新文章评论数
            postDao.incrementComments(conn, postId);
            conn.commit();
            return id;
        }
    }

    public boolean deleteComment(Integer commentId, Integer currentUserId, boolean isAdmin) throws SQLException {
        try (Connection conn = JdbcUtil.getConnection()) {
            Comment comment = commentDao.findById(conn, commentId);
            if (comment == null) throw new IllegalArgumentException("评论不存在");
            if (!comment.getUserId().equals(currentUserId) && !isAdmin) {
                throw new SecurityException("无权限删除");
            }
            Integer postId = comment.getPostId();
            boolean deleted = commentDao.deleteById(conn, commentId);
            if (deleted) {
                postDao.decrementComments(conn, postId);
            }
            return deleted;
        }
    }
}