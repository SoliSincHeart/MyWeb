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

@WebServlet("/comments")
public class CommentServlet extends BaseServlet {
    private CommentService commentService = new CommentService();

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
            String content = body.get("content").getAsString();
            Integer commentId = commentService.addComment(postId, currentUser.getId(), currentUser.getUsername(), content);
            JsonObject out = new JsonObject();
            out.addProperty("ok", true);
            out.addProperty("id", commentId);
            resp.getWriter().write(GSON.toJson(out));
        } catch (JsonSyntaxException e) {
            resp.setStatus(400);
            writeOk(resp, false, "无效JSON");
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        } catch (IOException e) {
            e.printStackTrace();
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
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.setStatus(400);
            writeOk(resp, false, "缺少id参数");
            return;
        }
        try {
            Integer commentId = Integer.parseInt(idParam);
            boolean isAdmin = currentUser.isAdmin();
            boolean success = commentService.deleteComment(commentId, currentUser.getId(), isAdmin);
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