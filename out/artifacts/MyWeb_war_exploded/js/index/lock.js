
function createCoverAnchorLayout(backgroundImage, stage, target, anchor, options = {}) {
    // 参数校验
    if (!backgroundImage || !stage || !target) {
        console.warn('createCoverAnchorLayout: 缺少必要参数');
        return null;
    }

    const { ax, ay } = anchor;
    const { offsetX = 0, offsetY = 0, onUpdate = null } = options;

    // 核心布局函数
    function layout() {
        const iw = backgroundImage.naturalWidth;
        const ih = backgroundImage.naturalHeight;
        if (!iw || !ih) return;

        const vw = window.innerWidth;
        const vh = window.innerHeight;

        // cover 缩放比
        const scale = Math.max(vw / iw, vh / ih);
        const rw = iw * scale;
        const rh = ih * scale;

        // 舞台高度 = 图片实际渲染高度（保留滚动能力）
        stage.style.height = Math.ceil(rh) + 'px';

        // 水平居中偏移（object-position: center top）
        const dx = (vw - rw) / 2;
        const dy = 0; // 顶部对齐

        // 目标元素跟随背景缩放 + 锚定在背景图的指定坐标
        target.style.left = (dx + ax * scale + offsetX) + 'px';
        target.style.top = (dy + ay * scale + offsetY) + 'px';
        target.style.transform = 'scale(' + scale + ')';

        // 执行回调（如果有）
        if (typeof onUpdate === 'function') {
            onUpdate(scale, dx, dy);
        }
    }

    // 绑定事件监听
    function bindEvents() {
        if (backgroundImage.complete) {
            layout();
        }
        backgroundImage.addEventListener('load', layout);
        window.addEventListener('resize', layout);
    }

    // 解绑事件（用于清理）
    function unbindEvents() {
        backgroundImage.removeEventListener('load', layout);
        window.removeEventListener('resize', layout);
    }

    // 立即执行绑定
    bindEvents();

    // 返回控制对象，方便外部调用
    return {
        layout,          // 手动触发重新布局
        bindEvents,
        unbindEvents,
        updateOptions: (newOptions) => {
            // 动态更新偏移量
            if (newOptions.offsetX !== undefined) options.offsetX = newOptions.offsetX;
            if (newOptions.offsetY !== undefined) options.offsetY = newOptions.offsetY;
            if (newOptions.onUpdate !== undefined) options.onUpdate = newOptions.onUpdate;
            layout();
        }
    };
}



const stage = document.getElementById('stage');
const hero = document.getElementById('hero');
const card = document.getElementById('card');

const cardLocker = createCoverAnchorLayout(hero, stage, card, {
    ax: 980,
    ay: 175
}, {
    // 可选：额外偏移
    // offsetX: 10,
    // offsetY: -5,
});
