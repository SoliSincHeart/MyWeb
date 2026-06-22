<%--
  Created by IntelliJ IDEA.
  User: hyb
  Date: 2026/5/14
  Time: 12:36
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>cover + login-card 同步缩放并锚定</title>
  <!-- Font Awesome 6 (免费图标库) -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />

  <style>
    /* ===== 新增：防止非输入元素的文本选中和多余光标 ===== */
    html, body, .stage, .login-card, .form-wrapper, .footer-note,
    button, .btn, .switch-text, .arrow_btn, .action_btn, #mg_log,
    .form-title, .log-preview-time, .log-preview-body, .log-count-badge,
    .remember-me, .forgot-password, .footer-note span {
      user-select: none;
      -webkit-user-select: none;
      -moz-user-select: none;
      -ms-user-select: none;
      cursor: default;
    }

    input, textarea {
      user-select: text;
      -webkit-user-select: text;
      cursor: text;
    }

    button, .btn, .switch-text, .arrow_btn, .action_btn, #mg_log {
      cursor: pointer;
    }

    button:focus, .btn:focus, .switch-text:focus, .arrow_btn:focus, .action_btn:focus, #mg_log:focus {
      outline: none;
    }

    /* ===== 全局重置 ===== */
    html,
    body {
      margin: 0;
      padding: 0;
      width: 100vw;
      height: 100vh;
      overflow-x: auto;
    }

    /* ===== 舞台：撑满视口，可滚动 ===== */
    .stage {
      position: relative;
      width: 100vw;
      height: 100vh;
      min-height: 100vh;
      overflow: hidden;
    }

    /* ===== 背景图：cover 居中顶对齐 ===== */
    .stage img {
      position: absolute;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      object-fit: cover;
      object-position: center top;
      display: block;
      z-index: -1;
      user-select: none;
      -webkit-user-drag: none;
    }

    /* ================================================================
           ★ 日志预览框 — 与 login-card 完全一致的锚定方式 ★
           ================================================================ */
    #logPreviewBox {
      position: absolute;
      transform-origin: 0 0;
      will-change: transform, left, top;
      z-index: 20;
      width: 280px;
      background: rgba(255, 255, 255, 0.12);
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
      border-radius: 20px;
      border: 1px solid rgba(255, 255, 255, 0.25);
      box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
      padding: 16px 18px 14px 18px;
      pointer-events: auto;
      color: #f0f3fa;
      text-shadow: 0 1px 3px rgba(0, 0, 0, 0.25);
      user-select: none;
    }

    #logPreviewBox:hover {
      background: rgba(255, 255, 255, 0.18);
      box-shadow: 0 12px 40px rgba(0, 0, 0, 0.35);
    }

    .log-preview-time {
      display: block;
      font-size: 12px;
      font-weight: 500;
      opacity: 0.8;
      letter-spacing: 0.5px;
      margin-bottom: 4px;
      color: #eef2ff;
    }

    .log-preview-body {
      font-size: 14px;
      line-height: 1.5;
      font-weight: 400;
      color: #ffffff;
      display: -webkit-box;
      -webkit-line-clamp: 3;
      -webkit-box-orient: vertical;
      overflow: hidden;
      text-overflow: ellipsis;
      min-height: 42px;
      max-height: 63px;
      word-break: break-word;
      margin-bottom: 10px;
    }

    .log-preview-footer {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      gap: 10px;
      border-top: 1px solid rgba(255, 255, 255, 0.15);
      padding-top: 10px;
    }

    .log-preview-footer .log-count-badge {
      font-size: 11px;
      opacity: 0.6;
      color: #eef2ff;
      font-weight: 400;
      letter-spacing: 0.3px;
    }

    #mg_log {
      background: rgba(255, 255, 255, 0.15);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 40px;
      padding: 4px 14px;
      font-size: 13px;
      font-weight: 500;
      font-family: 'Inter', sans-serif;
      color: #fff;
      cursor: pointer;
      transition: background 0.25s ease, border-color 0.25s ease, color 0.25s ease;
      backdrop-filter: blur(4px);
      letter-spacing: 0.3px;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
      white-space: nowrap;
      transform: none !important;
    }

    #mg_log:hover {
      background: rgba(255, 255, 255, 0.28);
      border-color: rgba(255, 255, 255, 0.4);
      color: #ffe69e;
    }

    #mg_log:active {
      transform: scale(0.95) !important;
    }

    /* ========================= 日志弹窗（完整功能） ========================= */
    dialog {
      border-radius: 20px;
      border: 2px solid rgba(255, 255, 255, 0.4);
      box-shadow: 0 20px 60px rgba(0, 0, 0, 0.35);
      position: fixed;
      margin: 0;
      left: 50%;
      transform: translateX(-50%);
      background: rgba(255, 255, 255, 0.97);
      backdrop-filter: blur(8px);
      padding: 0;
      z-index: 100;
    }

    #show_log {
      top: 10%;
    }

    .log_viewer {
      width: 400px;
      max-width: 80vw;
      padding: 20px 22px 18px 22px;
    }

    .log_header {
      display: flex;
      justify-content: space-between;
      align-items: baseline;
      margin-bottom: 16px;
      font-size: 0.9rem;
      color: #334155;
      border-bottom: 1px solid #e2e8f0;
      padding-bottom: 10px;
      flex-wrap: wrap;
      gap: 6px;
    }

    .log_time_display {
      font-weight: 600;
      font-size: 1rem;
      color: #1e293b;
    }

    .log_counter {
      background: #f1f5f9;
      padding: 2px 10px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 500;
      color: #475569;
    }

    .arrow_btn {
      background: #f1f5f9;
      border: none;
      font-size: 1.2rem;
      width: 32px;
      height: 32px;
      border-radius: 50%;
      cursor: pointer;
      transition: 0.2s;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      color: #334155;
    }

    .arrow_btn:hover {
      background: #cbd5e1;
    }

    .arrow_btn:active {
      transform: scale(0.92);
    }

    .log_body {
      display: flex;
      align-items: stretch;
      gap: 10px;
      margin-bottom: 20px;
      min-height: 130px;
    }

    .log_content_preview {
      flex: 1;
      background: #f8fafc;
      border-radius: 16px;
      padding: 16px 18px;
      min-height: 120px;
      word-wrap: break-word;
      white-space: pre-wrap;
      font-size: 0.95rem;
      line-height: 1.5;
      color: #0f172a;
      border: 1px solid #e9edf2;
    }

    .log_actions {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      border-top: 1px solid #e2e8f0;
      padding-top: 14px;
      flex-wrap: wrap;
    }

    .action_btn {
      padding: 6px 18px;
      border-radius: 40px;
      border: none;
      background-color: #3b82f6;
      color: white;
      cursor: pointer;
      font-size: 0.85rem;
      font-weight: 500;
      transition: 0.2s;
      font-family: 'Inter', sans-serif;
    }

    .action_btn:hover {
      background-color: #2563eb;
      transform: translateY(-1px);
    }

    .action_btn.secondary {
      background-color: #e2e8f0;
      color: #1e293b;
    }

    .action_btn.secondary:hover {
      background-color: #cbd5e1;
    }

    /* ===== 编辑日志弹窗 ===== */
    #edit_log {
      top: 25%;
      max-height: 80vh;
      overflow-y: auto;
    }

    .edit_modal {
      background: white;
      border-radius: 28px;
      width: 500px;
      max-width: 92vw;
      padding: 28px 30px 24px 30px;
    }

    .edit_modal h3 {
      margin-top: 0;
      margin-bottom: 20px;
      font-size: 1.5rem;
      font-weight: 600;
      color: #0f172a;
    }

    .edit_modal label {
      font-weight: 500;
      display: block;
      margin: 14px 0 6px;
      color: #0f172a;
      font-size: 0.9rem;
    }

    .edit_modal input,
    .edit_modal textarea {
      border: 1.5px solid #d1d9e6;
      border-radius: 16px;
      font-family: 'Inter', sans-serif;
      font-size: 0.95rem;
      transition: 0.2s;
      display: block;
      width: 100%;
      box-sizing: border-box;
      padding: 10px 14px;
      margin: 0;
      background: #fafbfc;
    }

    .edit_modal input:focus,
    .edit_modal textarea:focus {
      outline: none;
      border-color: #3b82f6;
      background: #ffffff;
      box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
    }

    .edit_modal textarea {
      min-height: 110px;
      resize: vertical;
    }

    .modal_buttons {
      display: flex;
      justify-content: flex-end;
      gap: 12px;
      margin-top: 30px;
    }

    .modal_buttons button {
      padding: 8px 24px;
      border-radius: 40px;
      border: none;
      font-weight: 500;
      cursor: pointer;
      transition: 0.2s;
      font-size: 0.9rem;
      font-family: 'Inter', sans-serif;
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

    /* ===== 登录卡片 ===== */
    .login-card {
      position: absolute;
      width: 860px;
      height: 505px;
      background-image: url("resources/img/界面.png");
      background-repeat: no-repeat;
      background-size: 100% 100%;
      transform-origin: 0 0;
      will-change: transform, left, top;
      border: solid 2px red;
    }

    .form-login,
    .form-register {
      position: relative;
      width: 100%;
      height: 100%;
    }

    .form-wrapper {
      position: absolute;
      top: 12%;
      left: 30%;
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
      pointer-events: none;
      transform-origin: center center;
      transform: rotate(0.6deg);
    }

    .form-wrapper>* {
      pointer-events: auto;
      position: relative;
      left: 0;
      top: 0;
    }

    .form-title {
      font-size: 40px;
      font-weight: 700;
      color: #fff;
      text-shadow: 0 2px 12px rgba(0, 0, 0, 0.35);
      letter-spacing: 2px;
      margin: 0 0 20px 0;
      text-align: center;
      width: 100%;
      user-select: none;
    }

    .input-group {
      position: relative;
      width: 360px;
    }

    .input-group .input-icon {
      position: absolute;
      left: 1rem;
      top: 50%;
      transform: translateY(-50%);
      color: #a0a5ba;
      font-size: 1.05rem;
      transition: none;
      pointer-events: none;
      z-index: 1;
    }

    .login-card .field {
      position: relative;
      left: 0;
      top: 0;
      width: 100%;
      height: 48px;
      box-sizing: border-box;
      padding: 8px 12px 8px 2.8rem;
      margin: 10px 0px 10px 0rem;
      border: 1.5px solid rgba(0, 0, 0, .2);
      background: rgba(255, 255, 255, .92);
      border-radius: 1.5rem;
      font-size: 18px;
      outline: none;
      transition: border-color 0.25s ease, box-shadow 0.25s ease, background 0.25s ease;
    }

    .login-card .field:focus {
      border: 3px solid #ffe666;
      background: rgba(255, 255, 255, 0.98);
    }

    .login-card .field.user,
    .login-card .field.pass {
      top: auto;
    }

    .login-card .btn {
      position: relative;
      left: 0;
      top: 0;
      width: 360px;
      height: 46px;
      border: none;
      border-radius: 12px;
      background: linear-gradient(100deg, #667eea, #764ba2);
      color: #fff;
      font-size: 18px;
      font-weight: 600;
      cursor: pointer;
      transition: background 0.2s, transform 0.1s;
      letter-spacing: 2px;
      margin: 16px 0 0 0;
      border-radius: 2rem;
    }

    .login-card .btn:hover {
      filter: brightness(.90);
      transform: translateY(-1px);
    }

    .login-card .btn:active {
      transform: scale(0.99);
    }

    .form-extra {
      display: flex;
      align-items: center;
      justify-content: space-between;
      width: 102%;
      margin-top: 6px;
    }

    .remember-me {
      display: flex;
      align-items: center;
      gap: 6px;
      cursor: pointer;
      color: #eef2ff;
      font-size: 14px;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
      user-select: none;
    }

    .remember-me input[type="checkbox"] {
      width: 16px;
      height: 16px;
      accent-color: #1677ff;
      cursor: pointer;
      margin: 0;
    }

    .forgot-password {
      color: #ffd966;
      font-size: 14px;
      text-decoration: none;
      transition: color 0.2s, text-decoration 0.2s;
      text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
    }

    .forgot-password:hover {
      color: #ffe69e;
      text-decoration: underline;
    }

    .footer-note {
      position: absolute;
      bottom: 8%;
      left: 0;
      right: 0;
      text-align: center;
      font-size: 14px;
      color: #eef2ff;
      background: rgba(0, 0, 0, 0.30);
      padding: 10px 20px;
      border-radius: 60px;
      width: fit-content;
      margin: 0 auto;
      backdrop-filter: blur(6px);
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      pointer-events: auto;
      z-index: 10;
      transform-origin: center center;
      transform: rotate(0.6deg);
    }

    .footer-note span {
      opacity: 0.9;
    }

    .switch-text {
      background: none;
      border: none;
      color: #ffd966;
      font-weight: bold;
      font-size: 14px;
      cursor: pointer;
      padding: 4px 10px;
      border-radius: 30px;
      transition: 0.2s;
      font-family: inherit;
    }

    .switch-text:hover {
      text-decoration: underline;
      color: #ffe69e;
    }

    .switch-text:active {
      transform: scale(0.95);
    }

    .switch-text.guest:hover {
      opacity: 1;
      color: #ffe69e;
      text-decoration: underline;
    }

    .footer-divider {
      color: rgba(255, 255, 255, 0.25);
      margin: 0 2px;
      user-select: none;
    }

    .form-register {
      display: none;
    }
  </style>
</head>

<body>
<div class="stage" id="stage">
  <!-- 背景图 -->
  <img id="hero" src="resources/img/login.png" alt="login">

  <!-- ================================================================
  ★ 日志预览框 — 与 login-card 完全一致的锚定方式 ★
  ================================================================ -->
  <div id="logPreviewBox">
    <span class="log-preview-time" id="previewTime">📅 暂无日志</span>
    <div class="log-preview-body" id="previewContent">
      没有日志，请点击下方按钮添加
    </div>
    <div class="log-preview-footer">
      <span class="log-count-badge" id="previewCount">共 0 条</span>
      <button type="button" id="mg_log">📄 展示日志</button>
    </div>
  </div>

  <!-- ===== 日志弹窗（完整功能：查看全部、翻页、添加、删除） ===== -->
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
        <button type="button" id="add_log" class="action_btn">＋ 添加日志</button>
        <button type="button" id="delete_current_log" class="action_btn secondary">🗑 删除当前</button>
        <button type="button" id="closeshowlog" class="action_btn secondary">关闭</button>
      </div>
    </div>
  </dialog>

  <!-- ===== 编辑日志弹窗（添加/编辑） ===== -->
  <dialog id="edit_log">
    <div class="edit_modal">
      <h3 id="modalTitle">📝 编辑日志</h3>
      <label>📅 时间</label>
      <input type="datetime-local" id="logTimeInput" step="1">
      <label>📄 正文</label>
      <textarea id="logContentInput" placeholder="写点什么..."></textarea>
      <div class="modal_buttons">
        <button type="button" class="cancel_btn" id="cancelModalBtn">取消</button>
        <button type="button" class="save_btn" id="saveModalBtn">✅ 保存</button>
      </div>
    </div>
  </dialog>

  <!-- ===== 登录卡片 ===== -->
  <div class="login-card" id="card">

    <!-- 登录表单 -->
    <div id="loginForm" class="form-login">
      <form method="post" action="<%= request.getContextPath() %>/user">
        <div class="form-wrapper">
          <div class="form-title">欢迎回来</div>
          <!-- 隐藏字段，标识操作 -->
          <input type="hidden" name="action" value="login" />
          <div class="input-group">
            <i class="fas fa-envelope input-icon"></i>
            <input class="field user" id="loginEmail" name="email" placeholder="账号" autocomplete="username" />
          </div>
          <div class="input-group">
            <i class="fas fa-lock input-icon"></i>
            <input class="field pass" id="loginPassword" name="password" placeholder="密码" type="password" autocomplete="current-password" />
          </div>
          <div class="form-extra">
            <label class="remember-me">
              <input type="checkbox" name="rememberMe" />
              记住我
            </label>
            <a href="#" class="forgot-password">忘记密码？</a>
          </div>
          <button class="btn" type="submit">登录</button>
        </div>
      </form>
    </div>

    <!-- 注册表单 -->
    <div id="registerForm" class="form-register">
      <form method="post" action="<%= request.getContextPath() %>/user">
        <div class="form-wrapper">
          <div class="form-title">创建人生</div>
          <!-- 隐藏字段，标识操作 -->
          <input type="hidden" name="action" value="register" />
          <div class="input-group">
            <i class="fas fa-user input-icon"></i>
            <input class="field user" id="regUsername" name="username" placeholder="用户名" autocomplete="username" />
          </div>
          <div class="input-group">
            <i class="fas fa-envelope input-icon"></i>
            <input class="field user" id="regEmail" name="email" placeholder="邮箱号" autocomplete="email" />
          </div>
          <div class="input-group">
            <i class="fas fa-lock input-icon"></i>
            <input class="field pass" id="regPassword" name="password" placeholder="密码" type="password" autocomplete="new-password" />
          </div>
          <button class="btn" type="submit">注册</button>
        </div>
      </form>
    </div>

    <!-- ===== footer-note：切换面板 + 游客登录 ===== -->
    <div class="footer-note">
      <span id="footerHint">没有账号？</span>
      <button class="switch-text" id="switchFooterBtn">立即注册</button>
      <span class="footer-divider">|</span>
      <button class="switch-text guest" id="guestLoginBtn">游客登录</button>
    </div>

  </div>
  <!-- /login-card -->
</div>
<!-- /stage -->

<script>
  // ================================================================
  // ★★★ 上下文路径（用于 AJAX） ★★★
  // ================================================================
  var ctx = '<%= request.getContextPath() %>';

  // ================================================================
  // ★★★ 记住我：页面加载时自动填充账号（从 Cookie 读取） ★★★
  // ================================================================
  (function() {
    // 辅助：读取指定名称的 Cookie
    function getCookie(name) {
      var value = "; " + document.cookie;
      var parts = value.split("; " + name + "=");
      if (parts.length == 2) return parts.pop().split(";").shift();
      return null;
    }

    var savedEmail = getCookie('remember_me_email');
    if (savedEmail) {
      var emailInput = document.getElementById('loginEmail');
      var rememberCheckbox = document.querySelector('input[name="rememberMe"]');
      if (emailInput) emailInput.value = savedEmail;
      if (rememberCheckbox) rememberCheckbox.checked = true;
    }
  })();

  // ================================================================
  //  ★ 日志模块：与后端 API 完全整合 ★
  // ================================================================
  (function() {
    // ---- DOM 元素 ----
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

    // ---- 预览框元素 ----
    const previewTime = document.getElementById('previewTime');
    const previewContent = document.getElementById('previewContent');
    const previewCount = document.getElementById('previewCount');

    // ---- 数据 ----
    let logsData = [];
    let currentLogIndex = 0;

    // ================================================================
    //  ★ API 交互函数（所有 fetch 都使用 ctx） ★
    // ================================================================

    async function fetchLogs() {
      try {
        const res = await fetch(ctx + '/logs?limit=50&offset=0');
        if (!res.ok) throw new Error('获取日志失败');
        const data = await res.json();
        logsData = data.map(item => ({
          id: item.id,
          time: item.time,
          content: item.content
        }));
        if (logsData.length > 0) currentLogIndex = 0;
        renderAll();
      } catch (e) {
        console.error('Fetch logs error:', e);
        logsData = [];
        renderAll();
      }
    }

    async function addLogToServer(time, content) {
      try {
        const res = await fetch(ctx + '/logs', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json;charset=UTF-8' },
          body: JSON.stringify({ time, content })
        });
        const result = await res.json();
        if (result.ok) {
          logsData.unshift({ id: result.id, time: time, content: content });
          currentLogIndex = 0;
          renderAll();
          return true;
        } else {
          alert(result.error || '添加失败，请检查输入');
          return false;
        }
      } catch (e) {
        console.error('Add log error:', e);
        alert('网络错误，请重试');
        return false;
      }
    }

    async function deleteLogFromServer(id) {
      if (!id) {
        alert('该日志 ID 无效，无法删除');
        return;
      }
      try {
        const res = await fetch(ctx + '/logs?id=' + id, { method: 'DELETE' });
        const result = await res.json();
        if (result.ok) {
          const index = logsData.findIndex(log => log.id === id);
          if (index > -1) {
            logsData.splice(index, 1);
            if (currentLogIndex >= logsData.length) currentLogIndex = logsData.length - 1;
            if (logsData.length === 0) currentLogIndex = 0;
            renderAll();
          }
        } else {
          alert(result.error || '删除失败');
        }
      } catch (e) {
        console.error('Delete log error:', e);
        alert('网络错误，请重试');
      }
    }

    // ---- 渲染 ----
    function renderAll() {
      if (!Array.isArray(logsData) || logsData.length === 0) {
        previewTime.textContent = '📅 暂无日志';
        previewContent.textContent = '没有日志，请点击下方按钮添加';
        previewCount.textContent = '共 0 条';
      } else {
        const first = logsData[0];
        const displayTime = first.time ? first.time.replace('T', ' ') : '未知时间';
        previewTime.textContent = '📅 ' + displayTime;
        previewContent.textContent = first.content || '（空内容）';
        previewCount.textContent = '共 ' + logsData.length + ' 条';
      }

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

      const formattedTime = log.time.replace('T', ' ');
      if (logTimeDisplay) logTimeDisplay.textContent = formattedTime;
      if (logContentPreview) logContentPreview.textContent = log.content;
      if (logCounter) logCounter.textContent = (currentLogIndex + 1) + ' / ' + logsData.length;
    }

    function prevLog() {
      if (!logsData.length) return;
      currentLogIndex = (currentLogIndex - 1 + logsData.length) % logsData.length;
      renderAll();
    }

    function nextLog() {
      if (!logsData.length) return;
      currentLogIndex = (currentLogIndex + 1) % logsData.length;
      renderAll();
    }

    // ---- 事件绑定 ----
    if (mg_log) {
      mg_log.addEventListener('click', function() {
        show_log.showModal();
        renderAll();
      });
    }

    if (leftArrow) leftArrow.addEventListener('click', prevLog);
    if (rightArrow) rightArrow.addEventListener('click', nextLog);

    if (add_log) {
      add_log.addEventListener('click', function() {
        edit_log.showModal();
      });
    }

    if (closeshowlog) {
      closeshowlog.addEventListener('click', function() {
        show_log.close();
      });
    }

    if (cancelModalBtn) {
      cancelModalBtn.addEventListener('click', function() {
        edit_log.close();
      });
    }

    if (saveModalBtn) {
      saveModalBtn.addEventListener('click', async function() {
        const newTime = logTimeInput.value;
        const newContent = logContentInput.value;
        if (!newTime || !newContent.trim()) {
          alert("请填写完整的时间和正文内容");
          return;
        }
        const success = await addLogToServer(newTime, newContent);
        if (success) {
          edit_log.close();
          if (show_log.open) renderAll();
        }
      });
    }

    const deleteLogBtn = document.getElementById('delete_current_log');
    if (deleteLogBtn) {
      deleteLogBtn.addEventListener('click', function(e) {
        e.stopPropagation?.();
        if (!logsData.length) {
          alert('没有日志可删除');
          return;
        }
        const log = logsData[currentLogIndex];
        if (!log || !log.id) {
          alert('无法获取当前日志 ID');
          return;
        }
        const confirmDelete = confirm(
                '确定要删除这条日志吗？\n时间：' + (log.time?.replace('T', ' ') || '未知') +
                '\n正文预览：' + (log.content || '').substring(0, 50) +
                ((log.content || '').length > 50 ? '…' : '')
        );
        if (!confirmDelete) return;
        deleteLogFromServer(log.id);
      });
    }

    fetchLogs();

    // ---- 草稿保存 ----
    const DRAFT_API = ctx + '/draft';

    async function saveDraft() {
      const payload = {
        time: logTimeInput.value || null,
        content: logContentInput.value || ""
      };
      try {
        await fetch(DRAFT_API, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json;charset=UTF-8' },
          body: JSON.stringify(payload),
          credentials: 'same-origin'
        });
      } catch (_) {}
    }

    async function loadDraftToInputs() {
      try {
        const r = await fetch(DRAFT_API, { credentials: 'same-origin' });
        if (!r.ok) return;
        const data = await r.json();
        if (data && data.time != null) logTimeInput.value = data.time;
        if (data && data.content != null) logContentInput.value = data.content;
      } catch (_) {}
    }

    if (add_log) {
      add_log.addEventListener('click', async function() {
        await loadDraftToInputs();
        edit_log.showModal();
      });
    }

    let draftTimer = null;
    function scheduleDraftSave() {
      clearTimeout(draftTimer);
      draftTimer = setTimeout(function() {
        saveDraft().catch(function() {});
      }, 350);
    }
    if (logTimeInput) logTimeInput.addEventListener('input', scheduleDraftSave);
    if (logContentInput) logContentInput.addEventListener('input', scheduleDraftSave);

    window.addEventListener('beforeunload', function() {
      try {
        const payload = JSON.stringify({
          time: logTimeInput.value || null,
          content: logContentInput.value || ""
        });
        const blob = new Blob([payload], { type: 'application/json;charset=UTF-8' });
        navigator.sendBeacon(DRAFT_API, blob);
      } catch (_) {}
    });

    document.addEventListener('click', async function(e) {
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

    window.logsData = logsData;
    window.renderAll = renderAll;
    window.fetchLogs = fetchLogs;
  })();


  // ================================================================
  //  ★ 通用封装：背景图 Cover 锚定布局（不变） ★
  // ================================================================
  function createCoverAnchorLayout(backgroundImage, stage, target, anchor, options) {
    if (!backgroundImage || !stage || !target) {
      console.warn('createCoverAnchorLayout: 缺少必要参数');
      return null;
    }
    options = options || {};
    var ax = anchor.ax;
    var ay = anchor.ay;
    var offsetX = options.offsetX || 0;
    var offsetY = options.offsetY || 0;
    var onUpdate = options.onUpdate || null;

    function layout() {
      var iw = backgroundImage.naturalWidth;
      var ih = backgroundImage.naturalHeight;
      if (!iw || !ih) return;
      var vw = window.innerWidth;
      var vh = window.innerHeight;
      var scale = Math.max(vw / iw, vh / ih);
      var rw = iw * scale;
      var rh = ih * scale;
      stage.style.height = Math.ceil(rh) + 'px';
      var dx = (vw - rw) / 2;
      var dy = 0;
      target.style.left = (dx + ax * scale + offsetX) + 'px';
      target.style.top = (dy + ay * scale + offsetY) + 'px';
      target.style.transform = 'scale(' + scale + ')';
      if (typeof onUpdate === 'function') {
        onUpdate(scale, dx, dy);
      }
    }

    function bindEvents() {
      if (backgroundImage.complete) layout();
      backgroundImage.addEventListener('load', layout);
      window.addEventListener('resize', layout);
    }

    function unbindEvents() {
      backgroundImage.removeEventListener('load', layout);
      window.removeEventListener('resize', layout);
    }

    bindEvents();
    return {
      layout: layout,
      bindEvents: bindEvents,
      unbindEvents: unbindEvents,
      updateOptions: function(newOptions) {
        if (newOptions.offsetX !== undefined) options.offsetX = newOptions.offsetX;
        if (newOptions.offsetY !== undefined) options.offsetY = newOptions.offsetY;
        if (newOptions.onUpdate !== undefined) options.onUpdate = newOptions.onUpdate;
        layout();
      }
    };
  }

  var stage = document.getElementById('stage');
  var hero = document.getElementById('hero');
  var card = document.getElementById('card');
  var previewBox = document.getElementById('logPreviewBox');

  var cardLocker = createCoverAnchorLayout(hero, stage, card, {
    ax: 980,
    ay: 175
  }, {});

  var previewLocker = createCoverAnchorLayout(hero, stage, previewBox, {
    ax: 300,
    ay: 80
  }, {
    offsetX: 0,
    offsetY: 0
  });


  // ================================================================
  //  ★ 用户认证模块（切换面板 + 游客登录） ★
  // ================================================================
  (function() {
    // 游客登录
    const guestBtn = document.getElementById('guestLoginBtn');
    if (guestBtn) {
      guestBtn.addEventListener('click', function() {
        window.location.href = 'https://www.baidu.com';
      });
    }

    // 登录/注册面板切换
    const switchBtn = document.getElementById('switchFooterBtn');
    const loginForm = document.getElementById('loginForm');
    const registerForm = document.getElementById('registerForm');
    const footerHint = document.getElementById('footerHint');
    let isLogin = true;

    function toggleForm() {
      if (isLogin) {
        loginForm.style.display = 'none';
        registerForm.style.display = 'block';
        footerHint.textContent = '已有账号？';
        switchBtn.textContent = '去登录';
      } else {
        loginForm.style.display = 'block';
        registerForm.style.display = 'none';
        footerHint.textContent = '没有账号？';
        switchBtn.textContent = '立即注册';
      }
      isLogin = !isLogin;
    }

    if (switchBtn) {
      switchBtn.addEventListener('click', toggleForm);
    }
  })();
</script>
</body>
</html>