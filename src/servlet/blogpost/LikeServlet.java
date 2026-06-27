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
 * 点赞接口 Servlet，处理 /likes。
 */
@WebServlet("/likes")
public class LikeServlet extends BaseServlet {
    private LikeService likeService = new LikeService();

    /**
     * POST 点赞（需登录，请求体 {"postId": ...}）。
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        //登录校验
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
            return;
        }

        try {
            //解析请求体获取 postId
            JsonObject body = GSON.fromJson(req.getReader(), JsonObject.class);
            Integer postId = body.get("postId").getAsInt();

            //执行点赞业务
            boolean success = likeService.likePost(currentUser.getId(), postId);

            //返回操作结果
            writeOk(resp, success, success ? null : "点赞失败");

        } catch (JsonSyntaxException e) {
            resp.setStatus(400);
            writeOk(resp, false, "无效JSON");
        } catch (IllegalStateException e) {
            // 已点赞的情况视为冲突
            resp.setStatus(409);
            writeOk(resp, false, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        }
    }

    /**
     * DELETE 取消点赞（需登录，参数 ?postId=...）。
     */
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        //登录校验
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
            return;
        }

        //获取参数 postId
        String idParam = req.getParameter("postId");
        if (idParam == null) {
            resp.setStatus(400);
            writeOk(resp, false, "缺少postId参数");
            return;
        }

        try {
            //转换参数并执行取消点赞
            Integer postId = Integer.parseInt(idParam);
            boolean success = likeService.unlikePost(currentUser.getId(), postId);

            //返回结果
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