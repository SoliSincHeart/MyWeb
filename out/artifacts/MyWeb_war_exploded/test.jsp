<%--
  Created by IntelliJ IDEA.
  User: hyb
  Date: 2026/6/26
  Time: 15:36
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>全屏桌面 · 墨隅博客</title>
    <!-- Quill -->
    <link href="https://cdn.quilljs.com/1.3.7/quill.snow.css" rel="stylesheet" />
    <script src="https://cdn.quilljs.com/1.3.7/quill.js">
    </script>
    <style>
        /* ===== 全局防选中 ===== */
        html,
        body,
        .stage,
        .computer,
        button,
        .btn {
            user-select: none;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            cursor: default;
        }
        input,
        textarea {
            user-select: text;
            -webkit-user-select: text;
            cursor: text;
        }
        button,
        .btn {
            cursor: pointer;
        }
        button:focus,
        .btn:focus {
            outline: none;
        }

        /* ttf字体 */
        @font-face {
            font-family: 'MyCustomFont';
            src: url('resources/font/BoutiqueBitmap9x9_1.92.ttf') format('truetype');
            font-weight: normal;
            font-style: normal;
        }

        /* ===== 重置 & 舞台 ===== */
        html,
        body {
            margin: 0;
            padding: 0;
            width: 100vw;
            height: 100vh;
            overflow: hidden;
            -ms-overflow-style: none;
            scrollbar-width: none;
        }
        html::-webkit-scrollbar {
            display: none;
        }
        .stage {
            position: relative;
            width: 100vw;
            height: 100vh;
            min-height: 100vh;
            overflow: hidden;
        }

        /* 背景图 */
        .stage img#hero {
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

        /* ===== computer 前景图 ===== */
        .computer {
            position: absolute;
            width: 900px;
            height: 724px;
            background: url("resources/img/computer.png") no-repeat center center;
            background-size: contain;
            z-index: 1;
            pointer-events: auto;
            transform-origin: 0 0;
            will-change: transform, left, top;
            transition: filter 0s;
        }

        .computer.computer-hover {
            cursor: pointer;
            filter: brightness(0.9);
        }

        /* ===== 热区可视化 ===== */
        #hotspotVisual {
            position: absolute;
            z-index: 20;
            pointer-events: none;
            border: 3px dashed #ff4444;
            background: rgba(255, 68, 68, 0.0);
            transition: background 0.2s;
            box-sizing: border-box;
        }
        #hotspotVisual.active {
            background: rgba(255, 68, 68, 0.25);
        }

        #toggleHotspotBtn {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 9999;
            padding: 10px 20px;
            background: rgba(0, 0, 0, 0.7);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 8px;
            font-size: 14px;
            font-family: sans-serif;
            cursor: pointer;
            backdrop-filter: blur(4px);
        }
        #toggleHotspotBtn:hover {
            background: rgba(0, 0, 0, 0.9);
        }

        /* ===== 全屏弹窗（桌面） ===== */
        #fullscreenModal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 999;
            background: rgba(0, 0, 0, 0.6);
            backdrop-filter: blur(4px);
            justify-content: center;
            align-items: center;
        }

        .computer_window {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }

        .computer_window img.modal-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center top;
            display: block;
        }

        .modal-content {
            position: absolute;
            z-index: 1;
            color: black;
            width: 1774px;
            height: 864px;
            transform-origin: 0 0;
            will-change: transform, left, top;
            overflow: hidden;
            border: 1px solid;
        }

        /* 桌面图标 */
        .home-icon {
            position: absolute;
            z-index: 10;
            width: 198px;
            height: 198px;
            cursor: pointer;
            background: url("resources/img/主页.png") no-repeat center center;
            background-size: contain;
            transition: filter 0.2s, transform 0.1s;
            will-change: left, top;
        }
        .blog-icon {
            position: absolute;
            z-index: 10;
            width: 198px;
            height: 198px;
            cursor: pointer;
            background: url("resources/img/博客.png") no-repeat center center;
            background-size: contain;
            transition: filter 0.2s, transform 0.1s;
            will-change: left, top;
        }
        .home-icon:hover,
        .blog-icon:hover {
            background-color: rgba(0, 0, 0, 0.1);
        }
        .home-icon:active,
        .blog-icon:active {
            transform: scale(0.92);
        }

        /* 隐藏桌面图标（进入博客时） */
        .home-icon.hidden,
        .blog-icon.hidden {
            display: none;
        }

        /* ================================================================
           ★ blogContainerModal：使用背景图，添加半透明遮罩
           ================================================================ */
        #blogContainerModal {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: none;
            /* 默认隐藏 */
            overflow: hidden;
            z-index: 20;
            flex-direction: column;

            /* ===== 背景图（替换下方图片路径即可） ===== */
            background-image: url('resources/img/页面.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;

        }





        #blogContainerModal.active {
            display: flex;
        }

        /* ===== 博客顶部栏（固定） ===== */
        .blogContainerTop {
            flex-shrink: 0;
            width: 100%;
            height: 72px;
            padding: 0 36px;
            background: rgba(255, 255, 255, 0.92);
            box-sizing: border-box;
            display: flex;
            align-items: center;
            gap: 14px;
            background: url("resources/img/blogcontainertop.png");
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            border: 1px solid red;
        }
        .blogContainerTop.has-bg {
            position: relative;
        }

        .blogContainerTop {
            position: relative;
            /* 原有样式保持不变 */
        }



        .blogContainerTop.has-bg::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.75);
            z-index: 30;
            pointer-events: none;
        }

        .blogContainerTop .btn-back-home {
            background: rgba(238, 244, 250, 0.9);
            border: none;
            padding: 0 14px 0 10px;
            height: 36px;
            color: #2c6e9e;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            transition: background 0.2s, transform 0.15s;
            flex-shrink: 0;
            border: 1px solid rgba(255, 255, 255, 0.3);

            background-image: url('resources/img/关闭.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;

        }
        .blogContainerTop .btn-back-home:hover {
            background: rgba(220, 232, 242, 0.95);
            border-color: #cde0ec;
        }
        .blogContainerTop .btn-back-home:active {
            transform: scale(0.95);
        }
        .blogContainerTop .btn-back-home svg {
            width: 18px;
            height: 18px;
            stroke: currentColor;
            stroke-width: 2.5;
            fill: none;
            stroke-linecap: round;
            stroke-linejoin: round;
        }
        .blogContainerTop .top-right {
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        /* ===== 博客主体容器 ===== */
        .page-wrapper {
            flex: 1;
            overflow: hidden;
            width: 100%;
            margin: 0 auto;
            padding: 0;
            background: transparent;
            display: block;
            position: relative;
            opacity: 1;
            transition: none;
            border: none;
        }
        .page-wrapper.visible {
            display: block;
            opacity: 1;
        }

        /* ===== 博客卡片容器 ===== */
        .blog-container {
            width: 48%;
            height: 99%;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            padding: 7px;
            margin: 0 auto;
            box-sizing: border-box;

            background-image: url("resources/img/预览栏.png");
            background-size: contain;  /* ← 改为 contain */
            background-repeat: no-repeat;
            background-position: center;  /* 居中显示 */
        }

        /* ===== 博客头部 ===== */
        .blog-header {
            position: relative;   /* ← 添加这一行 */
            flex-shrink: 0;
            width: 97%;
            height: 72px;
            padding: 0 36px;
            background: rgba(255, 255, 255, 0.7);
            box-sizing: border-box;
            display: flex;
            align-items: center;
            margin: 10px 10px 0 10px;
        }


        .blog-header h1 {
            font-family: "MyCustomFont";
            font-size: 40px;
            font-weight: 700;
            letter-spacing: -0.3px;
            color: #7d94d2;
            margin: 0;
            flex: 1;
        }


        .blog-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background-image: url('resources/img/线条.png');
            pointer-events: none;
            background-repeat: no-repeat;
            background-size: auto 100%; /* 保持图片原始宽度 */
            background-position: center bottom;
        }



        .toolbar {
            display: none;
        }

        /* ===== 内容区域（滚动） ===== */
        .posts-area {
            flex: 1;
            overflow-y: auto;
            padding: 0;
            background: rgba(255, 255, 255, 1);
            display: block;
            position: relative;
            box-sizing: border-box;
            border: 1px solid red;
            margin: 10px;
        }
        /* 自定义滚动条 */
        .posts-area::-webkit-scrollbar {
            width: 5px;
        }
        .posts-area::-webkit-scrollbar-track {
            background: rgba(240, 244, 249, 0.5);
            border-radius: 8px;
        }
        .posts-area::-webkit-scrollbar-thumb {
            background: rgba(192, 211, 226, 0.8);
            border-radius: 8px;
        }
        .posts-area::-webkit-scrollbar-thumb:hover {
            background: rgba(165, 188, 207, 0.9);
        }

        /* ===== 浮动新建按钮 ===== */
        .floating-new-post {
            position: absolute;
            bottom: 10%;
            right: 24px;
            z-index: 10;
            border: none;
            cursor: pointer;
            width: 74px;
            height: 74px;
            padding: 0;
            background: url("resources/img/add_close.png") no-repeat center center;
            background-size: contain;
            background-color: transparent;
            -webkit-appearance: none;
            appearance: none;
            outline: none;
            transition: filter 0.1s ease, transform 0.1s ease;
        }
        .floating-new-post:hover {
            filter: brightness(0.8);
        }
        .floating-new-post:active {
            background-image: url("resources/img/add_open.png");
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center center;
            background-color: transparent;
            transform: translateY(2px);
        }

        /* ===== 左右悬浮栏 ===== */
        .left-floating-bar,
        .right-floating-bar {
            position: absolute;
            top: 0;
            z-index: 20;
            width: 24%;
            height: 330px;
            background: rgb(255, 255, 255);
            display: flex;
            align-items: center;
            justify-content: flex-start;
            flex-direction: column;
            writing-mode: vertical-lr;
            text-orientation: mixed;
            padding: 24px 0;
            margin: 6px 20px;
            gap: 12px;

            background-image: url("resources/img/悬浮栏.png");
            background-size: cover;
            background-repeat: no-repeat;
        }
        .left-floating-bar {
            left: 0;
        }
        .right-floating-bar {
            right: 0;
        }
        .floating-text {
            display: inline-block;
            color: #b0c8da;
            font-size: 12px;
            letter-spacing: 2px;
            font-weight: 400;
            transition: color 0.3s;
        }

        /* ===== 文章列表容器 ===== */
        #postsContainer {
            width: 100%;
            padding: 18px 0px 18px 0px;
            box-sizing: border-box;
            display: block;
            background: transparent;
        }

        .empty-message {
            text-align: center;
            padding: 60px 20px;
            color: #8aaec9;
            background: rgba(250, 253, 255, 0.7);
            backdrop-filter: blur(4px);
            border-radius: 20px;
            border: 1px dashed rgba(205, 224, 236, 0.6);
            font-size: 16px;
            display: block;
        }

        .post-card {
            width: 97%;
            padding: 16px 26px;
            margin:0px 10px 6px 10px;
            background: rgba(255, 255, 255, 0.85);
            border-radius: 18px;
            border: 1px solid rgba(228, 237, 245, 0.6);
            transition: 0.2s;
            box-sizing: border-box;
            display: block;
        }
        .post-card:hover {
            border-color: rgba(205, 223, 234, 0.8);
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.06);
            background: rgba(255, 255, 255, 0.95);
        }
        .post-card:last-child {
            margin-bottom: 0;
        }

        .post-info {
            display: block;
            width: 100%;
        }
        .post-title {
            font-weight: 650;
            font-size: 26px;
            color: #1d4a6e;
            cursor: pointer;
            transition: color 0.2s;
            display: inline-block;
            margin-bottom: 4px;
        }
        .post-title:hover {
            color: #2c6e9e;
            text-decoration: underline;
            text-underline-offset: 2px;
        }
        .post-excerpt {
            font-size: 16px;
            color: #5f7f9a;
            display: block;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            margin-bottom: 4px;
        }
        .post-meta {
            display: block;
            font-size: 14px;
            color: #8aa8c0;
            margin-top: 2px;
        }
        .post-meta span {
            display: inline-block;
            margin-right: 18px;
        }

        /* ===== 内联详情视图 ===== */
        #detailView {
            display: none;
            width: 100%;
            height: 100%;
            padding: 16px 36px 20px 36px;
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(12px);
            box-sizing: border-box;
            overflow: hidden;
            position: absolute;
            top: 0;
            left: 0;
            animation: fadeUp 0.2s ease;
            border-radius: 0 0 28px 28px;
        }
        @keyframes fadeUp {
            0% {
                opacity: 0;
                transform: translateY(6px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .detail-nav {
            display: block;
            width: 100%;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(238, 243, 248, 0.6);
            margin-bottom: 0;
        }
        .detail-nav-left {
            display: inline-block;
            vertical-align: middle;
        }
        .detail-actions {
            display: inline-block;
            vertical-align: middle;
            float: right;
        }

        .btn-back {
            background: rgba(238, 244, 250, 0.8);
            border: none;
            padding: 0 14px 0 8px;
            height: 32px;
            border-radius: 32px;
            font-size: 13px;
            font-weight: 500;
            color: #2c6e9e;
            cursor: pointer;
            display: inline-block;
            vertical-align: middle;
            line-height: 32px;
            transition: 0.2s;
        }
        .btn-back:hover {
            background: rgba(220, 232, 242, 0.9);
        }
        .btn-back svg {
            width: 16px;
            height: 16px;
            stroke: currentColor;
            stroke-width: 2.5;
            fill: none;
            stroke-linecap: round;
            stroke-linejoin: round;
            vertical-align: middle;
        }

        .detail-title {
            font-size: 20px;
            font-weight: 700;
            color: #1c4a6e;
            display: inline-block;
            vertical-align: middle;
            margin-left: 10px;
            max-width: 500px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .detail-actions .btn-edit-detail,
        .detail-actions .btn-delete-detail {
            padding: 0 16px;
            height: 30px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: 0.2s;
            border: 1px solid transparent;
            display: inline-block;
            vertical-align: middle;
            line-height: 30px;
            margin-left: 6px;
        }
        .detail-actions .btn-edit-detail {
            background: rgba(238, 244, 250, 0.8);
            border-color: rgba(205, 224, 236, 0.5);
            color: #2c6e9e;
        }
        .detail-actions .btn-edit-detail:hover {
            background: rgba(220, 232, 242, 0.9);
        }
        .detail-actions .btn-delete-detail {
            background: rgba(252, 241, 236, 0.8);
            border-color: rgba(240, 223, 216, 0.5);
            color: #b1624b;
        }
        .detail-actions .btn-delete-detail:hover {
            background: rgba(247, 227, 219, 0.9);
        }

        .detail-meta {
            display: block;
            padding: 6px 0 8px 0;
            border-bottom: 1px solid rgba(238, 243, 248, 0.6);
            font-size: 12px;
            color: #6f94b0;
        }
        .detail-meta span {
            display: inline-block;
            margin-right: 20px;
        }

        .detail-scroll-area {
            width: 100%;
            height: 464px;
            overflow-y: auto;
            overflow-x: hidden;
            padding-right: 6px;
            margin-top: 6px;
            box-sizing: border-box;
            display: block;
        }
        .detail-scroll-area::-webkit-scrollbar {
            width: 5px;
        }
        .detail-scroll-area::-webkit-scrollbar-track {
            background: rgba(240, 244, 249, 0.5);
            border-radius: 8px;
        }
        .detail-scroll-area::-webkit-scrollbar-thumb {
            background: rgba(192, 211, 226, 0.7);
            border-radius: 8px;
        }
        .detail-scroll-area::-webkit-scrollbar-thumb:hover {
            background: rgba(165, 188, 207, 0.8);
        }

        .detail-content {
            line-height: 1.7;
            font-size: 15px;
            color: #1e3b4f;
            display: block;
        }
        .detail-content img {
            max-width: 100%;
            height: auto;
            border-radius: 6px;
        }
        .detail-content p {
            margin-bottom: 8px;
        }
        .detail-content blockquote {
            border-left: 4px solid #2c6e9e;
            padding-left: 14px;
            color: #3d5e78;
            margin: 6px 0;
        }
        .detail-content code {
            background: rgba(240, 244, 249, 0.7);
            padding: 0 6px;
            border-radius: 4px;
            font-size: 0.85em;
        }
        .detail-content pre {
            background: rgba(240, 244, 249, 0.7);
            padding: 10px 14px;
            border-radius: 8px;
            overflow-x: auto;
        }

        .likes-section {
            display: block;
            padding: 6px 0 10px 0;
            margin: 4px 0 0 0;
        }
        .btn-like {
            background: rgba(255, 240, 230, 0.8);
            border: none;
            padding: 0 18px;
            height: 34px;
            border-radius: 34px;
            font-weight: 500;
            cursor: pointer;
            font-size: 14px;
            color: #c26e4a;
            transition: 0.2s;
            display: inline-block;
            line-height: 34px;
        }
        .btn-like:hover {
            transform: scale(0.96);
        }
        .btn-like.liked {
            background: rgba(243, 221, 210, 0.8);
            color: #b24f2c;
        }

        .comments-section {
            display: block;
            border-top: 1px solid rgba(238, 243, 248, 0.6);
            padding-top: 10px;
            margin-top: 4px;
        }
        .comments-section h4 {
            font-size: 15px;
            color: #1d4a6e;
            margin: 0 0 6px 0;
            display: block;
        }

        .comment-list {
            display: block;
            background: rgba(250, 253, 255, 0.6);
            border-radius: 12px;
            padding: 4px 0;
            margin-bottom: 6px;
            max-height: 120px;
            overflow-y: auto;
        }
        .comment-list::-webkit-scrollbar {
            width: 4px;
        }
        .comment-list::-webkit-scrollbar-track {
            background: rgba(240, 244, 249, 0.5);
            border-radius: 8px;
        }
        .comment-list::-webkit-scrollbar-thumb {
            background: rgba(192, 211, 226, 0.7);
            border-radius: 8px;
        }

        .comment-item {
            display: block;
            padding: 6px 10px;
            border-bottom: 1px solid rgba(238, 243, 248, 0.6);
        }
        .comment-item:last-child {
            border-bottom: none;
        }
        .comment-author {
            font-weight: 600;
            font-size: 12px;
            color: #2c6e9e;
            display: inline-block;
        }
        .comment-date {
            font-size: 11px;
            color: #8aaec9;
            margin-left: 8px;
            display: inline-block;
        }
        .comment-text {
            font-size: 13px;
            margin-top: 2px;
            word-break: break-word;
            color: #2c4a64;
            display: block;
        }
        .no-comments {
            color: #8aaec9;
            font-size: 13px;
            padding: 6px 0;
            display: block;
        }

        .add-comment {
            display: block;
            margin-top: 4px;
        }
        .add-comment input,
        .add-comment textarea {
            width: 100%;
            border: 1px solid rgba(212, 227, 239, 0.6);
            border-radius: 16px;
            padding: 8px 14px;
            font-size: 13px;
            font-family: inherit;
            background: rgba(250, 253, 255, 0.7);
            transition: 0.2s;
            box-sizing: border-box;
            display: block;
            margin-bottom: 6px;
        }
        .add-comment input:focus,
        .add-comment textarea:focus {
            outline: none;
            border-color: #2c6e9e;
            box-shadow: 0 0 0 3px rgba(44, 110, 158, 0.10);
        }
        .add-comment textarea {
            min-height: 48px;
            resize: vertical;
        }
        .btn-submit-comment {
            background: #2c6e9e;
            border: none;
            padding: 0 22px;
            height: 34px;
            border-radius: 34px;
            color: white;
            font-size: 13px;
            cursor: pointer;
            transition: 0.2s;
            display: inline-block;
            line-height: 34px;
        }
        .btn-submit-comment:hover {
            background: #1e5a7d;
        }

        /* 模态框（编辑） */
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.55);
            backdrop-filter: blur(4px);
            display: block;
            z-index: 3000;
            visibility: hidden;
            opacity: 0;
            transition: visibility 0.2s, opacity 0.2s;
        }
        .modal-overlay.active {
            visibility: visible;
            opacity: 1;
        }

        .modal-container {
            width: 900px;
            height: 700px;
            background: white;
            border-radius: 28px;
            box-shadow: 0 25px 45px rgba(0, 0, 0, 0.2);
            margin: 40px auto 0 auto;
            overflow: hidden;
            display: block;
            position: relative;
        }

        .modal-header {
            width: 900px;
            height: 60px;
            padding: 0 28px;
            border-bottom: 1px solid #edf2f8;
            background: white;
            box-sizing: border-box;
            display: block;
            line-height: 60px;
            position: relative;
        }
        .modal-header h3 {
            font-size: 20px;
            font-weight: 600;
            color: #1d3e53;
            margin: 0;
            display: inline-block;
            vertical-align: middle;
        }
        .modal-close {
            background: transparent;
            border: none;
            font-size: 28px;
            cursor: pointer;
            color: #92acc4;
            transition: 0.2s;
            display: inline-block;
            vertical-align: middle;
            float: right;
            line-height: 60px;
            padding: 0 4px;
        }
        .modal-close:hover {
            color: #1d3e53;
        }

        .modal-body {
            width: 900px;
            height: 518px;
            padding: 18px 28px 12px 28px;
            box-sizing: border-box;
            overflow-y: auto;
            display: block;
        }
        .modal-body::-webkit-scrollbar {
            width: 5px;
        }
        .modal-body::-webkit-scrollbar-track {
            background: #f0f4f9;
            border-radius: 8px;
        }
        .modal-body::-webkit-scrollbar-thumb {
            background: #c0d3e2;
            border-radius: 8px;
        }

        .field {
            display: block;
            margin-bottom: 14px;
        }
        .field label {
            display: block;
            font-weight: 600;
            margin-bottom: 4px;
            font-size: 14px;
            color: #2c5a74;
        }
        .field input {
            width: 100%;
            padding: 8px 14px;
            border-radius: 16px;
            border: 1px solid #cfdfec;
            font-family: inherit;
            font-size: 15px;
            transition: 0.2s;
            box-sizing: border-box;
            display: block;
        }
        .field input:focus {
            outline: none;
            border-color: #2c6e9e;
            box-shadow: 0 0 0 3px rgba(44, 110, 158, 0.12);
        }

        #quill-editor {
            height: 340px;
            border-radius: 16px;
            background: white;
            display: block;
        }
        .ql-editor {
            font-size: 15px;
            line-height: 1.6;
        }
        .ql-editor img {
            max-width: 100%;
            cursor: pointer;
        }

        .edit-footer {
            width: 900px;
            height: 62px;
            padding: 0 28px;
            border-top: 1px solid #edf2f8;
            background: white;
            box-sizing: border-box;
            display: block;
            line-height: 62px;
            text-align: right;
        }
        .edit-footer .btn-save,
        .edit-footer .btn-cancel {
            padding: 0 22px;
            height: 38px;
            border-radius: 38px;
            font-weight: 500;
            cursor: pointer;
            transition: 0.2s;
            border: none;
            display: inline-block;
            vertical-align: middle;
            line-height: 38px;
            margin-left: 8px;
            font-size: 14px;
        }
        .btn-save {
            background: #2c6e9e;
            color: white;
        }
        .btn-save:hover {
            background: #1e5a7d;
        }
        .btn-cancel {
            background: #eef2f8;
            color: #3d5e78;
        }
        .btn-cancel:hover {
            background: #e0e6ef;
        }

        .toast-message {
            position: fixed;
            bottom: 40px;
            left: 50%;
            transform: translateX(-50%);
            background: #1e2f3e;
            color: white;
            padding: 10px 28px;
            border-radius: 40px;
            font-size: 15px;
            z-index: 4000;
            opacity: 0;
            transition: opacity 0.25s;
            pointer-events: none;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            display: block;
        }
        .toast-message.show {
            opacity: 1;
        }

        /* ===== 关闭按钮（桌面） ===== */
        #closeModalBtn {
            position: absolute;
            z-index: 10;
            cursor: pointer;
            width: 90px;
            height: 55px;
            background: url("resources/img/esc.png") no-repeat center center;
            background-size: contain;
            transform-origin: 0 0;
            transition: filter 0.2s, transform 0.1s;
            will-change: transform, left, top;
        }
        #closeModalBtn:hover {
            filter: brightness(1.5);
        }
        #closeModalBtn:active {
            transform: scale(0.92);
        }

        #footTime {
            position: absolute;
            z-index: 10;
            transform-origin: 0 0;
            will-change: transform, left, top;
            pointer-events: none;
            font-family: 'MyCustomFont', 'Courier New', monospace;
            font-size: 40px;
            color: rgba(0, 0, 0);
            padding: 6px 18px;
            text-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
            white-space: nowrap;
        }

    </style>
