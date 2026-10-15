# Smartisan OS UI — 组件规格（全量）

每个组件写明：Figma 节点、CSS 类与 HTML 结构、尺寸、各状态取值。节点 ID 汇总在 `inventory.md`，HTML 写法以 `assets/demo.html` 为准，视觉目标以 `screenshots/` 为准。

通用约定：
- 可按压组件都同时支持 `:active` 和 `.is-pressed`（后者用来静态展示按下态）。
- 禁用用 `:disabled` 或 `aria-disabled="true"`；选中用 `:checked`、`aria-selected`、`aria-pressed`、`aria-current`，具体见各组件。
- 图标用 `<svg class="s-icon"><use href="#si-名称"/></svg>`，单色图标随 `color` 变色，彩色图标用 `#si-c-名称`。

---

## 1. App Bar · `.s-appbar`（`40:887`）
```html
<header class="s-appbar">                 <!-- 红色版加 s-appbar--red -->
  <button aria-label="返回"><svg class="s-icon s-icon--20"><use href="#si-back"/></svg></button>
  <span class="s-appbar__spacer"></span>
  <span class="s-appbar__title">Title</span>
  <div class="s-appbar__actions">
    <button><svg class="s-icon"><use href="#si-confirm"/></svg></button>
    <button><svg class="s-icon s-icon--20"><use href="#si-setting"/></svg></button>
  </div>
</header>
```
- 432×48，内边距 8px 14px，间距 4；右侧操作组间距 18。
- 标题绝对居中（垂直方向上移 0.5px），16px 700。
- White：底 `#fff`，底边 1px `#d8d8d8`，标题 `#636363`，图标为灰色渐变 `#8c8c8c→#989898`。
- Red：底 `#cd3f3a→#c83530`，底边 `#b7241f`，标题和图标都是白色。
- 属性：`showBack`、`show1stIcon`（默认 confirm 24px）、`show2ndIcon`（默认 setting 20px），图标可替换。
- 示例：Settings（无返回，右侧放 Icon Button），App Store（红色，只有返回）。
- 文字操作：主操作（如"完成"）用 `.s-btn.s-btn--sm`，次要操作用 `.s-btn.s-btn--outline`，两者都是 30px 高；纯文字用 `.s-appbar__text`（16px 500 `#636363`，Kit 里没有，是推导出来的）。按钮重置规则的特异性为 0，加在按钮上的任何类都能覆盖它。

