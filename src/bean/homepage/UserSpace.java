package bean.homepage;

import java.sql.Timestamp;
import java.util.Date;

public class UserSpace {
    private Integer userId;
    private String nickname;
    private Date birthday;
    private String bio;
    private String announcement;
    private Timestamp lastLoginAt;
    private Integer totalArticles;
    private Long totalViews;
    private Long totalLikes;
    private Timestamp updatedAt;

    public UserSpace() {}

    public UserSpace(Integer userId, String nickname, Date birthday, String bio,
                     String announcement, Timestamp lastLoginAt, Integer totalArticles,
                     Long totalViews, Long totalLikes, Timestamp updatedAt) {
        this.userId = userId;
        this.nickname = nickname;
        this.birthday = birthday;
        this.bio = bio;
        this.announcement = announcement;
        this.lastLoginAt = lastLoginAt;
        this.totalArticles = totalArticles;
        this.totalViews = totalViews;
        this.totalLikes = totalLikes;
        this.updatedAt = updatedAt;
    }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public Date getBirthday() { return birthday; }
    public void setBirthday(Date birthday) { this.birthday = birthday; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getAnnouncement() { return announcement; }
    public void setAnnouncement(String announcement) { this.announcement = announcement; }

    public Timestamp getLastLoginAt() { return lastLoginAt; }
    public void setLastLoginAt(Timestamp lastLoginAt) { this.lastLoginAt = lastLoginAt; }

    public Integer getTotalArticles() { return totalArticles; }
    public void setTotalArticles(Integer totalArticles) { this.totalArticles = totalArticles; }

    public Long getTotalViews() { return totalViews; }
    public void setTotalViews(Long totalViews) { this.totalViews = totalViews; }

    public Long getTotalLikes() { return totalLikes; }
    public void setTotalLikes(Long totalLikes) { this.totalLikes = totalLikes; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    // 年龄计算（三岁封顶）
    public String getAgeDisplay() {
        if (birthday == null) return "未知";
        java.util.Calendar now = java.util.Calendar.getInstance();
        java.util.Calendar birth = java.util.Calendar.getInstance();
        birth.setTime(birthday);

        int totalMonths = (now.get(java.util.Calendar.YEAR) - birth.get(java.util.Calendar.YEAR)) * 12
                + (now.get(java.util.Calendar.MONTH) - birth.get(java.util.Calendar.MONTH));
        if (now.get(java.util.Calendar.DAY_OF_MONTH) < birth.get(java.util.Calendar.DAY_OF_MONTH)) {
            totalMonths--;
        }

        if (totalMonths <= 36) {
            int years = totalMonths / 12;
            int months = totalMonths % 12;
            return years + "岁零" + months + "个月";
        } else {
            int extraMonths = totalMonths - 36;
            return "3岁零" + extraMonths + "个月";
        }
    }
}