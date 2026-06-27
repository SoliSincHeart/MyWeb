package bean.blogpost;

import java.sql.Timestamp;

/**
 * 评论实体类，对应数据库中的 comments 表。
 * 记录了某篇文章下的一条评论信息。
 */
public class Comment {
    private Integer id;          // 评论唯一标识，自增主键
    private Integer postId;      // 所属文章ID，关联 posts 表
    private Integer userId;      // 评论者用户ID，关联 users 表
    private String author;       // 评论者名称
    private String content;      // 评论内容
    private Timestamp createdAt; // 评论创建时间

    public Comment() {}

    // 省略 getter/setter
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public Integer getPostId() { return postId; }
    public void setPostId(Integer postId) { this.postId = postId; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}