## 2. Buttons
### Elevated Button · `.s-btn`（`18:7`）
- 408×60，内边距 22，圆角 10（`button-radius`），16px 700 白字，`line-height: 1`。
- normal：`#5b87eb→#5883eb`，0.8px `#3f68e2`，drop-shadow `0 4px 2px rgba(0,0,0,.1)`。
- pressed：纯色 `#4772e6`，描边 `#2f54d7`（投影保留）。
- disabled：同 normal，整体 `opacity: .3`。
- 宽度撑满容器用 `.s-btn--block`。
### Small Elevated Button · `.s-btn--sm`（`147:413`）
- 高 30（约 62 宽），内边距 8px 12px，圆角 4（`button/radius/small`），14px 700，0.4px 描边，**无投影**。
- pressed 同大按钮；disabled 渐变改为 `#628cec→#517ce8`，描边 `#2c50cf`，opacity .3。
### BottomSheet Button · `.s-btn--sheet`（`27:138`）
- 392×48，圆角 8，白底，0.8px `#eee`，16px 700 `#636363`；pressed 底 `#f8f8f8`。
### Outlined Button · `.s-btn--outline`（`26:13`）
- 94×30：内边距 8px 28px，圆角 4，0.5px `#d3d3d3`，14px 700 `#606060`。
### Text Button · `.s-btn--text`（`147:270`）
- 12px 常规，`line-height: 1`，颜色 **Blue/400 `#5079d9`**。
### Icon Button · `.s-btn-icon`（`40:1028`）
- 38×30（内边距 6px 10px），圆角 6，底 Blue/100 `#e7edfd`，18px 图标 `#5c89f2`（`ri:menu-add-fill`）。
### Rounded Button · `.s-round-btn` / `.s-round-btn--sm`（`20:5`）
- large 80：外圈底座 `#ededed`；内圈 68 白旋钮 `#fff→#fcfcfc`，0.4px `#eee`，投影 `0 5px 16.6px rgba(0,0,0,.21)`；中间播放三角约 19×23，用灰色渐变。
- small 28：底座 `#f5f5f5`，内圈 23.3，投影 `0 4px 4px rgba(0,0,0,.12)`。
- pressed（两种尺寸相同）：内圈变 `#ebebeb→#f2f2f2`（Background/Button/White/Pressed）。
- 原始矢量：`assets/kit-renders/rounded-button-*.svg`。
### Segmented Button · `.s-segmented`（`26:83`，单项 `208:1263`）
```html
<div class="s-segmented"><button><span>全部</span></button><button aria-pressed="true"><span>视频</span></button>…</div>
```
- 白底条高 60，每段宽 100（想均分宽度加 `.s-segmented--fill`），段之间是 12px 高、0.8px 宽的 `#eee` 短竖线。
- 未选中：14px 700 `#636363` 纯文字。
- 选中：文字外包一块 30px 高的底，内边距 6px 12px，圆角 3，`#4878f0→#6997f4`，0.8px `#3d6fee`，白字。
- ⚠ Figma 单项变体的命名是反的：`Selected=False` 才是蓝块。
### Tabs · `.s-tabs`（`179:3017`，Tab `203:1864`）
```html
<div class="s-tabs" role="tablist"><button role="tab">日</button><button role="tab" aria-selected="true">周</button>…</div>
```
- 180×28.8，圆角 6，0.4px `#e2e2e2`。每项 60×28，Roboto/Inter 12px 700 `#636363`，白底，项间 0.5px `#f2f2f2`。
- 选中：底 `#b2b2b2`，0.4px `#a7a7a7`，白字，内阴影 `inset 0 4px 10px rgba(0,0,0,.06)`。

## 3. Bottom Navigation Bar · `.s-bottom-nav`（`203:2020`，Item `72:178`）
```html
<nav class="s-bottom-nav">
  <button><svg class="s-icon"><use href="#si-playlist"/></svg>Play List</button>
  <button aria-current="page"><svg class="s-icon"><use href="#si-playing"/></svg>Playing</button>
</nav>
```
- 432×54，白底，项居中，间距 48。每项 38×40，图标在上、标签在下（两端对齐）。
- 未选中：图标 22px，颜色为 Fill/Icon/Disabled 渐变 `#c6c6c6→#c8c8c8`；标签 8px `#9d9d9d`。
- 选中：图标 28px，纯色 `#636363`；标签 `#636363`。
- 示例图标：Recommend（like-outlined）、Hot（star-fill，选中）、Classify（list）、Game（game-filled）。

## 4. Bottom Sheet · `.s-sheet`（`27:121`），Header `.s-sheet__header`（`204:1173`）
```html
<div class="s-sheet">
  <div class="s-sheet__header">
    <button><svg class="s-icon s-icon--20"><use href="#si-close-thin"/></svg></button>
    <span class="s-sheet__spacer"></span><span class="s-sheet__title">Title</span>
    <button><svg class="s-icon s-icon--20"><use href="#si-confirm"/></svg></button>
  </div>
  <div class="s-sheet__body"><button class="s-btn s-btn--sheet">选项一</button>…</div>
</div>
```
- Header：高 48（内边距 14px 13px），`#fff→#fafafa`，底线 1px `#e2e2e2`，上圆角 20；标题 14px 700 `#656565` 居中（水平偏右 0.5px）；`showLeading`（× 20px 细线）、`showTrailing`（✓ 20px），二者都可以省略。BottomSheet 示例是"标题 + 右侧 ×"。
- Body：底 `#efefef`，内边距上 22、下 40、左右 20，按钮间距 20。

