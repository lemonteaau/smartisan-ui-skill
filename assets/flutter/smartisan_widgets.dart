// Smartisan OS UI — Flutter widgets (Flutter SDK only, no third-party packages).
// Mirrors the .s-* components of assets/smartisan.css. See references/flutter.md.
//
// Copy smartisan_theme.dart, smartisan_icons.dart and this file into lib/smartisan/, then:
//   import 'smartisan/smartisan_widgets.dart';   // re-exports theme + icons
//
// Pressed states change colour (no ripple), exactly like the kit.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'smartisan_component_theme.dart';
import 'smartisan_icons.dart';
import 'smartisan_palette.dart';
import 'smartisan_theme.dart';

export 'smartisan_adapters.dart';
export 'smartisan_bars.dart';
export 'smartisan_glyphs.dart';
export 'smartisan_icons.dart';
export 'smartisan_tabs.dart';
export 'smartisan_theme.dart';

// ============================================================================================
// Primitives
// ============================================================================================

/// Vector icon from [SIcons]. Paints the original viewBox into a [size] square (contain).
class SIcon extends StatelessWidget {
  const SIcon(this.icon, {super.key, this.size = 24, this.color});
  final SIconData icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(
      painter: _SIconPainter(
        icon,
        color ?? IconTheme.of(context).color ?? context.sp.icon,
      ),
    ),
  );
}

class _SIconPainter extends CustomPainter {
  _SIconPainter(this.icon, this.color);
  final SIconData icon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final vb = icon.viewBox;
    final s = math.min(size.width / vb.width, size.height / vb.height);
    canvas
      ..save()
      ..translate(
        (size.width - vb.width * s) / 2,
        (size.height - vb.height * s) / 2,
      )
      ..scale(s)
      ..translate(-vb.left, -vb.top);
    for (final part in icon.parts) {
      final path = Path.from(part.path)
        ..fillType = part.evenOdd ? PathFillType.evenOdd : PathFillType.nonZero;
      if (part.paint != SIconPaint.stroke) {
        canvas.drawPath(
          path,
          Paint()
            ..color = color
            ..isAntiAlias = true,
        );
      }
      if (part.paint != SIconPaint.fill) {
        canvas.drawPath(
          path,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = part.strokeWidth
            ..strokeCap = part.cap
            ..strokeJoin = part.join
            ..isAntiAlias = true,
        );
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_SIconPainter old) =>
      old.icon != icon || old.color != color;
}

/// Inner ("inset") shadow — Flutter's BoxShadow has no inset, the kit relies on it for
/// switch/slider tracks, the picker well, text fields and selected tabs.
class SInsetShadow extends StatelessWidget {
  const SInsetShadow({
    super.key,
    required this.shadows,
    this.borderRadius = BorderRadius.zero,
    this.child,
  });
  final List<BoxShadow> shadows;
  final BorderRadius borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) => CustomPaint(
    foregroundPainter: _InsetPainter(shadows, borderRadius),
    child: child,
  );
}

class _InsetPainter extends CustomPainter {
  _InsetPainter(this.shadows, this.radius);
  final List<BoxShadow> shadows;
  final BorderRadius radius;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final rrect = radius.toRRect(bounds);
    canvas
      ..save()
      ..clipRRect(rrect);
    for (final s in shadows) {
      // Fill the shape with the shadow colour, then knock out a blurred copy of the shape that is
      // shifted by the offset — what remains is the inner shadow along the opposite edges.
      canvas
        ..saveLayer(bounds, Paint())
        ..drawRect(bounds, Paint()..color = s.color)
        ..drawRRect(
          rrect.shift(s.offset).deflate(s.spreadRadius),
          Paint()
            ..blendMode = BlendMode.dstOut
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, s.blurSigma),
        )
        ..restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InsetPainter old) =>
      old.shadows != shadows || old.radius != radius;
}

/// Page background: flat kit grey (#F5F5F5) or the real-device pinstripes (#F0F0F0 / #EEEEEE, 3.6dp).
class SPage extends StatelessWidget {
  const SPage({super.key, required this.child, this.textured = false});
  final Widget child;
  final bool textured;

  @override
  Widget build(BuildContext context) => textured
      ? CustomPaint(painter: _StripePainter(context.sp), child: child)
      : ColoredBox(color: context.sp.page, child: child);
}

class _StripePainter extends CustomPainter {
  _StripePainter(this.palette);
  final SPalette palette;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = palette.pageReal);
    final p = Paint()..color = palette.pageStripe;
    for (double x = 3.6; x < size.width; x += 7.2) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 3.6, size.height), p);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) => old.palette != palette;
}

/// Tracks pointer-down state to render pressed styles (no ripple).
class SPressable extends StatefulWidget {
  const SPressable({
    super.key,
    required this.builder,
    this.onTap,
    this.enabled = true,
  });
  final Widget Function(BuildContext context, bool pressed) builder;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  State<SPressable> createState() => _SPressableState();
}

class _SPressableState extends State<SPressable> {
  bool _down = false;
  void _set(bool v) {
    if (mounted && _down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && widget.onTap != null;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: active ? (_) => _set(true) : null,
      onTapUp: active ? (_) => _set(false) : null,
      onTapCancel: active ? () => _set(false) : null,
      onTap: active ? widget.onTap : null,
      child: MouseRegion(
        cursor: active ? SystemMouseCursors.click : MouseCursor.defer,
        child: widget.builder(context, _down),
      ),
    );
  }
}

