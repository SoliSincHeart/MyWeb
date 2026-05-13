const stage = document.getElementById('stage');
const hero  = document.getElementById('hero');
const card  = document.getElementById('card');

const anchor = {
    ax: 1000,
    ay: 220
};

function layoutCoverScrollable() {
    const iw = hero.naturalWidth;
    const ih = hero.naturalHeight;
    if (!iw || !ih) return;

    const vw = window.innerWidth;
    const vh = window.innerHeight;

    // cover 缩放
    const scale = Math.max(vw / iw, vh / ih);
    const rw = iw * scale;
    const rh = ih * scale;

    // 让 stage 高度等于 cover 后的图片高度（保留你原本“可滚动裁剪区”的需求）
    stage.style.height = Math.ceil(rh) + "px";

    // 对应 object-position: center top
    const dx = (vw - rw) / 2; // 水平居中偏移（通常为负）
    const dy = 0;             // 顶部对齐

    // card 跟随背景同样缩放 + 钉在背景原图的锚点
    card.style.left = (dx + anchor.ax * scale) + "px";
    card.style.top  = (dy + anchor.ay * scale) + "px";
    card.style.transform = `scale(${scale})`;
}

if (hero.complete) layoutCoverScrollable();
hero.addEventListener('load', layoutCoverScrollable);
window.addEventListener('resize', layoutCoverScrollable);