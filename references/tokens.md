# Smartisan OS UI — Design Tokens

来源有两处：
1. Figma 社区文件 [Smartisan OS UI Kit (Unofficial)](https://www.figma.com/community/file/1419385240874679870)（作者 Paix Chan，CC BY 4.0）里的变量、样式和节点数值。
2. 在一台真机 Smartisan R2（Smartisan OS 8.5.3）上用 adb 实测的结果，表中标 **[R2]**。

括号里是 Figma 变量名或样式名。机器可读版本：`assets/tokens.json`（W3C DTCG 格式），Tailwind 版本：`assets/tailwind.preset.js`。

## 颜色

### 灰阶（Grey/*）
| Token | 值 | Figma 语义名 | 用途 |
|---|---|---|---|
| `--s-white` | `#ffffff` | Grey/white | 卡片、列表行、按钮底 |
| `--s-grey-100` | `#fafafa` | Background/Container/Miscellaneous | 对话框标题栏、搜索结果左格、白 Chip |
| `--s-grey-200` | `#f2f2f2` | Divider | 分隔线 |
| `--s-grey-300` | `#eeeeee` | Border/Button | 白按钮描边、短分隔线 |
| `--s-grey-400` | `#e2e2e2` | Border/List | 列表卡片、菜单、开关、输入框描边 |
| `--s-grey-500` | `#bababa` | Disabled | 禁用文字 |
| `--s-grey-600` | `#9d9d9d` | Subtitle/Other | 次要副标题、底部导航未选中 |
| `--s-grey-700` | `#7f7f7f` | Subtitle/List | 列表副标题、Detail、分组标题 |
| `--s-grey-800` | `#636363` | Title/Other | App Bar 标题、按钮字、对话框标题、菜单项（[R2] 实测设置页标题 `#666666`） |
| `--s-grey-900` | `#333333` | Title/List | 列表标题、正文（[R2] 一致） |

### 蓝（Blue/*）
| Token | 值 | 用途 |
|---|---|---|
| `--s-blue-100` | `#e7edfd` | 图标按钮底 |
| `--s-blue-300` | `#5985eb` | 列表行按下 |
| `--s-blue-400` | `#5079d9` | 文字按钮 |
| `--s-blue-500` | `#3f68e2` | 主按钮描边 |
| `--s-blue-600` | `#2f54d7` | 主按钮按下描边 |
| `--s-btn-primary-pressed` | `#4772e6` | 主按钮按下底（Background/Button/Primary/Pressed） |
| `--s-dialog-action-text` | `#5e80d0` | 对话框主操作（Dialog/Action） |
| `--s-icon-blue` | `#5c89f2` | 图标按钮的图标 |
| `--s-icon-check-blue` | `#6190ff` | 蓝色对勾 |

### 其它语义色
| Token | 值 | 用途 |
|---|---|---|
| `--s-page` / `--s-board` | `#f5f5f5` | 页面底（ComponentBoard/SectionFill） |
| `--s-page-real` | `#f0f0f0` | **[R2]** 真机设置页底色 |
| `--s-sheet-body` | `#efefef` | 底部弹窗正文区 |
| `--s-overlay` | `rgba(0,0,0,.6)` | 遮罩 |
| `--s-dialog-action` | `#f7f7f7` | 对话框按钮底（…/DialogAction/Enabled） |
| `--s-dialog-action-pressed` | `#dfdfdf` | 对话框按钮按下（…/DialogAction/Pressed） |
| `--s-red-stroke` | `#da463e` | 红色圆形图标描边（Red/Button-Stroke-Enabled） |
| `--s-board-stroke` | `#9a9a9a` | 组件集虚线框（ComponentBoard/ComponentSetStroke） |
| `--s-appbar-border` | `#d8d8d8` | App Bar 底线（[R2] `#d7d7d7`） |
| `--s-appbar-red-border` | `#b7241f` | 红 App Bar 底线 |
| `--s-dialog-header-border` | `#ededed` | 对话框标题底线 |
| `--s-dialog-action-border(-pressed)` | `#e8e8e8` / `#d5d5d5` | 对话框按钮顶线 |
| `--s-text-body` | `#656565` | 对话框正文、底部弹窗标题 |
| `--s-text-desc` | `#797979` | 列表说明 |
| `--s-text-simple-dialog` | `#898989` | Simple Dialog |
| `--s-text-tile3` | `#787878` | List Tile 3 |
| `--s-placeholder` | `#d9d9d9` | 输入框占位符 |
| — | `#606060` / `#d3d3d3` | 描边按钮的文字 / 描边 |
| — | `#55585c` / `#b3b3b5` | 滚轮选中项 / 未选中项 |

### 图标色
| Token | 值 | 用途 |
|---|---|---|
| `--s-grad-icon` | `#8c8c8c → #989898` | Fill/Icon/Enabled（几乎所有图标） |
| `--s-icon` | `#929292` | 上面渐变的纯色替代 |
| `--s-grad-icon-disabled` | `#c6c6c6 → #c8c8c8` | Fill/Icon/Disabled（底部导航未选中、禁用行） |
| `--s-icon-disabled` | `#c7c7c7` | 纯色替代 |
| `--s-icon-list-light` | `#cdcdcf` | **[R2]** 真机设置页列表前导图标（比 Kit 浅） |
| `--s-icon-chevron` | `#b2b2b2` | `>`（[R2] 一致） |
| `--s-icon-more` | `#bababa` | 三点 |
| `--s-icon-add` | `#c9cbcf` | 加号 |
| — | `#666666 → #999999` | mute / volume 图标 |

### 渐变（Figma 样式，均为自上而下）
| Token | 值 | Figma 样式 |
|---|---|---|
| `--s-grad-primary` | `#5b87eb → #5883eb` | Background/Button/Primary/Enabled |
| `--s-grad-primary-sm-disabled` | `#628cec → #517ce8` | 小按钮禁用 |
| `--s-grad-white` | `#ffffff → #fcfcfc` | Background/Button/White/Enabled（旋钮、开关拨钮） |
| `--s-grad-white-pressed` | `#ebebeb → #f2f2f2` | Background/Button/White/Pressed |
| `--s-grad-red` | `#e5645a → #e55f55` | Background/Button/Red/Enabled（红勾、删除） |
| `--s-grad-appbar-red` | `#cd3f3a → #c83530` | 红 App Bar |
| `--s-grad-segment` | `#4878f0 → #6997f4` | 分段按钮选中（上深下浅） |
| `--s-grad-sheet-header` | `#ffffff → #fafafa` | 底部弹窗标题栏 |
| `--s-grad-toast` | `#fcf6e6 → #fcf3dc` | Toast |
| `--s-grad-slider-fill` | `#668ff7 → #7ca3fb` | 滑块已填充部分 |
| `--s-grad-switch-dot` | `#9cbcff → #7da7ff` | 开关蓝点 |
| `--s-grad-radio-on` / `-off` | `#95afe5 → #6889da` / `#fbfbfb → #f1f1f1` | 单选 |
| `--s-grad-picker-body` | `#ededed 0 / #f1f1f1 14% / #ededed 100%` | 滚轮外框 |
| `--s-grad-picker-well` | `#fefefe 40.5% → #e2e2e3` | 滚轮井 |
| `--s-grad-picker-band` | `#fff 0 / #f5f5f5 53.5% / #f8f8f8` | 选中带 |
| `--s-grad-kit-header` | `#222325 / #3b3c3f 49% / #222325`（横向） | 文档页头 |
| `--s-page-texture` | `repeating-linear-gradient(90deg, #f0f0f0 0 3.6px, #eeeeee 3.6px 7.2px)` | **[R2]** 页面竖条纹 |
| `--s-appbar-shadow` | `rgba(0,0,0,.045) → 0`，高 8px | **[R2]** App Bar 下方的渐隐阴影 |

### Chip 配色
| 色 | 底 | 描边 | 字 | 按下底 | 按下描边 |
|---|---|---|---|---|---|
| White | `#fafafa` | `#cecece` | `#646464` | `#e9e9e9→#ececec` | `#bfbfbf` |
| Yellow | `#fff5d9` | `#ccb08c` | `#cd9143` | `#f2e9d1→#f2e8c9` | `#c5aa87` |
| Blue | `#ffffff` | `#93b2f7` | `#6393ff` | `#e6efff→#e1ecff` | `#93b2f7` |
| Red | `#ffe7e5` | `#eb7f77` | `#cc3e39` | `#f2dcda→#f2d8d6` | `#f0948d` |
| Grey | `#f0f0f0` | `#dadada` | `#646464` | — | — |

### Toast
底 `#fcf6e6 → #fcf3dc`，0.4px `#d2b89c`，14px 700 `#ad8a67`。

## 字体
- **[R2] 真机**：拉丁字母和数字用 **Smartisan Compact**（`/system/fonts/Smartisan_Compact-*.otf`，有 Thin 100 / Light 300 / Regular 400 / Medium 500 / Bold 700 / Heavy 900 六个字重），中文用 **Noto Sans CJK SC**（思源黑体）。
- **Figma Kit**：Inter（Tab 用 Roboto Bold）。
- CSS 字体栈：`"Smartisan Compact", "Inter", … "Noto Sans CJK SC", "Source Han Sans SC", "Noto Sans SC", "PingFang SC", …`。Smartisan Compact 是专有字体，本 skill 不分发，只有本机装了才会生效；否则用 Inter 加思源黑体，观感最接近。

| 场景 | 字号 | 字重 | 颜色 | 行高 |
|---|---|---|---|---|
| 文档页头标题 | 48 | 700 | `rgba(255,255,255,.9)` | 1 |
| 封面说明 | 20 | 500 | `#b8b8b8` | normal |
| 对话框标题 | 18 | 700 | `#636363` | normal |
| List Tile 2 标题 | 18 | 400 | `#333` | normal |
| App Bar 标题、大按钮、弹窗按钮 | 16 | 700 | `#636363` / 白 | 1 |
| 列表标题（List Title 样式）、菜单项、Detail、滚轮 | 16 | 400 | `#333` / `#636363` / `#7f7f7f` | normal（Figma 写 100%） |
| 对话框正文 | 16 | 400 | `#656565` | 24px |
| 小按钮、描边按钮、对话框操作、分段按钮、底部弹窗标题、Toast | 14 | 700 | 视组件而定 | normal |
| 列表分组标题 | 14 | 600 | `#7f7f7f` | normal |
| 列表说明、搜索输入、单选项、List Tile 2 Detail、List Tile 3 标题 | 14 | 400 | 视组件而定 | normal |
| 搜索结果标题 | 14 | 400，字距 0.5px | `#333` | 24px |
| 副标题 | 12 | 400 | `#7f7f7f` / `#9d9d9d` | normal |
| Chip | 12 | 600 | 随颜色 | normal |
| Tab | 12 | 700 | `#636363` / 白 | normal |
| 文字按钮 | 12 | 400 | `#5079d9` | 1 |
| Simple Dialog | 12 | 400 | `#898989` | 28px |
| 底部导航标签 | 8 | 400 | `#9d9d9d` / `#636363` | normal |

## 圆角
| Token | 值 | 用于 |
|---|---|---|
| `--s-r-segment` | 3 | 分段按钮选中块 |
| `--s-r-sm` | 4 | 小按钮、描边按钮（button/radius/small） |
| `--s-r-md` | 6 | 菜单、Tabs、Toast、输入框、图标按钮、滚轮井 |
| `--s-r-sheet-btn` | 8 | 底部弹窗按钮、Label 标签 |
| `--s-r-lg` | 10 | 大按钮（button-radius）、列表卡片（[R2] 实测约 10dp）、滑块卡片 |
| `--s-r-dialog` | 12 | 对话框、Simple Dialog |
| `--s-r-sheet` | 20 | 底部弹窗顶部 |
| `--s-r-kit` | 40 | 文档展示板 |
| `--s-r-pill` | 100 | Chip、开关、搜索框、滑块轨道 |

## 描边
0.4px（Chip、开关、菜单、Tabs、Toast、小按钮、列表按下）· 0.5px（描边按钮、搜索框、搜索结果左格、Tab 分隔、List Tile 3）· 0.8px（大按钮、列表卡片、白按钮、对话框按钮顶线、分隔线、滑块卡片）· 1px（App Bar 底线、对话框标题底线、底部弹窗标题底线、滚轮井、搜索结果和菜单分隔线）。
[R2] 在 2.5x 屏上，0.8dp 正好是 2 个物理像素（例如分隔线 `#f2f2f2` 占 2px）。

## 阴影
| Token | 值 | 用于 |
|---|---|---|
| `--s-shadow-btn` | `0 4px 2px rgba(0,0,0,.10)`（drop-shadow） | 大主按钮 |
| `--s-shadow-card` | `0 10px 16px rgba(0,0,0,.04)` | 分组列表卡片 |
| `--s-shadow-card-sm` | `0 2px 6px rgba(0,0,0,.06)` | 滑块卡片 |
| `--s-shadow-dialog-actions` | `0 4px 2.1px rgba(0,0,0,.07)` | 对话框按钮组 |
| `--s-shadow-bar` | `0 4px 4px rgba(0,0,0,.08)` | 搜索栏 |
| `--s-shadow-knob` | `0 5px 16.6px rgba(0,0,0,.21)` | 80px 旋钮 |
| `--s-shadow-knob-sm` | `0 4px 4px rgba(0,0,0,.12)` | 28px 旋钮 |
| `--s-shadow-thumb` | `0 4px 4px rgba(0,0,0,.08)` | 开关拨钮 |
| `--s-shadow-slider-thumb` | `0 4px 8px rgba(0,0,0,.16)` | 滑块拨钮 |
| `--s-shadow-radio-dot` | `0 2px 4px rgba(0,0,0,.06)` | 单选内点 |
| `--s-inset-track` | `inset 0 4px 4px rgba(0,0,0,.06)` | 滑块轨道 |
| `--s-inset-switch` | `inset 0 4px 12px rgba(0,0,0,.10)` | 开关凹槽 |
| `--s-inset-well` | `inset 0 4px 12px rgba(0,0,0,.18)` | 滚轮井 |
| `--s-inset-field` | `inset 0 4px 4px rgba(0,0,0,.04)` | 输入框（Shadow/textfield-inner） |
| `--s-inset-tab` | `inset 0 4px 10px rgba(0,0,0,.06)` | Tab 选中 |
| `--s-inset-swipe` | `inset 0 0 4px rgba(0,0,0,.16)` | 左滑操作托盘 |
| `--s-inset-radio` | `inset 0 0 2px rgba(0,0,0,.08)` | 单选外圈 |

## 尺寸与间距
- **设计宽度 432**。[R2] 物理分辨率 1080×2340，系统 density 被改成 400（2.5x），1080 ÷ 2.5 = 432dp，和 Kit 宽度一致。
- 大按钮 408（左右 12），底部弹窗按钮 392（左右 20），对话框 368（左右 32），Simple Dialog 376；[R2] 设置页卡片左右边距也是 12dp。
- 高度：App Bar 48 · 列表行 60（[R2] 一致）· 大按钮 60 · 弹窗按钮 48 · 单选项 48 · 对话框标题 48 · 对话框按钮 54 · 底部导航 54 · 菜单项 42 · Chip 30 · 小按钮 30 · 搜索框 30 · Tabs 28.8 · 开关 52×24 · 单选 22 · 滚轮选择器 274。
- 常用间距：4、6、8、10、12、16、18、20、22、24、40、48。
- 列表行：左 18 / 右 12，图标与文字间距 18，标题与副标题间距 4。
- App Bar：内边距 8/14，右侧操作间距 18。
- 底部导航：项间距 48，每项 38×40。

## 暗色模式
Kit 没有定义暗色。[R2] 实测 `Night mode: no`，这台设备上的 Smartisan OS 8.5.3 也没有开启系统暗色。如需暗色只能自行推导，并说明它不是官方规范。
