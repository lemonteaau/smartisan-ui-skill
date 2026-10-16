<p align="right">简体中文 | <a href="README.en.md">English</a></p>

# smartisan-ui

让 AI 编程助手直接写出 **Smartisan OS（锤子 / 坚果手机）** 风格界面的 Agent Skill。支持网页和 Flutter。

![smartisan-ui](docs/cover.png)

## 安装

**通用方式（推荐）**：用 [skills](https://github.com/vercel-labs/skills) CLI 安装。它会自动识别你装了哪些 agent，支持 Claude Code、Codex、OpenCode、Cursor、Gemini CLI、GitHub Copilot 等 50 多种。

```bash
npx skills add lemonteaau/smartisan-ui-skill
```

```bash
# 只装给指定的 agent，并且装到全局（-g）
npx skills add lemonteaau/smartisan-ui-skill -g -a claude-code -a codex -a opencode
```

**Claude Code 插件市场**：

```bash
/plugin marketplace add lemonteaau/smartisan-ui-skill
/plugin install smartisan-ui@smartisan-ui-skill
```

**手动安装**：直接 clone 到 agent 的 skills 目录。

```bash
git clone https://github.com/lemonteaau/smartisan-ui-skill ~/.claude/skills/smartisan-ui
```

| Agent | 全局目录 | 项目目录 |
|---|---|---|
| Claude Code | `~/.claude/skills/` | `.claude/skills/` |
| Codex | `~/.codex/skills/` | `.agents/skills/` |
| OpenCode | `~/.config/opencode/skills/` | `.agents/skills/` 或 `.opencode/skills/` |
| Cursor | `~/.cursor/skills/` | `.agents/skills/` |
| Gemini CLI | `~/.gemini/skills/` | `.agents/skills/` |

## 使用

装好后直接提需求，例如「做一个设置页，锤子手机风格」，或者「把这个页面改成 Smartisan OS 的样子」，agent 会自己加载这个 skill。

## 包含什么

- **完整 UI Kit**：17 页，所有组件、变体和状态，数值都从 Figma 原稿读出，并在 Smartisan R2 真机上校对过。
- **网页**：`smartisan.css`（设计 token + 30 多类 `.s-*` 组件）、`smartisan.js` 交互层、Tailwind preset、`tokens.json`。
- **Flutter**：设计 token、亮/暗色板与可选强调色、完整 `ThemeData`、23 个矢量图标 + 166 个字形的图标字体、全套组件（含分段 Tab、品牌栏、带按下态的列表行、右滑删除、字母索引、空状态），以及横推、全屏上推、对话框三种转场，不依赖任何第三方包。
- **图标**：29 个 SVG，附带各组件里实际用到的上色版本。
- **参考资料**：组件规格、Figma 节点清单、17 页参考截图、`demo.html` 完整复刻页。
- **真机实测**：在 Smartisan R2 上逐像素取色、60fps 录屏得到的按下态、转场和对话框动效、回弹、分段 Tab、间距与分隔线规则（`references/device-behavior.md`）。
- **交互与系统规范**：从 Smartisan OS 框架资源里读出的 6dp 间距网格、字号和文字色，以及参考社区复刻的锤子音乐 / 天气 / 时钟整理出的手感参数。包括按压时序（64ms / 100ms）、层级横推与标题栏分阶段转场、全屏页上推、标题栏图标弹性放大、可拖动的开关、向右滑删除、橡皮筋回弹、真滚轮和字母索引条（`references/motion.md`）。

## 效果展示

用 [opencode](https://opencode.ai) + GLM-5.3 实测。

<details>
<summary>任务提示词</summary>

```text
做一个音乐 App 的「播放设置」页面，要求做成锤子手机（Smartisan OS）的界面风格。
1. 顶部标题栏：左边返回，中间标题「播放设置」，右边一个完成按钮。
2. 「音效」设置列表：均衡器（显示「流行」带箭头）、杜比音效（开关，默认开）、无损音质（开关，默认关）。
3. 「播放」设置列表：定时关闭（显示「30 分钟」）、音量（滑块）。
4. 主按钮「恢复默认设置」，点击弹出确认对话框（取消 / 恢复），恢复后显示提示「已恢复默认设置」。
5. 底部导航：歌单、正在播放（当前页）、更多。
```
</details>

**网页版**：页面 → 确认对话框 → 恢复后的提示，用时约 3 分钟。

![web](docs/showcase/opencode-glm-web.png)

**Flutter 版**：同一个任务，`main.dart` 只有 120 行，`flutter analyze` 零问题。

![flutter](docs/showcase/opencode-glm-flutter.png)

## 致谢与许可

- 设计来源：[Smartisan OS UI Kit (Unofficial)](https://www.figma.com/community/file/1419385240874679870)，作者 [Paix Chan](https://www.figma.com/@paixchan)，按 [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/) 授权。图标、组件渲染图和参考截图都来自这个文件，沿用 CC BY 4.0。
- 交互参数参考了社区的 1:1 复刻项目：[SmartisanMusic-Revived](https://github.com/Mangi-11/SmartisanMusic-Revived)、[SmartisanWeather-Revived](https://github.com/Mangi-11/SmartisanWeather-Revived)、[SmartisanClock-Revived](https://github.com/Mangi-11/SmartisanClock-Revived)（作者 Mangi-11）和 [SmartisanOS_APP_Port](https://github.com/People-11/SmartisanOS_APP_Port)（作者 People-11）。本仓库只引用了其中的数值和行为描述，没有复制代码或位图。
- 本仓库自己写的代码和文档使用 [MIT](LICENSE) 许可。
- Flutter 图标字体的字形来自 [Phosphor Icons](https://phosphoricons.com)（MIT，见 `assets/flutter/glyphs/svg/LICENSE`）；其中“更多”的 `•••` 是本项目自己画的。
- Smartisan、锤子和 T 标志是其权利人的商标。本项目是非官方爱好者作品，与锤子科技没有关系。Smartisan Compact 字体不包含在本仓库中。
