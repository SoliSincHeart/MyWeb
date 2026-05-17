
<%--
  Created by IntelliJ IDEA.
  User: hyb
  Date: 2026/5/14
  Time: 12:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>原生dialog上下错开</title>
  <style>
    /* ========== 原有 CSS 完全保留，未作任何修改 ========== */
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
    .action_btn {
      padding: 6px 16px;
      border-radius: 40px;
      border: none;
      background-color: #3b82f6;
      color: white;
      cursor: pointer;
    }
    .action_btn.secondary {
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
    /* 动画未实现 */
    /* 		@keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(12px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            } */

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
    /*	标题和正文 */
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



  </style>
</head>
<body>
<a href="test55.html">这里是第一个网站</a>
<!-- 关键修复：为按钮添加 type="button" 避免表单提交或焦点移动 -->
<button type="button" id="mg_log">随身日志</button>

<dialog id="show_log">
  <div class="log_viewer">
    <div class="log_header">
      <span class="log_time_display">暂无日志</span>
      <!-- 为左右箭头添加 type="button" -->
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
      <!-- 为按钮添加 type="button" -->
      <button type="button" id="add_log" class="action_btn">添加日志</button>
      <button type="button" id="closeFirstDialog" class="action_btn secondary">关闭本弹窗</button>
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
        <!-- 为模态框按钮添加 type="button" -->
        <button type="button" class="cancel_btn" id="cancelModalBtn">取消</button>
        <button type="button" class="save_btn" id="saveModalBtn">保存</button>
      </div>
    </div>
  </div>
</dialog>

<script>
  // ========== 修复：使用 IIFE 隔离作用域，防止 JSP 环境全局污染 ==========
  (function() {
    // DOM 元素
    const show_log = document.getElementById('show_log');
    const edit_log = document.getElementById('edit_log');
    const mg_log = document.getElementById('mg_log');
    const add_log = document.getElementById('add_log');
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

    // 数据（内存存储）- 确保是数组且不被外部覆盖
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

    // ====== 渲染函数（增强防御，修复计数显示异常） ======
    function renderCurrentLog() {
      // 防御：确保 logsData 是数组且长度有效
      if (!Array.isArray(logsData) || logsData.length === 0) {
        if (logTimeDisplay) logTimeDisplay.textContent = '暂无日志';
        if (logContentPreview) logContentPreview.textContent = '没有日志，请点击"添加日志"添加';
        if (logCounter) logCounter.textContent = '0 / 0';
        return;
      }

      // 边界保护
      if (currentLogIndex >= logsData.length) currentLogIndex = logsData.length - 1;
      if (currentLogIndex < 0) currentLogIndex = 0;

      const log = logsData[currentLogIndex];
      if (!log) return;

      const formattedTime = log.time.replace('T', ' ');
      logTimeDisplay.textContent = formattedTime;
      logContentPreview.textContent = log.content;
      // 关键修复：确保分母显示正确（logsData.length 一定存在）
      logCounter.textContent = `${currentLogIndex + 1} / ${logsData.length}`;
    }

    // ====== 切换 ======
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

    // ====== 添加新日志 ======
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

    // ====== 事件绑定（所有按钮均已添加 type="button"） ======
    if (leftArrow) leftArrow.addEventListener('click', prevLog);
    if (rightArrow) rightArrow.addEventListener('click', nextLog);

    if (saveModalBtn) {
      saveModalBtn.addEventListener('click', () => {
        const newTime = logTimeInput.value;
        const newContent = logContentInput.value;
        if (addNewLog(newTime, newContent)) {
          edit_log.close();
          if (show_log.open) renderCurrentLog();
        }
      });
    }

    if (mg_log) {
      mg_log.addEventListener('click', () => {
        show_log.showModal();
        renderCurrentLog();
      });
    }

    if (add_log) {
      add_log.addEventListener('click', () => {
        edit_log.showModal();
      });
    }

    if (closeFirstBtn) {
      closeFirstBtn.addEventListener('click', () => {
        show_log.close();
      });
    }

    if (cancelModalBtn) {
      cancelModalBtn.addEventListener('click', () => {
        edit_log.close();
      });
    }

    // 初始渲染
    renderCurrentLog();
  })();   // IIFE 结束
</script>
</body>
</html>