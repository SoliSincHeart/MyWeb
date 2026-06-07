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