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
    <style>

    </style>
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

<script>

    let logsData = [];
    let currentLogIndex = 0;

    const show_log = document.getElementById('show_log');
    const edit_log = document.getElementById('edit_log');
    const mg_log = document.getElementById('mg_log');
    const openedit_log = document.getElementById('openedit_log');
    const closeFirstBtn = document.getElementById('closeFirstDialog');
    const cancelModalBtn = document.getElementById('cancelModalBtn');
    const saveModalBtn = document.getElementById('saveModalBtn');
    const logTimeDisplay = document.querySelector('.log_time_display');
    const logContentPreview = document.querySelector('.log_content_preview');
    const logCounter = document.querySelector('.log_counter');
    const leftArrow = document.querySelector('.left_arrow');
    const rightArrow = document.querySelector('.right_arrow');
    const logTimeInput = document.getElementById('logTimeInput');
    const logContentInput = document.getElementById('logContentInput');

    async function loadLogs() {
        try {
            const response = await fetch('/draft', { method: 'GET' });
            if (!response.ok) throw new Error('加载失败');
            const data = await response.json();
            logsData = data;
            currentLogIndex = logsData.length > 0 ? 0 : -1;
            renderCurrentLog();
        } catch (err) {
            console.error(err);
            logsData = [];
            renderCurrentLog();
        }
    }

    async function saveLogToBackend(time, content) {
        try {
            const response = await fetch('/draft', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ time, content })
            });
            if (!response.ok) throw new Error('保存失败');
            const updatedLogs = await response.json();
            logsData = updatedLogs;
            currentLogIndex = 0;
            renderCurrentLog();
            return true;
        } catch (err) {
            alert('保存失败：' + err.message);
            return false;
        }
    }

    function renderCurrentLog() {
        if (!logsData.length) {
            logTimeDisplay.textContent = '暂无日志';
            logContentPreview.textContent = '没有日志，请点击"打开第二个弹窗"添加';
            logCounter.textContent = '0 / 0';
            return;
        }
        if (currentLogIndex >= logsData.length) currentLogIndex = logsData.length - 1;
        if (currentLogIndex < 0) currentLogIndex = 0;
        const log = logsData[currentLogIndex];
        const formattedTime = log.time.replace('T', ' ');
        logTimeDisplay.textContent = formattedTime;
        logContentPreview.textContent = log.content;
        logCounter.textContent = `${currentLogIndex + 1} / ${logsData.length}`;
    }

    function prevLog() {
        if (!logsData.length) return;
        currentLogIndex = (currentLogIndex - 1 + logsData.length) % logsData.length;
        renderCurrentLog();
    }
    function nextLog() {
        if (!logsData.length) return;
        currentLogIndex = (currentLogIndex + 1) % logsData.length;
        renderCurrentLog();
    }

    leftArrow.addEventListener('click', prevLog);
    rightArrow.addEventListener('click', nextLog);

    mg_log.addEventListener('click', () => {
        show_log.showModal();
        loadLogs();
    });
    openedit_log.addEventListener('click', () => edit_log.showModal());
    closeFirstBtn.addEventListener('click', () => show_log.close());
    cancelModalBtn.addEventListener('click', () => edit_log.close());

    saveModalBtn.addEventListener('click', async () => {
        const time = logTimeInput.value;
        const content = logContentInput.value;
        if (!time || !content.trim()) {
            alert('请填写时间和内容');
            return;
        }
        const ok = await saveLogToBackend(time, content);
        if (ok) {
            logContentInput.value = '';
            edit_log.close();

            if (show_log.open) {
            }
        }
    });

    loadLogs();
</script>
</body>
</html>