## 5. Chip · `.s-chip`（`253:2478`，共 40 个变体）
```html
<button class="s-chip s-chip--red s-chip--all"><svg class="s-icon"><use href="#si-star"/></svg>Label<svg class="s-icon"><use href="#si-chevron-right"/></svg></button>
```
- 高 30（最小高 30、最小宽 60），胶囊，0.4px 描边，12px 600，overflow hidden，图标 20px，元素间距 4。
- 样式（Style）：
  | 样式 | 类 | 结构 | 内边距 |
  |---|---|---|---|
  | None | （默认） | 文字 | 6px 16px |
  | All | `--all` | 星标 + 文字 + `>` | 左 4、右 0 |
  | Leading | `--leading` | 星标 + 文字 | 左 4、右 16 |
  | Trailing | `--trailing` | 文字 + `>` | 左 16、右 0 |
- 颜色 × 状态：
  | 颜色 | 类 | 底 | 描边 | 字/图标 | 按下底 | 按下描边 |
  |---|---|---|---|---|---|---|
  | White | （默认） | `#fafafa` | `#cecece` | `#646464` | `#e9e9e9→#ececec` | `#bfbfbf` |
  | Yellow | `--yellow` | `#fff5d9` | `#ccb08c` | `#cd9143` | `#f2e9d1→#f2e8c9` | `#c5aa87` |
  | Blue | `--blue` | `#ffffff` | `#93b2f7` | `#6393ff` | `#e6efff→#e1ecff` | `#93b2f7` |
  | Red | `--red` | `#ffe7e5` | `#eb7f77` | `#cc3e39` | `#f2dcda→#f2d8d6` | `#f0948d` |
  | Grey | `--grey` | `#f0f0f0` | `#dadada` | `#646464` | （原稿无，按 White 处理） | |
- Figma 里的上色图标：`icons/variants/star--chip-*.svg`、`chevron-right--chip-*.svg`。

## 6. Date / Time Picker · `.s-picker`（`147:276` / `147:390`）
```html
<div class="s-picker">
  <div class="s-sheet__header">…标题如 2024-08-01 Wed / Time…</div>
  <div class="s-picker__body"><div class="s-picker__well"><div class="s-picker__band"></div>
    <div class="s-picker__col"><span>2022</span><span>2023</span><span aria-selected="true">2024</span><span>2025</span><span>2026</span></div>…
  </div></div>
</div>
```
- 432×274；顶部是 Bottom Sheet Header（左 ×、右 ✓）。
- Body：`#ededed → #f1f1f1(14%) → #ededed`，左右 12、下 18。
- 滚轮井：1px `#c6c6c8`，圆角 6，`#fefefe(40.5%) → #e2e2e3`，内阴影 `inset 0 4px 12px rgba(0,0,0,.18)`。
- 选中带：距井顶 81px，高 44，横贯（左右各外扩 1px），`#fff → #f5f5f5(53.5%) → #f8f8f8`，1px `#d9d9d9`。
- 列：等分，列间 1px `rgba(206,206,206,.4)`；上下内边距 14，5 个值间距 16，16px；选中项高 38、`#55585c`，其余 `#b3b3b5`。
- DatePicker 三列：年 / 月 / 日；TimePicker 三列：时 / 分 / 上午·下午。
- CSS 只负责外观，滚动逻辑要自己实现（scroll-snap 或拖拽）。

## 7. Dialog（`248:871`）
```html
<div class="s-overlay"><div class="s-dialog" role="dialog">
  <div class="s-dialog__header">Title</div>
  <div class="s-dialog__body">正文</div>
  <div class="s-dialog__actions"><button>取消</button><button data-primary>确定</button></div>
</div></div>
```
- 用 `hidden` 属性控制显示和隐藏（`.s-overlay[hidden]` 已经处理），出现时有 0.15s 淡入；配合 `smartisan.js` 可以用 `data-s-open` / `data-s-close` 开关，点遮罩或按 Esc 关闭（加 `data-s-modal` 可禁止）。
- 遮罩 `rgba(0,0,0,.6)`；对话框宽 368（在 432 宽屏幕上左右各留 32）。
- **Dialog Header**（`171:272`）：高 48，底 `#fafafa`，底线 1px `#ededed`，上圆角 12，18px 700 `#636363` 居中。
- **Content**：白底，内边距 20，16px / 行高 24 `#656565`。
- **Dialog Action Group**（`253:1210`）：Count = 1 / 2 / 3，主操作放最右；下圆角 12；整组 drop-shadow `0 4px 2.1px rgba(0,0,0,.07)`；按钮之间 1px `#f2f2f2` 竖线。
- **Dialog Action Button**（`253:1049`）：高 54，底 `#f7f7f7`，顶线 0.8px `#e8e8e8`，14px 700；主操作 `#5e80d0`（`data-primary`），次要 `#636363`。
  - Pressed：底 `#dfdfdf`；主操作的顶线变为 `#d5d5d5`，次要操作的顶线保持 `#e8e8e8`。
