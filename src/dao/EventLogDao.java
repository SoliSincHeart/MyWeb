package dao;

import bean.EventLog;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


//CREATE TABLE `event_log` (
//        `id` bigint unsigned NOT NULL AUTO_INCREMENT,
//        `content` text NOT NULL,
//        `event_time` datetime(3) NOT NULL,
//        PRIMARY KEY (`id`),
//        KEY `idx_time` (`event_time`)
//        ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci

public class EventLogDao {

    public long insert(Connection conn, String content, Timestamp eventTime) throws SQLException {
        String sql = "INSERT INTO event_log(content, event_time) VALUES(?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, content);
            ps.setTimestamp(2, eventTime);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys != null && keys.next()) return keys.getLong(1);
            }
            return 0;
        }
    }

    public List<EventLog> listDesc(Connection conn, int limit, int offset) throws SQLException {
        String sql = "SELECT id, content, event_time FROM v_event_log_desc LIMIT ? OFFSET ?";
        List<EventLog> list = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    EventLog e = new EventLog();
                    e.setId(rs.getLong("id"));
                    e.setContent(rs.getString("content"));
                    e.setEventTime(rs.getTimestamp("event_time"));
                    list.add(e);
                }
            }
        }
        return list;
    }

    public boolean deleteById(Connection conn, long id) throws SQLException {
        String sql = "DELETE FROM event_log WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        }
    }
}