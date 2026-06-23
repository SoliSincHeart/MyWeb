package util;

import java.sql.*;

public class JdbcUtil {
    private static final String URL =
            "jdbc:mysql://localhost:3306/myblog?useSSL=false&useUnicode=true&characterEncoding=utf8&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "123456";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void close(AutoCloseable c) {
        if (c == null) return;
        try { c.close(); } catch (Exception ignored) {}
    }

    public static void rollbackQuietly(Connection conn) {
        if (conn == null) return;
        try { conn.rollback(); } catch (SQLException ignored) {}
    }
}