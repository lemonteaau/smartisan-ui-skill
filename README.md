# smartisan-ui · Smartisan OS UI skill

一个让 AI 编程助手（Claude Code 等支持 Agent Skills 的工具）直接按 **Smartisan OS（锤子 / 坚果手机）** UI 风格写前端界面的 skill。

An Agent Skill that teaches coding agents to build front-end UI in the style of **Smartisan OS** — light skeuomorphism, whisper-quiet gradients, hairline borders, soft drop shadows and inset wells, a grey-first palette with a low-saturation blue accent and the Smartisan red.

![smartisan-ui skill](docs/cover.png)

## 内容 · What's inside

- **完整复刻整套 UI Kit**：17 页，所有组件、所有变体、所有状态（normal / pressed / disabled / selected），数值全部从 Figma 节点读取。
- **真机校对**：在 Smartisan R2（Smartisan OS 8.5.3）上用 adb 实测，校对了 432dp 设计宽度、系统字体（Smartisan Compact + Noto Sans CJK SC）、设置页的竖条纹底、App Bar 阴影和列表图标颜色。
- `assets/smartisan.css`：全部设计 token（CSS 变量）和 26 类组件样式 `.s-*`，不依赖任何框架。
- `assets/tokens.json`（W3C DTCG 格式）和 `assets/tailwind.preset.js`。
- 29 个图标（SVG 原件 + `currentColor` sprite）以及各组件里的上色版本。
- `assets/demo.html`：整套 Kit 的 1:1 复刻展示页。
- `references/`：token 全表、组件规格、Figma 节点清单、17 个页面的参考截图。

| Component | Class |
|---|---|
| App Bar（white / red） | `.s-appbar` |
| Buttons：elevated / small / sheet / outlined / text / icon / rounded knob / segmented | `.s-btn*`, `.s-btn-icon`, `.s-round-btn`, `.s-segmented` |
| Bottom Navigation | `.s-bottom-nav` |
| Bottom Sheet | `.s-sheet` |
| Chip（5 colours × 4 layouts × 2 states） | `.s-chip` |
| Date / Time Picker | `.s-picker` |
| Dialog：alert / simple / list / text field / action group 1–3 | `.s-dialog*`, `.s-textfield` |
| Divider | `.s-divider` |
| List：group / tile / tile 2 / tile 3 / slidable / detail | `.s-list*`, `.s-swipe` |
| Popup Menu | `.s-menu` |
| Radio | `.s-radio`, `.s-radio-item` |
| Search Bar / Field / Results | `.s-search*`, `.s-result` |
| Slide Bar | `.s-slider`, `.s-slider-card` |
| Switch | `.s-switch` |
| Tabs | `.s-tabs` |
| Toast | `.s-toast` |

## 效果展示 · Showcase

用 [opencode](https://opencode.ai) + GLM-5.3 实测。提示词里**没有点名这个 skill**，只说了“锤子手机风格”；当时环境里装了 70 多个 skill，其中好几个也是设计类的，模型仍然自己选中了 `smartisan-ui`，然后按 SKILL.md 的步骤做：复制 `smartisan.css`、内联图标 sprite、用 `.s-*` 组件拼页面，最后自己验证交互。

Tested with opencode + GLM-5.3. The prompt never names the skill — it just asks for "Smartisan phone style". The model picked `smartisan-ui` out of 70+ installed skills on its own.

<details>
<summary>任务提示词 · Task prompt</summary>

```text
做一个音乐 App 的「播放设置」页面，单个 index.html 文件（可以引用同目录下的 css 文件），
要求做成锤子手机（Smartisan OS）的界面风格。

1. 顶部标题栏：左边返回，中间标题「播放设置」，右边一个完成按钮。
2. 一组「音效」设置列表：均衡器（右侧显示「流行」并带箭头）、杜比音效（开关，默认开）、无损音质（开关，默认关）。
3. 一组「播放」设置列表：定时关闭（右侧显示「30 分钟」）、音量（一个滑块）。
4. 底部一个主按钮「恢复默认设置」，点击后弹出确认对话框（取消 / 恢复），
   点「恢复」后关闭对话框并显示一个提示「已恢复默认设置」。
5. 最底部是底部导航：歌单、正在播放（当前页）、更多。
```
</details>

**Web（HTML + skill 自带 CSS）**：页面 → 确认对话框 → 恢复后的提示。约 3 分钟完成，自写样式只有 43 行。

![opencode + GLM-5.3 web result](docs/showcase/opencode-glm-web.png)

**Flutter（同一个任务，只用 Flutter SDK）**：模型从 token 表把颜色、阴影、圆角翻译成 Dart，用 `CustomPainter` 画出竖条纹底和开关的小圆点，`flutter analyze` 零问题。

<img src="docs/showcase/opencode-glm-flutter.png" width="320" alt="opencode + GLM-5.3 Flutter result">

## 安装 · Install

```bash
git clone https://github.com/lemonteaau/smartisan-ui-skill ~/.claude/skills/smartisan-ui
```

装好后，在对话里提到「锤子风格」「Smartisan」「坚果 OS」之类的词，skill 会自动加载。

Once installed, mention "Smartisan style" or similar in a prompt and the agent will load the skill.

只想用 CSS 的话：

```html
<link rel="stylesheet" href="assets/smartisan.css">
<body class="s-page">
  <button class="s-btn">确定</button>
  <input type="checkbox" class="s-switch" checked>
</body>
```

## 预览 · Preview

```bash
cd assets && python3 -m http.server 8765
```

然后打开 http://localhost:8765/demo.html

## 致谢与许可 · Credits & license

- 设计来源：Figma Community 文件 [**Smartisan OS UI Kit (Unofficial)**](https://www.figma.com/community/file/1419385240874679870)，作者 [**Paix Chan**](https://www.figma.com/@paixchan)，按 [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) 授权。本仓库中的设计数值、图标 SVG、组件渲染图和页面截图都来自该文件（为了网页使用做过整理：统一了 SVG 的 ID、去掉了画布背景、修正了两个图标的方向命名，并增加了 `currentColor` 版本）。
- 本仓库自己编写的代码和文档（CSS、JSON、JS、Markdown、HTML）使用 [MIT](LICENSE) 许可。来自上述 Kit 的素材仍然按 CC BY 4.0 授权，使用时请保留对原作者的署名。
- "Smartisan"、"锤子"、T 标志和 Smartisan OS 是其各自权利人的商标或作品。本项目是非官方的爱好者项目，与锤子科技及其关联方没有任何关系。`assets/brand/` 里的标志只用于复刻 Kit 的展示页，请不要用在你自己的产品里。
- Smartisan Compact 是专有字体，本仓库**不包含**它，CSS 只会在你本机已经安装时调用它。
