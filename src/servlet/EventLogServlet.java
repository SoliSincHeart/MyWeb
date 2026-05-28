package servlet;

import bean.LogDraft;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import service.EventLogService;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/logs")
public class EventLogServlet extends HttpServlet {
    private static final Gson GSON = new GsonBuilder().serializeNulls().create();
    private final EventLogService service = new EventLogService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int limit = parseInt(req.getParameter("limit"), 50);
        int offset = parseInt(req.getParameter("offset"), 0);

        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json; charset=UTF-8");

        try {
            // 关键：返回 DTO（time 字符串），不直接返回 Timestamp
            List<?> list = service.listDescDto(limit, offset);
            resp.getWriter().write(GSON.toJson(list));
        } catch (SQLException e) {
            resp.setStatus(500);
            writeOk(resp, false, "db");
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

        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json; charset=UTF-8");

        try {
            long id = service.addLog(timeStr, content);
            JsonObject out = new JsonObject();
            out.addProperty("ok", true);
            out.addProperty("id", id);
            resp.getWriter().write(GSON.toJson(out));
        } catch (IllegalArgumentException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        } catch (SQLException e) {
            resp.setStatus(500);
            writeOk(resp, false, "db");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");

        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json; charset=UTF-8");

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
            resp.getWriter().write(GSON.toJson(out));
        } catch (IllegalArgumentException e) {
            resp.setStatus(400);
            writeOk(resp, false, e.getMessage());
        } catch (SQLException e) {
            resp.setStatus(500);
            writeOk(resp, false, "db");
        }
    }

    private static <T> T readJson(HttpServletRequest req, Class<T> clazz) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = req.getReader()) {
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
        }
        String body = sb.toString().trim();
        if (body.isEmpty()) return null;
        return GSON.fromJson(body, clazz);
    }

    private static int parseInt(String s, int def) {
        if (s == null) return def;
        try { return Integer.parseInt(s); } catch (Exception e) { return def; }
    }

    private static void writeOk(HttpServletResponse resp, boolean ok, String error) throws IOException {
        JsonObject out = new JsonObject();
        out.addProperty("ok", ok);
        if (error != null) out.addProperty("error", error);
        resp.getWriter().write(GSON.toJson(out));
    }
}