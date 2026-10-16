# Flutter 指南

在 Flutter 项目里做 Smartisan 风格时，**直接用 `assets/flutter/` 里的文件，不要从 CSS 自己翻译**。这些文件只依赖 Flutter SDK，不需要任何第三方包。

| 文件 | 内容 |
|---|---|
| `smartisan_theme.dart` | Kit 原始 token：`SColors`、`SChipColors`、`SGradients`、`SShadows`（已换算成 Flutter 的模糊参数）、`SRadii`、`SHair`、`SDims`、`SText`，以及最简版 `smartisanTheme()` |
| `smartisan_palette.dart` | `SPalette`：亮 / 暗两套颜色（`ThemeExtension`），`SPalette.of(context)` / `context.sp` 取色；`withAccent(color)` 按强调色推导整套强调色 |
| `smartisan_accent.dart` | `SmartisanAccent`：强调色预设（锤子蓝、锤子红、游戏紫、便签棕……）和 HSL 推导工具 |
| `smartisan_material_theme.dart` | **`SmartisanMaterialTheme.build(isDark:, accent:)`**：完整 `ThemeData`。去水波纹、按下态瞬时、48dp 柔和投影顶栏 + 细 ← 返回、分段感的配色、渐变主按钮、反转渐变的白按钮、内凹滑块、对话框/底部弹窗/菜单/输入框/Toast 配色、横向推入转场 |
| `smartisan_component_theme.dart` | 组件内部用的派生色（开关圆点、单选、分段……），全部跟随强调色和明暗 |
| `smartisan_widgets.dart` | Kit 组件（明暗自适应），并 re-export 下面所有文件 |
| `smartisan_adapters.dart` | `SmartisanSwitch`（可直接替换 Material `Switch`）、`SmartisanListSection`（分组卡片）、**`SmartisanTile`**（列表行：按下整行变强调色、内容变白，瞬时）、`SmartisanChevron` |
| `smartisan_tabs.dart` | **`SmartisanTabBar`**：真机分段 Tab（选中段内凹灰），包着 Material `TabBar`，`TabController` / 滑动照常工作，可放进 `AppBar.bottom` |
| `smartisan_bars.dart` | `SmartisanBrandBar` + `SmartisanSearchWell`（品牌色顶栏 + 内凹搜索框）、`SmartisanPinstripe`（真机竖条纹底）、`SmartisanSectionGap`（分区灰带 / 分区标题条）、`SmartisanBarShadow` |
| `smartisan_motion.dart` | **转场与动效**：`SMotion`（64ms 最短按下、100ms 点击超时、150 / 200 / 250 / 300ms、smooth / decelerate / accelerate 曲线）、`SPageRoute` 与 `SPageTransitionsBuilder`（横推：新页空白滑入、内容最后 40% 淡入、旧页左移 1/3）、`SModalPageRoute`（全屏页从底部升起）、`SDialogRoute`（遮罩 200ms 到 60%，卡片约 120ms 从 0.88 弹到原大，关闭时 100ms 淡出）、`SmartisanScrollBehavior`（弹性回弹、无光晕） |
| `smartisan_interaction.dart` | **框架层组件**：`SSwipeRow`（向右滑露出删除托盘，1/5 阻尼，同时只开一行）、`SQuickBar`（A–Z 字母索引条，带字母气泡和触觉）、`SEmptyState`、`SSectionTitle`（30dp 分区条）、`SCheck`（多选勾选圈，可红色）、`SRoundEditButton.add / .remove`、**组件编排** `SPartSwitcher` + `SPartEntrance`（主体不动，部件层 300ms 离场，新部件按各自时长 / 延迟 / 旋转 / 位移入场） |
| `smartisan_icons.dart` | Kit 的 23 个矢量图标（`SIcons.back` 等，`SIcon` 绘制） |
| `smartisan_glyphs.dart` + `glyphs/` | **`SGlyphs`**：166 个锤子风格字形的图标字体（Phosphor Icons fill / bold 字重，MIT）。用法同 `Icons`：`Icon(SGlyphs.like)` |
| `smartisan_gallery_page.dart` | 组件预览页，装好后先打开它目测一遍 |

真机交互、动效、间距的依据见 `references/device-behavior.md`；按压时序、转场时长、手势参数和出处见 `references/motion.md`。

## 接入

```bash
mkdir -p lib/smartisan assets/fonts
cp <skill>/assets/flutter/*.dart lib/smartisan/
cp <skill>/assets/flutter/glyphs/smartisan_glyphs.ttf assets/fonts/
```

`pubspec.yaml` 的 `flutter:` 下登记字体（family 名必须是 `SmartisanGlyphs`）：

```yaml
  fonts:
    - family: SmartisanGlyphs
      fonts:
        - asset: assets/fonts/smartisan_glyphs.ttf
```