- **Dialog state=pressed**（`11:163`）：整个对话框 opacity .9，正文改用 `#636363`，被按的按钮呈按下态 → `.s-dialog.is-pressed`。
- **Simple Dialog**（`40:1064`）：`.s-dialog--simple`；无标题、无按钮；宽 376，白底，圆角 12，内边距 40px 28px，正文 12px / 行高 28 `#898989`；点遮罩关闭。
- **List Dialog**（`195:1210`）：标题 + `.s-dialog__body--flush` 里放 4 个 `.s-radio-item` + 单个主操作。
- **TextField Dialog**（`195:1211`）：`.s-dialog__body--field`（内边距 24px 18px）里放 `.s-textfield`。
- **Text Field Size=Narrow**（`172:455`，Figma 说明为"Be used in dialog"）：332×34，左右内边距 12，圆角 6，0.8px `#e2e2e2`，白底，内阴影 `inset 0 4px 4px rgba(0,0,0,.04)`（Shadow/textfield-inner），14px，占位符 `#d9d9d9`。

## 8. Radio · `.s-radio` / `.s-radio-item`（`171:398`、`171:369`）
- 22px 外圈 `#ececec`，内阴影 `inset 0 0 2px rgba(0,0,0,.08)`；中心 10px 小圆，投影 `0 2px 4px rgba(0,0,0,.06)`。
- 未选：`#fbfbfb→#f1f1f1`，描边 `#ececec`；选中：`#95afe5→#6889da`，描边 `#5671c9`。
- Radio List Item：高 48，左右 16，14px `#333`，右侧单选，下方 0.8px `#f2f2f2`（总高 48.8）。

## 9. Divider（`253:210`）
- `.s-divider`：0.8px `#f2f2f2`（`173:1303`）。
- `.s-divider--v`：1×54 `#f2f2f2`，用于对话框按钮之间（`197:1228`）。
- `.s-divider--short`：0.8×12 `#eee`，用于分段按钮（`208:1274`）。
- 另有两处特殊分隔线：List Tile 3 用 0.5px `#ddd`；搜索结果和菜单项用 1px `#f2f2f2`。

