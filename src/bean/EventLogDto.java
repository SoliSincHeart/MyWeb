package bean;

// 对前端输出用（Servlet GET /logs 返回这个，避免 Timestamp 被 Gson 序列化成 Jun 15...）
public class EventLogDto {
    private long id;
    private String time;    // "yyyy-MM-dd HH:mm:ss.SSS"
    private String content;

    public EventLogDto() {}

    public EventLogDto(long id, String time, String content) {
        this.id = id;
        this.time = time;
        this.content = content;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}