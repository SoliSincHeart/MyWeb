<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>Dialog日志同步演示 test1</title>
    <link rel="stylesheet" href="css/log.css">
    <style>
        dialog {
            border-radius: 12px;
            border: none;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            position: fixed;
            margin: 0;
            left: 50%;
            transform: translateX(-50%);
        }
        #show_log { top: 10%; }
        .log_viewer { width: 400px; max-width: 80vw; padding: 16px; }
        .log_header {
            display: flex; justify-content: space-between; align-items: baseline;
            margin-bottom: 20px; font-size: 0.9rem; color: #334155;
            border-bottom: 1px solid #e2e8f0; padding-bottom: 8px;
        }
        .log_time_display, .log_counter, .log_content_preview {
            outline: none !important;
            user-select: text;
            cursor: default;
        }
        .log_time_display:focus, .log_counter:focus, .log_content_preview:focus {
            outline: none;
        }
        .log_body { display: flex; align-items: center; gap: 12px; margin-bottom: 24px; }
        .arrow_btn {
            background: #f1f5f9; border: none; font-size: 1.5rem; width: 36px; height: 36px;
            border-radius: 50%; cursor: pointer; transition: 0.2s;
        }
        .arrow_btn:hover { background: #cbd5e1; }
        .arrow_btn:active { transform: scale(0.95); }
        .log_content_preview {
            flex: 1; background: #f8fafc; border-radius: 16px; padding: 16px; min-height: 120px;
            word-wrap: break-word; white-space: pre-wrap; font-size: 0.95rem; line-height: 1.4;
        }
        .log_actions {
            display: flex; justify-content: flex-end; gap: 12px; border-top: 1px solid #e2e8f0; padding-top: 16px;
        }
        .action_btn { padding: 6px 16px; border-radius: 40px; border: none; background-color: #3b82f6; color: white; cursor: pointer; }
        .action_btn.secondary { background-color: #e2e8f0; color: #1e293b; }
        #edit_log { top: 30%; height: 50%; }
        .modal_overlay { top: 0; left: 0; width: 100%; height: 100%; justify-content: center; align-items: center; z-index: 1000; }
        .edit_modal { background: white; border-radius: 28px; width: 500px; max-width: 90%; padding: 24px; }
        .edit_modal h3 { margin-top: 0; margin-bottom: 18px; font-size: 1.5rem; font-weight: 600; }
        .edit_modal label { font-weight: 500; display: block; margin: 12px 0 6px; color: #0f172a; }
        .edit_modal input, .edit_modal textarea {
            width: 90%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 16px;
            font-family: inherit; font-size: 0.95rem; transition: 0.2s;
        }
        .edit_modal input:focus, .edit_modal textarea:focus { outline: none; border-color: #3b82f6; }
        .edit_modal textarea { min-height: 100px; resize: vertical; }
        .modal_buttons { display: flex; justify-content: flex-end; gap: 12px; margin-top: 50px; }
        .modal_buttons button { padding: 8px 20px; border-radius: 40px; border: none; font-weight: 500; cursor: pointer; transition: 0.2s; }
        .save_btn { background-color: #3b82f6; color: white; }
        .save_btn:hover { background-color: #2563eb; }
        .cancel_btn { background-color: #e2e8f0; color: #1e293b; }
        .cancel_btn:hover { background-color: #cbd5e1; }
    </style>
</head>
<body>
<a href="test2.jsp">这里是test1（点击切换页面）</a>
<button id="mg_log">管理日志</button>
<dialog id="show_log">
    <div class="log_viewer">
        <div class="log_header">
            <span class="log_time_display" tabindex="-1">暂无日志</span>
            <button class="arrow_btn left_arrow">◀</button>
            <span class="log_counter" tabindex="-1">0 / 0</span>
            <button class="arrow_btn right_arrow">▶</button>
        </div>
        <div class="log_body">
            <div class="log_content_preview" tabindex="-1">
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
    // 日志数据和本地操作
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

    // 日志数据
    let logsData = [
        {
            time: "2026-05-09T14:30:00",
            content: "今天初次实现了原生dialog上下错开，样式用下划线命名统一。"
        },
        {
            time: "2026-05-08T09:15:00",
            content: "解决弹窗联动中的数据同步问题，使用数据驱动视图。"
        }
    ];
    let currentLogIndex = 0;

    function renderCurrentLog() {
        if (!logsData.length) {
            logTimeDisplay.textContent = '暂无日志';
            logContentPreview.textContent = '没有日志，请点击"打开第二个弹窗"添加';
            logCounter.textContent = '0 / 0';
            document.activeElement.blur();
            return;
        }
        if (currentLogIndex >= logsData.length) currentLogIndex = logsData.length - 1;
        if (currentLogIndex < 0) currentLogIndex = 0;
        const log = logsData[currentLogIndex];
        const formattedTime = log.time.replace('T', ' ');
        logTimeDisplay.textContent = formattedTime;
        logContentPreview.textContent = log.content;
        logCounter.textContent = `${currentLogIndex + 1} / ${logsData.length}`;
        document.activeElement.blur();
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
    function addNewLog(timeValue, contentValue) {
        if (!timeValue || !contentValue.trim()) {
            alert("请填写完整的时间和正文内容");
            return false;
        }
        logsData.unshift({
            time: timeValue,
            content: contentValue.trim()
        });
        currentLogIndex = 0;
        if (show_log.open) renderCurrentLog();
        return true;
    }
    leftArrow.addEventListener('click', prevLog);
    rightArrow.addEventListener('click', nextLog);
    mg_log.addEventListener('click', () => {
        show_log.showModal();
        renderCurrentLog();
    });
    closeFirstBtn.addEventListener('click', () => {
        show_log.close();
    });

    // 后端 session 草稿自动化
    let draftTimer = null;
    function debounceSaveDraft() {
        clearTimeout(draftTimer);
        draftTimer = setTimeout(() => {
            saveDraftToServer().catch(err => console.error("saveDraftToServer failed:", err));
        }, 300);
    }
    async function saveDraftToServer() {
        const time = logTimeInput.value || "";
        const content = logContentInput.value || "";
        if (!time && !content.trim()) return;
        await fetch("draft", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ time, content })
        });
    }
    async function loadDraftFromServer() {
        const res = await fetch("draft", { method: "GET" });
        if (!res.ok) return;
        const data = await res.json();
        if (!data) return;
        if (typeof data.time === "string" && data.time) logTimeInput.value = data.time;
        if (typeof data.content === "string" && data.content) logContentInput.value = data.content;
    }
    async function clearDraftOnServer() {
        await fetch("draft", { method: "DELETE" });
    }
    logTimeInput.addEventListener("input", debounceSaveDraft);
    logContentInput.addEventListener("input", debounceSaveDraft);

    // 打开编辑弹窗时，拉取草稿
    openedit_log.addEventListener('click', async () => {
        await loadDraftFromServer();
        edit_log.showModal();
        setTimeout(() => logContentInput.focus(), 0);
    });
    cancelModalBtn.addEventListener('click', () => {
        edit_log.close();
    });

    saveModalBtn.addEventListener('click', async () => {
        const time = logTimeInput.value;
        const content = logContentInput.value;

        if (!time || !content.trim()) {
            alert('请填写时间和内容');
            return;
        }
        addNewLog(time, content);
        logTimeInput.value = "";
        logContentInput.value = "";
        await clearDraftOnServer();
        edit_log.close();
    });

    renderCurrentLog();
</script>
</body>
</html>