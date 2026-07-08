package service.homepage.impl;

import bean.homepage.UserSpace;
import dao.homepage.UserSpaceDao;
import dao.homepage.impl.UserSpaceDaoImpl;
import service.homepage.UserSpaceService;
import util.JdbcUtil;

import java.sql.*;

public class UserSpaceServiceImpl implements UserSpaceService {

    private UserSpaceDao spaceDao = new UserSpaceDaoImpl();

    @Override
    public UserSpace getSpaceByUserId(Integer userId) {
        return spaceDao.findByUserId(userId);
    }

    @Override
    public boolean initSpace(Integer userId, String nickname) {
        if (spaceDao.findByUserId(userId) != null) return true;
        UserSpace space = new UserSpace();
        space.setUserId(userId);
        space.setNickname(nickname);
        space.setBirthday(null);
        space.setBio("");
        space.setAnnouncement("");
        space.setLastLoginAt(null);
        space.setTotalArticles(0);
        space.setTotalViews(0L);
        space.setTotalLikes(0L);
        return spaceDao.insert(space) > 0;
    }

    @Override
    public boolean updateProfile(UserSpace space) {
        if (space == null || space.getUserId() == null) return false;
        UserSpace exist = spaceDao.findByUserId(space.getUserId());
        if (exist == null) {
            initSpace(space.getUserId(), space.getNickname() == null ? "用户" : space.getNickname());
        }
        return spaceDao.update(space) > 0;
    }

    @Override
    public boolean syncStats(Integer userId) {
        String statsSql = "SELECT COUNT(*) AS articleCount, " +
                "COALESCE(SUM(views_count), 0) AS totalViews, " +
                "COALESCE(SUM(likes_count), 0) AS totalLikes " +
                "FROM posts WHERE author_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = JdbcUtil.getConnection();
            ps = conn.prepareStatement(statsSql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                UserSpace space = new UserSpace();
                space.setUserId(userId);
                space.setTotalArticles(rs.getInt("articleCount"));
                space.setTotalViews(rs.getLong("totalViews"));
                space.setTotalLikes(rs.getLong("totalLikes"));
                return spaceDao.updateStats(space) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            JdbcUtil.close(rs);
            JdbcUtil.close(ps);
            JdbcUtil.close(conn);
        }
        return false;
    }

    @Override
    public boolean updateLastLogin(Integer userId) {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return spaceDao.updateLastLogin(userId, now) > 0;
    }

    @Override
    public boolean deleteSpace(Integer userId) {
        return spaceDao.deleteByUserId(userId) > 0;
    }
}