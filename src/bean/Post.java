package bean;

import java.sql.Timestamp;
import java.util.List;

public class Post {
    private Integer id;
    private String title;
    private String content;
    private Integer authorId;
    private Integer likesCount;
    private Integer viewsCount;
    private Integer commentsCount;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // 非表字段（关联查询）
    private String authorName;
    private List<Comment> comments;
    private boolean likedByCurrentUser;

    // 构造方法
    public Post() {}

    // getter/setter 全部生成（省略，实际必须全）
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