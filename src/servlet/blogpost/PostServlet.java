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
 * 文章接口 Servlet。
 * 处理 /posts 的 CRUD 操作：
 * - GET：无 id 参数时分页列表；带 id 参数时获取详情（自动增加浏览数并携带评论/点赞状态）
 * - POST：创建文章（需登录）
 * - PUT：更新文章（作者或管理员）
 * - DELETE：删除文章（作者或管理员）
 */
@WebServlet("/posts")   // 映射URL路径，所有 /posts 请求由此Servlet处理
public class PostServlet extends BaseServlet {
    // 业务服务层，封装所有文章相关的数据库操作和业务逻辑
    private PostService postService = new PostService();

    /**
     * GET 分发器。
     * 根据是否存在 id 参数决定调用详情或列表处理逻辑。
     * 无 id：分页列表；有 id：获取单篇文章详情（浏览量+1、加载评论及点赞状态）
     */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            handleDetail(req, resp, idParam);   // 处理详情
        } else {
            handleList(req, resp);              // 处理列表
        }
    }

    /**
     * 处理文章详情请求。
     * 解析ID，调用业务层获取详情，业务层内部已处理浏览数+1、评论加载及点赞状态。
     * 若文章不存在返回404。
     */
    private void handleDetail(HttpServletRequest req, HttpServletResponse resp, String idParam) {
        try {
            // 将字符串ID转换为整数，若格式错误则抛出NumberFormatException
            Integer postId = Integer.parseInt(idParam);

            // 获取当前登录用户（可能为null），用于判断点赞状态等
            Users currentUser = LoginManager.getLoginUser(req);
            Integer userId = currentUser != null ? currentUser.getId() : null;

            // 调用业务层获取完整文章详情，包含评论列表和当前用户的点赞状态
            Post post = postService.getPostDetail(postId, userId);

            // 若文章不存在，返回404状态和错误信息
            if (post == null) {
                resp.setStatus(404);
                writeOk(resp, false, "文章不存在");
                return;
            }

            // 成功：返回文章JSON（GSON自动序列化Post对象及其嵌套的评论和点赞状态）
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write(GSON.toJson(post));

        } catch (NumberFormatException e) {
            // ID格式错误，返回400
            resp.setStatus(400);
            writeOk(resp, false, "无效ID");
        } catch (SQLException e) {
            // 数据库异常，打印堆栈并返回500
            e.printStackTrace();
            resp.setStatus(500);
            writeOk(resp, false, "数据库错误");
        } catch (IOException e) {
            // 写入响应时的IO异常，打印堆栈（无法再向客户端返回错误）
            e.printStackTrace();
        }
    }

    /**
     * 处理文章列表请求。
     * 支持分页参数 limit（每页条数）和 offset（偏移量），默认值分别为10和0。
     * 直接返回文章列表（不包含评论和点赞状态，只含基本字段）。
     */
    private void handleList(HttpServletRequest req, HttpServletResponse resp) {
        // 解析分页参数，提供默认值：limit=10, offset=0
        int limit = parseInt(req.getParameter("limit"), 10);
        int offset = parseInt(req.getParameter("offset"), 0);

        try {
            // 调用业务层获取分页文章列表
            List<Post> list = postService.listPosts(limit, offset);

            // 将列表序列化为JSON并返回
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
     * 请求体：{"title":"...", "content":"..."}
     * 成功返回新文章ID，格式：{"ok":true, "id": 123}
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 检查登录状态，未登录返回401
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
            return;
        }

        // 新增：检查是否为游客，游客禁止创建文章
        if (LoginManager.isGuest(currentUser)) {
            resp.setStatus(403);
            writeOk(resp, false, "游客不能创建文章，请登录后操作");
            return;
        }

        try {
            // 解析请求JSON体，获取title和content
            JsonObject body = GSON.fromJson(req.getReader(), JsonObject.class);
            String title = body.get("title").getAsString();
            String content = body.get("content").getAsString();

            // 调用业务层创建文章，返回新生成的ID
            Integer id = postService.createPost(currentUser.getId(), title, content);

            // 构造成功响应，包含ID
            JsonObject out = new JsonObject();
            out.addProperty("ok", true);
            out.addProperty("id", id);
            resp.getWriter().write(GSON.toJson(out));

        } catch (JsonSyntaxException e) {
            // JSON格式错误，返回400
            resp.setStatus(400);
            writeOk(resp, false, "无效JSON");
        } catch (IllegalArgumentException | SQLException e) {
            // 业务层抛出参数非法或数据库错误，返回400（如标题为空等）
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * PUT 更新文章（需作者或管理员权限）。
     * 请求体：{"id": 1, "title":"...", "content":"..."}
     * 成功返回 {"ok": true}，失败返回错误信息。
     */
    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 检查登录，未登录返回401
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
            return;
        }

        // 新增：检查是否为游客，游客禁止更新文章
        if (LoginManager.isGuest(currentUser)) {
            resp.setStatus(403);
            writeOk(resp, false, "游客不能更新文章，请登录后操作");
            return;
        }

        try {
            // 解析请求体，获取文章ID、新标题、新内容
            JsonObject body = GSON.fromJson(req.getReader(), JsonObject.class);
            Integer postId = body.get("id").getAsInt();
            String title = body.get("title").getAsString();
            String content = body.get("content").getAsString();

            // 判断当前用户是否为管理员，用于权限校验
            boolean isAdmin = currentUser.isAdmin();
            // 调用业务层更新，内部会检查是否作者或管理员
            boolean success = postService.updatePost(postId, title, content, currentUser.getId(), isAdmin);

            // 返回操作结果
            writeOk(resp, success, success ? null : "更新失败");

        } catch (JsonSyntaxException e) {
            resp.setStatus(400);
            writeOk(resp, false, "无效JSON");
        } catch (SecurityException e) {
            // 权限不足时业务层抛出SecurityException，返回403
            resp.setStatus(403);
            writeOk(resp, false, e.getMessage());
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        }
    }

    /**
     * DELETE 删除文章（需作者或管理员权限）。
     * 参数：?id=文章ID
     * 成功返回 {"ok": true}，失败返回错误信息。
     */
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 检查登录，未登录返回401
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            writeOk(resp, false, "请先登录");
            return;
        }

        // 新增：检查是否为游客，游客禁止删除文章
        if (LoginManager.isGuest(currentUser)) {
            resp.setStatus(403);
            writeOk(resp, false, "游客不能删除文章，请登录后操作");
            return;
        }

        // 获取id查询参数，缺失则返回400
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.setStatus(400);
            writeOk(resp, false, "缺少id参数");
            return;
        }

        try {
            Integer postId = Integer.parseInt(idParam);
            boolean isAdmin = currentUser.isAdmin();
            // 调用业务层删除，权限检查在内部进行
            boolean success = postService.deletePost(postId, currentUser.getId(), isAdmin);

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