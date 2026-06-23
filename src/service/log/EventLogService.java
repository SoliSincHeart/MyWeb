package service.log;

import bean.log.EventLog;
import bean.log.EventLogDto;
import dao.log.EventLogDao;
import util.JdbcUtil;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class EventLogService {
    private final EventLogDao dao = new EventLogDao();

    public List<EventLogDto> listDescDto(int limit, int offset) throws SQLException {
        if (limit <= 0) limit = 50;
        if (limit > 200) limit = 200;
        if (offset < 0) offset = 0;

        try (Connection conn = JdbcUtil.getConnection()) {
            List<EventLog> list = dao.listDesc(conn, limit, offset);
            SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
            List<EventLogDto> out = new ArrayList<>();
            for (EventLog l : list) {
                String time = (l.getEventTime() == null) ? null : fmt.format(l.getEventTime());
                out.add(new EventLogDto(l.getId(), time, l.getContent()));
            }
            return out;
        }
    }

    public long addLog(String timeStr, String content) throws SQLException {
        if (timeStr == null || timeStr.isBlank()) throw new IllegalArgumentException("time required");
        if (content == null || content.isBlank()) throw new IllegalArgumentException("content required");

        Timestamp ts = toTimestamp(timeStr);
        Connection conn = null;
        try {
            conn = JdbcUtil.getConnection();
            conn.setAutoCommit(false);
            long id = dao.insert(conn, content, ts);
            conn.commit();
            return id;
        } catch (SQLException e) {
            JdbcUtil.rollbackQuietly(conn);
            throw e;
        } finally {
            JdbcUtil.close(conn);
        }
    }

    public boolean deleteLog(long id) throws SQLException {
        if (id <= 0) throw new IllegalArgumentException("bad id");
        try (Connection conn = JdbcUtil.getConnection()) {
            return dao.deleteById(conn, id);
        }
    }

    public static Timestamp toTimestamp(String datetimeLocal) {
        String v = datetimeLocal.trim().replace('T', ' ');
        if (v.length() == 16) {
            v = v + ":00.000";
        } else if (v.length() == 19) {
            v = v + ".000";
        }
        return Timestamp.valueOf(v);
    }
}