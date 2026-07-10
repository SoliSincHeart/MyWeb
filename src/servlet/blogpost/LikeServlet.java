package servlet.blogpost;

import bean.users.Users;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import service.blogpost.LikeService;
import servlet.base.BaseServlet;
import util.LoginManager;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * 点赞接口 Servlet。
 * 处理 /likes 的 POST（点赞）与 DELETE（取消点赞）。
 * 均需登录。
 */
@WebServlet("/likes")
public class LikeServlet extends BaseServlet {
    private LikeService likeService = new LikeService();

    /**
     * POST /likes  点赞。
     * 请求体 JSON：{"postId": 123}
     * 成功：{"ok": true}；已点赞：409；其他错误：4xx。
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
            return;
        }

        // 新增：检查是否为游客，游客禁止点赞
        if (LoginManager.isGuest(currentUser)) {
            resp.setStatus(403);
            writeOk(resp, false, "游客不能点赞，请登录后操作");
            return;
        }

        try {
            JsonObject body = GSON.fromJson(req.getReader(), JsonObject.class);
            Integer postId = body.get("postId").getAsInt();

            boolean success = likeService.likePost(currentUser.getId(), postId);

            writeOk(resp, success, success ? null : "点赞失败");

        } catch (JsonSyntaxException e) {
            resp.setStatus(400);
            writeOk(resp, false, "无效JSON");
        } catch (IllegalStateException e) {
            // 业务层检测到重复点赞，返回409 Conflict
            resp.setStatus(409);
            writeOk(resp, false, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        }
    }

    /**
     * DELETE /likes?postId=123  取消点赞。
     * 成功：{"ok": true}；未点赞：409。
     */
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
            return;
        }

        // 新增：检查是否为游客，游客禁止取消点赞
        if (LoginManager.isGuest(currentUser)) {
            resp.setStatus(403);
            writeOk(resp, false, "游客不能取消点赞，请登录后操作");
            return;
        }

        String idParam = req.getParameter("postId");
        if (idParam == null) {
            resp.setStatus(400);
            writeOk(resp, false, "缺少postId参数");
            return;
        }

        try {
            Integer postId = Integer.parseInt(idParam);
            boolean success = likeService.unlikePost(currentUser.getId(), postId);

            writeOk(resp, success, success ? null : "取消点赞失败");

        } catch (NumberFormatException e) {
            resp.setStatus(400);
            writeOk(resp, false, "无效postId");
        } catch (IllegalStateException e) {
            // 尚未点赞时取消，返回409
            resp.setStatus(409);
            writeOk(resp, false, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        }
    }
}