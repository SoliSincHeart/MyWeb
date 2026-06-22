<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>测试跳转</title>
</head>
<body>
<h1>✅ 登录成功！</h1>
<p>欢迎来到 test3.jsp</p>
<p>当前会话用户：<%= session.getAttribute("loginUser") %></p>
<p><a href="<%= request.getContextPath() %>/index.jsp">返回登录页</a></p>
</body>
</html>