</head>
<body>
<div class="stage" id="stage">
    <img id="hero" src="resources/img/home.gif" alt="background">
    <div class="computer" id="computer" title="点击进入电脑">
        <!-- 热区可视化由 JS 动态创建 -->
    </div>

    <!-- 桌面弹窗 -->
    <div id="fullscreenModal">
        <div class="computer_window" id="computerWindow">
            <img class="modal-bg" id="modalBg" src="resources/img/computer_window.png" alt="modal background">
            <div class="modal-content" id="modalContent">
                <!-- 桌面图标 -->
                <div class="home-icon" id="homeIcon"></div>
                <div class="blog-icon" id="blogIconModal"></div>

                <!-- ===== 博客容器（背景图） ===== -->
                <div id="blogContainerModal">
                    <!-- 顶部栏 -->
                    <div class="blogContainerTop" id="blogContainerTop">
                        <button class="btn-back-home" id="backToHomeBtn" title="返回桌面">

                        </button>
                        <div class="top-right">
                            <!-- 未来可扩展 -->
                        </div>
                    </div>

                    <!-- 博客主体 -->
                    <div class="page-wrapper" id="pageWrapper">
                        <!-- 左悬浮栏 -->
                        <div class="left-floating-bar">
                        </div>
                        <!-- 右悬浮栏 -->
                        <div class="right-floating-bar">
                        </div>

                        <!-- 主博客容器 -->
                        <div class="blog-container">
                            <!-- 头部 -->
                            <div class="blog-header">
                                <h1>SoliSincHeart的博客</h1>
                            </div>

                            <!-- 内容区域（滚动） -->
                            <div class="posts-area">
                                <!-- 悬浮按钮 -->
                                <button class="floating-new-post" id="floatingNewPostBtn" aria-label="撰写新文章"></button>

                                <!-- 文章列表 -->
                                <div id="postsContainer">
                                    <div class="empty-message">📭 还没有文章，点击「撰写新文章」开始创作</div>
                                </div>

                                <!-- 内联详情视图 -->
                                <div id="detailView"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 关闭按钮和时间 -->
            <div id="closeModalBtn"></div>
            <div id="footTime"></div>
        </div>
    </div>

    <!-- Toast -->
    <div id="toastMsg" class="toast-message"></div>

    <!-- 编辑模态框 -->
    <div id="editModal" class="modal-overlay">
        <div class="modal-container">
            <div class="modal-header">
                <h3 id="editModalTitle">编辑文章</h3>
                <button class="modal-close" id="closeEditModalBtn">&times;</button>
            </div>
            <div class="modal-body">
                <div class="field">
                    <label>标题</label>
                    <input type="text" id="editTitleInput" placeholder="文章标题" />
                </div>
                <div class="field">
                    <label>正文 (支持图片拖拽缩放、文字样式)</label>
                    <div id="quill-editor"></div>
                </div>
            </div>
            <div class="edit-footer">
                <button class="btn-cancel" id="cancelEditBtn">取消</button>
                <button class="btn-save" id="saveEditBtn">保存文章</button>
            </div>
        </div>
    </div>
