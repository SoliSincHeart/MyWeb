package bean;

public class LogDraft {
    private String time;     // "2026-05-28T12:00:00"（来自 datetime-local）或 null
    private String content;  // 内容（允许空串）

    public LogDraft() {}

    public LogDraft(String time, String content) {
        this.time = time;
        this.content = content;
    }

    public String getTime() { return time; }
    public void setTime(String time) { this.time = time; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
}