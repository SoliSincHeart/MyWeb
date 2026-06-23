package bean.blogpost;

import java.sql.Timestamp;

public class LikeRecord {
    private Long id;
    private Integer userId;
    private Integer postId;
    private Timestamp createdAt;

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