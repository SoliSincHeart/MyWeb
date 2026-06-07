package service;

import bean.EventLog;
import bean.EventLogDto;
import dao.EventLogDao;
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

        Connection conn = null;
        try {
            conn = JdbcUtil.getConnection();
            List<EventLog> list = dao.listDesc(conn, limit, offset);

            SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");
            List<EventLogDto> out = new ArrayList<>();
            for (EventLog e : list) {
                String time = (e.getEventTime() == null) ? null : fmt.format(e.getEventTime());
                out.add(new EventLogDto(e.getId(), time, e.getContent()));
            }
            return out;
        } finally {
            JdbcUtil.close(conn);
        }
    }

    public long addLog(String timeStr, String content) throws SQLException {
        if (timeStr == null || timeStr.isBlank()) throw new IllegalArgumentException("time required");
        if (content == null || content.isBlank()) throw new IllegalArgumentException("content required");

        Timestamp ts = toTimestamp(timeStr);

        Connection conn = null;
        try {
            conn = JdbcUtil.getConnection();

            // 如果你未来要多表操作，再打开事务：
            // conn.setAutoCommit(false);

            long id = dao.insert(conn, content, ts);

            // if (!conn.getAutoCommit()) conn.commit();

            return id;
        } catch (SQLException e) {
            // 如果你打开了事务，这里回滚
            // JdbcUtil.rollbackQuietly(conn);
            throw e;
        } finally {
            JdbcUtil.close(conn);
        }
    }

    public boolean deleteLog(long id) throws SQLException {
        if (id <= 0) throw new IllegalArgumentException("bad id");

        Connection conn = null;
        try {
            conn = JdbcUtil.getConnection();
            return dao.deleteById(conn, id);
        } finally {
            JdbcUtil.close(conn);
        }
    }

    // "2026-05-28T12:00:00" 或 "2026-05-28T12:00:00.123" -> Timestamp
    public static Timestamp toTimestamp(String datetimeLocal) {
        String v = datetimeLocal.trim().replace('T', ' ');
        if (v.length() == 19) v = v + ".000";
        return Timestamp.valueOf(v);
    }
}