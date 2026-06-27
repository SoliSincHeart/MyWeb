package bean.blogpost;

import java.sql.Timestamp;
import java.util.List;

/**
 * 文章实体类，对应 posts 表，并包含一些不持久化的展示字段。
 * 为了提高查询性能，点赞数和评论数采用冗余计数的方式存储，
 * 每次点赞/评论时同步更新 posts 表中的计数字段，避免频繁的 COUNT 查询。
 */
public class Post {
    private Integer id;          // 文章ID，自增主键
    private String title;        // 文章标题
    private String content;      // 文章正文
    private Integer authorId;    // 作者用户ID，关联 users 表
    private Integer likesCount;  // 点赞数（冗余字段）
    private Integer viewsCount;  // 浏览数，每次查看文章详情时递增
    private Integer commentsCount; // 评论数（冗余字段）
    private Timestamp createdAt; // 创建时间
    private Timestamp updatedAt; // 最后更新时间

    // 以下字段仅用于数据传递和前端展示，不持久化到 posts 表
    private String authorName;       // 作者用户名，由查询时 LEFT JOIN users 获得
    private List<Comment> comments;  // 该文章下的所有评论列表，仅在详情接口中填充
    private boolean likedByCurrentUser; // 当前登录用户是否已点赞该文章

    public Post() {}

    // getter/setter
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Integer getAuthorId() { return authorId; }
    public void setAuthorId(Integer authorId) { this.authorId = authorId; }
    public Integer getLikesCount() { return likesCount; }
    public void setLikesCount(Integer likesCount) { this.likesCount = likesCount; }
    public Integer getViewsCount() { return viewsCount; }
    public void setViewsCount(Integer viewsCount) { this.viewsCount = viewsCount; }
    public Integer getCommentsCount() { return commentsCount; }
    public void setCommentsCount(Integer commentsCount) { this.commentsCount = commentsCount; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
    public List<Comment> getComments() { return comments; }
    public void setComments(List<Comment> comments) { this.comments = comments; }
    public boolean isLikedByCurrentUser() { return likedByCurrentUser; }
    public void setLikedByCurrentUser(boolean likedByCurrentUser) { this.likedByCurrentUser = likedByCurrentUser; }
}