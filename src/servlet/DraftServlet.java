package servlet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;


public class DraftServlet extends HttpServlet {
    private static final String KEY_TIME = "draft_time";
    private static final String KEY_CONTENT = "draft_content";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(true);
        String time = (String) session.getAttribute(KEY_TIME);
        String content = (String) session.getAttribute(KEY_CONTENT);
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write("{\"time\":" + jsonString(time) + ",\"content\":" + jsonString(content) + "}");
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(true);
        String body = readBody(req);
        String time = extractJsonString(body, "time");
        String content = extractJsonString(body, "content");
        session.setAttribute(KEY_TIME, time);
        session.setAttribute(KEY_CONTENT, content);
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write("{\"ok\":true}");
    }
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute(KEY_TIME);
            session.removeAttribute(KEY_CONTENT);
        }
        resp.setContentType("application/json; charset=UTF-8");
        resp.getWriter().write("{\"ok\":true}");
    }

    private static String readBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = req.getReader()) {
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
        }
        return sb.toString();
    }
    private static String extractJsonString(String json, String key) {
        if (json == null) return null;
        String pattern = "\"" + key + "\"";
        int k = json.indexOf(pattern);
        if (k < 0) return null;
        int colon = json.indexOf(':', k + pattern.length());
        if (colon < 0) return null;
        int firstQuote = json.indexOf('"', colon + 1);
        if (firstQuote < 0) return null;
        int secondQuote = findStringEndQuote(json, firstQuote + 1);
        if (secondQuote < 0) return null;
        String raw = json.substring(firstQuote + 1, secondQuote);
        return unescapeJson(raw);
    }
    private static int findStringEndQuote(String s, int start) {
        boolean esc = false;
        for (int i = start; i < s.length(); i++) {
            char c = s.charAt(i);
            if (esc) { esc = false; continue; }
            if (c == '\\') { esc = true; continue; }
            if (c == '"') return i;
        }
        return -1;
    }
    private static String jsonString(String s) {
        if (s == null) return "null";
        return "\"" + escapeJson(s) + "\"";
    }
    private static String escapeJson(String s) {
        StringBuilder sb = new StringBuilder();
        for (char c : s.toCharArray()) {
            switch (c) {
                case '\\': sb.append("\\\\"); break;
                case '"': sb.append("\\\""); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default: sb.append(c);
            }
        }
        return sb.toString();
    }
    private static String unescapeJson(String s) {
        return s.replace("\\n", "\n")
                .replace("\\r", "\r")
                .replace("\\t", "\t")
                .replace("\\\"", "\"")
                .replace("\\\\", "\\");
    }
}