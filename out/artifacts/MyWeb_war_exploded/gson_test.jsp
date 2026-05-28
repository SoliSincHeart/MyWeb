<%--
  Created by IntelliJ IDEA.
  User: hyb
  Date: 2026/5/28
  Time: 12:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="application/json;charset=UTF-8" language="java" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.util.*" %>
<%
    Map<String, Object> m = new LinkedHashMap<>();
    m.put("ok", true);
    m.put("now", new java.util.Date().toString());
    m.put("arr", Arrays.asList(1,2,3));
    m.put("msg", "gson works");

    String json = new Gson().toJson(m);
    out.print(json);
%>