class SDivider extends StatelessWidget {
  const SDivider({super.key, this.indent = 0});
  final double indent;
  @override
  Widget build(BuildContext context) => Container(
    height: SHair.md,
    margin: EdgeInsets.only(left: indent),
    color: context.sp.divider,
  );
}

// ============================================================================================
// App Bar
// ============================================================================================

/// 48dp bar, centred bold title, back on the left, actions (gap 18) on the right.
/// [red] = brand red bar (white title/icons). [shadow] = the 8dp fade measured on a real R2.
class SAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions = const [],
    this.red = false,
    this.shadow = false,
  });
  final String title;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final bool red, shadow;

  @override
  Size get preferredSize => Size.fromHeight(SDims.appBar + (shadow ? 8 : 0));

  @override
  Widget build(BuildContext context) {
    final fg = red ? Theme.of(context).colorScheme.onPrimary : context.sp.icon;
    final bar = Container(
      height: SDims.appBar,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: red ? null : context.sp.appBar,
        gradient: red ? context.sp.redBarGradient : null,
        border: Border(
          bottom: BorderSide(
            color: red ? context.sp.appBarRedBorder : context.sp.appBarBorder,
            width: 1,
          ),
        ),
      ),
      child: IconTheme(
        data: IconThemeData(color: fg),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                if (onBack != null)
                  SIconButtonPlain(
                    icon: SIcons.back,
                    size: 20,
                    color: fg,
                    onTap: onBack!,
                  ),
                const Spacer(),
                for (var i = 0; i < actions.length; i++) ...[
                  if (i > 0) const SizedBox(width: 18),
                  actions[i],
                ],
              ],
            ),
            IgnorePointer(
              child: Text(
                title,
                style: SText.barTitle.copyWith(
                  color: red
                      ? Theme.of(context).colorScheme.onPrimary
                      : context.sp.titleOther,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (!shadow) return bar;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        bar,
        Container(
          height: 8,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.sp.shadow.withValues(alpha: 11 / 255),
                context.sp.shadow.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Bare icon button for bars/headers (colour change on press).
class SIconButtonPlain extends StatelessWidget {
  const SIconButtonPlain({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 24,
    this.color,
  });
  final SIconData icon;
  final VoidCallback onTap;
  final double size;
  final Color? color;
  @override
  Widget build(BuildContext context) => SPressable(
    onTap: onTap,
    builder: (context, p) => Opacity(
      opacity: p ? .5 : 1,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: SIcon(icon, size: size, color: color),
      ),
    ),
  );
}

// ============================================================================================
// Buttons
// ============================================================================================

enum SButtonKind { primary, small, sheet, outline, text }

/// Elevated (primary, 60dp), small elevated (30dp), bottom-sheet white (48dp), outlined (30dp), text.
class SButton extends StatelessWidget {
  const SButton(
    this.label, {
    super.key,
    this.onPressed,
    this.kind = SButtonKind.primary,
    this.expand = true,
  });
  final String label;
  final VoidCallback? onPressed;
  final SButtonKind kind;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return SPressable(
      onTap: onPressed,
      builder: (context, p) {
        late BoxDecoration deco;
        late TextStyle style;
        double? height;
        EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 22);
        switch (kind) {
          case SButtonKind.primary:
          case SButtonKind.small:
            final small = kind == SButtonKind.small;
            final disabledGrad = small
                ? context.sp.smallDisabledGradient
                : context.sp.primary;
            deco = BoxDecoration(
              color: p ? context.sp.accentPressed : null,
              gradient: p
                  ? null
                  : (enabled ? context.sp.primary : disabledGrad),
              border: Border.all(
                color: p
                    ? context.sp.blue600
                    : (small && !enabled
                          ? context.sp.smallDisabledBorder
                          : context.sp.accentBorder),
                width: small ? SHair.xs : SHair.md,
              ),
              borderRadius: BorderRadius.circular(
                small ? SRadii.small : SRadii.button,
              ),
              boxShadow: small ? null : context.sp.buttonShadow,
            );
            style = small
                ? SText.buttonSmall.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                : SText.buttonLarge.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  );
            height = small ? SDims.buttonSmall : SDims.buttonLarge;
            if (small) padding = const EdgeInsets.symmetric(horizontal: 12);
          case SButtonKind.sheet:
            deco = BoxDecoration(
              color: p ? context.sp.cardPressed : context.sp.card,
              border: Border.all(
                color: context.sp.borderButton,
                width: SHair.md,
              ),
              borderRadius: BorderRadius.circular(SRadii.sheetButton),
            );
            style = SText.buttonLarge.copyWith(color: context.sp.titleOther);
            height = SDims.buttonSheet;
          case SButtonKind.outline:
            deco = BoxDecoration(
              color: p ? context.sp.divider : null,
              border: Border.all(
                color: context.sp.outlinedBorder,
                width: SHair.sm,
              ),
              borderRadius: BorderRadius.circular(SRadii.small),
            );
            style = SText.buttonSmall.copyWith(color: context.sp.outlinedText);
            height = SDims.buttonSmall;
            padding = const EdgeInsets.symmetric(horizontal: 28);
          case SButtonKind.text:
            return Opacity(
              opacity: p ? .6 : 1,
              child: Text(
                label,
                style: SText.textButton.copyWith(color: context.sp.accentText),
              ),
            );
        }
        final box = Container(
          height: height,
          padding: padding,
          alignment: Alignment.center,
          decoration: deco,
          child: Text(label, style: style),
        );
        final sized =
            expand && (kind == SButtonKind.primary || kind == SButtonKind.sheet)
            ? SizedBox(width: double.infinity, child: box)
            : box;
        return Opacity(opacity: enabled ? 1 : .3, child: sized);
      },
    );
  }
}

