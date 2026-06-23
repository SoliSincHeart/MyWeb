package servlet.log;

import bean.log.LogDraft;
import com.google.gson.JsonSyntaxException;
import service.log.DraftService;
import servlet.base.BaseServlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/draft")
public class DraftServlet extends BaseServlet {
    private final DraftService service = new DraftService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(true);
        LogDraft draft = service.load(session);
        resp.setCharacterEncoding("UTF-8");
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
        writeOk(resp, true, null);
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        service.delete(session);
        writeOk(resp, true, null);
    }
}