</div>

<!-- 热区开关 -->
<button id="toggleHotspotBtn">🔲 隐藏热区</button>

<script>
    // ================================================================
    // 锚定布局函数
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

    // ================================================================
    //  主逻辑：电脑与弹窗
    // ================================================================
    (function() {
        var stage = document.getElementById('stage');
        var hero = document.getElementById('hero');
        var computer = document.getElementById('computer');
        if (!stage || !hero || !computer) {
            console.error('缺少必要 DOM 元素');
            return;
        }

        // 锚定 computer
        var computerLocker = createCoverAnchorLayout(
            hero,
            stage,
            computer, { ax: 963, ay: 142 }, { offsetX: 0, offsetY: 0 }
        );

        // 弹窗元素
        var modalBg = document.getElementById('modalBg');
        var closeBtn = document.getElementById('closeModalBtn');
        var computerWindow = document.getElementById('computerWindow');
        var modalContent = document.getElementById('modalContent');
        var homeIcon = document.getElementById('homeIcon');
        var blogIconModal = document.getElementById('blogIconModal');
        var footTime = document.getElementById('footTime');
        var modal = document.getElementById('fullscreenModal');
        var blogContainer = document.getElementById('blogContainerModal');
        var backToHomeBtn = document.getElementById('backToHomeBtn');

        if (!modalBg || !closeBtn || !computerWindow || !modalContent || !homeIcon || !blogIconModal || !footTime) {
            console.error('弹窗元素缺失');
            return;
        }

        // ---- 关闭按钮锚定 ----
        var btnLocker = createCoverAnchorLayout(
            modalBg,
            computerWindow,
            closeBtn, { ax: 284, ay: 911 }, { offsetX: 0, offsetY: 0 }
        );

        // ---- modalContent 锚定 ----
        var modalContentLocker = createCoverAnchorLayout(
            modalBg,
            computerWindow,
            modalContent, { ax: 274, ay: 44 }, {
                offsetX: 0,
                offsetY: 0,
                onUpdate: function(scale, dx, dy) {
                    // 固定桌面图标位置（相对于 modalContent）
                    homeIcon.style.left = '41px';
                    homeIcon.style.top = '50px';
                    blogIconModal.style.left = '41px';
                    blogIconModal.style.top = '254px';
                    homeIcon.style.transform = 'scale(1)';
                    blogIconModal.style.transform = 'scale(1)';
                    // 博客容器占满 modalContent
                    blogContainer.style.width = '100%';
                    blogContainer.style.height = '100%';
                }
            }
        );

        // ---- footTime 锚定 ----
        var footTimeLocker = createCoverAnchorLayout(
            modalBg,
            computerWindow,
            footTime, { ax: 1450, ay: 904 }, {
                offsetX: 0,
                offsetY: 0,
                onUpdate: function(scale, dx, dy) {}
            }
        );

        // ---- 时间更新 ----
        var timerId = null;

        function updateTime() {
            var now = new Date();
            var year = now.getFullYear();
            var month = String(now.getMonth() + 1).padStart(2, '0');
            var day = String(now.getDate()).padStart(2, '0');
            var h = String(now.getHours()).padStart(2, '0');
            var m = String(now.getMinutes()).padStart(2, '0');
            var s = String(now.getSeconds()).padStart(2, '0');
            footTime.textContent = year + '/' + month + '/' + day + '   ' + h + ':' + m + ':' + s;
        }

        function startTimeUpdate() {
            if (timerId) return;
            updateTime();
            timerId = setInterval(updateTime, 1000);
        }

        function stopTimeUpdate() {
            if (timerId) {
                clearInterval(timerId);
                timerId = null;
            }
        }

        // ---- 弹窗控制 ----
        computer.addEventListener('click', function() {
            modal.style.display = 'flex';
            // 确保桌面图标可见，博客容器隐藏
            homeIcon.classList.remove('hidden');
            blogIconModal.classList.remove('hidden');
            blogContainer.classList.remove('active');
            blogContainer.style.display = 'none';

            if (btnLocker) btnLocker.layout();
            if (modalContentLocker) modalContentLocker.layout();
            if (footTimeLocker) footTimeLocker.layout();
            startTimeUpdate();
        });

        closeBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            modal.style.display = 'none';
            stopTimeUpdate();
            if (blogContainer.classList.contains('active')) {
                exitBlog();
            }
        });

        modal.addEventListener('click', function(e) {
            if (e.target === modal) {
                modal.style.display = 'none';
                stopTimeUpdate();
                if (blogContainer.classList.contains('active')) {
                    exitBlog();
                }
            }
        });

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                if (modal.style.display === 'flex') {
                    if (blogContainer.classList.contains('active')) {
                        if (document.getElementById('editModal').classList.contains('active')) {
                            closeEditModal();
                            return;
                        }
                        exitBlog();
                    } else {
                        modal.style.display = 'none';
                        stopTimeUpdate();
                    }
                }
            }
        });

        // ================================================================
        //  博客切换逻辑
        // ================================================================
        function enterBlog() {
            // 隐藏桌面图标
            homeIcon.classList.add('hidden');
            blogIconModal.classList.add('hidden');
            // 显示博客容器
            blogContainer.style.display = 'flex';
            blogContainer.classList.add('active');
            // 渲染文章列表
            renderPostList();
        }

        function exitBlog() {
            // 隐藏博客容器
            blogContainer.classList.remove('active');
            blogContainer.style.display = 'none';
            // 显示桌面图标
            homeIcon.classList.remove('hidden');
            blogIconModal.classList.remove('hidden');
            // 关闭详情视图
            if (document.getElementById('detailView').style.display === 'block') {
                closeDetailView();
            }
            document.getElementById('postsContainer').style.display = 'block';
        }

        // ---- 事件绑定 ----
        blogIconModal.addEventListener('click', function(e) {
            e.stopPropagation();
            enterBlog();
        });

        backToHomeBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            exitBlog();
        });

        // ================================================================
        // 热区代码
        // ================================================================
        var HOTSPOT = { x: 10, y: 10, width: 880, height: 570 };
        var hotspotVisual = document.createElement('div');
        hotspotVisual.id = 'hotspotVisual';
        hotspotVisual.style.left = HOTSPOT.x + 'px';
        hotspotVisual.style.top = HOTSPOT.y + 'px';
        hotspotVisual.style.width = HOTSPOT.width + 'px';
        hotspotVisual.style.height = HOTSPOT.height + 'px';
        computer.appendChild(hotspotVisual);

        var isVisible = true;
        var toggleBtn = document.getElementById('toggleHotspotBtn');
        toggleBtn.addEventListener('click', function() {
            isVisible = !isVisible;
            hotspotVisual.style.display = isVisible ? 'block' : 'none';
            toggleBtn.textContent = isVisible ? '🔲 隐藏热区' : '🔳 显示热区';
        });

        computer.addEventListener('mousemove', function(e) {
            var scale = 1;
            var transform = computer.style.transform;
            if (transform) {
                var match = transform.match(/scale\(([\d.]+)\)/);
                if (match) scale = parseFloat(match[1]);
            }
            var rect = computer.getBoundingClientRect();
            var mouseX = (e.clientX - rect.left) / scale;
            var mouseY = (e.clientY - rect.top) / scale;

            var inside = (mouseX >= HOTSPOT.x && mouseX <= HOTSPOT.x + HOTSPOT.width &&
                mouseY >= HOTSPOT.y && mouseY <= HOTSPOT.y + HOTSPOT.height);

            if (inside) {
                computer.classList.add('computer-hover');
            } else {
                computer.classList.remove('computer-hover');
            }
            if (inside) {
                hotspotVisual.classList.add('active');
            } else {
                hotspotVisual.classList.remove('active');
            }
        });

        computer.addEventListener('mouseleave', function() {
            computer.classList.remove('computer-hover');
            hotspotVisual.classList.remove('active');
        });

        // ================================================================
        //  博客功能
        // ================================================================
        const STORAGE_KEY = "blog_posts_data";
        let posts = [];
        let quill = null;
        let currentEditingId = null;
        let currentDetailPostId = null;

        // Toast 复用全局
        function showToast(message, duration = 2500) {
            const toast = document.getElementById('toastMsg');
            toast.textContent = message;
            toast.classList.add('show');
            clearTimeout(toast._timer);
            toast._timer = setTimeout(() => toast.classList.remove('show'), duration);
        }

        // 存储
        function saveToLocal() {
            localStorage.setItem(STORAGE_KEY, JSON.stringify(posts));
        }

        function escapeHtml(str) {
            if (!str) return '';
            return str.replace(/[&<>]/g, function(m) {
                if (m === '&') return '&amp;';
                if (m === '<') return '&lt;';
                if (m === '>') return '&gt;';
                return m;
            });
        }

        // 示例数据
        function initSampleData() {
            const now = new Date();
            const sample1 =
                `<p>黄昏时分，沿着湖岸慢慢走，水面泛着细碎的光。偶尔一只水鸟掠过，激起涟漪。这种时刻，思绪最自由，写作不过是把它捕捞上岸。</p><p style="color: #c0392b;"><strong>博客的第一篇文章</strong>，记录朴素日常。</p><p style="text-align: center;"><img src="https://picsum.photos/400/250?random=1" alt="湖畔" style="max-width:100%;border-radius:0.6rem;" /></p><p>这里还有一些额外的文字，用来测试滚动条的效果。当内容超出固定区域时，滚动条就会自动出现。这样无论文章多长，布局都能保持稳定。</p><p>你可以继续滚动查看更多内容……</p>`;
            const sample2 =
                `<p>编程和写诗本质上都是创造。严格语法之下隐藏着无限表达。搭建这个博客，是为了让文字有一块干净的地方。</p><p><span style="background-color: #f1c40f;">高亮标记</span> 重要段落。</p><p>代码块示例：</p><pre><code>function greet(name) {\n  console.log("Hello, " + name);\n}\ngreet("墨隅");</code></pre>`;
            return [{
                id: Date.now() + 1001,
                title: "湖畔漫步 · 黄昏记事",
                content: sample1,
                createdAt: new Date(now - 2 * 86400000).toLocaleString('zh-CN'),
                views: 23,
                likes: 5,
                comments: [{ id: Date.now() + 1, author: "林川", content: "很宁静的文字，期待更多分享。", date: new Date(now -
                        86400000).toLocaleString('zh-CN') }]
            }, {
                id: Date.now() + 1002,
                title: "代码与诗：创造的双重奏",
                content: sample2,
                createdAt: new Date().toLocaleString('zh-CN'),
                views: 12,
                likes: 2,
                comments: []
            }];
        }

        function loadData() {
            const stored = localStorage.getItem(STORAGE_KEY);
            if (stored) {
                posts = JSON.parse(stored);
                posts = posts.map(p => {
                    if (p.views === undefined) p.views = 0;
                    if (p.likes === undefined) p.likes = 0;
                    if (!p.comments) p.comments = [];
                    if (p.content && !p.content.startsWith('<') && !p.content.includes('</')) {
                        p.content = `<p>${escapeHtml(p.content).replace(/\n/g, '</p><p>')}</p>`;
                    }
                    return p;
                });
            } else {
                posts = initSampleData();
                saveToLocal();
            }
        }

        // 点赞/评论
        function hasUserLiked(postId) {
            const map = JSON.parse(localStorage.getItem("blog_liked_posts") || "{}");
            return !!map[postId];
        }

        function setUserLiked(postId, liked) {
            const map = JSON.parse(localStorage.getItem("blog_liked_posts") || "{}");
            if (liked) map[postId] = true;
            else delete map[postId];
            localStorage.setItem("blog_liked_posts", JSON.stringify(map));
        }

        function toggleLike(postId) {
            const post = posts.find(p => p.id === postId);
            if (!post) return false;
            const isLiked = hasUserLiked(postId);
            if (isLiked) {
                if ((post.likes || 0) > 0) post.likes -= 1;
                setUserLiked(postId, false);
            } else {
                post.likes = (post.likes || 0) + 1;
                setUserLiked(postId, true);
            }
            saveToLocal();
            return true;
        }

        function markViewed(postId) {
            const viewedKey = "blog_viewed_articles";
            let set = new Set(JSON.parse(sessionStorage.getItem(viewedKey) || "[]"));
            if (!set.has(postId)) {
                const post = posts.find(p => p.id === postId);
                if (post) {
                    post.views = (post.views || 0) + 1;
                    saveToLocal();
                    set.add(postId);
                    sessionStorage.setItem(viewedKey, JSON.stringify([...set]));
                    return true;
                }
            }
            return false;
        }

        function addComment(postId, author, content) {
            const post = posts.find(p => p.id === postId);
            if (!post) return false;
            if (!author.trim() || !content.trim()) {
                showToast("请填写昵称和评论内容", 1500);
                return false;
            }
            post.comments.push({
                id: Date.now(),
                author: author.trim(),
                content: content.trim(),
                date: new Date().toLocaleString('zh-CN')
            });
            saveToLocal();
            return true;
        }

        function deletePostById(id) {
            const idx = posts.findIndex(p => p.id === id);
            if (idx === -1) return;
            posts.splice(idx, 1);
            saveToLocal();
            if (currentDetailPostId === id) {
                closeDetailView();
            }
            renderPostList();
            showToast("文章已删除", 1200);
        }

        // 渲染列表
        function renderPostList() {
            const container = document.getElementById("postsContainer");
            if (!posts.length) {
                container.innerHTML =
                    `<div class="empty-message">📭 还没有文章，点击「撰写新文章」开始创作</div>`;
                return;
            }
            const sorted = [...posts].sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));
            let html = '';
            sorted.forEach(post => {
                const temp = document.createElement('div');
                temp.innerHTML = post.content || '';
                const plain = temp.textContent || temp.innerText || '';
                const excerpt = plain.slice(0, 70) + (plain.length > 70 ? "..." : "");
                html += `
                            <div class="post-card">
                                <div class="post-info">
                                    <div class="post-title" data-id="${post.id}">${escapeHtml(post.title || '无题')}</div>
                                    <div class="post-excerpt">${escapeHtml(excerpt)}</div>
                                    <div class="post-meta">
                                        <span>👁️ ${post.views || 0}</span>
                                        <span>❤️ ${post.likes || 0}</span>
                                        <span>💬 ${post.comments?.length || 0}</span>
                                        <span>📅 ${post.createdAt || '未知'}</span>
                                    </div>
                                </div>
                            </div>
                        `;
            });
            container.innerHTML = html;
            container.querySelectorAll('.post-title').forEach(el => {
                el.addEventListener('click', function() {
                    const id = parseInt(this.getAttribute('data-id'));
                    openDetailView(id);
                });
            });
        }

        // 详情视图
        function openDetailView(postId) {
            const post = posts.find(p => p.id === postId);
            if (!post) {
                showToast("文章不存在", 1500);
                return;
            }
            currentDetailPostId = post.id;
            markViewed(postId);
            const fresh = posts.find(p => p.id === postId);
            renderDetailViewContent(fresh);
            document.getElementById('postsContainer').style.display = 'none';
            const detail = document.getElementById('detailView');
            detail.style.display = 'block';
        }

        function closeDetailView() {
            document.getElementById('detailView').style.display = 'none';
            document.getElementById('postsContainer').style.display = 'block';
            currentDetailPostId = null;
            renderPostList();
        }

        function renderDetailViewContent(post) {
            const container = document.getElementById('detailView');
            if (!post) {
                container.innerHTML = `<div style="padding:20px;color:#8aaec9;">文章不存在</div>`;
                return;
            }

            const liked = hasUserLiked(post.id);
            const likeBtnClass = liked ? "btn-like liked" : "btn-like";
            const likeBtnText = liked ? "❤️ 已点赞" : "👍 点赞";

            let commentsHtml = '';
            if (post.comments && post.comments.length) {
                post.comments.forEach(c => {
                    commentsHtml += `
                                <div class="comment-item">
                                    <div><span class="comment-author">${escapeHtml(c.author)}</span><span class="comment-date">${escapeHtml(c.date)}</span></div>
                                    <div class="comment-text">${escapeHtml(c.content)}</div>
                                </div>
                            `;
                });
            } else {
                commentsHtml = `<div class="no-comments">暂无评论，来做第一个评论的人吧</div>`;
            }

            container.innerHTML = `
                        <div class="detail-nav">
                            <div class="detail-nav-left">
                                <button class="btn-back" id="backToListBtn">
                                    <svg viewBox="0 0 24 24" style="width:16px;height:16px;vertical-align:middle;"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>
                                    返回列表
                                </button>
                                <span class="detail-title">${escapeHtml(post.title)}</span>
                            </div>
                            <div class="detail-actions">
                                <button class="btn-edit-detail" id="detailEditBtn" data-id="${post.id}">✏️ 编辑</button>
                                <button class="btn-delete-detail" id="detailDeleteBtn" data-id="${post.id}">🗑️ 删除</button>
                            </div>
                        </div>
                        <div class="detail-meta">
                            <span>📅 ${escapeHtml(post.createdAt)}</span>
                            <span>👁️ 阅读 ${post.views || 0}</span>
                            <span>❤️ 点赞 ${post.likes || 0}</span>
                            <span>💬 评论 ${post.comments?.length || 0}</span>
                        </div>
                        <div class="detail-scroll-area">
                            <div class="detail-content">${post.content || ''}</div>
                            <div class="likes-section">
                                <button id="likeActionBtn" class="${likeBtnClass}">${likeBtnText}</button>
                            </div>
                            <div class="comments-section">
                                <h4>📝 评论 · 留言</h4>
                                <div class="comment-list" id="commentListArea">${commentsHtml}</div>
                                <div class="add-comment">
                                    <input type="text" id="commentAuthorInput" placeholder="昵称" maxlength="20" />
                                    <textarea id="commentContentInput" placeholder="写下你的想法..." rows="2"></textarea>
                                    <button id="submitCommentBtn" class="btn-submit-comment">发表评论</button>
                                </div>
                            </div>
                        </div>
                    `;

            document.getElementById('backToListBtn').addEventListener('click', closeDetailView);

            document.getElementById('likeActionBtn').addEventListener('click', function() {
                const success = toggleLike(post.id);
                if (success) {
                    const fresh = posts.find(p => p.id === post.id);
                    if (fresh) {
                        renderDetailViewContent(fresh);
                        renderPostList();
                    }
                }
            });

            document.getElementById('submitCommentBtn').addEventListener('click', function() {
                const authorInput = document.getElementById('commentAuthorInput');
                const contentInput = document.getElementById('commentContentInput');
                const author = authorInput.value.trim();
                const content = contentInput.value.trim();
                if (!author) { showToast("请填写昵称", 1500); return; }
                if (!content) { showToast("请填写评论内容", 1500); return; }
                const added = addComment(post.id, author, content);
                if (added) {
                    const fresh = posts.find(p => p.id === post.id);
                    if (fresh) {
                        renderDetailViewContent(fresh);
                        renderPostList();
                        authorInput.value = '';
                        contentInput.value = '';
                    }
                }
            });

            document.getElementById('detailEditBtn').addEventListener('click', function() {
                const pid = post.id;
                closeDetailView();
                openEditModal(pid);
            });

            document.getElementById('detailDeleteBtn').addEventListener('click', function() {
                if (confirm(`确定删除《${post.title}》吗？此操作不可撤销。`)) {
                    deletePostById(post.id);
                }
            });
        }

        // 富文本编辑器
        function initQuill() {
            if (quill) return;
            const toolbarOptions = [
                [{ header: [1, 2, 3, false] }],
                ['bold', 'italic', 'underline', 'strike'],
                [{ color: [] }, { background: [] }],
                [{ align: [] }],
                ['blockquote', 'code-block'],
                [{ list: 'ordered' }, { list: 'bullet' }],
                ['link', 'image'],
                ['clean']
            ];
            quill = new Quill('#quill-editor', {
                theme: 'snow',
                modules: { toolbar: toolbarOptions },
                placeholder: '开始撰写文章... 支持图片拖拽缩放、文字样式、对齐...'
            });
            const toolbar = quill.getModule('toolbar');
            toolbar.addHandler('image', () => {
                const input = document.createElement('input');
                input.setAttribute('type', 'file');
                input.setAttribute('accept', 'image/*');
                input.click();
                input.onchange = () => {
                    const file = input.files[0];
                    if (file) {
                        const reader = new FileReader();
                        reader.onload = (e) => {
                            const range = quill.getSelection(true);
                            quill.insertEmbed(range.index, 'image', e.target.result);
                            quill.setSelection(range.index + 1);
                        };
                        reader.readAsDataURL(file);
                    }
                };
            });
        }

        // 编辑模态框
        function openEditModal(postId) {
            initQuill();
            if (postId !== null) {
                const post = posts.find(p => p.id === postId);
                if (!post) return;
                currentEditingId = post.id;
                document.getElementById('editModalTitle').innerText = '编辑文章';
                document.getElementById('editTitleInput').value = post.title || '';
                quill.root.innerHTML = post.content || '';
            } else {
                currentEditingId = null;
                document.getElementById('editModalTitle').innerText = '写新文章';
                document.getElementById('editTitleInput').value = '';
                quill.root.innerHTML = '';
            }
            document.getElementById('editModal').classList.add('active');
        }

        function closeEditModal() {
            document.getElementById('editModal').classList.remove('active');
            currentEditingId = null;
        }

        function saveEditPost() {
            const title = document.getElementById('editTitleInput').value.trim();
            const contentHtml = quill.root.innerHTML;
            if (!title) { showToast('请填写文章标题', 1500); return; }
            if (!contentHtml || contentHtml === '<p><br></p>') { showToast('请填写文章内容', 1500); return; }

            if (currentEditingId !== null) {
                const idx = posts.findIndex(p => p.id === currentEditingId);
                if (idx !== -1) {
                    posts[idx].title = title;
                    posts[idx].content = contentHtml;
                    saveToLocal();
                    renderPostList();
                    closeEditModal();
                    openDetailView(currentEditingId);
                    showToast('文章已更新', 1000);
                } else {
                    showToast('文章不存在', 1500);
                }
            } else {
                const newId = Date.now();
                const newPost = {
                    id: newId,
                    title: title,
                    content: contentHtml,
                    createdAt: new Date().toLocaleString('zh-CN'),
                    views: 0,
                    likes: 0,
                    comments: []
                };
                posts.unshift(newPost);
                saveToLocal();
                renderPostList();
                closeEditModal();
                openDetailView(newId);
                showToast('新文章已发布', 1000);
            }
        }

        // 博客内按钮事件
        document.getElementById('floatingNewPostBtn').addEventListener('click', () => openEditModal(null));
        document.getElementById('closeEditModalBtn').addEventListener('click', closeEditModal);
        document.getElementById('cancelEditBtn').addEventListener('click', closeEditModal);
        document.getElementById('saveEditBtn').addEventListener('click', saveEditPost);

        // ---- 启动 ----
        loadData();
        renderPostList(); // 预渲染
        // 初始状态：博客隐藏，桌面图标可见
        blogContainer.classList.remove('active');
        blogContainer.style.display = 'none';
        homeIcon.classList.remove('hidden');
        blogIconModal.classList.remove('hidden');

        console.log('✅ 背景图已应用：请将图片放到 resources/img/modal-bg.png');
        console.log('💡 如果图片未显示，检查路径或替换 background-image 中的 URL');
    })();
</script>
</body>
</html>