package service.blogpost;

import bean.blogpost.Comment;
import dao.blogpost.CommentDao;
import dao.blogpost.PostDao;
import util.JdbcUtil;

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
            Comment comment = new Comment();
            comment.setPostId(postId);
            comment.setUserId(userId);
            comment.setAuthor(author.trim());
            comment.setContent(content.trim());
            Integer id = commentDao.insert(conn, comment);
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