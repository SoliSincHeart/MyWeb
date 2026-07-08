package servlet.homepage;

import bean.homepage.UserSpace;
import com.google.gson.JsonSyntaxException;
import service.homepage.UserSpaceService;
import service.homepage.impl.UserSpaceServiceImpl;
import servlet.base.BaseServlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/user-space/*")
public class UserSpaceServlet extends BaseServlet {

    private UserSpaceService spaceService = new UserSpaceServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        String pathInfo = req.getPathInfo();

        if (pathInfo == null || "/".equals(pathInfo)) {
            Integer userId = getCurrentUserId(req);
            if (userId == null) {
                writeOk(resp, false, "未登录");
                return;
            }

            UserSpace space = spaceService.getSpaceByUserId(userId);
            if (space == null) {
                spaceService.initSpace(userId, "新用户");
                space = spaceService.getSpaceByUserId(userId);
            }

            // 补充年龄显示字段
            String ageDisplay = space.getAgeDisplay();
            Map<String, Object> result = GSON.fromJson(GSON.toJson(space), Map.class);
            result.put("ageDisplay", ageDisplay);

            // 直接使用父类的 GSON 输出
            resp.getWriter().write(GSON.toJson(result));
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        String action = req.getParameter("action");
        Integer userId = getCurrentUserId(req);

        if (userId == null) {
            writeOk(resp, false, "未登录");
            return;
        }

        if ("update".equals(action)) {
            String nickname = req.getParameter("nickname");
            String birthdayStr = req.getParameter("birthday");
            String bio = req.getParameter("bio");
            String announcement = req.getParameter("announcement");

            UserSpace space = new UserSpace();
            space.setUserId(userId);
            space.setNickname(nickname);

            if (birthdayStr != null && !birthdayStr.isEmpty()) {
                try {
                    java.util.Date birthday = new SimpleDateFormat("yyyy-MM-dd").parse(birthdayStr);
                    space.setBirthday(birthday);
                } catch (Exception e) {
                    // 忽略日期解析异常
                }
            }
            space.setBio(bio);
            space.setAnnouncement(announcement);

            boolean success = spaceService.updateProfile(space);
            if (success) {
                spaceService.syncStats(userId);
                writeOk(resp, true, null);
            } else {
                writeOk(resp, false, "更新失败");
            }

        } else if ("syncStats".equals(action)) {
            boolean success = spaceService.syncStats(userId);
            // 因为 writeOk 只支持 ok 字段，这里我们自定义输出（或者也可以使用 writeOk，但需要额外字段）
            // 为了更灵活，直接使用 GSON 输出
            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            resp.getWriter().write(GSON.toJson(result));
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    /**
     * 获取当前登录用户ID（实际应从 Session 或 Token 获取）
     */
    private Integer getCurrentUserId(HttpServletRequest req) {
        // 测试阶段固定返回 1，正式使用时改为：
        // return (Integer) req.getSession().getAttribute("userId");
        return 1;
    }
}