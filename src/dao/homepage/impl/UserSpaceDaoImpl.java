package dao.homepage.impl;

import bean.homepage.UserSpace;
import dao.homepage.UserSpaceDao;
import util.JdbcUtil;

import java.sql.*;

public class UserSpaceDaoImpl implements UserSpaceDao {

    @Override
    public UserSpace findByUserId(Integer userId) {
        String sql = "SELECT user_id, nickname, birthday, bio, announcement, " +
                "last_login_at, total_articles, total_views, total_likes, updated_at " +
                "FROM user_spaces WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = JdbcUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(ps);
            JdbcUtil.close(conn);
        }
        return null;
    }

    @Override
    public int insert(UserSpace space) {
        String sql = "INSERT INTO user_spaces (user_id, nickname, birthday, bio, announcement, " +
                "last_login_at, total_articles, total_views, total_likes) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = JdbcUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, space.getUserId());
            ps.setString(2, space.getNickname());
            ps.setDate(3, space.getBirthday() == null ? null : new java.sql.Date(space.getBirthday().getTime()));
            ps.setString(4, space.getBio());
            ps.setString(5, space.getAnnouncement());
            ps.setTimestamp(6, space.getLastLoginAt());
            ps.setInt(7, space.getTotalArticles() == null ? 0 : space.getTotalArticles());
            ps.setLong(8, space.getTotalViews() == null ? 0L : space.getTotalViews());
            ps.setLong(9, space.getTotalLikes() == null ? 0L : space.getTotalLikes());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            JdbcUtil.close(ps);
            JdbcUtil.close(conn);
        }
    }

    @Override
    public int update(UserSpace space) {
        String sql = "UPDATE user_spaces SET nickname=?, birthday=?, bio=?, announcement=? WHERE user_id=?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = JdbcUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, space.getNickname());
            ps.setDate(2, space.getBirthday() == null ? null : new java.sql.Date(space.getBirthday().getTime()));
            ps.setString(3, space.getBio());
            ps.setString(4, space.getAnnouncement());
            ps.setInt(5, space.getUserId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            JdbcUtil.close(ps);
            JdbcUtil.close(conn);
        }
    }

    @Override
    public int updateStats(UserSpace space) {
        String sql = "UPDATE user_spaces SET total_articles=?, total_views=?, total_likes=? WHERE user_id=?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = JdbcUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, space.getTotalArticles() == null ? 0 : space.getTotalArticles());
            ps.setLong(2, space.getTotalViews() == null ? 0L : space.getTotalViews());
            ps.setLong(3, space.getTotalLikes() == null ? 0L : space.getTotalLikes());
            ps.setInt(4, space.getUserId());
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            JdbcUtil.close(ps);
            JdbcUtil.close(conn);
        }
    }

    @Override
    public int updateLastLogin(Integer userId, Timestamp lastLoginAt) {
        String sql = "UPDATE user_spaces SET last_login_at=? WHERE user_id=?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = JdbcUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setTimestamp(1, lastLoginAt);
            ps.setInt(2, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            JdbcUtil.close(ps);
            JdbcUtil.close(conn);
        }
    }

    @Override
    public int deleteByUserId(Integer userId) {
        String sql = "DELETE FROM user_spaces WHERE user_id=?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = JdbcUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        } finally {
            JdbcUtil.close(ps);
            JdbcUtil.close(conn);
        }
    }

    private UserSpace mapRow(ResultSet rs) throws SQLException {
        UserSpace space = new UserSpace();
        space.setUserId(rs.getInt("user_id"));
        space.setNickname(rs.getString("nickname"));
        space.setBirthday(rs.getDate("birthday"));
        space.setBio(rs.getString("bio"));
        space.setAnnouncement(rs.getString("announcement"));
        space.setLastLoginAt(rs.getTimestamp("last_login_at"));
        space.setTotalArticles(rs.getInt("total_articles"));
        space.setTotalViews(rs.getLong("total_views"));
        space.setTotalLikes(rs.getLong("total_likes"));
        space.setUpdatedAt(rs.getTimestamp("updated_at"));
        return space;
    }
}