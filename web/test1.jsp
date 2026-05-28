<%--
  Created by IntelliJ IDEA.
  User: hyb
  Date: 2026/5/14
  Time: 12:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>原生dialog上下错开</title>
    <style>
        /* ========== 原有 CSS 完全保留，未作任何修改 ========== */
        button, .arrow_btn, .add_btn, .modal_buttons button {
            user-select: none;
            -webkit-user-select: none;  /* Safari 兼容 */
            cursor: pointer;            /* 保持点击手感 */
        }

        dialog {
            border-radius: 12px;
            border: none;
            box-shadow: 0 5px 20px rgba(0,0,0,0.2);
            position: fixed;
            margin: 0;
            left: 50%;
            transform: translateX(-50%);
        }

        #show_log {
            top: 10%;
        }

        .log_viewer {
            width: 400px;
            max-width: 80vw;
            padding: 16px;
        }

        .log_header {
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            margin-bottom: 20px;
            font-size: 0.9rem;
            color: #334155;
            border-bottom: 1px solid #e2e8f0;
            padding-bottom: 8px;
        }
        .log_time_display {
            font-weight: 600;
            font-size: 1rem;
        }
        .log_counter {
            background: #f1f5f9;
            padding: 2px 8px;
            border-radius: 20px;
            font-size: 0.8rem;
        }

        .log_body {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
        }
        .arrow_btn {
            background: #f1f5f9;
            border: none;
            font-size: 1.5rem;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            cursor: pointer;
            transition: 0.2s;
        }
        .arrow_btn:hover {
            background: #cbd5e1;
        }
        .arrow_btn:active {
            transform: scale(0.95);
        }
        .log_content_preview {
            flex: 1;
            background: #f8fafc;
            border-radius: 16px;
            padding: 16px;
            min-height: 120px;
            word-wrap: break-word;
            white-space: pre-wrap;
            font-size: 0.95rem;
            line-height: 1.4;
        }

        .log_actions {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            border-top: 1px solid #e2e8f0;
            padding-top: 16px;
        }
        .add_btn {
            padding: 6px 16px;
            border-radius: 40px;
            border: none;
            background-color: #3b82f6;
            color: white;
            cursor: pointer;
        }
        .add_btn.secondary {
            background-color: #e2e8f0;
            color: #1e293b;
        }

        #edit_log {
            top: 30%;
            height:50%;
        }

        .modal_overlay {
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }
        .edit_modal {
            background: white;
            border-radius: 28px;
            width: 500px;
            max-width: 90%;
            padding: 24px;
        }

        .edit_modal h3 {
            margin-top: 0;
            margin-bottom: 18px;
            font-size: 1.5rem;
            font-weight: 600;
        }

        .edit_modal label {
            font-weight: 500;
            display: block;
            margin: 12px 0 6px;
            color: #0f172a;
        }
        .edit_modal input, .edit_modal textarea {
            width: 90%;
            padding: 10px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 16px;
            font-family: inherit;
            font-size: 0.95rem;
            transition: 0.2s;
        }
        .edit_modal input:focus, .edit_modal textarea:focus {
            outline: none;
            border-color: #3b82f6;
        }

        .edit_modal textarea {
            min-height: 100px;
            resize: vertical;
        }

        .modal_buttons {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 50px;
        }

        .modal_buttons button {
            padding: 8px 20px;
            border-radius: 40px;
            border: none;
            font-weight: 500;
            cursor: pointer;
            transition: 0.2s;
        }

        .save_btn {
            background-color: #3b82f6;
            color: white;
        }

        .save_btn:hover {
            background-color: #2563eb;
        }

        .cancel_btn {
            background-color: #e2e8f0;
            color: #1e293b;
        }

        .cancel_btn:hover {
            background-color: #cbd5e1;
        }

        dialog .arrow_btn:focus {
            outline: none !important;
            box-shadow: none !important;
        }

        dialog .arrow_btn:focus-visible {
            outline: 2px solid #3b82f6 !important;
            outline-offset: 2px !important;
            box-shadow: none !important;
        }
    </style>
</head>
<body>
<a href="test2.jsp">这里是第一个网站</a>
<button type="button" id="mg_log">展示日志</button>

<dialog id="show_log">
    <div class="log_viewer">
        <div class="log_header">
            <span class="log_time_display">暂无日志</span>
            <button type="button" class="arrow_btn left_arrow">◀</button>
            <span class="log_counter">0 / 0</span>
            <button type="button" class="arrow_btn right_arrow">▶</button>
        </div>
        <div class="log_body">
            <div class="log_content_preview">
                这里展示日志正文内容
            </div>
        </div>
        <div class="log_actions">
            <button type="button" id="add_log" class="add_btn">添加日志</button>
            <button type="button" id="closeshowlog" class="add_btn secondary">关闭本弹窗</button>
            <button type="button" id="delete_current_log" class="add_btn secondary">删除当前日志</button>
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
                <button type="button" class="cancel_btn" id="cancelModalBtn">取消</button>
                <button type="button" class="save_btn" id="saveModalBtn">保存</button>
            </div>
        </div>
    </div>
