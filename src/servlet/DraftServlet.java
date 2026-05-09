package servlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.BufferedReader;

@WebServlet("/draft")
public class DraftServlet extends HttpServlet {

    // 处理GET请求：从session获取草稿
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();


        Object draft = session.getAttribute("draft");
        if (draft == null) {
            response.getWriter().write("无内容");
        } else {
            response.getWriter().write("草稿内容：" + draft.toString());
        }
    }

    // 处理POST请求：简单存一个字符串到session
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        // 暂时不管前端传什么，直接写死一个字符串
        session.setAttribute("draft", "hello session!");

        response.getWriter().write("post ok");
    }
}