## 10. List（`248:872`）
### List（分组）· `.s-list-group`（`203:1548`）
```html
<div class="s-list-group">
  <div class="s-list-group__body">
    <div class="s-list-group__header">Title</div>
    <div class="s-list"> ….s-list-item… </div>
  </div>
  <div class="s-list-group__desc">Description</div>
</div>
```
- 分组标题：左右 16，14px 600 `#7f7f7f`；与卡片间距 6；卡片与说明间距 4。
- 卡片：白底，圆角 10，0.8px `#e2e2e2`，投影 `0 10px 16px rgba(0,0,0,.04)`，overflow hidden。
- 说明：14px `#797979` 居中，`line-height: 1`。
### List Tile · `.s-list-item`（`253:1305`）
```html
<div class="s-list-item" data-pressable>
  <svg class="s-icon"><use href="#si-setting"/></svg>
  <div class="s-list-item__text"><span class="s-list-item__title">Title</span><span class="s-list-item__subtitle">Subtitle</span></div>
  <span class="s-list-item__detail">Detail<svg class="s-icon"><use href="#si-chevron-right"/></svg></span>
</div>
```
- 412×60（加分隔线共 60.8），左 18 / 右 12，间距 18；前导图标 20px；标题 16px `#333`（List Title 样式），副标题 12px `#7f7f7f`，二者间距 4。
- 尾部可放 Detail、开关或任意元素（`trailing` 槽）。
- Enabled：白底，行下 0.8px `#f2f2f2`（在 `.s-list` 内自动加，单独使用时加 `.s-list-item--divider`）。
- Pressed：底 Blue/300 `#5985eb`，0.4px Blue/500 `#3f68e2`，所有文字和图标变白。
- Disabled：文字 `#bababa`，图标 Fill/Icon/Disabled 渐变。
### 行内控件 · `.s-list-item__control`
- 用于需要占满剩余宽度的控件，例如音量滑块：`<div class="s-list-item"><div class="s-list-item__text">…音量…</div><div class="s-list-item__control s-slider-row">图标 + 滑块 + 图标</div></div>`。有它时标题区不再自动撑满。
### List Item Detail · `.s-list-item__detail`（`253:1360`）
- 16px `#7f7f7f` + 24px `>`（`#b2b2b2`）；Pressed 时文字和箭头都变白。
### List Tile 2 · `.s-list-item--simple`（`253:2000`）
- 60px 高，左 18.4 / 右 11.2，间距 18.4；标题 **18px** `#333`；右侧 Detail 14px `#9d9d9d` 右对齐；下方 0.8px 分隔线。
### List Tile 3 · `.s-list-item--plain`（`211:1303`）
- 无底色，左右 18；60px 高的文字区：标题 14px、副标题 12px，颜色都是 `#787878`，间距 4；下方 0.5px `#ddd`。用于灰底页上的轻量列表。
### Slidable List Tile · `.s-swipe`（`211:1357`）
```html
<div class="s-swipe">
  <div class="s-swipe__actions"><button>…star</button><button>…search</button><button>…close</button></div>
  <div class="s-list-item">…</div>
</div>
```
- 列表行左滑露出操作托盘：内边距 16，图标 24px 间距 20，0.5px `#c7c7c7` 描边，内阴影 `inset 0 0 4px rgba(0,0,0,.16)`（凹槽感）。
- 行本身：白底，1px `#e2e2e2` 描边，左 18.4 / 右 11.2，尾部示例为开关。
- 滑动交互要自己实现（translateX），CSS 只负责外观。

## 11. Switch · `.s-switch`（`42:1333`）
```html
<input type="checkbox" class="s-switch" checked>
```
- 52×24 胶囊凹槽：白底，0.4px `#e2e2e2`，内阴影 `inset 0 4px 12px rgba(0,0,0,.1)`。
- 旋钮：24px 白圆 `#fff→#fcfcfc`，0.4px `#e2e2e2`，投影 `0 4px 4px rgba(0,0,0,.08)`。
- 指示点约 9.5×9.6，位于旋钮另一侧：
  - selected=true：旋钮在右，左侧露出蓝点 `#9cbcff→#7da7ff`（描边 `#769dfe`）。
  - selected=false：旋钮在左，右侧露出灰点 `#f4f4f4`（描边 `#e8e8e8`）。
- 原始矢量：`assets/kit-renders/switch-*.svg`。

## 12. Popup Menu · `.s-menu`（`253:2463`），Item（`175:1583`）
- 宽 220，圆角 6，0.4px `#e2e2e2`，overflow hidden。
- 每项 42px 内容区 + 1px `#f2f2f2` 分隔线（共 43），左右 18；24px 图标 + 间距 8 + 16px `#636363` 文字；属性 `showDivider`、图标可替换。
- 按下（原稿未画，推导值）：`#f2f2f2`。

## 13. Search（`249:1242`）
- **Search Field** `.s-search-field`（`68:140`）：380×30，胶囊，底 `#f5f5f5`，0.5px 描边（单独使用 `#e9e9e9`，放在搜索栏里 `#e2e2e2`），内边距 8，间距 10；16px 放大镜 + 14px `#333` 文字 + 18px 圆形清除按钮（白底灰叉，`#si-c-clear`）。
- **Search Bar** `.s-search`（`68:142`）：432×48 白底，左右 16，间距 16，drop-shadow `0 4px 4px rgba(0,0,0,.08)`；右侧是 24px 粗叉（取消）。
- **Search Result Item** `.s-result`（`70:1103`）：432×60；左侧 60 宽格子：底 `#fafafa`，右边线 0.5px `#e2e2e2`，中间 20px 图标；文字区白底，内边距 12 / 18 / 10，字距 0.5，行高 24，标题 14px `#333`，副标题 12px `#9d9d9d`；行下 1px `#f2f2f2`。属性 `showLeading`、`showSubtitle`。
- **Search Result List**（`181:530`）：Result Item 竖排（240 高的视口，可滚动）。
- **Search Bar With Result** `.s-search-with-result`（`185:3469`）：搜索栏在上（投影压在结果上），下接结果列表，总高 288。

