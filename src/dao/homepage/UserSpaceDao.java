package dao.homepage;

import bean.homepage.UserSpace;
import java.sql.Timestamp;

public interface UserSpaceDao {
    UserSpace findByUserId(Integer userId);
    int insert(UserSpace space);
    int update(UserSpace space);
    int updateStats(UserSpace space);
    int updateLastLogin(Integer userId, Timestamp lastLoginAt);
    int deleteByUserId(Integer userId);
}