```dart
import 'smartisan/smartisan_material_theme.dart';
import 'smartisan/smartisan_motion.dart';
import 'smartisan/smartisan_widgets.dart';

MaterialApp(
  theme: SmartisanMaterialTheme.build(isDark: false, accent: SmartisanAccent.blue.color),
  darkTheme: SmartisanMaterialTheme.build(isDark: true, accent: SmartisanAccent.blue.color),
  scrollBehavior: const SmartisanScrollBehavior(),
  home: ...,
);
```

只想要最小改动时也可以用 `MaterialApp(theme: smartisanTheme())`（只关水波纹、设灰底和文字颜色）。

## 组件对照（CSS → Flutter）

| CSS | Flutter |
|---|---|
| `.s-page` / `.s-page--textured` | `SPage(textured: true, child: …)` |
| `.s-appbar`（`--red` / `--shadow`） | `SAppBar(title:, onBack:, actions:, red:, shadow:)` |
| `.s-btn`、`--sm`、`--sheet`、`--outline`、`--text` | `SButton('…', kind: SButtonKind.primary / small / sheet / outline / text)` |
| `.s-btn-icon` | `SIconButton(icon:, onTap:)` |
| `.s-round-btn`（`--sm`） | `SRoundButton(icon:, small:)` |
| `.s-segmented` / `.s-tabs` | `SSegmented` / `STabs`；带 `TabController` 的页面 Tab 用 `SmartisanTabBar` |
| 设置类列表行（带按下态） | `SmartisanListSection(header:, children: [SmartisanTile(leading: Icon(SGlyphs.bell), title: Text('通知'), detail: '已关闭', onTap: …)])` |
| 品牌色顶栏 + 搜索 | `SmartisanBrandBar(child: Row(children: [Expanded(child: SmartisanSearchWell(hint: '搜索', onTap: …)), …]))` |
| 设置页竖条纹底 / 分区灰带 | `SmartisanPinstripe(child: …)` / `SmartisanSectionGap()`、`SmartisanSectionGap(label: '分类浏览')` |
| `.s-list-group` + `.s-list-item` | `SListGroup(header:, description:, lightIcons:, children: [SListTile(...)])` |
| `.s-list-item--simple` | `SListTileSimple` |
| `.s-switch` / `.s-radio` / `.s-radio-item` | `SSwitch` / `SRadio` / `SRadioTile` |
| `.s-slider`、`.s-slider-row`、`.s-slider-card` | `SSlider`（0–1）、`SSliderRow`、`SSliderCard` |
| `.s-chip` | `SChip('…', colors: SChipColors.red, leading: SIcons.star, trailing: true)` |
| `.s-toast` | `showSToast(context, '…')` |
| `.s-textfield` | `STextField(hint:)` |
| `.s-dialog` | `showSDialog<T>(context, title:, body:, actions: [SDialogAction('取消'), SDialogAction('确定', primary: true, value: …)])` |
| `.s-dialog--simple` | `showSSimpleDialog(context, '…')` |
| `.s-sheet` | `showSBottomSheet(context, title:, options:)`；只要标题栏用 `SSheetHeader` |
| `.s-picker` | `SWheelPicker(columns:, selected:, onChanged:)`，滚轮是真的能滚动 |
| `.s-menu` | `SPopupMenu(items: [SMenuItem(...)])` |
| `.s-search` | `SSearchBar(onCancel:)` |
| `.s-bottom-nav` | `SBottomNav(items: [SNavItem('…', SIcons.playlist)], currentIndex:, onTap:)` |
| 红勾 / 删除图标 | `SRedBadge.check()` / `SRedBadge.delete()` |
| `<svg class="s-icon"><use href="#si-x">` | `SIcon(SIcons.x, size:, color:)` |

一个完整页面的写法：

```dart
Scaffold(
  body: SPage(
    textured: true,
    child: Column(children: [
      SAppBar(title: '播放设置', onBack: () {}, shadow: true,
          actions: [SButton('完成', kind: SButtonKind.small, onPressed: () {})]),
      Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(12, 8, 12, 24), children: [
        SListGroup(header: '音效', children: [
          SListTile(title: '均衡器', detail: '流行', onTap: () {}),
          SListTile(title: '杜比音效', trailing: SSwitch(value: dolby, onChanged: (v) => setState(() => dolby = v))),
          SListTile(title: '音量', trailing: SizedBox(width: 250,
              child: SSliderRow(value: volume, gap: 14, onChanged: (v) => setState(() => volume = v)))),
        ]),
        const SizedBox(height: 24),
        SButton('恢复默认设置', onPressed: _confirmReset),
      ])),
      SBottomNav(items: [SNavItem('歌单', SIcons.playlist), SNavItem('正在播放', SIcons.playing), SNavItem('更多', SIcons.more)],
          currentIndex: 1, onTap: (_) {}),
    ]),
  ),
);
```

## 容易做错的地方

