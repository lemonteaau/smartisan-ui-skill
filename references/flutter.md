# Flutter 指南

在 Flutter 项目里做 Smartisan 风格时，**直接用 `assets/flutter/` 里的三个文件，不要从 CSS 自己翻译**。这三个文件只依赖 Flutter SDK，不需要任何第三方包。

| 文件 | 内容 |
|---|---|
| `smartisan_theme.dart` | token：`SColors`、`SChipColors`、`SGradients`、`SShadows`（已换算成 Flutter 的模糊参数）、`SRadii`、`SHair`、`SDims`、`SText`，以及 `smartisanTheme()` |
| `smartisan_icons.dart` | 23 个矢量图标（`SIcons.back` 等），由 `tools/gen_dart_icons.py` 从 sprite 生成 |
| `smartisan_widgets.dart` | 组件库，同时 re-export 上面两个文件 |

## 接入

```bash
mkdir -p lib/smartisan && cp <skill>/assets/flutter/*.dart lib/smartisan/
```

```dart
import 'smartisan/smartisan_widgets.dart';

MaterialApp(theme: smartisanTheme(), home: ...);   // 关掉水波纹、设好灰底和文字颜色
```

## 组件对照（CSS → Flutter）

| CSS | Flutter |
|---|---|
| `.s-page` / `.s-page--textured` | `SPage(textured: true, child: …)` |
| `.s-appbar`（`--red` / `--shadow`） | `SAppBar(title:, onBack:, actions:, red:, shadow:)` |
| `.s-btn`、`--sm`、`--sheet`、`--outline`、`--text` | `SButton('…', kind: SButtonKind.primary / small / sheet / outline / text)` |
| `.s-btn-icon` | `SIconButton(icon:, onTap:)` |
| `.s-round-btn`（`--sm`） | `SRoundButton(icon:, small:)` |
| `.s-segmented` / `.s-tabs` | `SSegmented` / `STabs` |
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

1. **对话框必须有 60% 黑色遮罩**。用 `showSDialog`，或者 `barrierColor: SColors.overlay`。不要写 `Colors.transparent`。
2. **不要直接用 Material 控件**（`Switch`、`Slider`、`AppBar`、`NavigationBar`、`ElevatedButton`、`AlertDialog`、`SnackBar`、`Icons.*`）。它们的外观和交互都是 Material 风格。对应的 S 组件见上表，图标用 `SIcon(SIcons.…)`。
3. **按下态是换颜色，不是水波纹**。`smartisanTheme()` 已经关掉了 splash；自己写的可点击元素用 `SPressable(builder: (context, pressed) => …)`。
4. **内凹阴影**：`BoxShadow` 不支持 inset。要做凹陷效果，用 `SInsetShadow(shadows: SShadows.insetSwitch, borderRadius: …, child: …)` 包住。
5. **阴影数值不要从 CSS 直接抄**。CSS 的 blur 等于 2σ，Flutter 的 `blurRadius` 换算成 σ 是 `× 0.577 + 0.5`。`SShadows` 里已经换算好了；要自己写阴影时用 `SShadows.css(x, y, blur, color)`。
6. **字体**：真机是 Smartisan Compact 加 Noto Sans CJK SC，Kit 用的是 Inter。`SText` 配了 `fontFamilyFallback`，没装这些字体时会回落到系统字体。需要更接近的效果时，在 `pubspec.yaml` 里打包 Inter 和思源黑体。不要把 `fontFamily` 写死成 `'PingFang SC'`，Android 上没有这个字体。
7. **尺寸**：设计宽度是 432dp（R2 真机）。卡片和大按钮左右各留 12dp；行高 60；App Bar 48；底部导航 54。
8. **描边**：0.4、0.5、0.8 这些细线在 Flutter 里直接写 `width: SHair.xs / sm / md`。
9. 图标要更新时，改 `assets/icons-sprite.svg`，再运行 `python3 tools/gen_dart_icons.py` 重新生成。
