package util;

import bean.users.Users;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class LoginManager {
    private static final String USER_KEY = "loginUser";
    private static final String REMEMBER_ME_COOKIE = "remember_me_email";

    public static void setLoginUser(HttpServletRequest request, Users user) {
        if (user == null) {
            request.getSession().removeAttribute(USER_KEY);
        } else {
            request.getSession().setAttribute(USER_KEY, user);
        }
    }

    public static Users getLoginUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        Object obj = session.getAttribute(USER_KEY);
        return obj instanceof Users ? (Users) obj : null;
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getLoginUser(request) != null;
    }

    public static void logout(HttpServletRequest request) {
        request.getSession().removeAttribute(USER_KEY);
    }

    public static void setRememberMeCookie(HttpServletRequest request, HttpServletResponse response, String email) {
        Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, email);
        cookie.setMaxAge(7 * 24 * 60 * 60);
        cookie.setPath(request.getContextPath() + "/");
        response.addCookie(cookie);
    }

    public static void clearRememberMeCookie(HttpServletRequest request, HttpServletResponse response) {
        Cookie cookie = new Cookie(REMEMBER_ME_COOKIE, "");
        cookie.setMaxAge(0);
        cookie.setPath(request.getContextPath() + "/");
        response.addCookie(cookie);
    }

    public static String getRememberMeEmail(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (REMEMBER_ME_COOKIE.equals(c.getName())) {
                    return c.getValue();
                }
            }
        }
        return null;
    }
}