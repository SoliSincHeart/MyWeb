package servlet.users;

import bean.users.Users;
import service.users.UserService;
import util.LoginManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/user")
public class UserServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String action = request.getParameter("action");

        if ("login".equals(action)) {
            handleLogin(request, response);
        } else if ("register".equals(action)) {
            handleRegister(request, response);
        } else {
            response.getWriter().write("未知操作");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("rememberMe");

        Users user = userService.login(email, password);
        if (user != null) {
            // 登录成功，设置 Session
            LoginManager.setLoginUser(request, user);

            // 处理“记住我”
            if ("on".equals(remember)) {
                LoginManager.setRememberMeCookie(request, response, email);
            } else {
                LoginManager.clearRememberMeCookie(request, response);
            }

            // 重定向到首页
            response.sendRedirect(request.getContextPath() + "/test1.jsp");
        } else {
            // 登录失败，返回提示信息
            response.getWriter().write("邮箱或密码错误，或者账号已被禁用");
        }
    }
    public UserServlet() {
        System.out.println("UserServlet 被实例化了！");
    }
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        boolean ok = userService.register(username, email, password);
        if (ok) {
            response.getWriter().write("注册成功");
        } else {
            response.getWriter().write("注册失败：邮箱已存在");
        }
    }
}