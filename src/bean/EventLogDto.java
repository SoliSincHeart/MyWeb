package bean;

public class EventLogDto {
    private long id;
    private String time;// Êä³öÊ±¼ä
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