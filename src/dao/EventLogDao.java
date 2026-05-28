package dao;

import bean.EventLog;
import util.JdbcUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventLogDao {

    public long insert(String content, Timestamp eventTime) throws SQLException {
        String sql = "INSERT INTO event_log(content, event_time) VALUES(?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet keys = null;
        try {
            conn = JdbcUtil.getConnection();
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, content);
            ps.setTimestamp(2, eventTime);
            ps.executeUpdate();

            keys = ps.getGeneratedKeys();
            if (keys != null && keys.next()) {
                return keys.getLong(1);
            }
            return 0;
        } finally {
            JdbcUtil.close(conn, ps, keys);
        }
    }

    public List<EventLog> listDesc(int limit, int offset) throws SQLException {
        String sql = "SELECT id, content, event_time FROM v_event_log_desc LIMIT ? OFFSET ?";
        List<EventLog> list = new ArrayList<>();

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = JdbcUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            rs = ps.executeQuery();

            while (rs.next()) {
                EventLog e = new EventLog();
                e.setId(rs.getLong("id"));
                e.setContent(rs.getString("content"));
                e.setEventTime(rs.getTimestamp("event_time"));
                list.add(e);
            }
            return list;
        } finally {
            JdbcUtil.close(conn, ps, rs);
        }
    }

    // 更稳：删除只按 id（避免 time 精度/格式匹配导致删除失败）
    public boolean deleteById(long id) throws SQLException {
        String sql = "DELETE FROM event_log WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = JdbcUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } finally {
            JdbcUtil.close(conn, ps);
        }
    }
}