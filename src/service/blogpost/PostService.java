package service.blogpost;

import bean.blogpost.Comment;
import bean.blogpost.Post;
import dao.blogpost.CommentDao;
import dao.blogpost.LikeDao;
import dao.blogpost.PostDao;
import util.JdbcUtil;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

public class PostService {
    private PostDao postDao = new PostDao();
    private CommentDao commentDao = new CommentDao();
    private LikeDao likeDao = new LikeDao();

    public Integer createPost(Integer authorId, String title, String content) throws SQLException {
        if (authorId == null || title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("参数不完整");
        }
        Post post = new Post();
        post.setAuthorId(authorId);
        post.setTitle(title.trim());
        post.setContent(content);
        try (Connection conn = JdbcUtil.getConnection()) {
            conn.setAutoCommit(false);
            Integer id = postDao.insert(conn, post);
            conn.commit();
            return id;
        }
    }

    public boolean updatePost(Integer postId, String title, String content, Integer currentUserId, boolean isAdmin) throws SQLException {
        try (Connection conn = JdbcUtil.getConnection()) {
            Post exist = postDao.findById(conn, postId);
            if (exist == null) throw new IllegalArgumentException("文章不存在");
            if (!exist.getAuthorId().equals(currentUserId) && !isAdmin) {
                throw new SecurityException("无权限修改");
            }
            Post update = new Post();
            update.setId(postId);
            update.setTitle(title);
            update.setContent(content);
            return postDao.update(conn, update);
        }
    }

    public boolean deletePost(Integer postId, Integer currentUserId, boolean isAdmin) throws SQLException {
        try (Connection conn = JdbcUtil.getConnection()) {
            Post exist = postDao.findById(conn, postId);
            if (exist == null) throw new IllegalArgumentException("文章不存在");
            if (!exist.getAuthorId().equals(currentUserId) && !isAdmin) {
                throw new SecurityException("无权限删除");
            }
            return postDao.deleteById(conn, postId);
        }
    }

    public Post getPostDetail(Integer postId, Integer currentUserId) throws SQLException {
        try (Connection conn = JdbcUtil.getConnection()) {
            Post post = postDao.findById(conn, postId);
            if (post == null) return null;
            postDao.incrementViews(conn, postId);
            List<Comment> comments = commentDao.listByPostId(conn, postId);
            post.setComments(comments);
            if (currentUserId != null) {
                boolean liked = likeDao.existsByUserAndPost(conn, currentUserId, postId);
                post.setLikedByCurrentUser(liked);
            } else {
                post.setLikedByCurrentUser(false);
            }
            return post;
        }
    }

    public List<Post> listPosts(int limit, int offset) throws SQLException {
        try (Connection conn = JdbcUtil.getConnection()) {
            return postDao.listDesc(conn, limit, offset);
        }
    }
}