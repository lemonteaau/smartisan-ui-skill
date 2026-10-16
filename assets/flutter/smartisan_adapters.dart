import 'dart:async' show Timer;

import 'smartisan_palette.dart';
import 'smartisan_widgets.dart';

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';

/// Drop-in Material Switch adapter. Styling arguments are accepted for source
/// compatibility; the Smartisan palette owns the appearance.
class SmartisanSwitch extends StatelessWidget {
  const SmartisanSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = SDims.switchSize,
    WidgetStateProperty<Icon?>? thumbIcon,
    Color? activeThumbColor,
    Color? activeTrackColor,
    Color? inactiveThumbColor,
    Color? inactiveTrackColor,
    WidgetStateProperty<Color?>? trackOutlineColor,
    MaterialTapTargetSize? materialTapTargetSize,
    EdgeInsetsGeometry? padding,
    double? splashRadius,
    this.focusNode,
    this.autofocus = false,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    MouseCursor? mouseCursor,
    WidgetStateProperty<Color?>? thumbColor,
    WidgetStateProperty<Color?>? trackColor,
    WidgetStateProperty<Color?>? overlayColor,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Size size;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) => FocusableActionDetector(
    enabled: onChanged != null,
    focusNode: focusNode,
    autofocus: autofocus,
    mouseCursor: onChanged == null
        ? SystemMouseCursors.basic
        : SystemMouseCursors.click,
    actions: {
      ActivateIntent: CallbackAction<ActivateIntent>(
        onInvoke: (_) {
          onChanged?.call(!value);
          return null;
        },
      ),
    },
    child: SizedBox.fromSize(
      size: size,
      child: FittedBox(
        child: SSwitch(value: value, onChanged: onChanged),
      ),
    ),
  );
}

/// Group flat settings rows into a clipped Smartisan card.
class SmartisanListSection extends StatelessWidget {
  const SmartisanListSection({
    super.key,
    required this.children,
    this.header,
    this.footer,
    this.margin = const EdgeInsets.symmetric(horizontal: 12),
    this.maxWidth = 720,
  });

  final List<Widget> children;
  final String? header;
  final String? footer;
  final EdgeInsetsGeometry margin;

  /// Cards never grow wider than this (centred on wide screens).
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final palette = SPalette.of(context);
    const radius = BorderRadius.all(Radius.circular(10));
    // Wide screens: keep the phone-sized card centred instead of stretching
    // rows across a tablet / desktop window.
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: _section(palette, radius),
      ),
    );
  }

  Widget _section(SPalette palette, BorderRadius radius) {
    return Padding(
      padding: margin,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (header != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Text(
                header!,
                style: SText.sectionHeader.copyWith(color: palette.subtitle),
              ),
            ),
          // Shadow only here; the card surface itself is a Material so that
          // ListTile / InkWell children can paint on it.
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: radius,
              boxShadow: palette.cardShadow,
            ),
            child: Material(
              color: palette.card,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: radius,
                side: BorderSide(color: palette.border, width: .8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(.8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < children.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 0.8,
                          thickness: 0.8,
                          color: palette.rowDivider,
                        ),
                      children[i],
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (footer != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                footer!,
                textAlign: TextAlign.center,
                style: SText.description.copyWith(color: palette.subtitle),
              ),
            ),
        ],
      ),
    );
  }
}

/// The kit's right-facing arrow, tinted by the current palette.
class SmartisanChevron extends StatelessWidget {
  const SmartisanChevron({super.key});

  @override
  Widget build(BuildContext context) =>
      SIcon(SIcons.chevronRight, color: SPalette.of(context).chevron);
}

/// Smartisan list row, as on the R2: 56–60dp, pale filled glyph in front,
/// `#333` title, optional grey detail and `>` chevron. While pressed the
/// whole row turns Smartisan blue and every text / icon in it turns white.
///
/// Use it for any tappable list row (settings, menus, simple lists). Put it
/// inside [SmartisanListSection] for the grouped-card look.
class SmartisanTile extends StatefulWidget {
  const SmartisanTile({
    super.key,
    required this.title,
    this.leading,
    this.subtitle,
    this.detail,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.showChevron,
    this.enabled = true,
    this.selected = false,
    this.minHeight = 56,
    this.padding = const EdgeInsets.only(left: 16, right: 12),
  });

