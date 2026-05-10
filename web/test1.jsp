<%--
  Created by IntelliJ IDEA.
  User: hyb
  Date: 2026/5/9
  Time: 21:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>原生dialog上下错开</title>
    <link rel="stylesheet" href="css/index/log.css">

</head>
<body>
<a href="test2.html">这里是第一个网站</a>
<button id="mg_log">随身日志</button>

<dialog id="show_log">
    <div class="log_viewer">
        <div class="log_header">
            <span class="log_time_display">暂无日志</span>
            <button class="arrow_btn left_arrow">◀</button>
            <span class="log_counter">0 / 0</span>
            <button class="arrow_btn right_arrow">▶</button>
        </div>
        <div class="log_body">
            <div class="log_content_preview">
                这里展示日志正文内容
            </div>
        </div>
        <div class="log_actions">
            <button id="openedit_log" class="action_btn">打开第二个弹窗</button>
            <button id="closeFirstDialog" class="action_btn secondary">关闭本弹窗</button>
        </div>
    </div>
</dialog>

<dialog id="edit_log" >
    <div id="logModal" class="modal_overlay">
        <div class="edit_modal">
            <h3 id="modalTitle">编辑日志</h3>
            <label>时间（标题）</label>
            <input type="datetime-local" id="logTimeInput" step="1">
            <label>正文</label>
            <textarea id="logContentInput" placeholder="写点什么..."></textarea>
            <div class="modal_buttons">
                <button class="cancel_btn" id="cancelModalBtn">取消</button>
                <button class="save_btn" id="saveModalBtn">保存</button>
            </div>
        </div>
    </div>
</dialog>
<script src="js/index/log.js"></script>
</body>
</html>