1. **对话框遮罩是 60%**：Kit 写 60%，[R2] 录屏也是 60%；`SmartisanMaterialTheme` 和 `showSDialog` 都用这个值。不要写 `Colors.transparent`。
2. **不要留下 Material 的标志性元素**：`Switch`、`Slider`（未换主题时）、`NavigationBar` 的胶囊指示器、`AlertDialog` 默认按钮排布、`SnackBar`、`Icons.*_outlined` 线框图标、下划线 `TabBar`、缩放转场。只要留一个，整页就会显得"Material + 锤子混搭"。对应替换：`SmartisanSwitch`、主题里的滑块、`SBottomNav` / 底栏主题、`showSDialog`、`showSToast`、`SGlyphs`、`SmartisanTabBar`、`SPageTransitionsBuilder`（主题已设）。
3. **按下态是瞬时换色，不是水波纹，也不是淡入高亮**。主题已关 splash，并给所有 `ButtonStyle` 设了 `animationDuration: Duration.zero`。列表行用 `SmartisanTile`；自己写的可点击元素用 `SPressable(builder: (context, pressed) => …)`。`AnimatedContainer` 做按下态会在页面被推走时"冻住"，松开后回来还看到蓝色，不要用。
4. **`PopupMenuButton` 不给 `icon` 时会画 Material 的 `⋮`**，主题改不掉，记得写 `icon: const Icon(SGlyphs.more)`（锤子的"更多"是横向 `•••`）。
5. **卡片里放 `ListTile` / `InkWell`**：卡片表面要是 `Material`（`SmartisanListSection` 已经这样做），用带颜色的 `DecoratedBox` 会挡住它们的绘制，debug 下还会断言。
6. **强调色只有一个**：所有强调元素都从 `SPalette.withAccent(accent)` 推导，不要在业务代码里写死 `#5b87eb`；需要强调色时用 `context.sp.accent` / `brandSelected` / `rowPressed`。
7. **分段 Tab 在平板上不要拉满**：`SmartisanTabBar` 默认最大 560dp 居中；超过 5 段自动横向滚动。
8. **内凹阴影**：`BoxShadow` 不支持 inset。要做凹陷效果，用 `SInsetShadow(shadows: SShadows.insetSwitch, borderRadius: …, child: …)` 包住。
9. **阴影数值不要从 CSS 直接抄**。CSS 的 blur 等于 2σ，Flutter 的 `blurRadius` 换算成 σ 是 `× 0.577 + 0.5`。`SShadows` 里已经换算好了；要自己写阴影时用 `SShadows.css(x, y, blur, color)`。
10. **字体**：真机是 Smartisan Compact 加 Noto Sans CJK SC，Kit 用的是 Inter。`SText` 配了 `fontFamilyFallback`，没装这些字体时会回落到系统字体。不要把 `fontFamily` 写死成 `'PingFang SC'`，Android 上没有这个字体。
11. **尺寸**：设计宽度是 432dp（R2 真机）。卡片和大按钮左右各留 12dp、卡片间 14dp；行高 60；App Bar 48；底部导航 54。
12. **描边**：0.4、0.5、0.8 这些细线在 Flutter 里直接写 `width: SHair.xs / sm / md`。
13. 路由库（如 GetX）有自己的转场时，主题里的 `pageTransitionsTheme` 可能不生效：GetX 用 `customTransition` 包一层 `sPushTransition(...)`；go_router 用 `CustomTransitionPage(transitionsBuilder: sPushTransition)`。
15. **两种页面打开方式要分清**：往下一层看详情用横推（`SPageRoute`，或主题里的 `MaterialPageRoute`）；设置、编辑器、搜索、"新建…"这类整页用 `SModalPageRoute` 从底部升起，下面的页不动。
16. **列表行的按压**：自己用 `SPressable` 做列表行时传 `delayed: true`（过 100ms 才变色，滚动时不闪）；按钮不用传。`SListTile` / `SmartisanTile` 已经按这个时序处理，快速点击也会保留 64ms 的按下色。
17. **开关、滑动删除、滚轮的手感已经内置**：`SSwitch` 可以拖，归位是线性移动（满程约 70ms）；`SSwipeRow` 是向右滑；`SWheelPicker` 是平的，越靠近中间字越大越深，每格一次 `selectionClick` 触觉。不要再自己包 `Dismissible`（那是左右滑走的 Material 行为）。
18. 底部菜单里的危险操作：`SDialogAction('清除', destructive: true)` 会变成红色 `SButtonKind.danger` 按钮。
19. **Tab 切换别整页换**：页面之间有共同主体（表盘、封面、仪表）时，把主体放在 `SPartSwitcher` 外面，`SPartSwitcher(child: KeyedSubtree(key: ValueKey(tab), child: 部件层))`，部件用 `SPartEntrance` 描述各自动作。旋转类部件（指针）要做成和主体一样大、以主体中心为中心的图层，`fromTurns` 才会绕表心转。
14. Kit 图标要更新时，改 `assets/icons-sprite.svg`，再运行 `python3 tools/gen_dart_icons.py`；字形字体要增删时改 `assets/flutter/glyphs/build.py` 里的列表再运行它（码位按顺序分配，不要重排已有的）。
