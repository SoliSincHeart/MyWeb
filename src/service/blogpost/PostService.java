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

/**
 * 文章业务逻辑层。
 */
public class PostService {
    private PostDao postDao = new PostDao();
    private CommentDao commentDao = new CommentDao();
    private LikeDao likeDao = new LikeDao();

    /**
     * 创建新文章。
     */
    public Integer createPost(Integer authorId, String title, String content) throws SQLException {
        //参数校验
        if (authorId == null || title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("参数不完整");
        }

        //构建 Post 对象（计数字段由数据库默认值处理）
        Post post = new Post();
        post.setAuthorId(authorId);
        post.setTitle(title.trim());
        post.setContent(content);

        //获取连接、开启事务并插入
        try (Connection conn = JdbcUtil.getConnection()) {
            conn.setAutoCommit(false);
            Integer id = postDao.insert(conn, post);
            conn.commit();
            return id;
        }
    }

    /**
     * 更新文章（需作者或管理员权限）。
     */
    public boolean updatePost(Integer postId, String title, String content, Integer currentUserId, boolean isAdmin) throws SQLException {
        // 1. 获取连接并查询原文章
        try (Connection conn = JdbcUtil.getConnection()) {
            Post exist = postDao.findById(conn, postId);
            if (exist == null) throw new IllegalArgumentException("文章不存在");

            //权限校验
            if (!exist.getAuthorId().equals(currentUserId) && !isAdmin) {
                throw new SecurityException("无权限修改");
            }

            //执行更新
            Post update = new Post();
            update.setId(postId);
            update.setTitle(title);
            update.setContent(content);
            return postDao.update(conn, update);
        }
    }

    /**
     * 删除文章（需作者或管理员权限）。
     */
    public boolean deletePost(Integer postId, Integer currentUserId, boolean isAdmin) throws SQLException {
        //查询并校验文章存在性
        try (Connection conn = JdbcUtil.getConnection()) {
            Post exist = postDao.findById(conn, postId);
            if (exist == null) throw new IllegalArgumentException("文章不存在");

            //权限校验
            if (!exist.getAuthorId().equals(currentUserId) && !isAdmin) {
                throw new SecurityException("无权限删除");
            }

            //执行删除
            return postDao.deleteById(conn, postId);
        }
    }

    /**
     * 获取文章详情：递增浏览数、加载评论、设置点赞状态。
     */
    public Post getPostDetail(Integer postId, Integer currentUserId) throws SQLException {
        //获取连接并查询基础文章信息
        try (Connection conn = JdbcUtil.getConnection()) {
            Post post = postDao.findById(conn, postId);
            if (post == null) return null;

            //浏览数 +1
            postDao.incrementViews(conn, postId);

            //加载该文章的所有评论
            List<Comment> comments = commentDao.listByPostId(conn, postId);
            post.setComments(comments);

            //如果用户已登录，检查其点赞状态
            if (currentUserId != null) {
                boolean liked = likeDao.existsByUserAndPost(conn, currentUserId, postId);
                post.setLikedByCurrentUser(liked);
            } else {
                post.setLikedByCurrentUser(false);
            }
            return post;
        }
    }

    /**
     * 分页获取文章列表（倒序）。
     */
    public List<Post> listPosts(int limit, int offset) throws SQLException {
        try (Connection conn = JdbcUtil.getConnection()) {
            return postDao.listDesc(conn, limit, offset);
        }
    }
}