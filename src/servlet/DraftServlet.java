package servlet;

import bean.LogDraft;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import service.DraftService;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

@WebServlet("/draft")
public class DraftServlet extends HttpServlet {
    private static final Gson GSON = new GsonBuilder().serializeNulls().create();
    private final DraftService service = new DraftService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(true);
        LogDraft draft = service.load(session);

        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write(GSON.toJson(draft));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(true);

        LogDraft payload;
        try {
            payload = readJson(req, LogDraft.class);
        } catch (JsonSyntaxException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            writeOk(resp, false, "invalid json");
            return;
        }

        service.save(session, payload);

        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json; charset=UTF-8");
        writeOk(resp, true, null);
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        service.delete(session);

        resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
        resp.setContentType("application/json; charset=UTF-8");
        writeOk(resp, true, null);
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

    private static void writeOk(HttpServletResponse resp, boolean ok, String error) throws IOException {
        JsonObject out = new JsonObject();
        out.addProperty("ok", ok);
        if (error != null) out.addProperty("error", error);
        resp.getWriter().write(GSON.toJson(out));
    }
}