  final Widget title;

  /// Usually `Icon(SGlyphs.xxx)`; tinted `palette.iconListLight` by default.
  final Widget? leading;
  final Widget? subtitle;

  /// Grey value text before the chevron (e.g. "已关闭").
  final String? detail;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Defaults to true when [onTap] is set and there is no [trailing].
  final bool? showChevron;
  final bool enabled;

  /// Selected rows (e.g. the active pane in a split layout) use the light
  /// accent container.
  final bool selected;
  final double minHeight;
  final EdgeInsetsGeometry padding;

  @override
  State<SmartisanTile> createState() => _SmartisanTileState();
}

class _SmartisanTileState extends State<SmartisanTile> {
  bool _pressed = false;
  Timer? _timer;

  bool get _interactive =>
      widget.enabled && (widget.onTap != null || widget.onLongPress != null);

  // TapGestureRecognizer reports onTapDown after the 100ms tap timeout (kPressTimeout), the same
  // delay Android's ListView uses, so a scroll that starts on a row never flashes it blue.
  void _down(TapDownDetails _) {
    _timer?.cancel();
    if (mounted) setState(() => _pressed = true);
  }

  void _clear() {
    _timer?.cancel();
    if (_pressed && mounted) setState(() => _pressed = false);
  }

  void _up(TapUpDetails _) {
    _timer?.cancel();
    if (_pressed) {
      // finger was resting on the row: release immediately
      _clear();
    } else if (mounted) {
      // quick tap: keep the pressed colour for the platform's 64ms pressed-state duration
      setState(() => _pressed = true);
      _timer = Timer(SMotion.pressedMin, _clear);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = SPalette.of(context);
    final pressed = _pressed && _interactive;
    final fg = pressed ? Colors.white : null;
    final chevron =
        widget.showChevron ?? (widget.onTap != null && widget.trailing == null);
    final titleColor = fg ?? (widget.enabled ? p.title : p.disabled);
    final subColor = fg ?? p.subtitleOther;

    Widget row = Row(
      children: [
        if (widget.leading != null) ...[
          IconTheme.merge(
            data: IconThemeData(
              size: 22,
              color: fg ?? (widget.enabled ? p.iconListLight : p.iconDisabled),
            ),
            child: widget.leading!,
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DefaultTextStyle.merge(
                  style: TextStyle(
                    fontSize: 16,
                    color: titleColor,
                    height: 1.3,
                  ),
                  child: widget.title,
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 3),
                  DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize: 12,
                      color: subColor,
                      height: 1.35,
                    ),
                    child: widget.subtitle!,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (widget.detail != null) ...[
          const SizedBox(width: 8),
          Text(
            widget.detail!,
            style: TextStyle(fontSize: 13, color: fg ?? p.subtitleOther),
          ),
        ],
        if (widget.trailing != null) ...[
          const SizedBox(width: 8),
          IconTheme.merge(
            data: IconThemeData(color: fg ?? p.icon),
            child: DefaultTextStyle.merge(
              style: TextStyle(color: fg ?? p.subtitleOther, fontSize: 13),
              child: widget.trailing!,
            ),
          ),
        ],
        if (chevron) ...[
          const SizedBox(width: 4),
          SIcon(SIcons.chevronRight, size: 22, color: fg ?? p.chevron),
        ],
      ],
    );

    // Press and release are instant colour swaps, as on the device (an
    // animated release would also freeze while a pushed page covers it).
    row = Container(
      constraints: BoxConstraints(minHeight: widget.minHeight),
      padding: widget.padding,
      color: pressed
          ? p.rowPressed
          : widget.selected
          ? Theme.of(context).colorScheme.primaryContainer
          : Colors.transparent,
      child: row,
    );

    if (!_interactive) return row;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _down,
      onTapUp: _up,
      onTapCancel: _clear,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress == null
          ? null
          : () {
              _clear();
              widget.onLongPress!();
            },
      child: row,
    );
  }
}
