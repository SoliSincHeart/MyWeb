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
 * 提供文章的增删改查功能，以及详情页所需的浏览计数、评论列表和当前用户点赞状态加载。
 */
public class PostService {
    private final PostDao postDao = new PostDao();
    private final CommentDao commentDao = new CommentDao();
    private final LikeDao likeDao = new LikeDao();

    /**
     * 创建新文章。
     *
     * @param authorId 作者用户ID（必填）
     * @param title    文章标题（必填，非空）
     * @param content  文章内容（必填，非空）
     * @return 新文章的自增ID
     * @throws IllegalArgumentException 参数非法
     * @throws SQLException              数据库异常（事务回滚）
     */
    public Integer createPost(Integer authorId, String title, String content) throws SQLException {
        if (authorId == null || title == null || title.trim().isEmpty()
                || content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("参数不能为空");
        }

        Connection conn = null;
        try {
            conn = JdbcUtil.getConnection();
            conn.setAutoCommit(false);

            Post post = new Post();
            post.setAuthorId(authorId);
            post.setTitle(title.trim());
            post.setContent(content);  // 内容保留原有格式，可能包含HTML等，不做trim

            Integer id = postDao.insert(conn, post);
            conn.commit();
            return id;
        } catch (Exception e) {
            JdbcUtil.rollbackQuietly(conn);
            throw e;
        } finally {
            JdbcUtil.close(conn);
        }
    }

    /**
     * 更新文章（仅作者或管理员可操作）。
     *
     * @param postId        文章ID
     * @param title         新标题
     * @param content       新内容
     * @param currentUserId 当前登录用户ID
     * @param isAdmin       是否管理员
     * @return 更新是否成功
     * @throws IllegalArgumentException 参数为空或文章不存在
     * @throws SecurityException        无权限
     * @throws SQLException              数据库异常
     */
    public boolean updatePost(Integer postId, String title, String content,
                              Integer currentUserId, boolean isAdmin) throws SQLException {
        if (postId == null || currentUserId == null || title == null || title.trim().isEmpty()
                || content == null || content.trim().isEmpty()) {
            throw new IllegalArgumentException("参数不能为空");
        }

        // 注意：这里使用了try-with-resources，连接会在结束时自动关闭
        try (Connection conn = JdbcUtil.getConnection()) {
            Post exist = postDao.findById(conn, postId);
            if (exist == null) throw new IllegalArgumentException("文章不存在");

            if (!exist.getAuthorId().equals(currentUserId) && !isAdmin) {
                throw new SecurityException("无权修改");
            }

            Post update = new Post();
            update.setId(postId);
            update.setTitle(title.trim());
            update.setContent(content);
            return postDao.update(conn, update);
        }
    }

    /**
     * 删除文章（仅作者或管理员可操作）。
     *
     * @param postId        文章ID
     * @param currentUserId 当前用户ID
     * @param isAdmin       是否管理员
     * @return 是否删除成功
     * @throws IllegalArgumentException 参数为空或文章不存在
     * @throws SecurityException        无权限
     * @throws SQLException              数据库异常
     */
    public boolean deletePost(Integer postId, Integer currentUserId, boolean isAdmin) throws SQLException {
        if (postId == null || currentUserId == null) {
            throw new IllegalArgumentException("参数不能为空");
        }

        try (Connection conn = JdbcUtil.getConnection()) {
            Post exist = postDao.findById(conn, postId);
            if (exist == null) throw new IllegalArgumentException("文章不存在");

            if (!exist.getAuthorId().equals(currentUserId) && !isAdmin) {
                throw new SecurityException("无权删除");
            }

            return postDao.deleteById(conn, postId);
        }
    }

    /**
     * 获取文章详情（用于前端展示）。
     * 该方法在同一个事务中完成：
     * 1. 文章浏览数 +1
     * 2. 重新查询最新数据（包含更新后的浏览数）
     * 3. 加载该文章的所有评论
     * 4. 如果用户已登录，则查询其对当前文章的点赞状态
     *
     * @param postId        文章ID
     * @param currentUserId 当前浏览用户ID（可为null，表示未登录）
     * @return 完整的文章对象（含评论列表和点赞状态），若文章不存在则返回null
     * @throws SQLException 数据库异常（事务回滚）
     */
    public Post getPostDetail(Integer postId, Integer currentUserId) throws SQLException {
        if (postId == null) throw new IllegalArgumentException("参数不能为空");

        Connection conn = null;
        try {
            conn = JdbcUtil.getConnection();
            conn.setAutoCommit(false);

            // 首先检查文章是否存在
            Post exist = postDao.findById(conn, postId);
            if (exist == null) {
                conn.commit(); // 文章不存在也提交事务，避免不必要的回滚
                return null;
            }

            // 浏览数 +1
            postDao.incrementViews(conn, postId);

            // 重新查询以获取更新后的浏览数
            Post post = postDao.findById(conn, postId);

            // 加载评论列表
            List<Comment> comments = commentDao.listByPostId(conn, postId);
            post.setComments(comments);

            // 如果用户已登录，查询其点赞状态；否则标记为未点赞
            if (currentUserId != null) {
                post.setLikedByCurrentUser(likeDao.existsByUserAndPost(conn, currentUserId, postId));
            } else {
                post.setLikedByCurrentUser(false);
            }

            conn.commit();
            return post;
        } catch (Exception e) {
            JdbcUtil.rollbackQuietly(conn);
            throw e;
        } finally {
            JdbcUtil.close(conn);
        }
    }

    /**
     * 分页获取文章列表（按时间倒序）。
     *
     * @param limit  每页条数
     * @param offset 偏移量（从0开始）
     * @return 文章列表
     * @throws SQLException 数据库异常
     */
    public List<Post> listPosts(int limit, int offset) throws SQLException {
        try (Connection conn = JdbcUtil.getConnection()) {
            return postDao.listDesc(conn, limit, offset);
        }
    }
}