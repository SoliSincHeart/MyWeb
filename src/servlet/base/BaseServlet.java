package servlet.base;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;

public abstract class BaseServlet extends HttpServlet {
    protected static final Gson GSON = new GsonBuilder().serializeNulls().create();

    protected <T> T readJson(HttpServletRequest req, Class<T> clazz) throws IOException, JsonSyntaxException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader br = req.getReader()) {
            String line;
            while ((line = br.readLine()) != null) sb.append(line);
        }
        String body = sb.toString().trim();
        if (body.isEmpty()) return null;
        return GSON.fromJson(body, clazz);
    }

    protected void writeOk(HttpServletResponse resp, boolean ok, String error) {
        try {
            JsonObject out = new JsonObject();
            out.addProperty("ok", ok);
            if (error != null) out.addProperty("error", error);
            resp.setCharacterEncoding(StandardCharsets.UTF_8.name());
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write(GSON.toJson(out));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    protected int parseInt(String s, int def) {
        if (s == null) return def;
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { return def; }
    }
}