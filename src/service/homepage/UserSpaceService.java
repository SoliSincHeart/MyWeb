package service.homepage;

import bean.homepage.UserSpace;

public interface UserSpaceService {
    UserSpace getSpaceByUserId(Integer userId);
    boolean initSpace(Integer userId, String nickname);
    boolean updateProfile(UserSpace space);
    boolean syncStats(Integer userId);
    boolean updateLastLogin(Integer userId);
    boolean deleteSpace(Integer userId);
}