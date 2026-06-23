package service.log;

import bean.log.LogDraft;

import javax.servlet.http.HttpSession;

public class DraftService {
    private static final String KEY_DRAFT = "log_draft";

    public LogDraft load(HttpSession session) {
        if (session == null) return new LogDraft(null, null);
        Object obj = session.getAttribute(KEY_DRAFT);
        if (obj instanceof LogDraft) {
            return (LogDraft) obj;
        }
        return new LogDraft(null, null);
    }

    public void save(HttpSession session, LogDraft payload) {
        if (session == null) throw new IllegalArgumentException("session is null");
        if (payload == null) {
            session.removeAttribute(KEY_DRAFT);
            return;
        }
        session.setAttribute(KEY_DRAFT, payload);
    }

    public void delete(HttpSession session) {
        if (session == null) return;
        session.removeAttribute(KEY_DRAFT);
    }
}