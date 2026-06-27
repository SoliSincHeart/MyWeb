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
 * 评论接口 Servlet，处理 /comments。
 */
@WebServlet("/comments")
public class CommentServlet extends BaseServlet {
    private CommentService commentService = new CommentService();

    /**
     * POST 发表评论（需登录）。
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        //登录检查
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
            return;
        }

        try {
            //解析 JSON 请求体
            JsonObject body = GSON.fromJson(req.getReader(), JsonObject.class);
            Integer postId = body.get("postId").getAsInt();
            String content = body.get("content").getAsString();

            //调用业务层添加评论
            Integer commentId = commentService.addComment(
                    postId, currentUser.getId(), currentUser.getUsername(), content);

            //构造成功响应
            JsonObject out = new JsonObject();
            out.addProperty("ok", true);
            out.addProperty("id", commentId);
            resp.getWriter().write(GSON.toJson(out));

        } catch (JsonSyntaxException e) {
            // JSON 格式错误
            resp.setStatus(400);
            writeOk(resp, false, "无效JSON");
        } catch (IllegalArgumentException | SQLException e) {
            // 参数或数据库错误
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * DELETE 删除评论（需本人或管理员，参数 ?id=评论ID）。
     */
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        //登录检查
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
            return;
        }

        //获取并校验请求参数 id
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.setStatus(400);
            writeOk(resp, false, "缺少id参数");
            return;
        }

        try {
            //转换 id 并调用业务逻辑
            Integer commentId = Integer.parseInt(idParam);
            boolean isAdmin = currentUser.isAdmin();
            boolean success = commentService.deleteComment(commentId, currentUser.getId(), isAdmin);

            //返回结果
            writeOk(resp, success, success ? null : "删除失败");

        } catch (NumberFormatException e) {
            resp.setStatus(400);
            writeOk(resp, false, "无效ID");
        } catch (SecurityException e) {
            resp.setStatus(403);
            writeOk(resp, false, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        }
    }
}