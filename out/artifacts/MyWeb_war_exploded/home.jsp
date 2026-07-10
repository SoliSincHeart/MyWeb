<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>桌面</title>
    <link href="https://unpkg.com/@wangeditor/editor@5.1.23/dist/css/style.css" rel="stylesheet" />
    <script src="https://unpkg.com/@wangeditor/editor@5.1.23/dist/index.js"></script>
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

        /* ===== 新增装饰卡片（与登录页面一致） ===== */
        .scenery {
            position: absolute;
            width: 735px;
            height: 670px;
            z-index: -2;            /* 默认在背景图之下（不可见），若需显示请改为 1 */
            background-image: url("resources/img/窗外.png");
            background-repeat: no-repeat;
            background-size: 100% 100%;
            transform-origin: 0 0;
            will-change: transform, left, top;
        }

        /* 全屏弹窗 */
        #fullscreenModal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            z-index: 999;
            background: rgba(0,0,0,0.6);
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
            width: 1774px;
            height: 864px;
            transform-origin: 0 0;
            will-change: transform, left, top;
            overflow: hidden;
        }

        #bottomBarContainer {
            position: absolute;
            z-index: 10;
            pointer-events: none;
            transform-origin: 0 0;
            will-change: transform, left, top;
            width: 1774px;
            height: 80px;
            overflow: visible;
        }

        .home-icon,
        .blog-icon {
            position: absolute;
            z-index: 10;
            width: 198px;
            height: 198px;
            cursor: pointer;
            background-size: contain;
            transition: filter 0.2s, transform 0.1s;
            will-change: left, top;
        }

        .home-icon {
            background: url("resources/img/主页.png") no-repeat center center;
        }

        .blog-icon {
            background: url("resources/img/博客.png") no-repeat center center;
        }

        .home-icon:hover,
        .blog-icon:hover {
            background-color: rgba(0,0,0,0.1);
        }

        .home-icon:active,
        .blog-icon:active {
            transform: scale(0.92);
        }

        .home-icon.hidden,
        .blog-icon.hidden {
            display: none;
        }

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
            pointer-events: auto;
        }

        #closeModalBtn:hover {
            filter: brightness(1.5);
        }

        #closeModalBtn:active {
            transform: scale(0.98);
        }

        #footTime {
            position: absolute;
            z-index: 10;
            transform-origin: 0 0;
            will-change: transform, left, top;
            pointer-events: none;
            font-family: 'MyCustomFont', 'Courier New', monospace;
            font-size: 40px;
            color: rgba(0,0,0);
            padding: 6px 18px;
            text-shadow: 0 2px 8px rgba(0,0,0,0.3);
            white-space: nowrap;
        }

        /* 博客容器 */
        #blogContainerModal {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            display: none;
            overflow: hidden;
            z-index: 20;
            background-image: url('resources/img/页面.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        #blogContainerModal.active {
            display: block;
        }

        .blogContainerTop {
            position: absolute;
            left: 5px;
            top: 4px;
            width: 1764px;
            height: 65px;
            background-image: url('resources/img/blogcontainertop.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            box-sizing: border-box;
            z-index: 25;
            pointer-events: auto;
        }

        .btn-back-home {
            position: absolute;
            border: none;
            width: 65px;
            height: 58px;
            cursor: pointer;
            background-image: url('resources/img/关闭.png');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            z-index: 30;
            transition: filter 0s, transform 0.1s;
        }

        .btn-back-home:hover {
            filter: brightness(0.8);
        }

        .btn-back-home:active {
            transform: scale(0.98);
        }

        .page-wrapper {
            position: absolute;
            top: 72px;
            left: 0;
            right: 0;
            bottom: 0;
            overflow: hidden;
            background: transparent;
        }

        .left-floating-bar,
        .right-floating-bar{
            position: absolute;
            top: 0;
            z-index: 20;
            width: 18%;
            height: 330px;
            background: rgb(255,255,255);
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
            background-size: contain;
            background-repeat: no-repeat;
        }

        .left-floating-bar {
            left: 1%;
        }

        /* ===== 额外信息框（左侧栏下方） ===== */
        .extra-info-box {
            position: absolute;
            left: 2.2%;
            top: 300px;
            width: 18%;
            height: 330px;
            box-sizing: border-box;
            z-index: 20;
            overflow: hidden;
            background-image: url("resources/img/悬浮栏.png");
            background-size: contain;
            background-repeat: no-repeat;
            padding: 0;
        }

        .extra-inner {
            position: relative;
            width: 100%;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .extra-title {
            position: absolute;
            top: 30px;
            left: 0;
            width: 100%;
            text-align: center;
            font-size: 24px;
            font-weight: 700;
            color: #2c4a64;
            letter-spacing: 0.5px;
            margin: 0;
            padding: 0 10px;
            box-sizing: border-box;
            pointer-events: none;
        }

        .extra-content {
            padding: 0 16px;
            margin-top: 30px;
            font-size: 18px;
            color: #4a6275;
            text-align: center;
            line-height: 1.5;
            word-break: break-word;
            box-sizing: border-box;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
        }

        .right-floating-bar {
            right: 1%;
        }

        .left-inner,
        .right-inner {
            writing-mode: horizontal-tb;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            width: 100%;
            height: 100%;
            gap: 6px;
            text-align: center;
            padding: 10px 8px;
            box-sizing: border-box;
            overflow: hidden;
        }

        .avatar-wrapper {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            overflow: hidden;
            flex-shrink: 0;
            border: 2px solid rgba(180,200,220,0.55);
            background: rgba(220,235,248,0.4);
            cursor: pointer;
            transition: border-color 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .avatar-wrapper img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }

        .avatar-wrapper:hover {
            border-color: rgba(140,170,200,0.8);
        }

        .avatar-fallback {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #dce8f2 0%, #c4d7e8 100%);
            border-radius: 50%;
        }

        .avatar-fallback svg {
            width: 36px;
            height: 36px;
            fill: #8aaec9;
        }

        .nickname-main {
            font-size: 20px;
            font-weight: 700;
            color: #2c4a64;
            letter-spacing: 1px;
            line-height: 1.2;
        }

        .nickname-sub {
            font-size: 16px;
            font-weight: 400;
            color: #8aa8c0;
            letter-spacing: 0.5px;
            line-height: 1.3;
            margin-bottom: 2px;
        }

        .divider-line {
            width: 40px;
            height: 2px;
            background: rgba(180,200,220,1);
            border-radius: 2px;
            flex-shrink: 0;
            margin: 2px 0;
        }

        .icon-row {
            display: flex;
            flex-direction: row;
            align-items: center;
            justify-content: center;
            gap: 6px;
            flex-wrap: wrap;
            margin-top: 2px;
        }

        .icon-link {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 46px;
            height: 46px;
            border-radius: 30%;
            background: rgba(220,235,248,0.45);
            color: #6b8da8;
            transition: all 0.25s;
            cursor: pointer;
            text-decoration: none;
        }

        .icon-link:hover {
            background: rgba(180,205,225,0.6);
            color: #2c6e9e;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(0,0,0,0.08);
        }

        .icon-link svg {
            width: 26px;
            height: 26px;
            pointer-events: none;
        }

        .stats-title {
            font-size: 28px;
            font-weight: 700;
            color: #2c4a64;
            letter-spacing: 2px;
            margin-bottom: 4px;
        }

        .stats-list {
            display: flex;
            flex-direction: column;
            gap: 4px;
            width: 90%;
            align-items: center;
        }

        .stat-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            width: 100%;
            padding: 3px 12px;
            background: rgba(240,246,252,0.55);
            border-radius: 16px;
            font-size: 18px;
            color: #4a6275;
            letter-spacing: 0.5px;
            box-sizing: border-box;
        }

        .stat-label {
            font-weight: 500;
            color: #5f7f9a;
        }

        .stat-value {
            font-weight: 700;
            color: #2c6e9e;
            font-size: 18px;
        }

        .stat-item.last-online {
            flex-direction: column;
            gap: 1px;
            align-items: center;
            padding: 4px 12px;
        }

        .stat-item.last-online .stat-label {
            font-size: 16px;
            color: #8aa8c0;
        }

        .stat-item.last-online .stat-value {
            font-size: 14px;
            font-weight: 500;
        }

        .blog-container {
            width: 58%;
            height: 100%;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            padding: 7px;
            margin: 0 auto;
            box-sizing: border-box;
            background-image: url("resources/img/预览栏.png");
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
        }

        .blog-header {
            position: relative;
            flex-shrink: 0;
            width: 97%;
            height: 72px;
            padding: 0 46px;
            background: rgba(255,255,255,0.7);
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
            background-size: auto 100%;
            background-position: center bottom;
        }

        .posts-area {
            flex: 1;
            overflow-y: auto;
            padding: 5px 0;
            background: rgba(255,255,255,1);
            display: block;
            position: relative;
            box-sizing: border-box;
            margin: 10px;
        }

        .posts-area::-webkit-scrollbar {
            width: 5px;
        }

        .posts-area::-webkit-scrollbar-track {
            background: rgba(240,244,249,0.5);
            border-radius: 8px;
        }

        .posts-area::-webkit-scrollbar-thumb {
            background: rgba(192,211,226,0.8);
            border-radius: 8px;
        }

        .posts-area::-webkit-scrollbar-thumb:hover {
            background: rgba(165,188,207,0.9);
        }

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
            background: url("resources/img/add_0.png") no-repeat center center;
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
            transform: translateY(2px);
        }

        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.55);
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
            box-shadow: 0 25px 45px rgba(0,0,0,0.2);
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
            height: 570px;
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
            box-shadow: 0 0 0 3px rgba(44,110,158,0.12);
        }

        /* wangEditor 编辑器容器样式 */
        #editor-wrapper {
            border-radius: 16px;
            border: 1px solid #cfdfec;
            overflow: hidden;
            background: white;
            display: block;
        }

        #toolbar-container {
            border-bottom: 1px solid #cfdfec;
        }

        #editor-container {
            height: 340px;
            overflow-y: auto;
            background: #fff;
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
            background: #eef2f8;
            color: #3d5e78;
        }

        .edit-footer .btn-cancel:hover {
            background: #e0e6ef;
        }

        .edit-footer .btn-save {
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
            background: #2c6e9e;
            color: white;
        }

        .edit-footer .btn-save:hover {
            background: #1d4a6e;
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
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            display: block;
        }

        .toast-message.show {
            opacity: 1;
        }

        .post-card {
            width: 97%;
            padding: 16px 26px;
            margin: 0px 10px 6px 10px;
            background: rgba(255,255,255,0.85);
            border-radius: 18px;
            border: 2px dashed #91a6dc;
            transition: 0.1s ease;
            box-sizing: border-box;
            display: block;
            transform: translateY(0);
        }

        .post-card:hover {
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            background: rgba(255,255,255,0.98);
            border-color: #7b8ec4;
            transform: translateY(-2px);
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
            display: inline-flex;
            align-items: center;
            gap: 4px;
            margin-right: 18px;
            color: #4a6275;
        }

        .post-meta span svg {
            width: 16px;
            height: 16px;
            stroke: currentColor;
            stroke-width: 2;
            fill: none;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        /* 详情视图 */
        #detailView {
            display: none;
            flex-direction: column;
            height: 100%;
            overflow: hidden;
            padding: 10px 20px;
            box-sizing: border-box;
        }

        #detailView.active {
            display: flex;
        }

        .detail-nav {
            display: flex;
            align-items: center;
            width: 100%;
            padding-bottom: 10px;
            border-bottom: 1px solid rgba(238,243,248,0.6);
            margin-bottom: 0;
            gap: 8px;
            flex-shrink: 0;
        }

        .detail-nav .detail-title {
            font-size: 35px;
            font-weight: 700;
            color: #1c4a6e;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 400px;
        }

        .detail-actions {
            display: flex;
            align-items: center;
            gap: 6px;
            margin-right: auto;
        }

        .btn-back {
            background: rgba(238,244,250,0.8);
            border: none;
            padding: 0 14px 0 8px;
            height: 32px;
            border-radius: 32px;
            font-size: 16px;
            font-weight: 500;
            color: #2c6e9e;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            transition: 0.2s;
        }

        .btn-back:hover {
            background: rgba(220,232,242,0.9);
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

        .detail-actions .btn-edit-detail,
        .detail-actions .btn-delete-detail {
            padding: 0 16px;
            height: 50px;
            border-radius: 24px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: 0.2s;
            border: 1px solid transparent;
            display: inline-flex;
            align-items: center;
        }

        .detail-actions .btn-edit-detail {
            background: rgba(238,244,250,0.8);
            border-color: rgba(205,224,236,0.5);
            color: #2c6e9e;
        }

        .detail-actions .btn-edit-detail:hover {
            background: rgba(220,232,242,0.9);
        }

        .detail-actions .btn-delete-detail {
            background: rgba(252,241,236,0.8);
            border-color: rgba(240,223,216,0.5);
            color: #b1624b;
        }

        .detail-actions .btn-delete-detail:hover {
            background: rgba(247,227,219,0.9);
        }

        .detail-meta {
            display: block;
            padding: 6px 0 8px 0;
            border-bottom: 1px solid rgba(238,243,248,0.6);
            font-size: 16px;
            color: #6f94b0;
            flex-shrink: 0;
        }

        .detail-meta span {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            margin-right: 20px;
            color: #4a6275;
        }

        .detail-meta span svg {
            width: 16px;
            height: 16px;
            stroke: currentColor;
            stroke-width: 2;
            fill: none;
            stroke-linecap: round;
            stroke-linejoin: round;
        }

        .detail-scroll-area {
            width: 100%;
            flex: 1;
            min-height: 0;
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
            background: rgba(240,244,249,0.5);
            border-radius: 8px;
        }

        .detail-scroll-area::-webkit-scrollbar-thumb {
            background: rgba(192,211,226,0.7);
            border-radius: 8px;
        }

        .detail-scroll-area::-webkit-scrollbar-thumb:hover {
            background: rgba(165,188,207,0.8);
        }

        .detail-content {
            line-height: 1.7;
            font-size: 19px;
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
            background: rgba(240,244,249,0.7);
            padding: 0 6px;
            border-radius: 4px;
            font-size: 0.85em;
        }

        .detail-content pre {
            background: rgba(240,244,249,0.7);
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
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: rgba(255,240,230,0.8);
            border: none;
            padding: 0 18px;
            height: 34px;
            border-radius: 34px;
            font-weight: 500;
            cursor: pointer;
            font-size: 14px;
            color: #c26e4a;
            transition: 0.2s;
        }

        .btn-like svg {
            width: 16px;
            height: 16px;
        }

        .btn-like:hover {
            transform: scale(0.96);
        }

        .btn-like.liked {
            background: rgba(243,221,210,0.8);
            color: #b24f2c;
        }

        .comments-section {
            display: block;
            border-top: 1px solid rgba(238,243,248,0.6);
            padding-top: 10px;
            margin-top: 4px;
            font-size: 16px;
        }

        .comments-section h4 {
            font-size: 26px;
            color: #1d4a6e;
            margin: 0 0 6px 0;
            display: block;
        }

        .comment-list {
            display: block;
            background: rgba(250,253,255,0.6);
            border-radius: 12px;
            padding: 4px 0;
            margin-bottom: 6px;
        }

        .comment-item {
            display: block;
            padding: 6px 10px;
            border-bottom: 1px solid rgba(238,243,248,0.6);
        }

        .comment-item:last-child {
            border-bottom: none;
        }

        .comment-author {
            font-weight: 600;
            font-size: 20px;
            color: #2c6e9e;
            display: inline-block;
        }

        .comment-date {
            font-size: 14px;
            color: #8aaec9;
            margin-left: 8px;
            display: inline-block;
        }

        .comment-text {
            font-size: 16px;
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

        .add-comment-bottom {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 8px;
            margin-top: 8px;
            padding-top: 8px;
            border-top: 1px solid rgba(238,243,248,0.6);
            flex-shrink: 0;
        }

        .add-comment-bottom textarea {
            width: 100%;
            border: 1px solid #8aaec9;
            border-radius: 16px;
            padding: 8px 14px;
            font-size: 16px;
            font-family: inherit;
            background: rgba(250,253,255,0.7);
            transition: 0.2s;
            box-sizing: border-box;
            min-height: 48px;
            max-height: 100px;
            resize: none;
            overflow-y: hidden;
            display: block;
        }

        .add-comment-bottom textarea:focus {
            outline: none;
            border-color: #2c6e9e;
            box-shadow: 0 0 0 3px rgba(44,110,158,0.10);
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
            white-space: nowrap;
            flex-shrink: 0;
        }

        .btn-submit-comment:hover {
            background: #1e5a7d;
        }

        /* ==================== 日志功能补充 CSS ==================== */
        /* 日志预览框 */
        #logBox {
            position: absolute;
            width: 434px;
            height: 471px;
            background-image: url("resources/img/log.png");
            background-repeat: no-repeat;
            background-size: 100% 100%;
            transform-origin: 0 0;
            will-change: transform, left, top;
            transition: filter 0s;
            /* border: solid 2px red; */ /* 调试用，已注释 */
        }
        #logBox:hover{
            filter: brightness(0.95);
        }
        .logPreviewBox {
            position: relative;
            top: 18%;
            left: 22%;
            width: 280px;
            height: 300px;
            padding: 30px 25px 20px 25px;
            transform: rotate(-5deg);
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            /* border: 1px solid red; */ /* 调试用 */
            font-weight: 800;
        }
        .log-preview-time {
            display: block;
            font-size: 12px;
            opacity: 0.8;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
            color: #eef2ff;
        }
        .log-preview-body {
            /* border: 1px solid red; */ /* 调试用 */
            position: relative;
            font-size: 16px;
            line-height: 1.5;
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
            border-top: 1px solid rgba(255,255,255,0.15);
            padding-top: 10px;
        }
        .log-preview-footer .log-count-badge {
            font-size: 11px;
            opacity: 0.6;
            color: #eef2ff;
            font-weight: 400;
        }
        #mg_log {
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 40px;
            padding: 4px 14px;
            font-size: 13px;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            color: #fff;
            cursor: pointer;
            transition: background 0.25s, border-color 0.25s, color 0.25s;
            backdrop-filter: blur(4px);
            letter-spacing: 0.3px;
            text-shadow: 0 1px 2px rgba(0,0,0,0.2);
            white-space: nowrap;
        }
        #mg_log:hover {
            background: rgba(255,255,255,0.28);
            border-color: rgba(255,255,255,0.4);
            color: #ffe69e;
        }
        #mg_log:active { transform: scale(0.95); }

        /* 日志弹窗 */
        dialog {
            border-radius: 20px;
            border: 2px solid rgba(255,255,255,0.4);
            box-shadow: 0 20px 60px rgba(0,0,0,0.35);
            position: fixed;
            margin: 0;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(255,255,255,0.97);
            backdrop-filter: blur(8px);
            padding: 0;
            z-index: 100;
        }
        #show_log { top: 10%; }
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
        .arrow_btn:hover { background: #cbd5e1; }
        .arrow_btn:active { transform: scale(0.92); }
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
        .action_btn:hover { background-color: #2563eb; transform: translateY(-1px); }
        .action_btn.secondary {
            background-color: #e2e8f0;
            color: #1e293b;
        }
        .action_btn.secondary:hover { background-color: #cbd5e1; }

        /* 编辑日志弹窗 */
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
            box-shadow: 0 0 0 3px rgba(59,130,246,0.15);
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
        .save_btn:hover { background-color: #2563eb; }
        .cancel_btn {
            background-color: #e2e8f0;
            color: #1e293b;
        }
        .cancel_btn:hover { background-color: #cbd5e1; }
        /* ==================== 日志 CSS 结束 ==================== */
    </style>

    <!-- ===== 新增：从 Session 获取当前用户信息，注入为 JavaScript 变量 ===== -->
    <%
        bean.users.Users currentUser = util.LoginManager.getLoginUser(request);
        boolean isLoggedIn = (currentUser != null);
        boolean isAdmin = isLoggedIn && currentUser.isAdmin();
        boolean isGuest = isLoggedIn && currentUser.getId() != null && currentUser.getId() < 0;
        String userJson = "{ \"id\": " + (isLoggedIn ? currentUser.getId() : "null") +
                ", \"username\": \"" + (isLoggedIn ? currentUser.getUsername() : "") + "\"" +
                ", \"admin\": " + isAdmin +
                ", \"isGuest\": " + isGuest +
                ", \"loggedIn\": " + isLoggedIn + " }";
    %>
    <script>
        window.currentUser = <%= userJson %>;
        window.isAdmin = window.currentUser.admin;
        window.isGuest = window.currentUser.isGuest;
        window.isLoggedIn = window.currentUser.loggedIn;
    </script>
</head>
<body>
<div class="stage" id="stage">
    <img id="hero" src="resources/img/home.gif" alt="background">

    <!-- ===== 新增装饰卡片（与登录页面一致） ===== -->
    <div class="scenery" id="scenery"></div>

    <!-- ===== 日志预览框 ===== -->
    <div id="logBox">
        <div class="logPreviewBox">
            <span class="log-preview-time" id="previewTime">📅 暂无日志</span>
            <div class="log-preview-body" id="previewContent">没有日志，请点击下方按钮添加</div>
            <div class="log-preview-footer">
                <span class="log-count-badge" id="previewCount">共 0 条</span>
                <button type="button" id="mg_log">📄 展示日志</button>
            </div>
        </div>
    </div>

    <!-- ===== 日志弹窗（查看全部、翻页、添加、删除） ===== -->
    <dialog id="show_log">
        <div class="log_viewer">
            <div class="log_header">
                <span class="log_time_display">暂无日志</span>
                <button type="button" class="arrow_btn left_arrow">◀</button>
                <span class="log_counter">0 / 0</span>
                <button type="button" class="arrow_btn right_arrow">▶</button>
            </div>
            <div class="log_body">
                <div class="log_content_preview">这里展示日志正文内容</div>
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

    <div class="computer" id="computer" title="点击进入电脑"></div>

    <div id="fullscreenModal">
        <div class="computer_window" id="computerWindow">
            <img class="modal-bg" id="modalBg" src="resources/img/computer_window.png" alt="modal background">
            <div class="modal-content" id="modalContent">
                <div class="home-icon" id="homeIcon"></div>
                <div class="blog-icon" id="blogIconModal"></div>

                <div id="blogContainerModal">
                    <div class="blogContainerTop" id="blogContainerTop">
                        <button class="btn-back-home" id="backToHomeBtn" title="返回桌面"></button>
                    </div>
                    <div class="page-wrapper" id="pageWrapper">
                        <div class="left-floating-bar" id="leftFloatingBar">
                            <div class="left-inner">
                                <div class="avatar-wrapper" id="avatarWrapper" title="点击更换头像">
                                    <img id="avatarImg"
                                         src="resources/img/avatar.png"
                                         alt="头像"
                                         onerror="this.style.display='none';document.getElementById('avatarFallback').style.display='flex';">
                                    <div class="avatar-fallback" id="avatarFallback" style="display:none;">
                                        <svg viewBox="0 0 24 24">
                                            <circle cx="12" cy="8" r="5"/>
                                            <path d="M4 20c0-4 3.6-7 8-7s8 3 8 7"
                                                  fill="none"
                                                  stroke="#8aaec9"
                                                  stroke-width="2"
                                                  stroke-linecap="round"/>
                                        </svg>
                                    </div>
                                </div>
                                <span class="nickname-main">孤子赤心</span>
                                <span class="nickname-sub">SoliSincHeart</span>
                                <div class="divider-line"></div>
                                <div class="icon-row">
                                    <a class="icon-link" href="javascript:void(0)" title="版权声明" id="copyrightIcon">
                                        <svg viewBox="0 0 24 24">
                                            <circle cx="12" cy="12" r="10"
                                                    fill="none"
                                                    stroke="currentColor"
                                                    stroke-width="2"/>
                                            <text x="12" y="16"
                                                  text-anchor="middle"
                                                  font-size="11"
                                                  fill="currentColor"
                                                  font-weight="bold">©</text>
                                        </svg>
                                    </a>
                                    <a class="icon-link"
                                       href="tencent://message/?uin=000000"
                                       title="QQ联系"
                                       id="qqIcon"
                                       target="_blank">
                                        <svg viewBox="0 0 24 24">
                                            <ellipse cx="12" cy="15" rx="8" ry="8" fill="currentColor"/>
                                            <ellipse cx="12" cy="9" rx="5.5" ry="4.5" fill="currentColor"/>
                                            <circle cx="9.5" cy="8" r="1.3" fill="#fff"/>
                                            <circle cx="14.5" cy="8" r="1.3" fill="#fff"/>
                                            <path d="M10.5 11 Q12 12.8 13.5 11"
                                                  stroke="#fff"
                                                  stroke-width="0.9"
                                                  fill="none"
                                                  stroke-linecap="round"/>
                                            <rect x="9" y="17" width="6" height="3" rx="1" fill="currentColor"/>
                                        </svg>
                                    </a>
                                    <a class="icon-link"
                                       href="https://github.com/"
                                       title="GitHub主页"
                                       id="githubIcon"
                                       target="_blank"
                                       rel="noopener">
                                        <svg viewBox="0 0 24 24">
                                            <path d="M12 1C5.92 1 1 5.92 1 12c0 4.86 3.15 8.98 7.52 10.44.55.1.75-.24.75-.53v-1.86c-3.06.66-3.7-1.47-3.7-1.47-.5-1.27-1.22-1.6-1.22-1.6-1-.68.08-.67.08-.67 1.1.08 1.68 1.13 1.68 1.13.98 1.68 2.57 1.2 3.2.92.1-.72.38-1.2.7-1.47-2.44-.28-5-1.22-5-5.43 0-1.2.43-2.18 1.13-2.95-.12-.28-.5-1.4.1-2.9 0 0 .92-.3 3 1.12a10.5 10.5 0 0 1 5.46 0c2.1-1.42 3-1.12 3-1.12.6 1.5.22 2.62.1 2.9.7.77 1.13 1.75 1.13 2.95 0 4.22-2.57 5.15-5.02 5.42.4.34.74 1 .74 2.02v3c0 .3.2.64.75.53A11 11 0 0 0 23 12c0-6.08-4.92-11-11-11z"
                                                  fill="currentColor"/>
                                        </svg>
                                    </a>
                                    <a class="icon-link" href="mailto:example@example.com" title="发送邮件" id="emailIcon">
                                        <svg viewBox="0 0 24 24">
                                            <rect x="2" y="4" width="20" height="16" rx="2"
                                                  fill="none"
                                                  stroke="currentColor"
                                                  stroke-width="2"/>
                                            <path d="M2 6l10 7 10-7"
                                                  fill="none"
                                                  stroke="currentColor"
                                                  stroke-width="2"
                                                  stroke-linecap="round"
                                                  stroke-linejoin="round"/>
                                        </svg>
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div class="extra-info-box" id="extraBox">
                            <div class="extra-inner">
                                <span class="extra-title">公告</span>
                                <p class="extra-content">功能不多，简单一点就好</p>
                            </div>
                        </div>

                        <div class="right-floating-bar" id="rightFloatingBar">
                            <div class="right-inner">
                                <span class="stats-title">博客统计</span>
                                <div class="stats-list">
                                    <div class="stat-item">
                                        <span class="stat-label">文章总数</span>
                                        <span class="stat-value" id="statArticleCount">0 篇</span>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-label">浏览总数</span>
                                        <span class="stat-value" id="statTotalViews">0 次</span>
                                    </div>
                                    <div class="stat-item">
                                        <span class="stat-label">点赞总数</span>
                                        <span class="stat-value" id="statTotalLikes">0 个</span>
                                    </div>
                                    <div class="stat-item last-online">
                                        <span class="stat-label">最后更新</span>
                                        <span class="stat-value" id="statLastUpdate">加载中...</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="blog-container">
                            <div class="blog-header">
                                <h1>SoliSincHeart的博客</h1>
                            </div>
                            <div class="posts-area" id="postsArea">
                                <button class="floating-new-post"
                                        id="floatingNewPostBtn"
                                        aria-label="撰写新文章"></button>
                                <div id="postsContainer">
                                    <div class="empty-message">📭 还没有文章，点击 + 开始创作</div>
                                </div>
                                <div id="detailView"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="bottomBarContainer">
            <div id="closeModalBtn"></div>
            <div id="footTime"></div>
        </div>
    </div>

    <div id="editModal" class="modal-overlay">
        <div class="modal-container">
            <div class="modal-header">
                <h3 id="editModalTitle">写新文章</h3>
                <button class="modal-close" id="closeEditModalBtn">&times;</button>
            </div>
            <div class="modal-body">
                <div class="field">
                    <label>标题</label>
                    <input type="text" id="editTitleInput" placeholder="文章标题" />
                </div>
                <div class="field">
                    <label>正文（支持图片、富文本）</label>
                    <div id="editor-wrapper">
                        <div id="toolbar-container"></div>
                        <div id="editor-container"></div>
                    </div>
                </div>
            </div>
            <div class="edit-footer">
                <button class="btn-cancel" id="cancelEditBtn">关闭</button>
                <button class="btn-save" id="saveEditBtn">保存</button>
            </div>
        </div>
    </div>

    <div id="toastMsg" class="toast-message"></div>
</div>

<script>
    /* ============================================================
    *  社交链接配置
    *  ============================================================ */
    const SOCIAL_LINKS = {
        copyrightUrl: '#',
        qqUin: '000000',
        githubUrl: 'https://github.com/',
        emailAddress: 'example@example.com'
    };

    /* ============================================================
     *  SVG 图标定义
     *  ============================================================ */
    const SVG_ICONS = {
        eye: `<svg viewBox="0 0 24 24"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>`,
        heartOutline: `<svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>`,
        heartFilled: `<svg viewBox="0 0 24 24"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z" fill="currentColor" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>`,
        message: `<svg viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>`,
        calendar: `<svg viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>`
    };

    /* ============================================================
     *  锚定布局引擎
     *  ============================================================ */
    function createCoverAnchorLayout(backgroundImage, stage, target, anchor, options) {
        if (!backgroundImage || !stage || !target) return null;
        options = options || {};
        const ax = anchor.ax;
        const ay = anchor.ay;
        let offsetX = options.offsetX || 0;
        let offsetY = options.offsetY || 0;
        let onUpdate = options.onUpdate || null;

        function layout() {
            const iw = backgroundImage.naturalWidth;
            const ih = backgroundImage.naturalHeight;
            if (!iw || !ih) return;
            const vw = window.innerWidth;
            const vh = window.innerHeight;
            const scale = Math.max(vw / iw, vh / ih);
            const dx = (vw - iw * scale) / 2;
            const dy = 0;
            target.style.left = (dx + ax * scale + offsetX) + 'px';
            target.style.top = (dy + ay * scale + offsetY) + 'px';
            target.style.transform = 'scale(' + scale + ')';
            if (typeof onUpdate === 'function') onUpdate(scale, dx, dy);
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
                if (newOptions.offsetX !== undefined) offsetX = newOptions.offsetX;
                if (newOptions.offsetY !== undefined) offsetY = newOptions.offsetY;
                if (newOptions.onUpdate !== undefined) onUpdate = newOptions.onUpdate;
                layout();
            }
        };
    }

    /* ============================================================
     *  主逻辑
     *  ============================================================ */
    (function() {
        const APP_CTX = (typeof ctx === 'string' && ctx) ? ctx : '/MyWeb';

        let stage = document.getElementById('stage');
        let hero = document.getElementById('hero');
        let computer = document.getElementById('computer');
        if (!stage || !hero || !computer) return;

        let computerLocker = createCoverAnchorLayout(hero, stage, computer, { ax: 963, ay: 142 }, {});
        window.computerLocker = computerLocker;

        // 热区绑定
        (function initHotspot() {
            let HOTSPOT = { x: 10, y: 10, width: 880, height: 570 };
            computer.addEventListener('mousemove', function(e) {
                let scale = 1;
                let match = computer.style.transform.match(/scale\(([\d.]+)\)/);
                if (match) scale = parseFloat(match[1]);
                let rect = computer.getBoundingClientRect();
                let mx = (e.clientX - rect.left) / scale;
                let my = (e.clientY - rect.top) / scale;
                let inside = mx >= HOTSPOT.x && mx <= HOTSPOT.x + HOTSPOT.width &&
                    my >= HOTSPOT.y && my <= HOTSPOT.y + HOTSPOT.height;
                computer.classList.toggle('computer-hover', inside);
            });
            computer.addEventListener('mouseleave', function() {
                computer.classList.remove('computer-hover');
            });
        })();

        let modal = document.getElementById('fullscreenModal');
        let modalBg = document.getElementById('modalBg');
        let modalContent = document.getElementById('modalContent');
        let computerWindow = document.getElementById('computerWindow');
        let bottomBarContainer = document.getElementById('bottomBarContainer');
        let closeBtn = document.getElementById('closeModalBtn');
        let footTime = document.getElementById('footTime');
        let homeIcon = document.getElementById('homeIcon');
        let blogIconModal = document.getElementById('blogIconModal');
        let blogContainer = document.getElementById('blogContainerModal');
        let backToHomeBtn = document.getElementById('backToHomeBtn');

        let modalContentLocker = createCoverAnchorLayout(
            modalBg,
            computerWindow,
            modalContent,
            { ax: 274, ay: 44 },
            {
                onUpdate: function() {
                    homeIcon.style.left = '41px';
                    homeIcon.style.top = '50px';
                    blogIconModal.style.left = '41px';
                    blogIconModal.style.top = '254px';
                    homeIcon.style.transform = 'scale(1)';
                    blogIconModal.style.transform = 'scale(1)';
                    updateBlogAnchor();
                }
            }
        );

        let bottomBarLocker = createCoverAnchorLayout(
            modalBg,
            computerWindow,
            bottomBarContainer,
            { ax: 274, ay: 911 },
            {
                onUpdate: function() {
                    closeBtn.style.left = '10px';
                    closeBtn.style.top = '0px';
                    closeBtn.style.transform = '';
                    footTime.style.left = '1300px';
                    footTime.style.top = '0px';
                    footTime.style.transform = '';
                }
            }
        );

        // 日志预览框锚定
        let previewBox = document.getElementById('logBox');
        if (previewBox) {
            createCoverAnchorLayout(hero, stage, previewBox, { ax: -2, ay: 618 }, { offsetX: 0, offsetY: 0 });
        }

        // ===== 新增：装饰卡片锚定（与登录页面一致） =====
        let scenery = document.getElementById('scenery');
        if (scenery) {
            createCoverAnchorLayout(hero, stage, scenery, { ax: 0, ay: 0 }, { offsetX: 0, offsetY: 0 });
        }

        function updateBlogAnchor() {
            if (blogContainer) {
                let cw = blogContainer.offsetWidth;
                let ch = blogContainer.offsetHeight;
                if (cw && ch) {
                    let sx = cw / 1774;
                    let sy = ch / 72;
                    backToHomeBtn.style.left = (1698 * sx) + 'px';
                    backToHomeBtn.style.top = (0 * sy) + 'px';
                }
            }
        }

        window.addEventListener('resize', function() {
            if (blogContainer && blogContainer.classList.contains('active')) {
                updateBlogAnchor();
            }
        });

        let timerId = null;
        function updateTime() {
            let now = new Date();
            footTime.textContent =
                now.getFullYear() + '/' +
                String(now.getMonth() + 1).padStart(2, '0') + '/' +
                String(now.getDate()).padStart(2, '0') + '   ' +
                String(now.getHours()).padStart(2, '0') + ':' +
                String(now.getMinutes()).padStart(2, '0') + ':' +
                String(now.getSeconds()).padStart(2, '0');
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

        computer.addEventListener('click', function() {
            modal.style.display = 'flex';
            homeIcon.classList.remove('hidden');
            blogIconModal.classList.remove('hidden');
            blogContainer.classList.remove('active');
            blogContainer.style.display = 'none';
            if (modalContentLocker) modalContentLocker.layout();
            if (bottomBarLocker) bottomBarLocker.layout();
            startTimeUpdate();
        });

        closeBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            closeModal();
        });

        modal.addEventListener('click', function(e) {
            if (e.target === modal) closeModal();
        });

        function closeModal() {
            modal.style.display = 'none';
            stopTimeUpdate();
            if (blogContainer.classList.contains('active')) exitBlog();
        }

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && modal.style.display === 'flex') closeModal();
        });

        // 社交链接与头像
        function initSocialLinks() {
            let copyrightIcon = document.getElementById('copyrightIcon');
            let qqIcon = document.getElementById('qqIcon');
            let githubIcon = document.getElementById('githubIcon');
            let emailIcon = document.getElementById('emailIcon');
            if (copyrightIcon) {
                copyrightIcon.addEventListener('click', function(e) {
                    e.preventDefault();
                    if (SOCIAL_LINKS.copyrightUrl && SOCIAL_LINKS.copyrightUrl !== '#') {
                        window.open(SOCIAL_LINKS.copyrightUrl, '_blank', 'noopener');
                    }
                });
            }
            if (qqIcon) qqIcon.setAttribute('href', 'tencent://message/?uin=' + SOCIAL_LINKS.qqUin);
            if (githubIcon) githubIcon.setAttribute('href', SOCIAL_LINKS.githubUrl);
            if (emailIcon) emailIcon.setAttribute('href', 'mailto:' + SOCIAL_LINKS.emailAddress);
        }

        function initAvatarUpload() {
            let avatarWrapper = document.getElementById('avatarWrapper');
            let avatarImg = document.getElementById('avatarImg');
            let avatarFallback = document.getElementById('avatarFallback');
            let saved = localStorage.getItem('blog_avatar_data');
            if (saved) {
                avatarImg.src = saved;
                avatarImg.style.display = 'block';
                if (avatarFallback) avatarFallback.style.display = 'none';
            }
            if (!avatarWrapper) return;
            avatarWrapper.addEventListener('click', function() {
                let input = document.createElement('input');
                input.type = 'file';
                input.accept = 'image/*';
                input.onchange = function(e) {
                    let file = e.target.files[0];
                    if (!file) return;
                    let reader = new FileReader();
                    reader.onload = function(ev) {
                        avatarImg.src = ev.target.result;
                        avatarImg.style.display = 'block';
                        if (avatarFallback) avatarFallback.style.display = 'none';
                        localStorage.setItem('blog_avatar_data', ev.target.result);
                    };
                    reader.readAsDataURL(file);
                };
                input.click();
            });
        }

        initSocialLinks();
        initAvatarUpload();

        // 博客切换
        function enterBlog() {
            homeIcon.classList.add('hidden');
            blogIconModal.classList.add('hidden');
            blogContainer.style.display = 'block';
            blogContainer.classList.add('active');
            updateBlogAnchor();
            exitDetailViewSilent();
            renderPosts();
        }

        function exitBlog() {
            blogContainer.classList.remove('active');
            blogContainer.style.display = 'none';
            homeIcon.classList.remove('hidden');
            blogIconModal.classList.remove('hidden');
            exitDetailViewSilent();
        }

        homeIcon.addEventListener('click', function(e) { e.stopPropagation(); });
        blogIconModal.addEventListener('click', function(e) {
            e.stopPropagation();
            enterBlog();
        });
        backToHomeBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            exitBlog();
        });

        function formatDateTimeCN(value) {
            if (!value) return '未知';
            let s = String(value).trim().replace('T', ' ');
            s = s.replace(/\.\d+$/, '');
            let m = s.match(/^(\d{4})-(\d{1,2})-(\d{1,2})\s+(\d{1,2}):(\d{1,2})(?::(\d{1,2}))?$/);
            if (m) {
                let y = m[1];
                let mon = String(parseInt(m[2], 10));
                let d = String(parseInt(m[3], 10));
                let hh = String(parseInt(m[4], 10)).padStart(2, '0');
                let mm = String(parseInt(m[5], 10)).padStart(2, '0');
                let ss = String(parseInt(m[6] || '0', 10)).padStart(2, '0');
                return y + '/' + mon + '/' + d + ' ' + hh + ':' + mm + ':' + ss;
            }
            let dt = new Date(s);
            if (!isNaN(dt.getTime())) {
                return dt.getFullYear() + '/' + (dt.getMonth() + 1) + '/' + dt.getDate() + ' ' +
                    String(dt.getHours()).padStart(2, '0') + ':' +
                    String(dt.getMinutes()).padStart(2, '0') + ':' +
                    String(dt.getSeconds()).padStart(2, '0');
            }
            return s;
        }

        const BLOG_API = {
            posts: APP_CTX + '/posts',
            comments: APP_CTX + '/comments',
            likes: APP_CTX + '/likes'
        };

        function safeJSONParse(text) {
            try { return JSON.parse(text); } catch (_) { return null; }
        }

        async function requestJSON(url, options) {
            const opt = Object.assign({ credentials: 'same-origin' }, options || {});
            if (opt.body && (!opt.headers || !opt.headers['Content-Type'])) {
                opt.headers = Object.assign({}, opt.headers || {}, {
                    'Content-Type': 'application/json;charset=UTF-8'
                });
            }
            const resp = await fetch(url, opt);
            const raw = await resp.text();
            const data = safeJSONParse(raw);
            if (!resp.ok) {
                const msg = (data && (data.message || data.msg || data.error)) ||
                    ('请求失败（' + resp.status + '）');
                throw new Error(msg);
            }
            return data != null ? data : {};
        }

        function normalizeComment(c) {
            return {
                id: c && c.id !== undefined ? c.id : Date.now() + Math.floor(Math.random() * 1000),
                author: (c && (c.author || c.username)) ? (c.author || c.username) : '匿名',
                content: (c && c.content) ? c.content : '',
                date: formatDateTimeCN(c && (c.date || c.createdAt || c.createTime || c.created_at))
            };
        }

        function normalizePost(p) {
            return {
                id: p.id,
                title: p.title || '无题',
                content: p.content || '',
                createdAt: formatDateTimeCN(p.createdAt || ''),
                updatedAt: formatDateTimeCN(p.updatedAt || ''),
                views: (p.viewsCount != null ? p.viewsCount : (p.views || 0)),
                likes: (p.likesCount != null ? p.likesCount : (p.likes || p.likeCount || 0)),
                commentsCount: (p.commentsCount != null ? p.commentsCount : (Array.isArray(p.comments) ? p.comments.length : 0)),
                liked: !!(p.liked || p.likedByCurrentUser),
                comments: Array.isArray(p.comments) ? p.comments.map(normalizeComment) : []
            };
        }

        let posts = [];

        async function loadPosts() {
            try {
                const list = await requestJSON(BLOG_API.posts + '?limit=50&offset=0', { method: 'GET' });
                posts = Array.isArray(list) ? list.map(normalizePost) : [];
            } catch (e) {
                posts = [];
                showToast(e.message || '文章加载失败');
                console.error(e);
            }
        }

        async function loadPostDetail(postId) {
            const detail = await requestJSON(BLOG_API.posts + '?id=' + encodeURIComponent(postId), { method: 'GET' });
            return normalizePost(detail);
        }

        function escapeHtml(str) {
            let div = document.createElement('div');
            div.appendChild(document.createTextNode(str == null ? '' : String(str)));
            return div.innerHTML;
        }

        function extractExcerpt(html, maxLength) {
            maxLength = maxLength || 80;
            let temp = document.createElement('div');
            temp.innerHTML = html || '';
            let text = temp.textContent || temp.innerText || '';
            return text.length > maxLength ? text.substring(0, maxLength) + '...' : text;
        }

        let postsContainer = document.getElementById('postsContainer');
        let detailView = document.getElementById('detailView');
        let postsArea = document.getElementById('postsArea');
        let floatingNewPostBtn = document.getElementById('floatingNewPostBtn');
        let currentDetailPostId = null;
        let currentEditingPostId = null;

        // ----- 权限判断辅助函数 -----
        function canWrite() {
            return window.isAdmin === true;
        }
        function canEditDelete() {
            return window.isAdmin === true;
        }
        function canLike() {
            return window.isLoggedIn === true && window.isGuest === false;
        }
        function canComment() {
            return window.isLoggedIn === true && window.isGuest === false;
        }

        // ----- 根据权限显示/隐藏“写文章”按钮 -----
        function updateFloatingButtonVisibility() {
            if (floatingNewPostBtn) {
                if (canWrite()) {
                    floatingNewPostBtn.style.display = '';
                    floatingNewPostBtn.disabled = false;
                } else {
                    floatingNewPostBtn.style.display = 'none';
                    floatingNewPostBtn.disabled = true;
                }
            }
        }

        // ----- 渲染文章列表 -----
        function renderPosts() {
            if (!postsContainer) return;
            if (posts.length === 0) {
                postsContainer.innerHTML = '<div class="empty-message">📭 还没有文章，点击 + 开始创作</div>';
            } else {
                let html = '';
                posts.sort(function(a, b) { return (b.id || 0) - (a.id || 0); });
                posts.forEach(function(post) {
                    let excerpt = extractExcerpt(post.content, 100);
                    html += '<div class="post-card">' +
                        '<div class="post-info">' +
                        '<div class="post-title" data-id="' + post.id + '">' + escapeHtml(post.title || '无题') + '</div>' +
                        '<div class="post-excerpt">' + escapeHtml(excerpt) + '</div>' +
                        '<div class="post-meta">' +
                        '<span>' + SVG_ICONS.eye + ' ' + (post.views || 0) + '</span>' +
                        '<span>' + SVG_ICONS.heartOutline + ' ' + (post.likes || 0) + '</span>' +
                        '<span>' + SVG_ICONS.message + ' ' + (post.commentsCount || 0) + '</span>' +
                        '<span>' + SVG_ICONS.calendar + ' ' + escapeHtml(post.createdAt || '未知') + '</span>' +
                        '</div>' +
                        '</div>' +
                        '</div>';
                });
                postsContainer.innerHTML = html;
            }
            updateStats();
            updateFloatingButtonVisibility();
        }

        // ----- 显示文章详情（根据权限隐藏并禁用操作）-----
        async function showPostDetail(postId) {
            try {
                let post = await loadPostDetail(postId);
                let idx = posts.findIndex(function(p) { return p.id === postId; });
                if (idx >= 0) posts[idx] = post;
                else posts.push(post);

                currentDetailPostId = postId;
                postsContainer.style.display = 'none';
                if (floatingNewPostBtn) floatingNewPostBtn.style.display = 'none';
                postsArea.style.overflow = 'hidden';

                let likeBtnClass = post.liked ? 'btn-like liked' : 'btn-like';
                let likeBtnText = post.liked ? SVG_ICONS.heartFilled + ' 已点赞' : SVG_ICONS.heartOutline + ' 点赞';

                function buildCommentsHtml() {
                    if (post.comments && post.comments.length > 0) {
                        return post.comments.map(function(c) {
                            return '<div class="comment-item">' +
                                '<span class="comment-author">' + escapeHtml(c.author || '匿名') + '</span>' +
                                '<span class="comment-date">' + escapeHtml(c.date || '') + '</span>' +
                                '<span class="comment-text">' + escapeHtml(c.content || '') + '</span>' +
                                '</div>';
                        }).join('');
                    }
                    return '<span class="no-comments">暂无评论，来抢沙发吧~</span>';
                }

                let showEditDelete = canEditDelete();
                let showLike = canLike();
                let showCommentBox = canComment();

                let html = '';
                html += '<div class="detail-nav">';
                html += '  <span class="detail-title">' + escapeHtml(post.title || '无题') + '</span>';
                html += '  <div class="detail-actions">';
                if (showEditDelete) {
                    html += '    <button class="btn-edit-detail" id="detailEditBtn" data-id="' + post.id + '">编辑</button>';
                    html += '    <button class="btn-delete-detail" id="detailDeleteBtn" data-id="' + post.id + '">🗑️删除</button>';
                }
                html += '  </div>';
                html += '  <button class="btn-back" id="backToListBtn"><svg viewBox="0 0 24 24" style="width:16px;height:16px;vertical-align:middle;"><path d="M19 12H5M12 19l-7-7 7-7"/></svg>返回列表</button>';
                html += '</div>';
                html += '<div class="detail-meta">';
                html += '  <span>' + SVG_ICONS.calendar + ' ' + escapeHtml(post.createdAt || '未知') + '</span>';
                html += '  <span>' + SVG_ICONS.eye + ' 阅读 ' + (post.views || 0) + '</span>';
                html += '  <span id="detailMetaLikes">' + SVG_ICONS.heartOutline + ' 点赞 ' + (post.likes || 0) + '</span>';
                html += '  <span>' + SVG_ICONS.message + ' 评论 ' + (post.comments ? post.comments.length : 0) + '</span>';
                html += '</div>';
                html += '<div class="detail-scroll-area">';
                html += '  <div class="detail-content">' + (post.content || '') + '</div>';
                if (showLike) {
                    html += '  <div class="likes-section"><button id="likeActionBtn" class="' + likeBtnClass + '">' + likeBtnText + '</button></div>';
                }
                html += '  <div class="comments-section"><h4>评论 · 留言</h4><div class="comment-list" id="commentListArea">' + buildCommentsHtml() + '</div></div>';
                html += '</div>';
                if (showCommentBox) {
                    html += '<div class="add-comment-bottom">';
                    html += '  <textarea id="commentContentInput" placeholder="写下你的想法..." rows="1"></textarea>';
                    html += '  <button id="submitCommentBtn" class="btn-submit-comment">发表评论</button>';
                    html += '</div>';
                } else {
                    html += '<div class="add-comment-bottom" style="border-top: none; padding-top: 0;">';
                    html += '  <span style="font-size:14px; color:#8aaec9;">登录后可评论</span>';
                    html += '</div>';
                }

                detailView.innerHTML = html;
                detailView.classList.add('active');

                // 绑定事件
                document.getElementById('backToListBtn').addEventListener('click', exitDetailView);

                if (showEditDelete) {
                    document.getElementById('detailEditBtn').addEventListener('click', function() {
                        if (!canEditDelete()) {
                            showToast('无权限编辑文章');
                            return;
                        }
                        openEditModalForPost(parseInt(this.getAttribute('data-id'), 10));
                    });
                    document.getElementById('detailDeleteBtn').addEventListener('click', function() {
                        if (!canEditDelete()) {
                            showToast('无权限删除文章');
                            return;
                        }
                        deletePost(parseInt(this.getAttribute('data-id'), 10));
                    });
                }

                if (showLike) {
                    document.getElementById('likeActionBtn').addEventListener('click', function() {
                        if (!canLike()) {
                            showToast('请先登录');
                            return;
                        }
                        toggleLike(post.id);
                    });
                }

                if (showCommentBox) {
                    let submitCommentBtn = document.getElementById('submitCommentBtn');
                    let commentTextarea = document.getElementById('commentContentInput');

                    async function submitComment() {
                        if (!canComment()) {
                            showToast('请先登录');
                            return;
                        }
                        let content = commentTextarea.value.trim();
                        if (!content) {
                            showToast('请输入评论内容');
                            return;
                        }
                        try {
                            await requestJSON(BLOG_API.comments, {
                                method: 'POST',
                                body: JSON.stringify({
                                    postId: post.id,
                                    content: content
                                })
                            });
                            let latest = await loadPostDetail(post.id);
                            let idx2 = posts.findIndex(function(p) { return p.id === post.id; });
                            if (idx2 >= 0) posts[idx2] = latest;
                            post = latest;

                            let commentListArea = document.getElementById('commentListArea');
                            if (commentListArea) {
                                commentListArea.innerHTML = (post.comments && post.comments.length > 0)
                                    ? post.comments.map(function(c) {
                                        return '<div class="comment-item">' +
                                            '<span class="comment-author">' + escapeHtml(c.author || '匿名') + '</span>' +
                                            '<span class="comment-date">' + escapeHtml(c.date || '') + '</span>' +
                                            '<span class="comment-text">' + escapeHtml(c.content || '') + '</span>' +
                                            '</div>';
                                    }).join('')
                                    : '<span class="no-comments">暂无评论，来抢沙发吧~</span>';
                            }
                            let metaComments = document.querySelector('.detail-meta span:last-child');
                            if (metaComments) {
                                metaComments.innerHTML = SVG_ICONS.message + ' 评论 ' + (post.comments ? post.comments.length : 0);
                            }
                            commentTextarea.value = '';
                            commentTextarea.style.height = 'auto';
                            showToast('评论发表成功！');
                            renderPosts();
                        } catch (e) {
                            showToast(e.message || '评论发表失败');
                            console.error(e);
                        }
                    }

                    submitCommentBtn.addEventListener('click', submitComment);
                    commentTextarea.addEventListener('keydown', function(e) {
                        if (e.key === 'Enter' && e.ctrlKey) {
                            e.preventDefault();
                            submitComment();
                        }
                    });
                    commentTextarea.addEventListener('input', function() {
                        this.style.height = 'auto';
                        this.style.height = this.scrollHeight + 'px';
                    });
                }

                updateStats();
            } catch (e) {
                showToast(e.message || '加载详情失败');
                console.error(e);
            }
        }

        // ----- 切换点赞 -----
        async function toggleLike(postId) {
            let post = posts.find(function(p) { return p.id === postId; });
            if (!post) return;
            if (!canLike()) {
                showToast('请先登录');
                return;
            }
            try {
                if (post.liked) {
                    await requestJSON(BLOG_API.likes + '?postId=' + encodeURIComponent(postId), {
                        method: 'DELETE'
                    });
                } else {
                    await requestJSON(BLOG_API.likes, {
                        method: 'POST',
                        body: JSON.stringify({ postId: postId })
                    });
                }
                let latest = await loadPostDetail(postId);
                Object.assign(post, latest);
                let likeBtn = document.getElementById('likeActionBtn');
                if (likeBtn) {
                    likeBtn.className = post.liked ? 'btn-like liked' : 'btn-like';
                    likeBtn.innerHTML = post.liked ? SVG_ICONS.heartFilled + ' 已点赞' : SVG_ICONS.heartOutline + ' 点赞';
                }
                let metaLikes = document.getElementById('detailMetaLikes');
                if (metaLikes) {
                    metaLikes.innerHTML = SVG_ICONS.heartOutline + ' 点赞 ' + (post.likes || 0);
                }
                updateStats();
                renderPosts();
            } catch (e) {
                showToast(e.message || '点赞操作失败');
                console.error(e);
            }
        }

        // ----- 退出详情 -----
        function exitDetailView() {
            detailView.classList.remove('active');
            detailView.innerHTML = '';
            postsContainer.style.display = 'block';
            updateFloatingButtonVisibility();
            postsArea.style.overflow = 'auto';
            currentDetailPostId = null;
            renderPosts();
        }

        function exitDetailViewSilent() {
            detailView.classList.remove('active');
            detailView.innerHTML = '';
            postsContainer.style.display = 'block';
            updateFloatingButtonVisibility();
            postsArea.style.overflow = 'auto';
            currentDetailPostId = null;
            renderPosts();
        }

        // ----- 删除文章（仅管理员）-----
        async function deletePost(postId) {
            if (!canEditDelete()) {
                showToast('无权限删除文章');
                return;
            }
            if (!confirm('确定要删除这篇文章吗？此操作不可恢复。')) return;
            try {
                await requestJSON(BLOG_API.posts + '?id=' + encodeURIComponent(postId), {
                    method: 'DELETE'
                });
                posts = posts.filter(function(p) { return p.id !== postId; });
                showToast('文章已删除');
                exitDetailView();
                renderPosts();
            } catch (e) {
                showToast(e.message || '删除失败');
                console.error(e);
            }
        }

        // 点击文章标题进入详情
        postsContainer.addEventListener('click', function(e) {
            let titleEl = e.target.closest('.post-title');
            if (titleEl) {
                let id = parseInt(titleEl.getAttribute('data-id'), 10);
                if (!isNaN(id)) showPostDetail(id);
            }
        });

        // ----- 统计信息更新 -----
        function updateStats() {
            let totalArticles = posts.length;
            let totalViews = posts.reduce(function(s, p) { return s + (p.views || 0); }, 0);
            let totalLikes = posts.reduce(function(s, p) { return s + (p.likes || 0); }, 0);
            let lastUpdate = '暂无';
            if (posts.length > 0) {
                let sorted = posts.slice().sort(function(a, b) { return (b.id || 0) - (a.id || 0); });
                lastUpdate = sorted[0].createdAt || '未知';
            }
            let statArticleCount = document.getElementById('statArticleCount');
            let statTotalViews = document.getElementById('statTotalViews');
            let statTotalLikes = document.getElementById('statTotalLikes');
            let statLastUpdate = document.getElementById('statLastUpdate');
            if (statArticleCount) statArticleCount.textContent = totalArticles + ' 篇';
            if (statTotalViews) statTotalViews.textContent = totalViews + ' 次';
            if (statTotalLikes) statTotalLikes.textContent = totalLikes + ' 个';
            if (statLastUpdate) statLastUpdate.textContent = lastUpdate;
        }

        // ----- 编辑器相关 -----
        let editor = null;

        function showToast(msg, dur) {
            let t = document.getElementById('toastMsg');
            if (!t) return;
            t.textContent = msg;
            t.classList.add('show');
            clearTimeout(t._timer);
            t._timer = setTimeout(function() {
                t.classList.remove('show');
            }, dur || 2000);
        }

        // ===== 修改后的 initEditor（已配置图片上传） =====
        function initEditor(initialContent) {
            if (editor) {
                editor.destroy();
                editor = null;
            }
            if (!window.wangEditor || !window.wangEditor.createEditor || !window.wangEditor.createToolbar) {
                showToast('编辑器资源未加载');
                return;
            }

            // 图片上传配置（适配您的 /uploadImage 接口）
            const uploadConfig = {
                server: APP_CTX + '/uploadImage',
                fieldName: 'image',
                allowedTypes: ['image/*'],
                maxFileSize: 10 * 1024 * 1024,
                timeout: 10000,
                customInsert: function(res, insertFn) {
                    if (res.errno === 0 && res.data && res.data.url) {
                        insertFn(res.data.url);
                    } else {
                        console.error('图片上传失败：', res);
                        showToast('图片上传失败：' + (res.message || '未知错误'));
                    }
                }
            };

            const editorConfig = {
                placeholder: '开始撰写文章...',
                autoFocus: false,
                MENU_CONF: {
                    uploadImage: uploadConfig
                }
            };

            editor = window.wangEditor.createEditor({
                selector: '#editor-container',
                config: editorConfig,
                html: initialContent || ''
            });

            const toolbarConfig = {
                excludeKeys: ['emotion', 'todo', 'insertTable', 'insertVideo']
            };

            window.wangEditor.createToolbar({
                editor: editor,
                selector: '#toolbar-container',
                config: toolbarConfig
            });
        }

        function destroyEditor() {
            if (editor) {
                editor.destroy();
                editor = null;
            }
        }

        function openEditModal() {
            if (!canWrite()) {
                showToast('无权限发表文章');
                return;
            }
            currentEditingPostId = null;
            document.getElementById('editTitleInput').value = '';
            document.getElementById('editModalTitle').innerText = '写新文章';
            document.getElementById('editModal').classList.add('active');
            requestAnimationFrame(function() { initEditor(''); });
        }

        async function openEditModalForPost(postId) {
            if (!canEditDelete()) {
                showToast('无权限编辑文章');
                return;
            }
            let post = posts.find(function(p) { return p.id === postId; });
            if (!post) {
                try {
                    post = await loadPostDetail(postId);
                    posts.push(post);
                } catch (e) {
                    showToast(e.message || '加载文章失败');
                    return;
                }
            }
            currentEditingPostId = postId;
            document.getElementById('editTitleInput').value = post.title || '';
            document.getElementById('editModalTitle').innerText = '编辑文章';
            document.getElementById('editModal').classList.add('active');
            requestAnimationFrame(function() { initEditor(post.content || ''); });
        }

        function closeEditModal() {
            document.getElementById('editModal').classList.remove('active');
            destroyEditor();
            currentEditingPostId = null;
        }

        async function savePost() {
            if (!canWrite()) {
                showToast('无权限保存文章');
                return;
            }
            if (!editor) {
                showToast('编辑器尚未就绪');
                return;
            }
            let title = document.getElementById('editTitleInput').value.trim();
            let content = editor.getHtml().trim();
            if (!title && !content) {
                showToast('标题和内容不能都为空');
                return;
            }
            try {
                if (currentEditingPostId !== null) {
                    await requestJSON(BLOG_API.posts, {
                        method: 'PUT',
                        body: JSON.stringify({
                            id: currentEditingPostId,
                            title: title || '无题',
                            content: content
                        })
                    });
                    showToast('文章更新成功！');
                } else {
                    await requestJSON(BLOG_API.posts, {
                        method: 'POST',
                        body: JSON.stringify({
                            title: title || '无题',
                            content: content
                        })
                    });
                    showToast('文章发布成功！');
                }
                await loadPosts();
                closeEditModal();
                renderPosts();
                if (currentDetailPostId !== null) {
                    let still = posts.find(function(p) { return p.id === currentDetailPostId; });
                    if (still) showPostDetail(currentDetailPostId);
                    else exitDetailView();
                }
                currentEditingPostId = null;
            } catch (e) {
                showToast(e.message || '保存失败');
                console.error(e);
            }
        }

        // 绑定浮动按钮
        let floatingBtn = document.getElementById('floatingNewPostBtn');
        if (floatingBtn) {
            floatingBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                openEditModal();
            });
        }

        // 保存按钮
        let saveEditBtn = document.getElementById('saveEditBtn');
        if (saveEditBtn) {
            saveEditBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                savePost();
            });
        }

        let closeEditModalBtn = document.getElementById('closeEditModalBtn');
        if (closeEditModalBtn) closeEditModalBtn.addEventListener('click', closeEditModal);

        let cancelEditBtn = document.getElementById('cancelEditBtn');
        if (cancelEditBtn) cancelEditBtn.addEventListener('click', closeEditModal);

        document.addEventListener('keydown', function(e) {
            let editModal = document.getElementById('editModal');
            if (e.key === 'Escape' && editModal && editModal.classList.contains('active')) {
                closeEditModal();
            }
        });

        // 初始化加载文章
        (async function initPosts() {
            await loadPosts();
            renderPosts();
        })();

    })();

    /* ==================== 日志功能补充 JS ==================== */
    (function() {
        const APP_CTX = (typeof ctx === 'string' && ctx) ? ctx : '/MyWeb';

        var show_log = document.getElementById('show_log');
        var edit_log = document.getElementById('edit_log');
        var mg_log = document.getElementById('mg_log');
        var add_log = document.getElementById('add_log');
        var closeshowlog = document.getElementById('closeshowlog');
        var cancelModalBtn = document.getElementById('cancelModalBtn');
        var saveModalBtn = document.getElementById('saveModalBtn');

        var logTimeDisplay = document.querySelector('.log_time_display');
        var logContentPreview = document.querySelector('.log_content_preview');
        var logCounter = document.querySelector('.log_counter');
        var leftArrow = document.querySelector('.left_arrow');
        var rightArrow = document.querySelector('.right_arrow');

        var logTimeInput = document.getElementById('logTimeInput');
        var logContentInput = document.getElementById('logContentInput');

        var previewTime = document.getElementById('previewTime');
        var previewContent = document.getElementById('previewContent');
        var previewCount = document.getElementById('previewCount');

        var logsData = [];
        var currentLogIndex = 0;

        async function fetchLogs() {
            try {
                var res = await fetch(APP_CTX + '/logs?limit=50&offset=0');
                if (!res.ok) throw new Error('获取日志失败');
                var data = await res.json();
                logsData = data.map(function(item) {
                    return { id: item.id, time: item.time, content: item.content };
                });
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
                var res = await fetch(APP_CTX + '/logs', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json;charset=UTF-8' },
                    body: JSON.stringify({ time: time, content: content })
                });
                var result = await res.json();
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
                var res = await fetch(APP_CTX + '/logs?id=' + id, { method: 'DELETE' });
                var result = await res.json();
                if (result.ok) {
                    var index = logsData.findIndex(function(log) { return log.id === id; });
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

        function renderAll() {
            if (!Array.isArray(logsData) || logsData.length === 0) {
                if (previewTime) previewTime.textContent = '📅 暂无日志';
                if (previewContent) previewContent.textContent = '没有日志，请点击下方按钮添加';
                if (previewCount) previewCount.textContent = '共 0 条';
                if (logTimeDisplay) logTimeDisplay.textContent = '暂无日志';
                if (logContentPreview) logContentPreview.textContent = '没有日志，请点击"添加日志"添加';
                if (logCounter) logCounter.textContent = '0 / 0';
                return;
            }
            var first = logsData[0];
            var displayTime = first.time ? first.time.replace('T', ' ') : '未知时间';
            if (previewTime) previewTime.textContent = '📅 ' + displayTime;
            if (previewContent) previewContent.textContent = first.content || '（空内容）';
            if (previewCount) previewCount.textContent = '共 ' + logsData.length + ' 条';
            if (currentLogIndex >= logsData.length) currentLogIndex = logsData.length - 1;
            if (currentLogIndex < 0) currentLogIndex = 0;
            var log = logsData[currentLogIndex];
            if (!log) return;
            var formattedTime = log.time.replace('T', ' ');
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
                var newTime = logTimeInput.value;
                var newContent = logContentInput.value;
                if (!newTime || !newContent.trim()) {
                    alert("请填写完整的时间和正文内容");
                    return;
                }
                var success = await addLogToServer(newTime, newContent);
                if (success) {
                    edit_log.close();
                    if (show_log.open) renderAll();
                }
            });
        }

        var deleteLogBtn = document.getElementById('delete_current_log');
        if (deleteLogBtn) {
            deleteLogBtn.addEventListener('click', function(e) {
                e.stopPropagation?.();
                if (!logsData.length) {
                    alert('没有日志可删除');
                    return;
                }
                var log = logsData[currentLogIndex];
                if (!log || !log.id) {
                    alert('无法获取当前日志 ID');
                    return;
                }
                var confirmDelete = confirm(
                    '确定要删除这条日志吗？\n时间：' + (log.time?.replace('T', ' ') || '未知') +
                    '\n正文预览：' + (log.content || '').substring(0, 50) +
                    ((log.content || '').length > 50 ? '…' : '')
                );
                if (!confirmDelete) return;
                deleteLogFromServer(log.id);
            });
        }

        fetchLogs();

        var DRAFT_API = APP_CTX + '/draft';

        async function saveDraft() {
            var payload = {
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
                var r = await fetch(DRAFT_API, { credentials: 'same-origin' });
                if (!r.ok) return;
                var data = await r.json();
                if (data && data.time != null) logTimeInput.value = data.time;
                if (data && data.content != null) logContentInput.value = data.content;
            } catch (_) {}
        }

        if (add_log) {
            var newAddLogHandler = async function(e) {
                await loadDraftToInputs();
                edit_log.showModal();
            };
            var oldAddLog = document.getElementById('add_log');
            if (oldAddLog) {
                var newAddLog = oldAddLog.cloneNode(true);
                oldAddLog.parentNode.replaceChild(newAddLog, oldAddLog);
                newAddLog.addEventListener('click', newAddLogHandler);
                add_log = newAddLog;
            }
        }

        var draftTimer = null;
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
                var payload = JSON.stringify({
                    time: logTimeInput.value || null,
                    content: logContentInput.value || ""
                });
                var blob = new Blob([payload], { type: 'application/json;charset=UTF-8' });
                navigator.sendBeacon(DRAFT_API, blob);
            } catch (_) {}
        });

        document.addEventListener('click', async function(e) {
            var a = e.target.closest && e.target.closest('a');
            if (!a) return;
            var href = a.getAttribute('href');
            if (!href || href.startsWith('#') || href.startsWith('javascript:')) return;
            var url;
            try {
                url = new URL(href, location.href);
            } catch (_) {
                return;
            }
            if (url.origin !== location.origin) return;
            e.preventDefault();
            try {
                await saveDraft();
            } catch (_) {}
            location.href = url.href;
        }, true);

        window.logsData = logsData;
        window.renderAllLogs = renderAll;
        window.fetchLogs = fetchLogs;
    })();
</script>
</body>
</html>