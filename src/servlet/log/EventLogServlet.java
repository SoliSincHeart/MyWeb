package servlet.log;

import servlet.base.BaseServlet;
import bean.log.LogDraft;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import service.log.EventLogService;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/logs")
public class EventLogServlet extends BaseServlet {
    private final EventLogService service = new EventLogService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int limit = parseInt(req.getParameter("limit"), 50);
        int offset = parseInt(req.getParameter("offset"), 0);

        try {
            List<?> list = service.listDescDto(limit, offset);
            resp.setCharacterEncoding("UTF-8");
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write(GSON.toJson(list));
        } catch (SQLException e) {
            e.printStackTrace();
            resp.setStatus(500);
            writeOk(resp, false, "数据库错误");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        LogDraft payload;
        try {
            payload = readJson(req, LogDraft.class);
        } catch (JsonSyntaxException e) {
            resp.setStatus(400);
            writeOk(resp, false, "invalid json");
            return;
        }

        String timeStr = payload == null ? null : payload.getTime();
        String content = payload == null ? null : payload.getContent();

        try {
            long id = service.addLog(timeStr, content);
            JsonObject out = new JsonObject();
            out.addProperty("ok", true);
            out.addProperty("id", id);
            resp.setCharacterEncoding("UTF-8");
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write(GSON.toJson(out));
        } catch (IllegalArgumentException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();
            resp.setStatus(500);
            writeOk(resp, false, "数据库错误");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        long id;
        try {
            id = Long.parseLong(idStr);
        } catch (Exception e) {
            resp.setStatus(400);
            writeOk(resp, false, "bad id");
            return;
        }

        try {
            boolean ok = service.deleteLog(id);
            JsonObject out = new JsonObject();
            out.addProperty("ok", ok);
            resp.setCharacterEncoding("UTF-8");
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write(GSON.toJson(out));
        } catch (IllegalArgumentException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();
            resp.setStatus(500);
            writeOk(resp, false, "数据库错误");
        }
    }
}