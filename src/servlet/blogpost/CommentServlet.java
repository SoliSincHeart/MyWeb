package servlet.blogpost;

import bean.users.Users;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import service.blogpost.CommentService;
import servlet.base.BaseServlet;
import util.LoginManager;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * 评论接口 Servlet。
 * 处理 /comments 的 POST（发表）与 DELETE（删除）请求。
 * 所有操作需登录。
 */
@WebServlet("/comments")
public class CommentServlet extends BaseServlet {
    private CommentService commentService = new CommentService();

    /**
     * POST /comments  发表评论（需登录）。
     * 请求体 JSON：{"postId": 1, "content": "很好"}
     * 响应：成功时 {"ok": true, "id": 新评论ID}；失败时包含 ok: false 及 message。
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 登录检查：从会话或token获取当前用户
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401); // Unauthorized
            writeOk(resp, false, "请先登录");
            return;
        }

        // 新增：检查是否为游客，游客禁止发表评论
        if (LoginManager.isGuest(currentUser)) {
            resp.setStatus(403);
            writeOk(resp, false, "游客不能发表评论，请登录后操作");
            return;
        }

        try {
            // 解析请求体JSON
            JsonObject body = GSON.fromJson(req.getReader(), JsonObject.class);
            Integer postId = body.get("postId").getAsInt();     // 必填
            String content = body.get("content").getAsString(); // 必填

            // 调用业务层发表评论
            Integer commentId = commentService.addComment(
                    postId, currentUser.getId(), currentUser.getUsername(), content);

            // 构造成功响应，返回新评论的ID
            JsonObject out = new JsonObject();
            out.addProperty("ok", true);
            out.addProperty("id", commentId);
            resp.getWriter().write(GSON.toJson(out));

        } catch (JsonSyntaxException e) {
            // JSON格式错误或缺少字段
            resp.setStatus(400);
            writeOk(resp, false, "无效JSON");
        } catch (IllegalArgumentException | SQLException e) {
            // 参数校验失败或数据库错误
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        } catch (IOException e) {
            e.printStackTrace(); // 实际项目应使用日志框架记录
        }
    }

    /**
     * DELETE /comments?id=123  删除评论（需本人或管理员权限）。
     * 请求参数：id - 评论ID
     * 响应：{"ok": true/false, "message": "..."}
     */
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 登录校验
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
            return;
        }

        // 新增：检查是否为游客，游客禁止删除评论
        if (LoginManager.isGuest(currentUser)) {
            resp.setStatus(403);
            writeOk(resp, false, "游客不能删除评论，请登录后操作");
            return;
        }

        // 获取查询参数 id
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.setStatus(400);
            writeOk(resp, false, "缺少id参数");
            return;
        }

        try {
            Integer commentId = Integer.parseInt(idParam);
            boolean isAdmin = currentUser.isAdmin();
            // 执行删除，内部包含权限检查
            boolean success = commentService.deleteComment(commentId, currentUser.getId(), isAdmin);

            // 根据成功与否返回不同消息
            writeOk(resp, success, success ? null : "删除失败");

        } catch (NumberFormatException e) {
            resp.setStatus(400);
            writeOk(resp, false, "无效ID");
        } catch (SecurityException e) {
            // 权限不足
            resp.setStatus(403); // Forbidden
            writeOk(resp, false, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        }
    }
}