/// Blue-tinted icon button (38×30), e.g. "add" in an app bar.
class SIconButton extends StatelessWidget {
  const SIconButton({super.key, required this.icon, required this.onTap});
  final SIconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SPressable(
    onTap: onTap,
    builder: (context, p) => Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: p ? context.sp.iconButtonPressed : context.sp.blue100,
        borderRadius: BorderRadius.circular(SRadii.md),
      ),
      child: SIcon(icon, size: 18, color: context.sp.iconBlue),
    ),
  );
}

/// Round knob in a recess (80dp or 28dp), e.g. play button. Pass [icon] (default play).
class SRoundButton extends StatelessWidget {
  const SRoundButton({super.key, this.icon, this.onTap, this.small = false});
  final SIconData? icon;
  final VoidCallback? onTap;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final outer = small ? 28.0 : 80.0;
    final inner = small ? 23.33 : 68.0;
    // si-play is already shifted right for optical centring — do not add padding.
    final iconSize = small ? 10.0 : 28.0;
    return SPressable(
      onTap: onTap,
      builder: (context, p) => Container(
        width: outer,
        height: outer,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: small ? context.sp.page : context.sp.roundWell,
        ),
        alignment: Alignment.center,
        child: Container(
          width: inner,
          height: inner,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: p ? context.sp.knobPressed : context.sp.knob,
            border: Border.all(color: context.sp.borderButton, width: SHair.xs),
            boxShadow: small
                ? context.sp.knobSmallShadow
                : context.sp.knobShadow,
          ),
          alignment: Alignment.center,
          child: SIcon(icon ?? SIcons.play, size: iconSize),
        ),
      ),
    );
  }
}

