package service;

import bean.EventLog;
import bean.EventLogDto;
import dao.EventLogDao;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class EventLogService {
    private final EventLogDao dao = new EventLogDao();

    // 对外：返回 DTO（字符串时间，稳定）
    public List<EventLogDto> listDescDto(int limit, int offset) throws SQLException {
        if (limit <= 0) limit = 50;
        if (limit > 200) limit = 200;
        if (offset < 0) offset = 0;

        List<EventLog> list = dao.listDesc(limit, offset);

        // 固定格式，避免 Gson 把 Timestamp 序列化成本地化字符串
        SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

        List<EventLogDto> out = new ArrayList<>();
        for (EventLog e : list) {
            String time = (e.getEventTime() == null) ? null : fmt.format(e.getEventTime());
            out.add(new EventLogDto(e.getId(), time, e.getContent()));
        }
        return out;
    }

    public long addLog(String timeStr, String content) throws SQLException {
        if (timeStr == null || timeStr.isBlank()) throw new IllegalArgumentException("time required");
        if (content == null || content.isBlank()) throw new IllegalArgumentException("content required");

        Timestamp ts = toTimestamp(timeStr);
        return dao.insert(content, ts);
    }

    public boolean deleteLog(long id) throws SQLException {
        if (id <= 0) throw new IllegalArgumentException("bad id");
        return dao.deleteById(id);
    }

    // 接收 datetime-local: "2026-05-28T12:00:00" 或带毫秒
    public static Timestamp toTimestamp(String datetimeLocal) {
        String v = datetimeLocal.trim().replace('T', ' ');
        // 保证至少到毫秒（3位），避免数据库 DATETIME(3) 精度不一致
        if (v.length() == 19) v = v + ".000";
        return Timestamp.valueOf(v);
    }
}