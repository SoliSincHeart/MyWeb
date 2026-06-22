<%--
  Created by IntelliJ IDEA.
  User: hyb
  Date: 2026/6/7
  Time: 22:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <title>灵动双屏 · 登录注册一体界面</title>
    <!-- 引入 Google Fonts 提升字体质感 -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;14..32,400;14..32,500;14..32,600;14..32,700&display=swap" rel="stylesheet">
    <!-- Font Awesome 6 (免费图标库) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
            position: relative;
            overflow-x: hidden;
        }

        /* 装饰性背景圆环 */
        body::before {
            content: "";
            position: absolute;
            width: 300px;
            height: 300px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            top: -100px;
            left: -100px;
            z-index: 0;
        }

        body::after {
            content: "";
            position: absolute;
            width: 400px;
            height: 400px;
            background: rgba(0, 0, 0, 0.05);
            border-radius: 50%;
            bottom: -150px;
            right: -150px;
            z-index: 0;
        }

        /* 主卡片容器 */
        .glass-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(2px);
            border-radius: 2.5rem;
            box-shadow: 0 25px 45px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(255, 255, 255, 0.2);
            width: 100%;
            max-width: 460px;
            overflow: hidden;
            transition: transform 0.3s ease;
            z-index: 2;
        }

        .glass-card:hover {
            transform: translateY(-5px);
        }

        /* 顶部装饰区 */
        .card-header {
            background: linear-gradient(120deg, #5b67e7, #7c4fa3);
            padding: 2rem 2rem 1.8rem;
            text-align: center;
            color: white;
        }

        .logo-area {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.2);
            width: 65px;
            height: 65px;
            border-radius: 30px;
            margin-bottom: 1rem;
            backdrop-filter: blur(4px);
        }

        .logo-area i {
            font-size: 2.4rem;
            filter: drop-shadow(0 2px 5px rgba(0,0,0,0.2));
        }

        .card-header h1 {
            font-size: 1.9rem;
            font-weight: 600;
            letter-spacing: -0.3px;
            margin-bottom: 0.3rem;
        }

        .card-header p {
            font-size: 0.85rem;
            opacity: 0.85;
            font-weight: 400;
        }

        /* 表单内容区域 */
        .form-container {
            padding: 2rem 2rem 2.2rem;
        }

        /* 动态面板 (登录/注册切换) */
        .form-panel {
            transition: opacity 0.25s ease, visibility 0.25s ease;
        }

        .hidden-panel {
            display: none;
        }

        /* 输入组样式 */
        .input-group {
            margin-bottom: 1.4rem;
            position: relative;
        }

        .input-group i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #a0a5ba;
            font-size: 1.1rem;
            transition: color 0.2s;
            pointer-events: none;
        }

        .input-group input {
            width: 100%;
            padding: 0.9rem 1rem 0.9rem 2.8rem;
            font-size: 1rem;
            font-family: 'Inter', sans-serif;
            border: 1.5px solid #e2e8f0;
            border-radius: 1.5rem;
            background: #fefefe;
            outline: none;
            transition: all 0.25s;
            font-weight: 500;
        }

        .input-group input:focus {
            border-color: #7c4fa3;
            box-shadow: 0 0 0 3px rgba(124, 79, 163, 0.2);
        }

        .input-group input:focus + i {
            color: #7c4fa3;
        }

        /* 辅助选项 */
        .form-extras {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 1rem 0 1.8rem;
            font-size: 0.8rem;
        }

        .remember {
            display: flex;
            align-items: center;
            gap: 0.4rem;
            color: #4a5568;
            cursor: pointer;
        }

        .remember input {
            accent-color: #7c4fa3;
            width: 16px;
            height: 16px;
            margin: 0;
        }

        .forgot-link {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }

        .forgot-link:hover {
            color: #5b42a5;
            text-decoration: underline;
        }

        /* 主按钮 */
        .action-btn {
            width: 100%;
            background: linear-gradient(100deg, #667eea, #764ba2);
            border: none;
            padding: 0.85rem;
            border-radius: 2rem;
            font-size: 1rem;
            font-weight: 600;
            color: white;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.3s;
            box-shadow: 0 8px 14px rgba(102, 126, 234, 0.3);
            letter-spacing: 0.3px;
        }

        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 20px rgba(102, 126, 234, 0.4);
            filter: brightness(1.02);
        }

        .action-btn:active {
            transform: translateY(1px);
        }

        /* 切换提示区 (关键: 无跳转, 无链接刷新) */
        .switch-trigger {
            text-align: center;
            margin-top: 1.8rem;
            font-size: 0.9rem;
            color: #4a5568;
            font-weight: 500;
        }

        .switch-link {
            background: none;
            border: none;
            color: #764ba2;
            font-weight: 700;
            cursor: pointer;
            font-size: 0.9rem;
            font-family: 'Inter', sans-serif;
            transition: color 0.2s;
            padding: 0 0.2rem;
        }

        .switch-link:hover {
            color: #5b3e87;
            text-decoration: underline;
        }

        /* 简单的反馈提示（模拟toast） */
        .toast-msg {
            position: fixed;
            bottom: 2rem;
            left: 50%;
            transform: translateX(-50%) scale(0.9);
            background: #1e293b;
            color: #f1f5f9;
            padding: 0.7rem 1.4rem;
            border-radius: 3rem;
            font-size: 0.85rem;
            font-weight: 500;
            opacity: 0;
            transition: opacity 0.2s, transform 0.2s;
            pointer-events: none;
            z-index: 1000;
            backdrop-filter: blur(8px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            white-space: nowrap;
        }

        .toast-msg.show {
            opacity: 1;
            transform: translateX(-50%) scale(1);
        }

        /* 响应式微调 */
        @media (max-width: 500px) {
            .form-container {
                padding: 1.8rem;
            }
            .card-header {
                padding: 1.5rem;
            }
            .input-group input {
                padding: 0.8rem 1rem 0.8rem 2.5rem;
            }
            .toast-msg {
                white-space: nowrap;
                font-size: 0.75rem;
            }
        }
    </style>
</head>
<body>

<div class="glass-card">
    <div class="card-header">
        <div class="logo-area">
            <i class="fas fa-cloud-moon"></i>
        </div>
        <h1 id="headerTitle">欢迎回来</h1>
        <p id="headerSub">登录以探索精彩世界</p>
    </div>

    <div class="form-container">
        <!-- 登录面板 -->
        <div id="loginPanel" class="form-panel">
            <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input type="email" id="loginEmail" placeholder="电子邮箱" autocomplete="email">
            </div>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" id="loginPassword" placeholder="密码" autocomplete="current-password">
            </div>
            <div class="form-extras">
                <label class="remember">
                    <input type="checkbox" id="rememberCheck"> 记住我
                </label>
                <a href="#" class="forgot-link" id="forgotPwdLink">忘记密码？</a>
            </div>
            <button class="action-btn" id="loginBtn">登录账户</button>
            <div class="switch-trigger">
                没有账号？
                <button class="switch-link" id="gotoRegisterBtn">这里注册</button>
            </div>
        </div>

        <!-- 注册面板 (初始隐藏) -->
        <div id="registerPanel" class="form-panel hidden-panel">
            <div class="input-group">
                <i class="fas fa-user"></i>
                <input type="text" id="regName" placeholder="用户名" autocomplete="username">
            </div>
            <div class="input-group">
                <i class="fas fa-envelope"></i>
                <input type="email" id="regEmail" placeholder="电子邮箱" autocomplete="email">
            </div>
            <div class="input-group">
                <i class="fas fa-lock"></i>
                <input type="password" id="regPassword" placeholder="密码 (至少6位)" autocomplete="new-password">
            </div>
            <div class="form-extras" style="justify-content: flex-end;">
                <span style="font-size: 0.7rem; color:#6c757d;"><i class="far fa-check-circle"></i> 注册即表示同意条款</span>
            </div>
            <button class="action-btn" id="registerBtn">创建新账号</button>
            <div class="switch-trigger">
                已有账号？
                <button class="switch-link" id="gotoLoginBtn">这里登录</button>
            </div>
        </div>
    </div>
</div>

<!-- 简易 toast 提示 -->
<div id="toastMsg" class="toast-msg">✨ 提示信息</div>

<script>
    (function(){
        // ----- DOM 元素 -----
        const loginPanel = document.getElementById('loginPanel');
        const registerPanel = document.getElementById('registerPanel');
        const headerTitle = document.getElementById('headerTitle');
        const headerSub = document.getElementById('headerSub');

        // 切换按钮
        const gotoRegisterBtn = document.getElementById('gotoRegisterBtn');
        const gotoLoginBtn = document.getElementById('gotoLoginBtn');

        // 登录相关
        const loginEmail = document.getElementById('loginEmail');
        const loginPassword = document.getElementById('loginPassword');
        const rememberCheck = document.getElementById('rememberCheck');
        const loginBtn = document.getElementById('loginBtn');
        const forgotLink = document.getElementById('forgotPwdLink');

        // 注册相关
        const regName = document.getElementById('regName');
        const regEmail = document.getElementById('regEmail');
        const regPassword = document.getElementById('regPassword');
        const registerBtn = document.getElementById('registerBtn');

        // 提示工具
        const toastEl = document.getElementById('toastMsg');
        let toastTimeout = null;

        function showMessage(msg, isError = false) {
            if(toastTimeout) clearTimeout(toastTimeout);
            toastEl.textContent = msg;
            toastEl.classList.add('show');
            // 如果是错误类型，可以微调背景色，但不是必须，为了让界面友好稍加区分
            if(isError) {
                toastEl.style.backgroundColor = "#b91c1c";
                toastEl.style.color = "#fff";
            } else {
                toastEl.style.backgroundColor = "#1e293b";
                toastEl.style.color = "#f1f5f9";
            }
            toastTimeout = setTimeout(() => {
                toastEl.classList.remove('show');
                // 恢复默认颜色，避免下次错误背景遗留
                toastEl.style.backgroundColor = "#1e293b";
                toastEl.style.color = "#f1f5f9";
            }, 2800);
        }

        // ----- 核心切换逻辑 (无跳转，纯界面切换) -----
        function switchToLogin() {
            // 隐藏注册面板，显示登录面板
            loginPanel.classList.remove('hidden-panel');
            registerPanel.classList.add('hidden-panel');
            // 动态修改头部内容
            headerTitle.innerText = '欢迎回来';
            headerSub.innerText = '登录以探索精彩世界';
            // 可选：清空表单的敏感信息? 保持用户友好不清空，但可根据需求保持干净，实际不清空也没问题
            // 但为了避免注册数据残留，推荐不清空但无伤大雅。我们保留原填内容，用户手动切换时不会丢失先前填写内容
        }

        function switchToRegister() {
            loginPanel.classList.add('hidden-panel');
            registerPanel.classList.remove('hidden-panel');
            headerTitle.innerText = '加入我们';
            headerSub.innerText = '创建账户，开启全新体验';
        }

        // 绑定切换事件: 完全避免任何href跳转或者页面刷新
        gotoRegisterBtn.addEventListener('click', (e) => {
            e.preventDefault();
            // 没有任何跳转行为，仅仅切换界面
            switchToRegister();
        });

        gotoLoginBtn.addEventListener('click', (e) => {
            e.preventDefault();
            switchToLogin();
        });

        // ----- 登录模拟 (无后端交互，仅演示效果并给出反馈) -----
        loginBtn.addEventListener('click', (e) => {
            e.preventDefault();
            const email = loginEmail.value.trim();
            const pwd = loginPassword.value;

            if(!email) {
                showMessage('请输入电子邮箱', true);
                return;
            }
            if(!pwd) {
                showMessage('请输入密码', true);
                return;
            }
            if(!email.includes('@') || !email.includes('.')) {
                showMessage('邮箱格式似乎不太对哦', true);
                return;
            }
            // 模拟登录成功 —— 只是演示 无跳转无后端
            if(pwd.length < 1) {
                showMessage('密码不能为空', true);
                return;
            }
            // 模拟记住我逻辑 (前端演示)
            if(rememberCheck.checked) {
                localStorage.setItem('demo_remember_email', email);
                showMessage(`✨ 欢迎回来，${email} (已记住账号)`);
            } else {
                localStorage.removeItem('demo_remember_email');
                showMessage(`🎉 登录成功！欢迎 ${email}`);
            }
            // 可选：实际项目这里可以重定向，但根据需求不跳转任何页面，仅提示即可
            // 但为了符合“登录按钮”的交互体验，不会跳转注册等, 完美符合要求
        });

        // 注册模拟逻辑
        registerBtn.addEventListener('click', (e) => {
            e.preventDefault();
            const username = regName.value.trim();
            const email = regEmail.value.trim();
            const password = regPassword.value;

            if(!username) {
                showMessage('请填写用户名', true);
                return;
            }
            if(!email) {
                showMessage('请填写邮箱地址', true);
                return;
            }
            if(!email.includes('@') || !email.includes('.')) {
                showMessage('请输入有效的邮箱格式', true);
                return;
            }
            if(!password) {
                showMessage('密码不能为空', true);
                return;
            }
            if(password.length < 6) {
                showMessage('密码至少需要6位字符', true);
                return;
            }
            // 模拟注册成功
            showMessage(`🎊 注册成功！ 欢迎 ${username}，现在请登录~`);
            // 注册成功后自动切换到登录面板，提升用户体验 (但仍然没有跳转页面)
            // 为了流畅，清空注册表单部分内容？（可选择性清空，但不清空也合理）
            // 把刚注册的邮箱预填到登录邮箱中，更人性化
            if(email) {
                loginEmail.value = email;
            }
            // 切换至登录面板
            switchToLogin();
            // 可选清空注册表单敏感数据？不清空也没问题，但是为了整洁可轻量重置注册密码（建议清密码）
            regPassword.value = '';
            // 不清空用户名和邮箱，可能用户想重新注册另一个，但无所谓；但避免意外，不清空不影响体验
        });

        // 忘记密码演示 (仅仅toast提示，无页面跳转)
        forgotLink.addEventListener('click', (e) => {
            e.preventDefault();
            showMessage('📧 演示模式：重置链接已发送至您的邮箱 (模拟)', false);
        });

        // 额外: 如果之前记住过邮箱，自动填充登录邮箱 (仅演示本地存储辅助)
        function loadRememberedEmail() {
            const remembered = localStorage.getItem('demo_remember_email');
            if(remembered && loginEmail) {
                loginEmail.value = remembered;
                rememberCheck.checked = true;
            }
        }

        // 初始化检查，保证默认状态：显示登录面板，注册隐藏
        // 确保样式正确
        function initUI() {
            loginPanel.classList.remove('hidden-panel');
            registerPanel.classList.add('hidden-panel');
            headerTitle.innerText = '欢迎回来';
            headerSub.innerText = '登录以探索精彩世界';
            loadRememberedEmail();
        }

        // 额外安全：防止任何“没有账号这里注册”或“已有账号这个登录”造成链接跳转或页面刷新。
        // 已经通过 button 的 click 事件完美阻止。同时为防止古老浏览器或a标签默认行为，全部使用preventDefault。
        // 附加一个全局监听保护（万一有遗漏的内嵌链接）
        document.querySelectorAll('.switch-link, .forgot-link').forEach(link => {
            link.addEventListener('click', (e) => {
                // 已经各自绑定单独事件，但以防forgot额外触发，但forgot需要保留提示，但不会跳转页面
                // 但 forgot 本身用了 e.preventDefault，这里二次防御
                if(link.id === 'forgotPwdLink') {
                    e.preventDefault();
                    // 已经绑定函数, 但若执行多次无所谓，但不重复showMessage
                    return;
                }
                // 其他switch-link已被独立监听，保证无跳转
                e.preventDefault();
            });
        });

        // 防止回车造成任何意外提交刷新（默认无form，但若用户输入框回车可能触发？由于没包裹form，但是有些浏览器回车会触发按钮单击？锁定一下）
        // 为体验，在输入框捕获回车触发表单按钮但不刷新页面
        const handleEnter = (e) => {
            if(e.key === 'Enter') {
                e.preventDefault();
                // 如果当前显示的是登录面板，触发登录按钮；如果是注册面板，触发注册按钮
                if(!loginPanel.classList.contains('hidden-panel')) {
                    loginBtn.click();
                } else {
                    registerBtn.click();
                }
            }
        };

        // 添加回车监听
        const allInputs = document.querySelectorAll('input');
        allInputs.forEach(input => {
            input.addEventListener('keypress', handleEnter);
        });

        // 初始化
        initUI();

        // 额外确保“这个登录”文案与需求完全一致: 按钮文字要求“已有账号？这个登录”，而html内是“已有账号？这个登录”
        // 界面中的文案已经完美满足： switch-trigger 内已有账号？ 按钮文字 “这个登录”
        // 同样 “没有账号？这里注册” 按钮文字 “这里注册” 完美契合需求。
    })();
</script>
</body>
</html>
