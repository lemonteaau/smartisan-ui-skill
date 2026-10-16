---
name: smartisan-ui
description: 用 Smartisan OS（锤子科技 / 坚果手机）的 UI 风格做前端界面：轻拟物、细腻纵向渐变、极细描边、柔和投影与内凹阴影、灰阶为主 + 低饱和蓝强调 + 锤子红品牌色。当用户提到 Smartisan、锤子、锤子风格、坚果 OS、Smartisan OS、老罗/罗永浩那种拟物风、"像锤子手机一样的 UI"，或要求把网页/组件/App 原型做成这种风格时使用。适用于网页（HTML/CSS/Tailwind/任意前端框架）和 Flutter。内含完整的 Figma《Smartisan OS UI Kit (Unofficial)》（17 页、全部组件和变体）提取出的 token、组件规格、可直接引用的 CSS、Tailwind preset、图标和参考截图，并经 Smartisan R2 真机校对；还包括从 Smartisan OS 框架资源和社区 1:1 复刻应用中整理的交互层（按压时序、转场、主体不动部件分层过渡的组件编排、开关拖拽、右滑删除、回弹、滚轮、字母索引）和官方 6dp 间距 / 字号 / 文字色体系。
---

# Smartisan OS UI 风格

来源：
- Figma 社区文件 [Smartisan OS UI Kit (Unofficial)](https://www.figma.com/community/file/1419385240874679870)，作者 Paix Chan，CC BY 4.0，基于 Smartisan R2 上的 Smartisan OS 8。所有数值都从 Figma 节点里读出，17 页、每个组件和每个变体都覆盖到了。
- 在一台真机 Smartisan R2（Smartisan OS 8.5.3）上用 adb 校对：屏幕 dp 宽度、字体、真实页面底纹、App Bar 阴影、列表图标颜色等，文档里标 **[R2]**。
- 在同一台 R2 上逐像素测量、60fps 录屏抽帧得到的**交互、动效、间距、分隔线**，以及各系统应用的取色方式，见 `references/device-behavior.md`。
- Smartisan OS 8 **框架资源**（官方间距、字号、文字色、转场时长和插值器）和社区 1:1 重写的锤子音乐 / 天气 / 时钟里校准过的**手势与动效参数**，见 `references/motion.md`。

## 文件

| 文件 | 用途 |
|---|---|
| `assets/smartisan.css` | 全部 token（CSS 变量）+ 全部组件类 `.s-*`。**做网页时优先直接引用这一份** |
| `assets/smartisan.js` | 交互层（无依赖）：Android 式按压时序、开关拖拽、右滑删除、真滚轮、橡皮筋回弹、页面栈横推（含标题栏分阶段转场）、全屏页上推、对话框 / 底部菜单进出场、字母索引条、`Smartisan.toast()` |
| `assets/flutter/*.dart` | **Flutter 版**（只依赖 Flutter SDK）：转场与动效常量（`smartisan_motion.dart`：`SPageRoute`、`SModalPageRoute`、`SDialogRoute`、`SMotion`）、框架层组件（`smartisan_interaction.dart`：`SSwipeRow`、`SQuickBar`、`SEmptyState`、`SSectionTitle`、`SCheck`、`SRoundEditButton`）、Kit token（`smartisan_theme.dart`）、亮/暗色板 + 强调色（`smartisan_palette.dart`、`smartisan_accent.dart`）、整套 `ThemeData`（`smartisan_material_theme.dart`）、23 个矢量图标、全部组件（明暗自适应）、真机补充组件（分段 Tab、品牌栏、条纹底、分区带、带按下态的列表行、动效）。用法见 `references/flutter.md` |
| `assets/flutter/glyphs/` | Flutter 图标字体 `SGlyphs`：166 个锤子风格实心字形（Phosphor Icons，MIT），用来替换 Material 线框图标 |
| `assets/demo.html` | 整套 Kit 的 1:1 复刻：17 页，每个变体都有，外加一块"Real device"展示板。拿不准 HTML 结构时照抄这里 |
| `assets/icons-sprite.svg` | 29 个图标的 `<symbol>`：单色 `si-*`（`currentColor`）+ 彩色 `si-c-*`。内联到 `<body>` 开头后用 `<svg class="s-icon"><use href="#si-back"/></svg>` |
| `assets/icons/*.svg` | 29 个原始图标（保留原渐变） |
| `assets/icons/variants/*.svg` | Figma 里各组件实际用到的上色版本（白色 App Bar 图标、Chip 五色、列表按下/禁用态、底部导航选中/未选中） |
| `assets/kit-renders/*.svg` | 旋钮按钮、开关、滑块的原始矢量渲染，用于像素级核对 |
| `assets/brand/*.svg` | Kit 封面和页头用的 T 标、字标、UNOFFICIAL 徽标（商标归属见 README，只用于展示页，不要用在产品里） |
| `assets/tokens.json` | W3C DTCG 格式的 token，保留 Figma 变量名 |
| `assets/tailwind.preset.js` | Tailwind preset（`bg-s-grey-100`、`rounded-s-lg`、`shadow-s-card`……） |
| `references/tokens.md` | 颜色 / 渐变 / 字体 / 圆角 / 描边 / 阴影 / 尺寸全表，含 [R2] 实测值 |
| `references/components.md` | 每个组件的 HTML 结构、尺寸、所有状态的取值 |
| `references/flutter.md` | Flutter 接入步骤、CSS→Flutter 组件对照、常见错误 |
| `references/motion.md` | **交互与系统规范**：6dp 间距网格、sp 字号与 0.91 字体缩放、透明黑文字色、按压时序、各类转场的时长和曲线、开关 / 右滑删除 / 回弹 / 滚轮 / 字母索引的手感参数、标题栏和底部菜单的版式，每条注明出处 |
| `references/device-behavior.md` | **真机实测**：按下态、页面推入/返回/对话框动效、回弹、分段 Tab、列表/卡片/分隔线/间距、品牌栏、"一个应用一个强调色" |
| `references/inventory.md` | Figma 节点清单：节点 ID → 组件 / 变体 → CSS 类 → 截图 → 素材 |
| `references/screenshots/NN-*.png` | 17 个 Figma 页面的截图，作为视觉对照 |

## 工作流程

**先判断技术栈**：
- **Flutter 项目** → 读 `references/flutter.md`，把 `assets/flutter/*.dart` 复制到 `lib/smartisan/`，然后用 `S*` 组件写页面。不要直接用 Material 控件，也不要从 CSS 自己翻译。
- **React / Vue / 原生 iOS / Android 等其它栈** → 按 `references/components.md` 和 `assets/tokens.json` 实现，外观以 `references/screenshots/` 为准。
- **网页（HTML / CSS / 任意前端框架）** → 走下面的步骤。

1. **先看 `assets/demo.html`** 里对应组件的写法；需要精确数值时查 `references/components.md` 和 `tokens.md`；不确定长什么样时，直接看 `references/screenshots/` 里那一页的截图（可以用 Read 读图）。
2. **把 `assets/smartisan.css` 复制进项目**（或移植到项目现有的样式体系：Tailwind 项目用 `tailwind.preset.js`，CSS-in-JS 项目读 `tokens.json`）。不要凭感觉重新调色。
3. 根元素加 `class="s-page"`；想要真机那种竖条纹底，再加 `s-page--textured`。
4. 把 `icons-sprite.svg` 内联到 `<body>` 开头。注意它的隐藏方式是 `position:absolute; width:0; height:0`，**不能改成 `display:none`**，否则彩色图标里的渐变不会渲染。
5. **引入 `assets/smartisan.js`**（做可交互的页面时都应该引入；锤子味很大一部分在手感上）：
   - 按压：按钮按下即变色，快速点击也至少保留 64ms；列表行过 100ms 才变蓝，开始滚动就取消。
   - 对话框、底部菜单、全屏页都用 `hidden` 控制；`<button data-s-open="id">` 打开，里面的 `data-s-close` 关闭，进出场动画自动处理。底部菜单用 `.s-overlay.s-overlay--sheet`，全屏页用 `.s-modal-page`。
   - 层级页面放进 `.s-stack > .s-stack__page[data-title]`，`data-s-push="pageId"` 推入，`data-s-back` 返回；`.s-stack` 加 `data-s-appbar="栏的 id"` 就会跑标题栏的分阶段转场。
   - 组件编排：主体放在 `.s-swap` 里，各页的部件层是 `.s-swap__panel`，会动的部件加 `data-s-part` 和 `--from-*` 变量，`data-s-show="panelId"` 切换。
   - 右滑删除：`.s-swipe[data-s-swipe]`，删除按钮加 `data-s-swipe-delete`。滚轮：`.s-picker__col[data-s-wheel]`（`data-s-loop` 循环），监听 `change`。回弹：`.s-elastic > .s-elastic__content`。字母索引：`.s-quickbar`，监听 `s-letter`。
   - `Smartisan.toast('已保存')` 弹出提示，它会自动放进 `.s-toast-host`；滑块的进度条填充（`--p`）会自动更新。
   - 放在手机外框里演示时，给遮罩、全屏页、Toast 加 `--in-frame` 修饰类。

   App Bar 里要放文字按钮时，用 `.s-btn.s-btn--sm`（主操作，如"完成"）或 `.s-btn--outline`；只放纯文字用 `.s-appbar__text`。列表行里要放占满剩余宽度的控件（如音量滑块），给控件加 `.s-list-item__control`。
6. 用户要 React / Vue 组件时，按 `.s-*` 的结构和 `components.md` 的状态表来封装：pressed、disabled、selected 都要做齐。`.is-pressed` 可以用来静态展示按下态。
7. 做完后按下方「自检清单」逐条检查；有浏览器的话截图和 `references/screenshots/` 对比。
8. 交互、动效、间距和分隔线以 `references/device-behavior.md`（真机实测）为准；它和 Figma Kit 不一致的地方，以真机为准。

## 美学要点（为什么看起来像锤子）

1. **轻拟物，不是扁平**。可点的东西都有"实体感"：主按钮是上浅下深的蓝色渐变，加 0.8px 深蓝描边和向下 4px 的短投影；圆形按钮是凹槽底座里嵌一颗白色旋钮；开关、滑块轨道、滚轮选择器、Tab 选中态、滑动删除托盘都是**内凹**的（inset shadow）。
2. **渐变极其克制**。几乎所有渐变都只是同色系 2–5% 的明度差（`#5b87eb→#5883eb`、`#fff→#fcfcfc`），用来制造光照感；图标也带一层几乎看不出的 `#8c8c8c→#989898` 渐变。不要做成炫彩渐变。
3. **极细描边**。普遍是 0.4 / 0.5 / 0.8px，颜色只比背景深一点（`#e2e2e2`、`#eee`）。[R2] 在 2.5x 屏上 0.8dp 正好是 2 个物理像素。
4. **灰阶文字体系**。正文 `#333`；标题栏和按钮文字 `#636363`；副标题 `#7f7f7f` / `#9d9d9d`；禁用 `#bababa`。标题也用灰色加粗，**不用纯黑**。
5. **强调色少而低饱和**：蓝 `#5b87eb` 用于主按钮、选中、进度，对话框主操作用 `#5e80d0`；锤子红 `#cd3f3a` 用于品牌 App Bar（如 App Store），红色圆形图标（红勾、删除）用 `#e5645a`；暖黄 `#fcf6e6` 配棕字 `#ad8a67` 用于 Toast。
6. **居中对称**。App Bar、对话框、底部弹窗的标题都绝对居中，左边返回、右边操作。
7. **卡片式分组列表**：白底，圆角 10，0.8px `#e2e2e2`，极淡的大范围投影 `0 10px 16px rgba(0,0,0,.04)`；行高 60，行间 0.8px `#f2f2f2`；分组标题在卡片外上方（14px 600 `#7f7f7f`），说明文字在卡片下方居中。[R2] 真机设置页一致，卡片左右边距 12dp。
8. **按下态是换色或下沉，不是涟漪，而且是瞬时的**（[R2] 60fps 录屏：按下那一帧就变，没有淡入淡出）。主按钮按下变纯色 `#4772e6`；灰色凸起按钮按下**渐变上下反转**（顶部变暗，像被按进去）；旋钮按下变 `#ebebeb→#f2f2f2`；对话框按钮按下 `#dfdfdf`；列表行按下整行变蓝 `#5985eb`、文字图标和 `>` 全变白；**顶栏图标按住时变深并弹性放大到 1.33 倍**（约 120ms 冲到 1.39 再落回），松手先缩到 0.95 再弹回（框架 `playBarIconScaleAnim`，[R2] 录屏核实），没有背景高亮。时序照 Android：快速点击的按下态至少留 64ms；列表行过 100ms 才变蓝，手指一滚动就取消。不要用 Material ripple，也不要 hover 放大。
9. **禁用**：主按钮整体 `opacity: .3`；列表和文字用 `#bababa`，图标用 `#c6c6c6→#c8c8c8`。
10. **页面层次**：页面底 `#f5f5f5`（[R2] 真机设置页是 `#f4f4f4` / `#f2f2f2` 交替、周期约 3.6dp 的竖条纹）；内容块白色；底部弹窗正文区更深（`#efefef`），和白色按钮形成层次；App Bar 下方 [R2] **没有细线**，是一道约 14dp、从 `#dfdfdf` 渐隐的阴影（框架 `title_bar_shadow_height` 14dp，`.s-appbar--shadow`）。
11. **字体**：[R2] 系统字体是 **Smartisan Compact**（拉丁字符）+ **Noto Sans CJK SC**（中文）；Figma Kit 用 Inter 替代。字体栈已经按这个顺序写好。
12. **Tab 是分段控件**（[R2] 应用商店排行）：整宽、圆角 6 的浅色框，**选中段是内凹的灰色**、白字。不是 Material 的下划线 Tab。
13. **一个应用一个强调色**：应用商店红、游戏中心紫、便签棕、系统应用蓝。品牌栏、底栏选中、Tab/勾选/主按钮/开关圆点/滑块/链接/按下的行都用同一个颜色，不要蓝色和品牌色混用。底部导航选中项在真机上是**品牌色**（Figma Kit 是加大的灰色图标）。
14. **动效**：层级页面横向推入 300ms（新页先以空白滑入、内容在最后 40% 淡入，旧页左移约 1/3），返回约 270ms 减速；设置、编辑器、"新建"这类**全屏页从底部升起** 300ms，下面的页不动；对话框卡片约 120ms 从 0.88 弹到原大并淡入、遮罩 200ms 加深到 60%，关闭时卡片 100ms 淡出；底部菜单上滑 300ms、下滑 250ms；列表到头是**橡皮筋回弹**，没有光晕或拉伸。曲线只用 smooth（`(1−cos πt)/2`）、decelerate、accelerate 三类，见 `references/motion.md`。
15. **手势**：开关能拖，归位是**线性**移动（满程约 70ms）；列表行**向右滑**露出左侧的删除托盘（不是 iOS 的左滑），超过托盘后有 1/5 阻尼，同时只开一行，点别处先收起并吃掉这次点击；滚轮越靠近中间字越大越深，每格一声"嗒"。
16. **6dp 网格与透明黑文字**：框架间距是 6 / 12 / 18 / 24 / 30 / 36 / 48 / 60；文字色是 `#cc000000`（正文）、`#99000000`（标题、按钮）、`#80000000`（说明）、`#4c000000`（提示）、`#26000000`（禁用），白底上正好等于 Kit 的灰。真机字体缩放 0.91，Kit 的 px 字号已经包含了这层缩放。
17. **组件编排：主体不动，部件分层过渡**（锤子时钟切 Tab，[R2] 录屏）。页面之间有共同的视觉主体（表盘、仪表、封面、卡片）时，它留在原位，旧部件约 300ms 顺着原方向离开（指针继续往前转），新部件各按自己的时长和延迟入场（指针从后方追上 0.7 / 0.9 / 1.0s，铃耳从斜后方滑回，按键错开弹出带过冲）；数值变化也让部件自己走过去。这是锤子"细腻过渡"的核心，做 Tab、详情切换、状态变化时优先这样设计，而不是整页滑动或淡入淡出。见 `references/motion.md` 第 5 节。
18. **间距与分隔线**：卡片左右 12dp、卡片之间约 14dp；卡片里的分隔线贯穿全宽且很浅（`#f3f3f3`），最后一行下面没有线；通栏图文列表的分隔线左右各缩进 12dp；分区之间是约 6dp 的内凹灰带，不和分隔线叠用。

## 核心 token 速查

```
页面底        #f5f5f5（[R2] #f0f0f0 + 竖条纹）  分隔线 #f2f2f2   描边 #e2e2e2 / #eeeeee
正文          #333333   标题/按钮字 #636363   副标题 #7f7f7f / #9d9d9d   禁用 #bababa
主蓝渐变      #5b87eb→#5883eb  描边 #3f68e2   按下 #4772e6 / 描边 #2f54d7   文字按钮 #5079d9
对话框主操作  #5e80d0   对话框按钮底 #f7f7f7（按下 #dfdfdf）   遮罩 rgba(0,0,0,.6)（[R2] 录屏实测也是 .6）
锤子红        App Bar #cd3f3a→#c83530 底边 #b7241f；红色图标 #e5645a→#e55f55 描边 #da463e
图标灰        #8c8c8c→#989898（纯色 #929292）；禁用 #c6c6c6→#c8c8c8；> 箭头 #b2b2b2
圆角          3 分段 / 4 小按钮 / 6 菜单·Tab·Toast·输入框 / 8 弹窗按钮 / 10 大按钮·卡片 / 12 对话框 / 20 底部弹窗顶 / 100 胶囊
字体          18 粗(对话框标题) 16 粗(栏标题/按钮) 16 常规(列表标题) 14 粗(小按钮/对话框操作) 14 半粗(分组标题) 12 常规(副标题) 12 半粗(Chip) 8(底部导航)
尺寸          App Bar 48 · 列表行 60 · 大按钮 60 · 弹窗按钮 48 · 对话框操作 54 · 底部导航 54 · 菜单项 42 · Chip 30 · 开关 52×24 · 单选 22
设计宽度      432dp（[R2] 1080px ÷ 2.5）；大按钮 408、弹窗按钮 392、对话框 368
```

## 组件清单（Figma 页 → CSS 类）

- **App Bar**：`.s-appbar`，红色版 `--red`，真机阴影 `--shadow`
- **Button**：
  - 大按钮 `.s-btn`，小按钮 `--sm`，白色弹窗按钮 `--sheet`，描边按钮 `--outline`，文字按钮 `--text`
  - 图标按钮 `.s-btn-icon`
  - 圆形旋钮按钮 `.s-round-btn`，小号 `--sm`
  - 分段按钮 `.s-segmented`
- **Bottom Navigation**：`.s-bottom-nav`
- **Bottom Sheet**：`.s-sheet`、`.s-sheet__header`
- **Chip**：`.s-chip`
  - 颜色：默认白 / `--yellow` / `--blue` / `--red` / `--grey`
  - 样式：默认纯文字 / `--all` / `--leading` / `--trailing`
- **Date Time Picker**：`.s-picker`
- **Dialog**：
  - `.s-overlay` + `.s-dialog`
  - 标题 `__header`，正文 `__body`（`--flush` / `--field`），按钮组 `__actions`（1–3 个按钮，主操作加 `data-primary`）
  - Simple Dialog `.s-dialog--simple`，输入框 `.s-textfield`
- **Radio**：`.s-radio`、`.s-radio-item`
- **Divider**：`.s-divider`，竖线 `--v`，短竖线 `--short`
- **List**：
  - 分组 `.s-list-group`，卡片 `.s-list`，行 `.s-list-item`，尾部 Detail `__detail`
  - List Tile 2 `--simple`，List Tile 3 `--plain`
  - 左滑操作行 `.s-swipe`
- **Popup Menu**：`.s-menu`
- **Search**：`.s-search`、`.s-search-field`、结果行 `.s-result`、整体 `.s-search-with-result`
- **Slide Bar**：`.s-slider`（`<input type="range">`，用 `--p` 设进度），配 `.s-slider-row` 或 `.s-slider-card`
- **Switch**：`.s-switch`
- **Tab Bar**：`.s-tabs`
- **Toast**：`.s-toast`
- **框架层（Kit 没画、系统应用常用）**：
  - 危险按钮 `.s-btn--danger`（可叠在 `.s-btn--sheet` 上）
  - 分区标题条 `.s-section-title`，空状态 `.s-empty`（`__icon` / `__title` / `__desc`）
  - 多选勾选圈 `.s-check`（`--red`），选中行 `.s-list-item[aria-selected=true]`，增删按钮 `.s-round-add` / `.s-round-remove`
  - 字母索引条 `.s-quickbar`
  - 页面栈 `.s-stack` / `.s-stack__page`，全屏页 `.s-modal-page`，底部菜单遮罩 `.s-overlay--sheet`，回弹容器 `.s-elastic`
  - 组件编排 `.s-swap` / `.s-swap__panel` / `[data-s-part]`（`data-s-show` 切换）
- **文档外框**（用于做设计规范 / 展示页）：`.s-kit-canvas`、`.s-kit-board`、`.s-kit-header`、`.s-kit-set`、`.s-kit-label`、`.s-kit-cover`

## Figma 原稿里的坑（已在 skill 里纠正）

- Segmented Button 单项的变体名是反的：`Selected=False` 才是蓝块。
- `icon-down` 的 `direction=up` 和 `direction=down` 两个变体也是反的，文件已按实际形状命名为 `chevron-up` / `chevron-down`。
- 播放三角的外接框故意向右偏约 3.8px，这样三角形的视觉重心才落在圆心（光学居中）。sprite 里的 `si-play` 已经带了这个偏移，**不要再额外加 margin**。旋钮按钮里图标的尺寸按 CSS 写的来：大号 28px，小号 10px。
- 搜索框单独使用时描边是 `#e9e9e9`，放进搜索栏后是 `#e2e2e2`。
- 每页的展示板底色是 `#f5f5f5`，只有 Tab Bar 页是白色。

## 不要做

- 不要用大圆角卡片、大面积彩色渐变、毛玻璃（那是 iOS / 现代 Web 的风格，不是锤子）。
- 不要用高饱和色、纯黑文字、粗边框、重投影。投影透明度基本 ≤ 0.1，只有圆形旋钮到 0.21。
- 不要用 Material 的 ripple、FAB、浮动标签输入框、底部 Snackbar。
- 开关不要做成 iOS 那种绿色胶囊。锤子的开关是白色凹槽里一颗白色拨钮，另一侧露出一个小圆点作指示：开时拨钮在右、左侧露蓝点；关时拨钮在左、右侧露灰点。
- 主色不要泛滥，一屏通常只有一个蓝色主按钮或一个选中态。
- 不要保留 Material 的标志性元素：线框图标（`Icons.*_outlined`）、下划线 Tab、浮起叠放的卡片、缩放转场、圆形 Radio、按下的淡入高亮。留一个就会有"混搭"感。
- 不要在同一个应用里混用锤子蓝和品牌色作为强调色。
- 不要做左滑删除、缓动曲线的开关、弹簧感很重的页面转场、长于 300ms 的普通转场；不要让按下态淡入淡出。
- 不要照抄应用商店顶栏下的"射灯"光斑：那是商店专属的设计，不是通用规范。

## 自检清单

- [ ] 页面底是 `#f5f5f5`（或真机条纹），内容块白色，没有纯黑文字
- [ ] 描边都 ≤ 0.8px，颜色是 `#e2e2e2` / `#eee` / `#f2f2f2` 这一档
- [ ] 主按钮、开关、滑块、Tab 选中、旋钮都有渐变或内凹，不是纯平色块
- [ ] 所有可点元素都有按下态（换色 / 下沉），禁用态正确
- [ ] 标题居中；列表行高 60；对话框宽 368、按钮高 54、主操作在最右
- [ ] 图标：Kit 里的图标是灰色细线风格（2px 圆头）；[R2] 系统应用的列表图标是**浅灰实心字形**，`>`、`✓`、`×`、搜索是线条；尺寸 16 / 20 / 24
- [ ] Tab 是分段控件；按下态瞬时；页面横向推入；列表到头回弹
- [ ] 引入了 `smartisan.js`（网页）或用了 `SPageRoute` / `SModalPageRoute` / `SDialogRoute`（Flutter）；全屏页从底部升起，层级页横推
- [ ] 顶栏图标按住会弹性放大；开关能拖；滑动删除是向右滑；滚轮能滚并吸附
- [ ] 间距落在 6dp 网格上（6 / 12 / 18 / 24 / 30 / 48 / 60）
- [ ] Tab / 状态切换时，共同的视觉主体留在原位，部件分层进出，没有整页淡入淡出
- [ ] 强调色只有一个，品牌栏、底栏选中、勾选、开关、按钮、链接都是它
- [ ] 分隔线：卡片里贯穿全宽、图文列表左右缩进 12dp、末行无线、不与分区带叠用
- [ ] 和 `references/screenshots/` 里对应页面对比过

## 适配说明

- 原稿是 432dp 宽的手机界面。做移动端页面时，内容区 `max-width: 432px` 居中最接近原貌；做桌面网页时组件尺寸保持不变，用灰底加白色卡片分组来铺开，不要把按钮、行高等比例放大。
- 0.4px 描边在 1x 屏上会显示成 1px，这是正常的。
- Kit 没有定义暗色模式，[R2] 上的系统也没有暗色。用户要暗色时要说明这是推导出来的，并保持同样的"低对比渐变 + 细描边 + 内凹"逻辑。
- 滚轮、右滑删除、回弹、页面栈的手势都在 `smartisan.js` 里；不引入它时这些组件只有静态外观。
- 用 React / Vue 等框架时，`smartisan.js` 用事件委托工作，动态插入的元素也能用；滚轮、回弹、字母索引是初始化时绑定的，插入后调用 `Smartisan.init(容器)`。
