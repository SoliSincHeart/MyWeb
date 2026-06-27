package bean.blogpost;

import java.sql.Timestamp;

/**
 * 点赞记录实体，对应数据库中的 user_post_likes 表。
 * 用于记录某个用户对某篇文章的点赞行为，通过用户ID和文章ID唯一确定一条记录。
 * 业务上主要用于判断用户是否已点赞以及执行点赞/取消点赞操作。
 */
public class LikeRecord {
    private Long id;            // 自增主键
    private Integer userId;     // 用户ID，关联 users 表
    private Integer postId;     // 文章ID，关联 posts 表
    private Timestamp createdAt; // 点赞时间

    public LikeRecord() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public Integer getPostId() { return postId; }
    public void setPostId(Integer postId) { this.postId = postId; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}