## 14. Slide Bar（`253:165`）
- **Slide Bar** `.s-slider-row`（`29:112`）：372 宽，两端 24px 图标（mute，`#666→#999` 渐变），间距 22，中间是滑块。
- **Contained** `.s-slider-card`（`204:1217`）：408×60 白卡片，圆角 10，0.8px `#e2e2e2`，投影 `0 2px 6px rgba(0,0,0,.06)`，里面放 Slide Bar。
- 滑块 `.s-slider`（`<input type="range">`，用 `--p` 设置 0–100）：轨道高 4，胶囊，`#efefef`，`inset 0 4px 4px rgba(0,0,0,.06)`；已填充部分 `#668ff7→#7ca3fb`（原稿还有 1px `#7198ff` 描边）；旋钮 20px 白圆，0.4px `#f1f1f1`，投影 `0 4px 8px rgba(0,0,0,.16)`。

## 15. Toast · `.s-toast`（`40:1076`）
- 定位：外面包一层 `.s-toast-host`，固定在底部导航上方 78px 处、水平居中；用 `hidden` 属性控制显示。放在手机外框里时加 `--in-frame`（改用 absolute 定位）。也可以直接调用 `smartisan.js` 的 `Smartisan.toast(text)`。
- 218×41：内边距 12px 16px，圆角 6，`#fcf6e6→#fcf3dc`，0.4px `#d2b89c`，14px 700 `#ad8a67`，不换行。示例文案 "Network error, pls try again"。

## 16. 文档外框（Kit chrome，可选）
用于在锤子风格下做设计规范页 / 组件展示页。
- 画布 `.s-kit-canvas`：`#dddddd`。
- 展示板 `.s-kit-board`：`#f5f5f5`（Tab Bar 页为白色 `.s-kit-board--white`），圆角 40。
- 页头 `.s-kit-header`（`248:874`）：高 220，横向渐变 `#222325 → #3b3c3f(49%) → #222325`，上圆角 40；左上 30px T 标（36,36）；标题 48px 700 `rgba(255,255,255,.9)`，位于左 36、顶 110。
- 组件集虚线框 `.s-kit-set`：1px dashed `#9a9a9a`（ComponentBoard/ComponentSetStroke），圆角 5。
- 标签 `.s-kit-label`（`261:442`，"Examples"）：底 `#e2e2e2`，1px `#bababa`，圆角 8，内边距 4px 8px，16px `#333`。
- 封面 `.s-kit-cover`：同页头渐变；60px T 标；字标 `brand/wordmark-smartisan-os-ui-kit.svg` + "UNOFFICIAL" 徽标；说明文字 Inter Medium 20px `#b8b8b8`。

## 17. 图标（`253:872`）
清单见 `inventory.md` §01。sprite id：
- 单色（随 `color`）：`si-back si-confirm si-close si-close-thin si-setting si-search si-star si-star-fill si-chevron-right si-chevron-up si-chevron-down si-play si-playing si-playlist si-more si-mute si-volume si-add si-menu-add si-like-outlined si-list si-game-filled`
- 彩色：`si-c-check si-c-redcheck si-c-delete si-c-unselected si-c-clear si-c-radio-on si-c-radio-off`
- 默认颜色：一般图标 `#929292`（原稿是 `#8c8c8c→#989898` 渐变），禁用/底部导航未选中 `#c7c7c7`，`>` 箭头 `#b2b2b2`，"更多" `#bababa`，加号 `#c9cbcf`，静音/音量 `#808080`（原稿 `#666→#999`）。
- 线性图标描边 2px，圆头圆角；尺寸为 16 / 18 / 20 / 22 / 24 / 28。