/// Segmented button bar (60dp). Selected segment = blue gradient block.
class SSegmented extends StatelessWidget {
  const SSegmented({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Container(
    height: 60,
    color: context.sp.card,
    child: Row(
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0)
            Container(
              width: SHair.md,
              height: 12,
              color: context.sp.borderButton,
            ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onChanged(i),
              child: Center(
                child: i == selected
                    ? Container(
                        height: 30,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: context.sp.segmentGradient,
                          border: Border.all(
                            color: context.sp.segmentBorder,
                            width: SHair.md,
                          ),
                          borderRadius: BorderRadius.circular(SRadii.segment),
                        ),
                        child: Text(
                          labels[i],
                          style: SText.buttonSmall.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      )
                    : Text(
                        labels[i],
                        style: SText.buttonSmall.copyWith(
                          color: context.sp.titleOther,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

/// Compact tabs (28.8dp). Selected tab is grey and recessed.
class STabs extends StatelessWidget {
  const STabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
    this.tabWidth = 60,
  });
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  final double tabWidth;

  @override
  Widget build(BuildContext context) => Container(
    height: SDims.tabs,
    decoration: BoxDecoration(
      border: Border.all(color: context.sp.border, width: SHair.xs),
      borderRadius: BorderRadius.circular(SRadii.md),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(SRadii.md - SHair.xs),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < labels.length; i++)
            GestureDetector(
              onTap: () => onChanged(i),
              child: SInsetShadow(
                shadows: i == selected ? context.sp.insetTabShadow : const [],
                child: Container(
                  width: tabWidth,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: i == selected
                        ? context.sp.selectedTab
                        : context.sp.card,
                    border: Border(
                      right: BorderSide(
                        color: i == labels.length - 1
                            ? Colors.transparent
                            : context.sp.divider,
                        width: SHair.sm,
                      ),
                    ),
                  ),
                  child: Text(
                    labels[i],
                    style: SText.tab.copyWith(
                      color: i == selected
                          ? Theme.of(context).colorScheme.onPrimary
                          : context.sp.titleOther,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

// ============================================================================================
// Lists
// ============================================================================================

/// Grouped list: header above the card, description below. Rows are separated by 0.8dp dividers.
class SListGroup extends StatelessWidget {
  const SListGroup({
    super.key,
    this.header,
    required this.children,
    this.description,
    this.lightIcons = false,
  });
  final String? header;
  final List<Widget> children;
  final String? description;

  /// Real-device Settings style: lighter (#CDCDCF) leading icons.
  final bool lightIcons;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) rows.add(const SDivider());
      rows.add(children[i]);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (header != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6),
            child: Text(
              header!,
              style: SText.sectionHeader.copyWith(color: context.sp.subtitle),
            ),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.sp.card,
            border: Border.all(color: context.sp.border, width: SHair.md),
            borderRadius: BorderRadius.circular(SRadii.button),
            boxShadow: context.sp.cardShadow,
          ),
          child: Padding(
            padding: const EdgeInsets.all(SHair.md),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(SRadii.button - SHair.md),
              child: IconTheme(
                data: IconThemeData(
                  color: lightIcons
                      ? context.sp.iconListLight
                      : context.sp.icon,
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: rows),
              ),
            ),
          ),
        ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              description!,
              textAlign: TextAlign.center,
              style: SText.description.copyWith(
                color: context.sp.descriptionText,
              ),
            ),
          ),
      ],
    );
  }
}

/// 60dp list row. [detail] text + chevron when [onTap] is set, or any [trailing] widget (switch, slider…).
/// Pressed = whole row blue (#5985EB) with white text. Disabled = #BABABA.
class SListTile extends StatelessWidget {
  const SListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.detail,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.showChevron,
  });
  final String title;
  final String? subtitle;
  final SIconData? leading;
  final String? detail;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;
  final bool? showChevron;

  @override
  Widget build(BuildContext context) {
    final iconColor = IconTheme.of(context).color ?? context.sp.icon;
    return SPressable(
      onTap: onTap,
      enabled: enabled,
      builder: (context, p) {
        final fg = p
            ? Theme.of(context).colorScheme.onPrimary
            : (enabled ? null : context.sp.disabled);
        final chevron = showChevron ?? (onTap != null && trailing == null);
        return Container(
          constraints: const BoxConstraints(minHeight: SDims.listRow),
          padding: const EdgeInsets.only(left: 18, right: 12),
          decoration: BoxDecoration(
            color: p ? context.sp.rowPressed : context.sp.card,
            border: p
                ? Border.all(color: context.sp.accentBorder, width: SHair.xs)
                : null,
          ),
          child: Row(
            children: [
              if (leading != null) ...[
                SIcon(
                  leading!,
                  size: 20,
                  color: p
                      ? Theme.of(context).colorScheme.onPrimary
                      : (enabled ? iconColor : context.sp.iconDisabled),
                ),
                const SizedBox(width: 18),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: SText.listTitle.copyWith(
                        color: fg ?? context.sp.title,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: SText.listSubtitle.copyWith(
                          color: fg ?? context.sp.subtitle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (detail != null)
                Text(
                  detail!,
                  style: SText.listDetail.copyWith(
                    color: fg ?? context.sp.subtitle,
                  ),
                ),
              if (trailing != null)
                IconTheme.merge(
                  data: IconThemeData(color: fg),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(color: fg),
                    child: trailing!,
                  ),
                ),
              if (chevron)
                SIcon(
                  SIcons.chevronRight,
                  size: 24,
                  color: p
                      ? Theme.of(context).colorScheme.onPrimary
                      : (enabled ? context.sp.chevron : context.sp.disabled),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// List Tile 2: 18dp title + right-aligned 14dp grey detail.
class SListTileSimple extends StatelessWidget {
  const SListTileSimple({super.key, required this.title, this.detail});
  final String title;
  final String? detail;
  @override
  Widget build(BuildContext context) => Container(
    height: SDims.listRow,
    color: context.sp.card,
    padding: const EdgeInsets.only(left: 18.4, right: 11.2),
    child: Row(
      children: [
        Text(
          title,
          style: SText.listTitle.copyWith(
            color: context.sp.title,
            fontSize: 18,
          ),
        ),
        const SizedBox(width: 18.4),
        Expanded(
          child: Text(
            detail ?? '',
            textAlign: TextAlign.right,
            style: SText.body14.copyWith(color: context.sp.subtitleOther),
          ),
        ),
      ],
    ),
  );
}

// ============================================================================================
// Switch / Radio / Slider
// ============================================================================================

/// 52×24 recessed track, white thumb, indicator dot on the free side (blue when on, grey when off).
class SSwitch extends StatefulWidget {
  const SSwitch({super.key, required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  State<SSwitch> createState() => _SSwitchState();
}

class _SSwitchState extends State<SSwitch> {
  double _dragDelta = 0;

  void _finishDrag(DragEndDetails details) {
    if (_dragDelta.abs() < 4) return;
    final next = _dragDelta > 0;
    if (next != widget.value) widget.onChanged?.call(next);
    _dragDelta = 0;
  }

  @override
  Widget build(BuildContext context) {
    final value = widget.value;
    final onChanged = widget.onChanged;
    final r = BorderRadius.circular(SRadii.pill);
    return Semantics(
      toggled: value,
      enabled: onChanged != null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged == null ? null : () => onChanged(!value),
        onHorizontalDragStart: onChanged == null ? null : (_) => _dragDelta = 0,
        onHorizontalDragUpdate: onChanged == null
            ? null
            : (d) => _dragDelta += d.delta.dx,
        onHorizontalDragEnd: onChanged == null ? null : _finishDrag,
        onHorizontalDragCancel: onChanged == null ? null : () => _dragDelta = 0,
        child: Opacity(
          opacity: onChanged == null ? .4 : 1,
          child: SizedBox.fromSize(
            size: SDims.switchSize,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: SInsetShadow(
                    shadows: context.sp.insetSwitchShadow,
                    borderRadius: r,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: context.sp.switchGroove,
                        borderRadius: r,
                        border: Border.all(
                          color: context.sp.border,
                          width: SHair.xs,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: value ? 7.9 : 34.5,
                  top: 7.2,
                  child: Container(
                    width: 9.6,
                    height: 9.6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: value ? null : context.sp.switchDotOff,
                      gradient: value ? context.sp.switchDotGradient : null,
                      border: Border.all(
                        color: value
                            ? context.sp.switchDotBorderOn
                            : context.sp.switchDotBorderOff,
                        width: SHair.xs,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  left: value ? 28 : 0,
                  top: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: context.sp.knob,
                      border: Border.all(
                        color: context.sp.border,
                        width: SHair.xs,
                      ),
                      boxShadow: context.sp.barShadow,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 22dp radio: grey recess with a small raised dot (blue when selected).
class SRadio extends StatelessWidget {
  const SRadio({super.key, required this.selected, this.onTap});
  final bool selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SInsetShadow(
      shadows: context.sp.insetRadioShadow,
      borderRadius: BorderRadius.circular(11),
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.sp.radioWell,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: selected
                ? context.sp.radioOnGradient
                : context.sp.radioOffGradient,
            border: Border.all(
              color: selected ? context.sp.radioBorderOn : context.sp.radioWell,
              width: SHair.xs,
            ),
            boxShadow: context.sp.radioDotShadow,
          ),
        ),
      ),
    ),
  );
}

/// Radio list item (48dp) for list dialogs.
class SRadioTile extends StatelessWidget {
  const SRadioTile({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Container(
      height: SDims.radioItem,
      color: context.sp.card,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: SText.body14.copyWith(color: context.sp.title),
            ),
          ),
          SRadio(selected: selected),
        ],
      ),
    ),
  );
}

/// Slider: 4dp recessed track, blue gradient fill, 20dp white thumb. [value] is 0…1.
class SSlider extends StatelessWidget {
  const SSlider({super.key, required this.value, required this.onChanged});
  final double value;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final w = c.maxWidth;
      void update(Offset local) =>
          onChanged?.call((local.dx / w).clamp(0.0, 1.0));
      final v = value.clamp(0.0, 1.0);
      final trackR = BorderRadius.circular(SRadii.pill);
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (d) => update(d.localPosition),
        onHorizontalDragUpdate: (d) => update(d.localPosition),
        child: SizedBox(
          height: 24,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              SInsetShadow(
                shadows: context.sp.insetTrackShadow,
                borderRadius: trackR,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.sp.sliderGroove,
                    borderRadius: trackR,
                  ),
                ),
              ),
              Container(
                width: math.max(4, w * v),
                height: 4,
                decoration: BoxDecoration(
                  gradient: context.sp.sliderFillGradient,
                  borderRadius: trackR,
                  border: Border.all(
                    color: context.sp.sliderFillBorder,
                    width: .5,
                  ),
                ),
              ),
              Positioned(
                left: (w - 20) * v,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: context.sp.knobTop,
                    border: Border.all(
                      color: context.sp.sliderThumbBorder,
                      width: SHair.xs,
                    ),
                    boxShadow: context.sp.sliderThumbShadow,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Slider with mute / volume icons (gap 22). Put it in an [SListTile.trailing] wrapped in Expanded-like width,
/// or use [SSliderCard] for the stand-alone white card.
class SSliderRow extends StatelessWidget {
  const SSliderRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.leading,
    this.trailing,
    this.gap = 22,
  });
  final double value;
  final ValueChanged<double>? onChanged;
  final SIconData? leading, trailing;
  final double gap;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      SIcon(leading ?? SIcons.mute, color: context.sp.iconMute),
      SizedBox(width: gap),
      Expanded(
        child: SSlider(value: value, onChanged: onChanged),
      ),
      SizedBox(width: gap),
      SIcon(trailing ?? SIcons.volume, color: context.sp.iconMute),
    ],
  );
}

class SSliderCard extends StatelessWidget {
  const SSliderCard({super.key, required this.value, required this.onChanged});
  final double value;
  final ValueChanged<double>? onChanged;
  @override
  Widget build(BuildContext context) => Container(
    height: 60,
    padding: const EdgeInsets.symmetric(horizontal: 18),
    decoration: BoxDecoration(
      color: context.sp.card,
      border: Border.all(color: context.sp.border, width: SHair.md),
      borderRadius: BorderRadius.circular(SRadii.button),
      boxShadow: context.sp.cardSmallShadow,
    ),
    child: SSliderRow(value: value, onChanged: onChanged),
  );
}

// ============================================================================================
// Chip / Toast / Text field
// ============================================================================================

/// 30dp pill chip. [leading] star / [trailing] chevron like the kit's All/Leading/Trailing styles.
class SChip extends StatelessWidget {
  const SChip(
    this.label, {
    super.key,
    this.colors = SChipColors.white,
    this.leading,
    this.trailing = false,
    this.onTap,
  });
  final String label;
  final SChipColors colors;
  final SIconData? leading;
  final bool trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final effectiveColors = context.sp.chipColors(colors);
    return SPressable(
      onTap: onTap ?? () {},
      builder: (context, p) => Container(
        height: SDims.chip,
        constraints: const BoxConstraints(minWidth: 60),
        padding: EdgeInsets.only(
          left: leading != null ? 4 : 16,
          right: trailing ? 0 : 16,
        ),
        decoration: BoxDecoration(
          color: p ? null : effectiveColors.bg,
          gradient: p
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: effectiveColors.pressed,
                )
              : null,
          border: Border.all(
            color: p ? effectiveColors.pressedBorder : effectiveColors.border,
            width: SHair.xs,
          ),
          borderRadius: BorderRadius.circular(SRadii.pill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[
              SIcon(leading!, size: 20, color: effectiveColors.text),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: SText.chip.copyWith(color: effectiveColors.text),
            ),
            if (trailing) ...[
              const SizedBox(width: 4),
              SIcon(SIcons.chevronRight, size: 20, color: effectiveColors.text),
            ],
          ],
        ),
      ),
    );
  }
}

/// Warm yellow toast box. Use [showSToast] to display it.
class SToast extends StatelessWidget {
  const SToast(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      gradient: context.sp.toast,
      border: Border.all(color: context.sp.toastBorder, width: SHair.xs),
      borderRadius: BorderRadius.circular(SRadii.md),
    ),
    child: Text(text, style: SText.toast.copyWith(color: context.sp.toastText)),
  );
}

/// Shows a toast above the bottom navigation for [duration] (fade in/out).
void showSToast(
  BuildContext context,
  String text, {
  Duration duration = const Duration(milliseconds: 1800),
  double bottom = 78,
}) {
  final overlay = Overlay.of(context);
  final themes = InheritedTheme.capture(from: context, to: overlay.context);
  final visible = ValueNotifier<bool>(false);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => Positioned(
      left: 0,
      right: 0,
      bottom: bottom,
      child: IgnorePointer(
        child: ValueListenableBuilder<bool>(
          valueListenable: visible,
          builder: (_, v, child) => AnimatedOpacity(
            opacity: v ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: child,
          ),
          child: themes.wrap(
            Center(
              child: Material(
                type: MaterialType.transparency,
                child: SToast(text),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  overlay.insert(entry);
  WidgetsBinding.instance.addPostFrameCallback((_) => visible.value = true);
  Timer(duration, () {
    visible.value = false;
    Timer(const Duration(milliseconds: 220), () {
      entry.remove();
      visible.dispose();
    });
  });
}

/// Narrow text field (34dp) with the kit's subtle inner shadow.
class STextField extends StatelessWidget {
  const STextField({super.key, this.controller, this.hint, this.onChanged});
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(SRadii.md);
    return SInsetShadow(
      shadows: context.sp.insetFieldShadow,
      borderRadius: r,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: context.sp.card,
          borderRadius: r,
          border: Border.all(color: context.sp.border, width: SHair.md),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: SText.body14.copyWith(color: context.sp.title),
            cursorColor: context.sp.accentBorder,
            decoration: InputDecoration.collapsed(
              hintText: hint,
              hintStyle: SText.body14.copyWith(color: context.sp.placeholder),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================================
// Dialogs & sheets
// ============================================================================================

class SDialogAction<T> {
  const SDialogAction(this.label, {this.value, this.primary = false});
  final String label;
  final T? value;
  final bool primary;
}

/// The dialog card: 368dp, grey header (48dp), white body, 54dp action row (primary on the right).
class SDialog extends StatelessWidget {
  const SDialog({
    super.key,
    this.title,
    required this.body,
    required this.actions,
    this.flushBody = false,
  });
  final String? title;
  final Widget body;
  final List<Widget> actions;
  final bool flushBody;

  @override
  Widget build(BuildContext context) {
    const r = Radius.circular(SRadii.dialog);
    final row = <Widget>[];
    for (var i = 0; i < actions.length; i++) {
      if (i > 0) {
        row.add(
          Container(
            width: 1,
            height: SDims.dialogAction,
            color: context.sp.divider,
          ),
        );
      }
      row.add(Expanded(child: actions[i]));
    }
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        width: SDims.dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              Container(
                height: SDims.dialogHeader,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.sp.containerMisc,
                  borderRadius: const BorderRadius.vertical(top: r),
                  border: Border(
                    bottom: BorderSide(
                      color: context.sp.dialogHeaderBorder,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  title!,
                  style: SText.dialogTitle.copyWith(
                    color: context.sp.titleOther,
                  ),
                ),
              ),
            Container(
              padding: flushBody ? EdgeInsets.zero : const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.sp.card,
                borderRadius: title == null
                    ? const BorderRadius.vertical(top: r)
                    : null,
              ),
              child: DefaultTextStyle(
                style: SText.dialogBody.copyWith(color: context.sp.body),
                child: body,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: r),
                boxShadow: context.sp.dialogActionsShadow,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: r),
                child: Row(children: row),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One button of the dialog action row.
class SDialogButton extends StatelessWidget {
  const SDialogButton(
    this.label, {
    super.key,
    required this.onTap,
    this.primary = false,
  });
  final String label;
  final VoidCallback onTap;
  final bool primary;
  @override
  Widget build(BuildContext context) => SPressable(
    onTap: onTap,
    builder: (context, p) => Container(
      height: SDims.dialogAction,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: p ? context.sp.dialogActionPressed : context.sp.dialogAction,
        border: Border(
          top: BorderSide(
            color: p && primary
                ? context.sp.dialogActionBorderPressed
                : context.sp.dialogActionBorder,
            width: SHair.md,
          ),
        ),
      ),
      child: Text(
        label,
        style: SText.dialogAction.copyWith(
          color: primary ? context.sp.dialogActionText : context.sp.titleOther,
        ),
      ),
    ),
  );
}

/// Shows a Smartisan dialog over the 60% black scrim (do not use a transparent barrier).
/// Returns the tapped action's value.
Future<T?> showSDialog<T>(
  BuildContext context, {
  String? title,
  required Widget body,
  required List<SDialogAction<T>> actions,
  bool barrierDismissible = true,
  bool flushBody = false,
}) {
  final themes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(context, rootNavigator: true).context,
  );
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'dismiss',
    barrierColor: context.sp.scrim,
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: (context, anim, secondary, child) =>
        FadeTransition(opacity: anim, child: child),
    pageBuilder: (ctx, anim, secondary) => themes.wrap(
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SDialog(
            title: title,
            body: body,
            flushBody: flushBody,
            actions: [
              for (final a in actions)
                SDialogButton(
                  a.label,
                  primary: a.primary,
                  onTap: () => Navigator.of(ctx).pop(a.value),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Simple dialog: no header/actions, 12dp grey text, dismissed by tapping the scrim.
Future<void> showSSimpleDialog(BuildContext context, String text) {
  final themes = InheritedTheme.capture(
    from: context,
    to: Navigator.of(context, rootNavigator: true).context,
  );
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'dismiss',
    barrierColor: context.sp.scrim,
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: (context, anim, secondary, child) =>
        FadeTransition(opacity: anim, child: child),
    pageBuilder: (ctx, anim, secondary) => themes.wrap(
      Builder(
        builder: (context) => Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              width: 376,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              decoration: BoxDecoration(
                color: context.sp.card,
                borderRadius: BorderRadius.circular(SRadii.dialog),
              ),
              child: Text(
                text,
                style: SText.simpleDialog.copyWith(
                  color: context.sp.simpleDialogText,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Bottom-sheet / picker header: gradient white, 20dp top corners, centred 14dp title, optional × and ✓.
class SSheetHeader extends StatelessWidget {
  const SSheetHeader({
    super.key,
    required this.title,
    this.onClose,
    this.onConfirm,
  });
  final String title;
  final VoidCallback? onClose, onConfirm;
  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 13),
    decoration: BoxDecoration(
      gradient: context.sp.sheetHeaderGradient,
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(SRadii.sheet),
      ),
      border: Border(
        bottom: BorderSide(color: context.sp.border, width: 1),
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            if (onClose != null)
              SIconButtonPlain(
                icon: SIcons.closeThin,
                size: 20,
                onTap: onClose!,
              ),
            const Spacer(),
            if (onConfirm != null)
              SIconButtonPlain(
                icon: SIcons.confirm,
                size: 20,
                onTap: onConfirm!,
              ),
          ],
        ),
        IgnorePointer(
          child: Text(
            title,
            style: SText.sheetTitle.copyWith(color: context.sp.body),
          ),
        ),
      ],
    ),
  );
}

/// Shows a bottom sheet with a header and white 48dp option buttons on the #EFEFEF body.
Future<T?> showSBottomSheet<T>(
  BuildContext context, {
  required String title,
  required List<SDialogAction<T>> options,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: context.sp.scrim,
    elevation: 0,
    builder: (ctx) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SSheetHeader(title: title, onClose: () => Navigator.of(ctx).pop()),
        Container(
          color: ctx.sp.sheetBody,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 40),
          child: Column(
            children: [
              for (var i = 0; i < options.length; i++) ...[
                if (i > 0) const SizedBox(height: 20),
                SButton(
                  options[i].label,
                  kind: SButtonKind.sheet,
                  onPressed: () => Navigator.of(ctx).pop(options[i].value),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

/// Wheel picker (date/time style): recessed well, highlighted 44dp band, real scrolling wheels.
class SWheelPicker extends StatelessWidget {
  const SWheelPicker({
    super.key,
    required this.columns,
    required this.selected,
    required this.onChanged,
    this.height = 226,
  });
  final List<List<String>> columns;
  final List<int> selected;
  final void Function(int column, int index) onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(SRadii.md);
    return Container(
      height: height,
      decoration: BoxDecoration(gradient: context.sp.pickerBodyGradient),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
      child: SInsetShadow(
        shadows: context.sp.insetWellShadow,
        borderRadius: r,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: context.sp.pickerWellGradient,
            borderRadius: r,
            border: Border.all(color: context.sp.pickerBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.all(1),
            child: ClipRRect(
              borderRadius: r,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: context.sp.pickerBandGradient,
                      border: Border.all(color: context.sp.pickerBandBorder),
                    ),
                  ),
                  Row(
                    children: [
                      for (var c = 0; c < columns.length; c++)
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: c == columns.length - 1
                                      ? Colors.transparent
                                      : context.sp.pickerColumnBorder,
                                ),
                              ),
                            ),
                            child: _Wheel(
                              items: columns[c],
                              selected: selected[c],
                              onChanged: (i) => onChanged(c, i),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Wheel extends StatefulWidget {
  const _Wheel({
    required this.items,
    required this.selected,
    required this.onChanged,
  });
  final List<String> items;
  final int selected;
  final ValueChanged<int> onChanged;
  @override
  State<_Wheel> createState() => _WheelState();
}

class _WheelState extends State<_Wheel> {
  late final FixedExtentScrollController _c = FixedExtentScrollController(
    initialItem: widget.selected,
  );
  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListWheelScrollView.useDelegate(
    controller: _c,
    itemExtent: 38,
    diameterRatio: 2.2,
    physics: const FixedExtentScrollPhysics(),
    onSelectedItemChanged: widget.onChanged,
    childDelegate: ListWheelChildBuilderDelegate(
      childCount: widget.items.length,
      builder: (_, i) => Center(
        child: Text(
          widget.items[i],
          style: SText.picker.copyWith(
            color: i == widget.selected
                ? context.sp.pickerSelected
                : context.sp.pickerUnselected,
          ),
        ),
      ),
    ),
  );
}

// ============================================================================================
// Menu / search / navigation
// ============================================================================================

class SMenuItem {
  const SMenuItem(this.label, {this.icon, this.onTap});
  final String label;
  final SIconData? icon;
  final VoidCallback? onTap;
}

/// Popup menu card (220dp, 42dp items).
class SPopupMenu extends StatelessWidget {
  const SPopupMenu({super.key, required this.items, this.width = 220});
  final List<SMenuItem> items;
  final double width;
  @override
  Widget build(BuildContext context) => Container(
    width: width,
    decoration: BoxDecoration(
      color: context.sp.card,
      border: Border.all(color: context.sp.border, width: SHair.xs),
      borderRadius: BorderRadius.circular(SRadii.md),
      boxShadow: context.sp.cardSmallShadow,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(SRadii.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < items.length; i++)
            SPressable(
              onTap: items[i].onTap ?? () {},
              builder: (context, p) => Container(
                height: 43,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: p ? context.sp.divider : context.sp.card,
                  border: Border(
                    bottom: BorderSide(color: context.sp.divider),
                  ),
                ),
                child: Row(
                  children: [
                    if (items[i].icon != null) ...[
                      SIcon(items[i].icon!),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      items[i].label,
                      style: SText.listTitle.copyWith(
                        color: context.sp.titleOther,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

/// Search bar (48dp) with pill field and a cancel ×.
class SSearchBar extends StatelessWidget {
  const SSearchBar({
    super.key,
    this.controller,
    this.hint = '搜索',
    this.onCancel,
    this.onChanged,
  });
  final TextEditingController? controller;
  final String hint;
  final VoidCallback? onCancel;
  final ValueChanged<String>? onChanged;
  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: context.sp.card,
      boxShadow: context.sp.barShadow,
    ),
    child: Row(
      children: [
        Expanded(
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: context.sp.page,
              border: Border.all(color: context.sp.border, width: SHair.sm),
              borderRadius: BorderRadius.circular(SRadii.pill),
            ),
            child: Row(
              children: [
                SIcon(SIcons.search, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Material(
                    type: MaterialType.transparency,
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      style: SText.body14.copyWith(color: context.sp.title),
                      decoration: InputDecoration.collapsed(
                        hintText: hint,
                        hintStyle: SText.body14.copyWith(
                          color: context.sp.subtitleOther,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (onCancel != null) ...[
          const SizedBox(width: 16),
          SIconButtonPlain(icon: SIcons.close, onTap: onCancel!),
        ],
      ],
    ),
  );
}

class SNavItem {
  const SNavItem(this.label, this.icon);
  final String label;
  final SIconData icon;
}

/// Bottom navigation (54dp). Selected item: 28dp #636363 icon; others 22dp light grey.
class SBottomNav extends StatelessWidget {
  const SBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });
  final List<SNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  @override
  Widget build(BuildContext context) => Container(
    height: SDims.bottomNav,
    color: context.sp.card,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 48),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onTap(i),
            child: SizedBox(
              width: 38,
              height: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 28,
                    child: Center(
                      child: SIcon(
                        items[i].icon,
                        size: i == currentIndex ? 28 : 22,
                        color: i == currentIndex
                            ? context.sp.titleOther
                            : context.sp.iconDisabled,
                      ),
                    ),
                  ),
                  Text(
                    items[i].label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.visible,
                    style: SText.navLabel.copyWith(
                      color: i == currentIndex
                          ? context.sp.titleOther
                          : context.sp.subtitleOther,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

// ============================================================================================
// Multi-colour icons
// ============================================================================================

/// Red circle with white check (24dp) / red circle with white bar (26dp, delete).
class SRedBadge extends StatelessWidget {
  const SRedBadge.check({super.key}) : delete = false;
  const SRedBadge.delete({super.key}) : delete = true;
  final bool delete;
  @override
  Widget build(BuildContext context) {
    final s = delete ? 26.0 : 24.0;
    return Container(
      width: s,
      height: s,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: context.sp.redBadgeGradient,
        border: Border.all(
          color: delete ? context.sp.deleteBorder : context.sp.redStroke,
          width: delete ? .5 : .4,
        ),
      ),
      alignment: Alignment.center,
      child: delete
          ? Container(
              width: 12,
              height: 3,
              color: Theme.of(context).colorScheme.onPrimary,
            )
          : SIcon(
              SIcons.check,
              size: 18,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
    );
  }
}
