<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

        /* 热区样式 */
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
            cursor: pointer;
            backdrop-filter: blur(4px);
        }

        #toggleHotspotBtn:hover {
            background: rgba(0, 0, 0, 0.9);
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
        .right-floating-bar {
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
    </style>
</head>
<body>
<div class="stage" id="stage">
    <img id="hero" src="resources/img/home.png" alt="background">
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
                        <div class="right-floating-bar" id="rightFloatingBar">
                            <div class="right-inner">
                                <span class="stats-title">📊 博客统计</span>
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
    <button id="toggleHotspotBtn">🔲 隐藏热区</button>
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
        eye: `<svg viewBox="0 0 24 24">
            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
            <circle cx="12" cy="12" r="3"/>
          </svg>`,
        heartOutline: `<svg viewBox="0 0 24 24">
                     <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"
                           fill="none"
                           stroke="currentColor"
                           stroke-width="2"
                           stroke-linecap="round"
                           stroke-linejoin="round"/>
                   </svg>`,
        heartFilled: `<svg viewBox="0 0 24 24">
                    <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"
                          fill="currentColor"
                          stroke="currentColor"
                          stroke-width="2"
                          stroke-linecap="round"
                          stroke-linejoin="round"/>
                  </svg>`,
        message: `<svg viewBox="0 0 24 24">
                <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>
              </svg>`,
        calendar: `<svg viewBox="0 0 24 24">
                 <rect x="3" y="4" width="18" height="18" rx="2" ry="2"/>
                 <line x1="16" y1="2" x2="16" y2="6"/>
                 <line x1="8" y1="2" x2="8" y2="6"/>
                 <line x1="3" y1="10" x2="21" y2="10"/>
               </svg>`
    };

    /* ============================================================
     *  锚定布局引擎
     *  ============================================================ */
    function createCoverAnchorLayout(backgroundImage,
                                     stage,
                                     target,
                                     anchor,
                                     options) {
        if (!backgroundImage || !stage || !target) {
            return null;
        }
        options = options || {};
        const ax = anchor.ax;
        const ay = anchor.ay;
        let offsetX = options.offsetX || 0;
        let offsetY = options.offsetY || 0;
        let onUpdate = options.onUpdate || null;

        function layout() {
            const iw = backgroundImage.naturalWidth;
            const ih = backgroundImage.naturalHeight;
            if (!iw || !ih) {
                return;
            }
            const vw = window.innerWidth;
            const vh = window.innerHeight;
            const scale = Math.max(vw / iw, vh / ih);
            const dx = (vw - iw * scale) / 2;
            const dy = 0;
            target.style.left = (dx + ax * scale + offsetX) + 'px';
            target.style.top = (dy + ay * scale + offsetY) + 'px';
            target.style.transform = 'scale(' + scale + ')';
            if (typeof onUpdate === 'function') {
                onUpdate(scale, dx, dy);
            }
        }

        function bindEvents() {
            if (backgroundImage.complete) {
                layout();
            }
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
                if (newOptions.offsetX !== undefined) {
                    offsetX = newOptions.offsetX;
                }
                if (newOptions.offsetY !== undefined) {
                    offsetY = newOptions.offsetY;
                }
                if (newOptions.onUpdate !== undefined) {
                    onUpdate = newOptions.onUpdate;
                }
                layout();
            }
        };
    }

    /* ============================================================
     *  初始化
     *  ============================================================ */
    (function() {
        let stage = document.getElementById('stage');
        let hero = document.getElementById('hero');
        let computer = document.getElementById('computer');
        if (!stage || !hero || !computer) {
            return;
        }

        let computerLocker = createCoverAnchorLayout(hero, stage, computer, { ax: 963, ay: 142 }, {});
        window.computerLocker = computerLocker;

        // 热区逻辑
        (function initHotspot() {
            let HOTSPOT = { x: 10, y: 10, width: 880, height: 570 };
            let hotspotVisual = document.createElement('div');
            hotspotVisual.id = 'hotspotVisual';
            hotspotVisual.style.cssText = 'left:' + HOTSPOT.x + 'px; top:' + HOTSPOT.y + 'px; width:' + HOTSPOT.width + 'px; height:' + HOTSPOT.height + 'px;';
            computer.appendChild(hotspotVisual);

            let isVisible = true;
            computer.addEventListener('mousemove', function(e) {
                let scale = 1;
                let match = computer.style.transform.match(/scale\(([\d.]+)\)/);
                if (match) scale = parseFloat(match[1]);

                let rect = computer.getBoundingClientRect();
                let mx = (e.clientX - rect.left) / scale;
                let my = (e.clientY - rect.top) / scale;
                let inside = mx >= HOTSPOT.x && mx <= HOTSPOT.x + HOTSPOT.width && my >= HOTSPOT.y && my <= HOTSPOT.y + HOTSPOT.height;

                computer.classList.toggle('computer-hover', inside);
                hotspotVisual.classList.toggle('active', inside);
            });
            computer.addEventListener('mouseleave', function() {
                computer.classList.remove('computer-hover');
                hotspotVisual.classList.remove('active');
            });

            let toggleBtn = document.getElementById('toggleHotspotBtn');
            if (toggleBtn) {
                toggleBtn.addEventListener('click', function() {
                    isVisible = !isVisible;
                    hotspotVisual.style.display = isVisible ? 'block' : 'none';
                    toggleBtn.textContent = isVisible ? '🔲 隐藏热区' : '🔳 显示热区';
                });
            }
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

        let modalContentLocker = createCoverAnchorLayout(modalBg, computerWindow, modalContent, { ax: 274, ay: 44 }, {
            onUpdate: function() {
                homeIcon.style.left = '41px';
                homeIcon.style.top = '50px';
                blogIconModal.style.left = '41px';
                blogIconModal.style.top = '254px';
                homeIcon.style.transform = 'scale(1)';
                blogIconModal.style.transform = 'scale(1)';
                updateBlogAnchor();
            }
        });

        let bottomBarLocker = createCoverAnchorLayout(modalBg, computerWindow, bottomBarContainer, { ax: 274, ay: 911 }, {
            onUpdate: function() {
                closeBtn.style.left = '10px';
                closeBtn.style.top = '0px';
                closeBtn.style.transform = '';
                footTime.style.left = '1300px';
                footTime.style.top = '0px';
                footTime.style.transform = '';
            }
        });

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
            footTime.textContent = now.getFullYear() + '/' +
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
            if (blogContainer.classList.contains('active')) {
                exitBlog();
            }
        }

        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && modal.style.display === 'flex') closeModal();
        });

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
        blogIconModal.addEventListener('click', function(e) { e.stopPropagation(); enterBlog(); });
        backToHomeBtn.addEventListener('click', function(e) { e.stopPropagation(); exitBlog(); });

        /* ==============================
           评论者昵称 - 后端接口预留
           ============================== */
        function getCurrentUserNickname() {
            // TODO: 可接 /user/me
            return "墨隅";
        }

        /* ==============================
           后端 API（按你给的 Servlet 接口）
           ============================== */
        const BLOG_API = {
            posts: '/posts',
            comments: '/comments',
            likes: '/likes'
        };

        function withCredentialsDefault(options) {
            let opt = Object.assign({}, options || {});
            if (!opt.headers) opt.headers = {};
            if (!opt.headers['Content-Type']) opt.headers['Content-Type'] = 'application/json';
            if (!opt.credentials) opt.credentials = 'include'; // 兼容基于 cookie/session 的登录
            return opt;
        }

        async function requestJSON(url, options) {
            const resp = await fetch(url, withCredentialsDefault(options));
            let data = null;
            const ct = resp.headers.get('content-type') || '';
            if (ct.indexOf('application/json') >= 0) {
                data = await resp.json();
            } else {
                // 某些 writeOk 可能不是标准 json content-type，也尽量尝试解析
                const txt = await resp.text();
                try { data = JSON.parse(txt); } catch (e) { data = { ok: resp.ok, message: txt }; }
            }
            if (!resp.ok) {
                const msg = (data && (data.message || data.msg)) ? (data.message || data.msg) : ('HTTP ' + resp.status);
                const err = new Error(msg);
                err.status = resp.status;
                err.data = data;
                throw err;
            }
            return data;
        }

        /* ==============================
           数据转换（后端 -> 前端视图）
           ============================== */
        function normalizeComment(c) {
            return {
                id: c && c.id !== undefined ? c.id : Date.now() + Math.floor(Math.random() * 1000),
                author: c && (c.author || c.username) ? (c.author || c.username) : '匿名',
                content: c && c.content ? c.content : '',
                date: c && (c.date || c.createdAt || c.createTime) ? (c.date || c.createdAt || c.createTime) : ''
            };
        }

        function normalizePost(p) {
            return {
                id: p.id,
                title: p.title || '无题',
                content: p.content || '',
                createdAt: p.createdAt || p.createTime || p.created_at || '',
                updatedAt: p.updatedAt || p.updateTime || p.updated_at || '',
                views: p.views || 0,
                likes: p.likes || p.likeCount || 0,
                liked: !!(p.liked || p.likedByCurrentUser),
                comments: Array.isArray(p.comments) ? p.comments.map(normalizeComment) : []
            };
        }

        /* ==============================
           文章数据管理（后端）
           ============================== */
        let posts = [];

        async function loadPosts() {
            try {
                // 对接 PostServlet.doGet 列表：GET /posts?limit=...&offset=...
                const list = await requestJSON(BLOG_API.posts + '?limit=50&offset=0', { method: 'GET' });
                posts = Array.isArray(list) ? list.map(normalizePost) : [];
            } catch (e) {
                posts = [];
                showToast(e.message || '文章加载失败');
                console.error(e);
            }
        }

        async function loadPostDetail(postId) {
            // 对接 PostServlet.doGet 详情：GET /posts?id=...
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
                        '<span>' + SVG_ICONS.message + ' ' + (post.comments ? post.comments.length : 0) + '</span>' +
                        '<span>' + SVG_ICONS.calendar + ' ' + escapeHtml(post.createdAt || '未知') + '</span>' +
                        '</div>' +
                        '</div>' +
                        '</div>';
                });
                postsContainer.innerHTML = html;
            }
            updateStats();
        }

        async function showPostDetail(postId) {
            try {
                // 每次进详情都请求后端（可拿到 views+1、最新评论、liked 状态）
                let post = await loadPostDetail(postId);

                // 同步到 posts 缓存
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

                let html = '';
                html += '<div class="detail-nav">';
                html += '  <span class="detail-title">' + escapeHtml(post.title) + '</span>';
                html += '  <div class="detail-actions">';
                html += '    <button class="btn-edit-detail" id="detailEditBtn" data-id="' + post.id + '">编辑</button>';
                html += '    <button class="btn-delete-detail" id="detailDeleteBtn" data-id="' + post.id + '">🗑️删除</button>';
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
                html += '  <div class="likes-section"><button id="likeActionBtn" class="' + likeBtnClass + '">' + likeBtnText + '</button></div>';
                html += '  <div class="comments-section"><h4>评论 · 留言</h4><div class="comment-list" id="commentListArea">' + buildCommentsHtml() + '</div></div>';
                html += '</div>';
                html += '<div class="add-comment-bottom">';
                html += '  <textarea id="commentContentInput" placeholder="写下你的想法..." rows="1"></textarea>';
                html += '  <button id="submitCommentBtn" class="btn-submit-comment">发表评论</button>';
                html += '</div>';

                detailView.innerHTML = html;
                detailView.classList.add('active');

                document.getElementById('backToListBtn').addEventListener('click', exitDetailView);
                document.getElementById('detailEditBtn').addEventListener('click', function() {
                    openEditModalForPost(parseInt(this.getAttribute('data-id')));
                });
                document.getElementById('detailDeleteBtn').addEventListener('click', function() {
                    deletePost(parseInt(this.getAttribute('data-id')));
                });

                document.getElementById('likeActionBtn').addEventListener('click', function() {
                    toggleLike(post.id);
                });

                let submitCommentBtn = document.getElementById('submitCommentBtn');
                let commentTextarea = document.getElementById('commentContentInput');

                async function submitComment() {
                    let content = commentTextarea.value.trim();
                    if (!content) {
                        showToast('请输入评论内容');
                        return;
                    }

                    try {
                        // 对接 CommentServlet.doPost: POST /comments { postId, content }
                        let res = await requestJSON(BLOG_API.comments, {
                            method: 'POST',
                            body: JSON.stringify({
                                postId: post.id,
                                content: content
                            })
                        });

                        // doPost 返回 {ok:true,id:...}，为拿 author/date，重新拉详情最稳
                        let latest = await loadPostDetail(post.id);
                        let idx2 = posts.findIndex(function(p) { return p.id === post.id; });
                        if (idx2 >= 0) posts[idx2] = latest;
                        post = latest;

                        let commentListArea = document.getElementById('commentListArea');
                        if (commentListArea) commentListArea.innerHTML = (function() {
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
                        })();

                        let metaComments = document.querySelector('.detail-meta span:last-child');
                        if (metaComments) metaComments.innerHTML = SVG_ICONS.message + ' 评论 ' + (post.comments ? post.comments.length : 0);

                        commentTextarea.value = '';
                        commentTextarea.style.height = 'auto';
                        showToast((res && res.ok) ? '评论发表成功！' : '评论已提交');
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

                updateStats();
            } catch (e) {
                showToast(e.message || '加载详情失败');
                console.error(e);
            }
        }

        async function toggleLike(postId) {
            let post = posts.find(function(p) { return p.id === postId; });
            if (!post) return;

            try {
                // 对接 LikeServlet:
                // - 点赞:   POST   /likes   body {postId}
                // - 取消赞: DELETE /likes?postId=...
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

                // 点赞接口只回 ok，不回数量，重新拉详情刷新 likes/liked
                let latest = await loadPostDetail(postId);
                Object.assign(post, latest);

                let likeBtn = document.getElementById('likeActionBtn');
                if (likeBtn) {
                    likeBtn.className = post.liked ? 'btn-like liked' : 'btn-like';
                    likeBtn.innerHTML = post.liked ? (SVG_ICONS.heartFilled + ' 已点赞') : (SVG_ICONS.heartOutline + ' 点赞');
                }
                let metaLikes = document.getElementById('detailMetaLikes');
                if (metaLikes) metaLikes.innerHTML = SVG_ICONS.heartOutline + ' 点赞 ' + (post.likes || 0);

                updateStats();
                renderPosts();
            } catch (e) {
                showToast(e.message || '点赞操作失败');
                console.error(e);
            }
        }

        function exitDetailView() {
            detailView.classList.remove('active');
            detailView.innerHTML = '';
            postsContainer.style.display = 'block';
            if (floatingNewPostBtn) floatingNewPostBtn.style.display = '';
            postsArea.style.overflow = 'auto';
            currentDetailPostId = null;
        }

        function exitDetailViewSilent() {
            detailView.classList.remove('active');
            detailView.innerHTML = '';
            postsContainer.style.display = 'block';
            if (floatingNewPostBtn) floatingNewPostBtn.style.display = '';
            postsArea.style.overflow = 'auto';
            currentDetailPostId = null;
        }

        async function deletePost(postId) {
            if (!confirm('确定要删除这篇文章吗？此操作不可恢复。')) return;
            try {
                // 对接 PostServlet.doDelete: DELETE /posts?id=...
                await requestJSON(BLOG_API.posts + '?id=' + encodeURIComponent(postId), { method: 'DELETE' });
                posts = posts.filter(function(p) { return p.id !== postId; });
                showToast('文章已删除');
                exitDetailView();
                renderPosts();
            } catch (e) {
                showToast(e.message || '删除失败');
                console.error(e);
            }
        }

        postsContainer.addEventListener('click', function(e) {
            let titleEl = e.target.closest('.post-title');
            if (titleEl) {
                let id = parseInt(titleEl.getAttribute('data-id'));
                if (!isNaN(id)) showPostDetail(id);
            }
        });

        function updateStats() {
            let totalArticles = posts.length;
            let totalViews = posts.reduce(function(s, p) { return s + (p.views || 0); }, 0);
            let totalLikes = posts.reduce(function(s, p) { return s + (p.likes || 0); }, 0);
            let lastUpdate = '暂无';
            if (posts.length > 0) {
                let sorted = posts.slice().sort(function(a, b) { return (b.id || 0) - (a.id || 0); });
                lastUpdate = sorted[0].createdAt || '未知';
            }

            let el1 = document.getElementById('statArticleCount');
            let el2 = document.getElementById('statTotalViews');
            let el3 = document.getElementById('statTotalLikes');
            let el4 = document.getElementById('statLastUpdate');
            if (el1) el1.textContent = totalArticles + ' 篇';
            if (el2) el2.textContent = totalViews + ' 次';
            if (el3) el3.textContent = totalLikes + ' 个';
            if (el4) el4.textContent = lastUpdate;
        }

        // ========== wangEditor 相关逻辑 ==========
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

        function initEditor(initialContent) {
            if (editor) {
                editor.destroy();
                editor = null;
            }
            const { createEditor, createToolbar } = window.wangEditor;

            const editorConfig = {
                placeholder: '开始撰写文章...',
                autoFocus: false
            };

            editor = createEditor({
                selector: '#editor-container',
                config: editorConfig,
                html: initialContent || ''
            });

            const toolbarConfig = {
                excludeKeys: ['emotion', 'todo', 'insertTable', 'insertVideo']
            };

            createToolbar({
                editor,
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
            currentEditingPostId = null;
            document.getElementById('editTitleInput').value = '';
            document.getElementById('editModalTitle').innerText = '写新文章';
            document.getElementById('editModal').classList.add('active');
            requestAnimationFrame(() => initEditor(''));
        }

        async function openEditModalForPost(postId) {
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
            requestAnimationFrame(() => initEditor(post.content || ''));
        }

        function closeEditModal() {
            document.getElementById('editModal').classList.remove('active');
            destroyEditor();
            currentEditingPostId = null;
        }

        async function savePost() {
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
                    // 对接 PostServlet.doPut：PUT /posts body {id,title,content}
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
                    // 对接 PostServlet.doPost：POST /posts body {title,content}
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
                    if (still) {
                        showPostDetail(currentDetailPostId);
                    } else {
                        exitDetailView();
                    }
                }
                currentEditingPostId = null;
            } catch (e) {
                showToast(e.message || '保存失败');
                console.error(e);
            }
        }

        document.getElementById('floatingNewPostBtn').addEventListener('click', function(e) {
            e.stopPropagation();
            openEditModal();
        });
        document.getElementById('saveEditBtn').addEventListener('click', function(e) {
            e.stopPropagation();
            savePost();
        });
        document.getElementById('closeEditModalBtn').addEventListener('click', closeEditModal);
        document.getElementById('cancelEditBtn').addEventListener('click', closeEditModal);
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape' && document.getElementById('editModal').classList.contains('active')) {
                closeEditModal();
            }
        });

        (async function initPosts() {
            await loadPosts();
            renderPosts();
        })();
    })();
</script>
</body>
</html>