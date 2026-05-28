package bean;

import java.sql.Timestamp;

// 数据库实体（DAO 层用）
public class EventLog {
    private long id;
    private String content;
    private Timestamp eventTime;

    public EventLog() {}

    public EventLog(long id, String content, Timestamp eventTime) {
        this.id = id;
        this.content = content;
        this.eventTime = eventTime;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Timestamp getEventTime() { return eventTime; }
    public void setEventTime(Timestamp eventTime) { this.eventTime = eventTime; }
}