</dialog>

<script>
    (function() {
        // DOM
        const show_log = document.getElementById('show_log');
        const edit_log = document.getElementById('edit_log');
        const mg_log = document.getElementById('mg_log');
        const add_log = document.getElementById('add_log');
        const closeshowlog = document.getElementById('closeshowlog');
        const cancelModalBtn = document.getElementById('cancelModalBtn');
        const saveModalBtn = document.getElementById('saveModalBtn');

        const logTimeDisplay = document.querySelector('.log_time_display');
        const logContentPreview = document.querySelector('.log_content_preview');
        const logCounter = document.querySelector('.log_counter');
        const leftArrow = document.querySelector('.left_arrow');
        const rightArrow = document.querySelector('.right_arrow');

        const logTimeInput = document.getElementById('logTimeInput');
        const logContentInput = document.getElementById('logContentInput');

        // 数据来自数据库：每条 { id, time, content }
        // time: "yyyy-MM-dd HH:mm:ss.SSS"（来自后端 DTO）
        let logsData = [];
        let currentLogIndex = 0;

        // ========== API 地址（同目录拼接，适配 contextPath）==========
        const BASE = (location.pathname.replace(/\/[^\/]*$/, ''));
        const LOGS_API = BASE + '/logs';

        // 草稿接口候选（保持原逻辑）
        const DRAFT_API_CANDIDATES = [
            BASE + '/draft',
            BASE + '/DraftServlet'
        ];
        let DRAFT_API = null;

        // ========== 渲染 ==========
        function renderCurrentLog() {
            if (!Array.isArray(logsData) || logsData.length === 0) {
                if (logTimeDisplay) logTimeDisplay.textContent = '暂无日志';
                if (logContentPreview) logContentPreview.textContent = '没有日志，请点击"添加日志"添加';
                if (logCounter) logCounter.textContent = '0 / 0';
                return;
            }

            if (currentLogIndex >= logsData.length) currentLogIndex = logsData.length - 1;
            if (currentLogIndex < 0) currentLogIndex = 0;

            const log = logsData[currentLogIndex];
            if (!log) return;

            // 统一展示到秒：yyyy-MM-dd HH:mm:ss
            const timeShow = (log.time ? String(log.time).substring(0, 19) : "未知时间");
            logTimeDisplay.textContent = timeShow;
            logContentPreview.textContent = log.content || "";
            logCounter.textContent = (currentLogIndex + 1) + " / " + logsData.length;
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

        // ========== /logs 数据库接口 ==========
        async function loadLogsFromDb() {
            const r = await fetch(LOGS_API + "?limit=200&offset=0", { credentials: 'same-origin' });
            if (!r.ok) throw new Error("读取日志失败");

            const arr = await r.json();
            logsData = (Array.isArray(arr) ? arr : []).map(item => ({
                id: item && item.id != null ? item.id : null,
                time: item && item.time != null ? String(item.time) : null,       // "yyyy-MM-dd HH:mm:ss.SSS"
                content: item && item.content != null ? String(item.content) : ""
            }));

            currentLogIndex = 0;
            renderCurrentLog();
        }

        async function saveLogToDb(timeValue, contentValue) {
            const payload = {
                time: timeValue || null,      // datetime-local: "yyyy-MM-ddTHH:mm:ss"
                content: contentValue || ""
            };

            const r = await fetch(LOGS_API, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json;charset=UTF-8' },
                body: JSON.stringify(payload),
                credentials: 'same-origin'
            });

            if (!r.ok) {
                let msg = "保存失败";
                try {
                    const data = await r.json();
                    if (data && data.error) msg = msg + ": " + data.error;
                } catch (_) {}
                throw new Error(msg);
            }
            return await r.json(); // {ok:true,id:...}
        }

        async function deleteLogFromDb(id) {
            if (!id) throw new Error("无法删除：缺少 id");

            const url = LOGS_API + "?id=" + encodeURIComponent(id);
            const r = await fetch(url, { method: 'DELETE', credentials: 'same-origin' });
            if (!r.ok) throw new Error("删除失败");
            return await r.json(); // {ok:true/false}
        }

        async function deleteCurrentLog() {
            if (!logsData.length) return;

            const currentLog = logsData[currentLogIndex];
            const timeShow = currentLog && currentLog.time ? String(currentLog.time).substring(0, 19) : "未知时间";
            const contentPreview = currentLog && currentLog.content ? currentLog.content.substring(0, 50) : "";
            const previewSuffix = (currentLog && currentLog.content && currentLog.content.length > 50) ? "…" : "";
            const confirmMsg = "确定要删除这条日志吗？\n时间：" + timeShow + "\n正文预览：" + contentPreview + previewSuffix;
            if (!confirm(confirmMsg)) return;

            try {
                await deleteLogFromDb(currentLog.id);
                await loadLogsFromDb();
            } catch (e) {
                alert(e && e.message ? e.message : "删除失败");
            }
        }

        // ========== 草稿接口（/draft） ==========
        async function detectDraftApi() {
            for (const url of DRAFT_API_CANDIDATES) {
                try {
                    const r = await fetch(url, { method: 'GET', credentials: 'same-origin' });
                    if (r.ok) return url;
                } catch (_) {}
            }
            return DRAFT_API_CANDIDATES[0];
        }

        async function saveDraft() {
            if (!DRAFT_API) DRAFT_API = await detectDraftApi();

            const payload = {
                time: logTimeInput.value || null,
                content: logContentInput.value || ""
            };

            await fetch(DRAFT_API, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json;charset=UTF-8' },
                body: JSON.stringify(payload),
                credentials: 'same-origin'
            });
        }

        async function loadDraftToInputs() {
            if (!DRAFT_API) DRAFT_API = await detectDraftApi();

            const r = await fetch(DRAFT_API, { credentials: 'same-origin' });
            if (!r.ok) return;

            const data = await r.json();
            if (data && data.time != null) logTimeInput.value = data.time;
            if (data && data.content != null) logContentInput.value = data.content;
        }

        async function deleteDraft() {
            if (!DRAFT_API) DRAFT_API = await detectDraftApi();
            try {
                const response = await fetch(DRAFT_API, {
                    method: 'DELETE',
                    headers: { 'Content-Type': 'application/json;charset=UTF-8' },
                    credentials: 'same-origin'
                });
                return response.ok;
            } catch (_) {
                return false;
            }
        }

        // ========== 事件绑定 ==========
        if (leftArrow) leftArrow.addEventListener('click', prevLog);
        if (rightArrow) rightArrow.addEventListener('click', nextLog);

        if (mg_log) {
            mg_log.addEventListener('click', async () => {
                show_log.showModal();
                try {
                    await loadLogsFromDb(); // 每次打开都刷新
                } catch (_) {
                    renderCurrentLog();
                    alert("读取日志失败（请检查 /logs 接口或数据库连接）");
                }
            });
        }

        if (add_log) {
            add_log.addEventListener('click', async () => {
                await loadDraftToInputs();
                edit_log.showModal();
            });
        }

        if (closeshowlog) {
            closeshowlog.addEventListener('click', () => show_log.close());
        }

        if (cancelModalBtn) {
            cancelModalBtn.addEventListener('click', () => edit_log.close());
        }

        // 保存：写库 -> 清草稿 -> 清输入 -> 关闭 -> 刷新列表
        if (saveModalBtn) {
            saveModalBtn.addEventListener('click', async () => {
                const newTime = logTimeInput.value;
                const newContent = logContentInput.value;

                if (!newTime || !newContent.trim()) {
                    alert("请填写完整的时间和正文内容");
                    return;
                }

                try {
                    await saveLogToDb(newTime, newContent.trim());
                    await deleteDraft();

                    logTimeInput.value = '';
                    logContentInput.value = '';

                    edit_log.close();

                    if (show_log.open) {
                        await loadLogsFromDb();
                    }
                } catch (e) {
                    alert(e && e.message ? e.message : "保存失败");
                }
            });
        }

        const deleteLogBtn = document.getElementById('delete_current_log');
        if (deleteLogBtn) {
            deleteLogBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                deleteCurrentLog();
            });
        }

        // 输入时自动保存草稿（防止跳转/刷新丢失）
        let draftTimer = null;
        function scheduleDraftSave() {
            clearTimeout(draftTimer);
            draftTimer = setTimeout(() => {
                saveDraft().catch(() => {});
            }, 350);
        }
        logTimeInput.addEventListener('input', scheduleDraftSave);
        logContentInput.addEventListener('input', scheduleDraftSave);

        // 点击同域链接前：强制保存一次草稿
        document.addEventListener('click', async (e) => {
            const a = e.target.closest && e.target.closest('a');
            if (!a) return;

            const href = a.getAttribute('href');
            if (!href || href.startsWith('#') || href.startsWith('javascript:')) return;

            let url;
            try { url = new URL(href, location.href); } catch (_) { return; }
            if (url.origin !== location.origin) return;

            e.preventDefault();
            try { await saveDraft(); } catch (_) {}
            location.href = url.href;
        }, true);

        // 兜底：刷新/关闭页面前，用 sendBeacon 尽量保存一次草稿
        window.addEventListener('beforeunload', () => {
            if (!DRAFT_API) return;
            try {
                const payload = JSON.stringify({
                    time: logTimeInput.value || null,
                    content: logContentInput.value || ""
                });
                const blob = new Blob([payload], { type: 'application/json;charset=UTF-8' });
                navigator.sendBeacon(DRAFT_API, blob);
            } catch (_) {}
        });

        // 初始渲染
        renderCurrentLog();
    })();
</script>
</body>
</html>