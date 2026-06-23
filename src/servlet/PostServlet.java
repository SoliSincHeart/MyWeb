package servlet;

import bean.Post;
import bean.Users;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import service.PostService;
import util.LoginManager;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/posts")
public class PostServlet extends BaseServlet {

    private PostService postService = new PostService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idParam = req.getParameter("id");
        if (idParam != null) {
            handleDetail(req, resp, idParam);
        } else {
            handleList(req, resp);
        }
    }

    // 处理文章详情
    private void handleDetail(HttpServletRequest req, HttpServletResponse resp, String idParam) throws IOException {
        try {
            Integer postId = Integer.parseInt(idParam);
            Users currentUser = LoginManager.getLoginUser(req);
            Integer userId = currentUser != null ? currentUser.getId() : null;
            Post post = postService.getPostDetail(postId, userId);
            if (post == null) {
                resp.setStatus(404);
                try {
                    writeOk(resp, false, "文章不存在");
                } catch (IOException e) {
                    e.printStackTrace();
                }
                return;
            }
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write(GSON.toJson(post));
        } catch (NumberFormatException e) {
            resp.setStatus(400);
            try {
                writeOk(resp, false, "无效ID");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            resp.setStatus(500);
            try {
                writeOk(resp, false, "数据库错误");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    // 处理文章列表
    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int limit = parseInt(req.getParameter("limit"), 10);
        int offset = parseInt(req.getParameter("offset"), 0);
        try {
            List<Post> list = postService.listPosts(limit, offset);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write(GSON.toJson(list));
        } catch (SQLException e) {
            e.printStackTrace();
            resp.setStatus(500);
            try {
                writeOk(resp, false, "数据库错误");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            try {
                writeOk(resp, false, "请先登录");
            } catch (IOException e) {
                e.printStackTrace();
            }
            return;
        }
        try {
            JsonObject body = GSON.fromJson(req.getReader(), JsonObject.class);
            String title = body.get("title").getAsString();
            String content = body.get("content").getAsString();
            Integer id = postService.createPost(currentUser.getId(), title, content);
            JsonObject out = new JsonObject();
            out.addProperty("ok", true);
            out.addProperty("id", id);
            resp.getWriter().write(GSON.toJson(out));
        } catch (JsonSyntaxException e) {
            resp.setStatus(400);
            try {
                writeOk(resp, false, "无效JSON");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            try {
                writeOk(resp, false, e.getMessage());
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            try {
                writeOk(resp, false, "请先登录");
            } catch (IOException e) {
                e.printStackTrace();
            }
            return;
        }
        try {
            JsonObject body = GSON.fromJson(req.getReader(), JsonObject.class);
            Integer postId = body.get("id").getAsInt();
            String title = body.get("title").getAsString();
            String content = body.get("content").getAsString();
            boolean isAdmin = currentUser.isAdmin();
            boolean success = postService.updatePost(postId, title, content, currentUser.getId(), isAdmin);
            try {
                writeOk(resp, success, success ? null : "更新失败");
            } catch (IOException e) {
                e.printStackTrace();
            }
        } catch (JsonSyntaxException e) {
            resp.setStatus(400);
            try {
                writeOk(resp, false, "无效JSON");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        } catch (SecurityException e) {
            resp.setStatus(403);
            try {
                writeOk(resp, false, e.getMessage());
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            try {
                writeOk(resp, false, e.getMessage());
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Users currentUser = LoginManager.getLoginUser(req);
        if (currentUser == null) {
            resp.setStatus(401);
            try {
                writeOk(resp, false, "请先登录");
            } catch (IOException e) {
                e.printStackTrace();
            }
            return;
        }
        String idParam = req.getParameter("id");
        if (idParam == null) {
            resp.setStatus(400);
            try {
                writeOk(resp, false, "缺少id参数");
            } catch (IOException e) {
                e.printStackTrace();
            }
            return;
        }
        try {
            Integer postId = Integer.parseInt(idParam);
            boolean isAdmin = currentUser.isAdmin();
            boolean success = postService.deletePost(postId, currentUser.getId(), isAdmin);
            try {
                writeOk(resp, success, success ? null : "删除失败");
            } catch (IOException e) {
                e.printStackTrace();
            }
        } catch (NumberFormatException e) {
            resp.setStatus(400);
            try {
                writeOk(resp, false, "无效ID");
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        } catch (SecurityException e) {
            resp.setStatus(403);
            try {
                writeOk(resp, false, e.getMessage());
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        } catch (IllegalArgumentException | SQLException e) {
            resp.setStatus(400);
            try {
                writeOk(resp, false, e.getMessage());
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}