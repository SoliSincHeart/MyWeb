package servlet.blogpost;

import bean.blogpost.Post;
import bean.users.Users;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import service.blogpost.PostService;
import servlet.base.BaseServlet;
import util.LoginManager;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * 文章接口 Servlet，处理 /posts 的列表、详情、创建、更新、删除。
 */
@WebServlet("/posts")
public class PostServlet extends BaseServlet {
    private PostService postService = new PostService();

    /**
     * GET 分发：带 id 参数 -> 详情，否则 -> 列表。
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            handleDetail(req, resp, idParam);
        } else {
            handleList(req, resp);
        }
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp, String idParam) {
        try {
            //解析文章 ID
            Integer postId = Integer.parseInt(idParam);

            //获取当前登录用户 ID（可为 null）
            Users currentUser = LoginManager.getLoginUser(req);
            Integer userId = currentUser != null ? currentUser.getId() : null;

            //查询详情（自动包含浏览数+1、评论、点赞状态）
            Post post = postService.getPostDetail(postId, userId);

            //文章不存在
            if (post == null) {
                resp.setStatus(404);
                writeOk(resp, false, "文章不存在");
                return;
            }

            //返回 JSON 格式的文章详情
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write(GSON.toJson(post));

        } catch (NumberFormatException e) {
            resp.setStatus(400);
            writeOk(resp, false, "无效ID");
        } catch (SQLException e) {
            e.printStackTrace();
            resp.setStatus(500);
            writeOk(resp, false, "数据库错误");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) {
        //获取分页参数，设置默认值
        int limit = parseInt(req.getParameter("limit"), 10);
        int offset = parseInt(req.getParameter("offset"), 0);

        try {
            //查询文章列表
            List<Post> list = postService.listPosts(limit, offset);

            //返回 JSON 数组
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write(GSON.toJson(list));

        } catch (SQLException | IOException e) {
            e.printStackTrace();
            resp.setStatus(500);
            writeOk(resp, false, "数据库错误");
        }
    }

    /**
     * POST 创建文章（需登录）。
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
            //解析请求 JSON
            JsonObject body = GSON.fromJson(req.getReader(), JsonObject.class);
            String title = body.get("title").getAsString();
            String content = body.get("content").getAsString();

            //调用创建逻辑
            Integer id = postService.createPost(currentUser.getId(), title, content);

            //返回新文章 ID
            JsonObject out = new JsonObject();
            out.addProperty("ok", true);
            out.addProperty("id", id);
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

    /**
     * PUT 更新文章（需作者或管理员权限）。
     */
    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        //登录校验
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
            return;
        }

        try {
            //解析更新参数
            JsonObject body = GSON.fromJson(req.getReader(), JsonObject.class);
            Integer postId = body.get("id").getAsInt();
            String title = body.get("title").getAsString();
            String content = body.get("content").getAsString();

            //调用业务逻辑（含权限检查）
            boolean isAdmin = currentUser.isAdmin();
            boolean success = postService.updatePost(postId, title, content, currentUser.getId(), isAdmin);

            //返回结果
            writeOk(resp, success, success ? null : "更新失败");

        } catch (JsonSyntaxException e) {
            resp.setStatus(400);
            writeOk(resp, false, "无效JSON");
        } catch (SecurityException e) {
            resp.setStatus(403);
            writeOk(resp, false, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        }
    }

    /**
     * DELETE 删除文章（需作者或管理员权限，参数 ?id=文章ID）。
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

        //获取并校验参数
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.setStatus(400);
            writeOk(resp, false, "缺少id参数");
            return;
        }

        try {
            //解析参数并执行删除
            Integer postId = Integer.parseInt(idParam);
            boolean isAdmin = currentUser.isAdmin();
            boolean success = postService.deletePost(postId, currentUser.getId(), isAdmin);

            //返回操作结果
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