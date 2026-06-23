package servlet.blogpost;

import servlet.base.BaseServlet;
import bean.users.Users;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import service.blogpost.LikeService;
import util.LoginManager;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/likes")
public class LikeServlet extends BaseServlet {
    private LikeService likeService = new LikeService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
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
            resp.setStatus(409);
            writeOk(resp, false, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
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
            resp.setStatus(409);
            writeOk(resp, false, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        }
    }
}