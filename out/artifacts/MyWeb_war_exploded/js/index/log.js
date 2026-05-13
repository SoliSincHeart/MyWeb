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
