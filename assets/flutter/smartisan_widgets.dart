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

import 'smartisan_icons.dart';
import 'smartisan_theme.dart';

export 'smartisan_icons.dart';
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
        child: CustomPaint(painter: _SIconPainter(icon, color ?? IconTheme.of(context).color ?? SColors.icon)),
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
    canvas.save();
    canvas.translate((size.width - vb.width * s) / 2, (size.height - vb.height * s) / 2);
    canvas.scale(s);
    canvas.translate(-vb.left, -vb.top);
    for (final part in icon.parts) {
      final path = Path.from(part.path)..fillType = part.evenOdd ? PathFillType.evenOdd : PathFillType.nonZero;
      if (part.paint != SIconPaint.stroke) {
        canvas.drawPath(path, Paint()..color = color..isAntiAlias = true);
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
  bool shouldRepaint(_SIconPainter old) => old.icon != icon || old.color != color;
}

/// Inner ("inset") shadow — Flutter's BoxShadow has no inset, the kit relies on it for
/// switch/slider tracks, the picker well, text fields and selected tabs.
class SInsetShadow extends StatelessWidget {
  const SInsetShadow({super.key, required this.shadows, this.borderRadius = BorderRadius.zero, this.child});
  final List<BoxShadow> shadows;
  final BorderRadius borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) => CustomPaint(foregroundPainter: _InsetPainter(shadows, borderRadius), child: child);
}

class _InsetPainter extends CustomPainter {
  _InsetPainter(this.shadows, this.radius);
  final List<BoxShadow> shadows;
  final BorderRadius radius;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = Offset.zero & size;
    final rrect = radius.toRRect(bounds);
    canvas.save();
    canvas.clipRRect(rrect);
    for (final s in shadows) {
      // Fill the shape with the shadow colour, then knock out a blurred copy of the shape that is
      // shifted by the offset — what remains is the inner shadow along the opposite edges.
      canvas.saveLayer(bounds, Paint());
      canvas.drawRect(bounds, Paint()..color = s.color);
      canvas.drawRRect(
        rrect.shift(s.offset).deflate(s.spreadRadius),
        Paint()
          ..blendMode = BlendMode.dstOut
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, s.blurSigma),
      );
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_InsetPainter old) => old.shadows != shadows || old.radius != radius;
}

/// Page background: flat kit grey (#F5F5F5) or the real-device pinstripes (#F0F0F0 / #EEEEEE, 3.6dp).
class SPage extends StatelessWidget {
  const SPage({super.key, required this.child, this.textured = false});
  final Widget child;
  final bool textured;

  @override
  Widget build(BuildContext context) => textured
      ? CustomPaint(painter: _StripePainter(), child: child)
      : ColoredBox(color: SColors.page, child: child);
}

class _StripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = SColors.pageReal);
    final p = Paint()..color = SColors.pageStripe;
    for (double x = 3.6; x < size.width; x += 7.2) {
      canvas.drawRect(Rect.fromLTWH(x, 0, 3.6, size.height), p);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) => false;
}

/// Tracks pointer-down state to render pressed styles (no ripple).
class SPressable extends StatefulWidget {
  const SPressable({super.key, required this.builder, this.onTap, this.enabled = true});
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
      child: MouseRegion(cursor: active ? SystemMouseCursors.click : MouseCursor.defer, child: widget.builder(context, _down)),
    );
  }
}

class SDivider extends StatelessWidget {
  const SDivider({super.key, this.indent = 0});
  final double indent;
  @override
  Widget build(BuildContext context) => Container(height: SHair.md, margin: EdgeInsets.only(left: indent), color: SColors.divider);
}

// ============================================================================================
// App Bar
// ============================================================================================

/// 48dp bar, centred bold title, back on the left, actions (gap 18) on the right.
/// [red] = brand red bar (white title/icons). [shadow] = the 8dp fade measured on a real R2.
class SAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SAppBar({super.key, required this.title, this.onBack, this.actions = const [], this.red = false, this.shadow = false});
  final String title;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final bool red, shadow;

  @override
  Size get preferredSize => Size.fromHeight(SDims.appBar + (shadow ? 8 : 0));

  @override
  Widget build(BuildContext context) {
    final fg = red ? SColors.white : SColors.icon;
    final bar = Container(
      height: SDims.appBar,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: red ? null : SColors.white,
        gradient: red ? SGradients.appBarRed : null,
        border: Border(bottom: BorderSide(color: red ? SColors.appBarRedBorder : SColors.appBarBorder, width: 1)),
      ),
      child: IconTheme(
        data: IconThemeData(color: fg),
        child: Stack(alignment: Alignment.center, children: [
          Row(children: [
            if (onBack != null) SIconButtonPlain(icon: SIcons.back, size: 20, color: fg, onTap: onBack!),
            const Spacer(),
            for (var i = 0; i < actions.length; i++) ...[if (i > 0) const SizedBox(width: 18), actions[i]],
          ]),
          IgnorePointer(child: Text(title, style: SText.barTitle.copyWith(color: red ? SColors.white : SColors.titleOther))),
        ]),
      ),
    );
    if (!shadow) return bar;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      bar,
      Container(
        height: 8,
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x0B000000), Color(0x00000000)])),
      ),
    ]);
  }
}

/// Bare icon button for bars/headers (colour change on press).
class SIconButtonPlain extends StatelessWidget {
  const SIconButtonPlain({super.key, required this.icon, required this.onTap, this.size = 24, this.color});
  final SIconData icon;
  final VoidCallback onTap;
  final double size;
  final Color? color;
  @override
  Widget build(BuildContext context) => SPressable(
        onTap: onTap,
        builder: (context, p) => Opacity(opacity: p ? .5 : 1, child: Padding(padding: const EdgeInsets.all(2), child: SIcon(icon, size: size, color: color))),
      );
}

// ============================================================================================
// Buttons
// ============================================================================================

enum SButtonKind { primary, small, sheet, outline, text }

/// Elevated (primary, 60dp), small elevated (30dp), bottom-sheet white (48dp), outlined (30dp), text.
class SButton extends StatelessWidget {
  const SButton(this.label, {super.key, this.onPressed, this.kind = SButtonKind.primary, this.expand = true});
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
            final disabledGrad = small ? SGradients.primarySmallDisabled : SGradients.primary;
            deco = BoxDecoration(
              color: p ? SColors.bluePressed : null,
              gradient: p ? null : (enabled ? SGradients.primary : disabledGrad),
              border: Border.all(color: p ? SColors.blue600 : (small && !enabled ? const Color(0xFF2C50CF) : SColors.blue500), width: small ? SHair.xs : SHair.md),
              borderRadius: BorderRadius.circular(small ? SRadii.small : SRadii.button),
              boxShadow: small ? null : SShadows.button,
            );
            style = small ? SText.buttonSmall : SText.buttonLarge;
            height = small ? SDims.buttonSmall : SDims.buttonLarge;
            if (small) padding = const EdgeInsets.symmetric(horizontal: 12);
          case SButtonKind.sheet:
            deco = BoxDecoration(
              color: p ? const Color(0xFFF8F8F8) : SColors.white,
              border: Border.all(color: SColors.borderButton, width: SHair.md),
              borderRadius: BorderRadius.circular(SRadii.sheetButton),
            );
            style = SText.buttonLarge.copyWith(color: SColors.titleOther);
            height = SDims.buttonSheet;
          case SButtonKind.outline:
            deco = BoxDecoration(
              color: p ? SColors.grey200 : null,
              border: Border.all(color: SColors.outlinedBorder, width: SHair.sm),
              borderRadius: BorderRadius.circular(SRadii.small),
            );
            style = SText.buttonSmall.copyWith(color: SColors.outlinedText);
            height = SDims.buttonSmall;
            padding = const EdgeInsets.symmetric(horizontal: 28);
          case SButtonKind.text:
            return Opacity(opacity: p ? .6 : 1, child: Text(label, style: SText.textButton));
        }
        final box = Container(
          height: height,
          padding: padding,
          alignment: Alignment.center,
          decoration: deco,
          child: Text(label, style: style),
        );
        final sized = expand && (kind == SButtonKind.primary || kind == SButtonKind.sheet) ? SizedBox(width: double.infinity, child: box) : box;
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
          decoration: BoxDecoration(color: p ? const Color(0xFFDBE3FA) : SColors.blue100, borderRadius: BorderRadius.circular(SRadii.md)),
          child: SIcon(icon, size: 18, color: SColors.iconBlue),
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
        decoration: BoxDecoration(shape: BoxShape.circle, color: small ? const Color(0xFFF5F5F5) : const Color(0xFFEDEDED)),
        alignment: Alignment.center,
        child: Container(
          width: inner,
          height: inner,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: p ? SGradients.whitePressed : SGradients.white,
            border: Border.all(color: SColors.grey300, width: SHair.xs),
            boxShadow: small ? SShadows.knobSmall : SShadows.knob,
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
  const SSegmented({super.key, required this.labels, required this.selected, required this.onChanged});
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Container(
        height: 60,
        color: SColors.white,
        child: Row(children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) Container(width: SHair.md, height: 12, color: SColors.grey300),
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
                            gradient: SGradients.segment,
                            border: Border.all(color: const Color(0xFF3D6FEE), width: SHair.md),
                            borderRadius: BorderRadius.circular(SRadii.segment),
                          ),
                          child: Text(labels[i], style: SText.buttonSmall.copyWith(height: null)),
                        )
                      : Text(labels[i], style: SText.buttonSmall.copyWith(color: SColors.titleOther, height: null)),
                ),
              ),
            ),
          ],
        ]),
      );
}

/// Compact tabs (28.8dp). Selected tab is grey and recessed.
class STabs extends StatelessWidget {
  const STabs({super.key, required this.labels, required this.selected, required this.onChanged, this.tabWidth = 60});
  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;
  final double tabWidth;

  @override
  Widget build(BuildContext context) => Container(
        height: SDims.tabs,
        decoration: BoxDecoration(border: Border.all(color: SColors.borderList, width: SHair.xs), borderRadius: BorderRadius.circular(SRadii.md)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SRadii.md - SHair.xs),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            for (var i = 0; i < labels.length; i++)
              GestureDetector(
                onTap: () => onChanged(i),
                child: SInsetShadow(
                  shadows: i == selected ? SShadows.insetTab : const [],
                  child: Container(
                    width: tabWidth,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: i == selected ? const Color(0xFFB2B2B2) : SColors.white,
                      border: Border(right: BorderSide(color: i == labels.length - 1 ? Colors.transparent : SColors.divider, width: SHair.sm)),
                    ),
                    child: Text(labels[i], style: SText.tab.copyWith(color: i == selected ? SColors.white : SColors.titleOther)),
                  ),
                ),
              ),
          ]),
        ),
      );
}

// ============================================================================================
// Lists
// ============================================================================================

/// Grouped list: header above the card, description below. Rows are separated by 0.8dp dividers.
class SListGroup extends StatelessWidget {
  const SListGroup({super.key, this.header, required this.children, this.description, this.lightIcons = false});
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
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
      if (header != null) Padding(padding: const EdgeInsets.only(left: 16, right: 16, bottom: 6), child: Text(header!, style: SText.sectionHeader)),
      Container(
        decoration: BoxDecoration(
          color: SColors.white,
          border: Border.all(color: SColors.borderList, width: SHair.md),
          borderRadius: BorderRadius.circular(SRadii.button),
          boxShadow: SShadows.card,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SRadii.button - SHair.md),
          child: IconTheme(
            data: IconThemeData(color: lightIcons ? SColors.iconListLight : SColors.icon),
            child: Column(mainAxisSize: MainAxisSize.min, children: rows),
          ),
        ),
      ),
      if (description != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(description!, textAlign: TextAlign.center, style: SText.description)),
    ]);
  }
}

/// 60dp list row. [detail] text + chevron when [onTap] is set, or any [trailing] widget (switch, slider…).
/// Pressed = whole row blue (#5985EB) with white text. Disabled = #BABABA.
class SListTile extends StatelessWidget {
  const SListTile({super.key, required this.title, this.subtitle, this.leading, this.detail, this.trailing, this.onTap, this.enabled = true, this.showChevron});
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
    final iconColor = IconTheme.of(context).color ?? SColors.icon;
    return SPressable(
      onTap: onTap,
      enabled: enabled,
      builder: (context, p) {
        final fg = p ? SColors.white : (enabled ? null : SColors.disabled);
        final chevron = showChevron ?? (onTap != null && trailing == null);
        return Container(
          constraints: const BoxConstraints(minHeight: SDims.listRow),
          padding: const EdgeInsets.only(left: 18, right: 12),
          decoration: BoxDecoration(
            color: p ? SColors.blue300 : SColors.white,
            border: p ? Border.all(color: SColors.blue500, width: SHair.xs) : null,
          ),
          child: Row(children: [
            if (leading != null) ...[SIcon(leading!, size: 20, color: p ? SColors.white : (enabled ? iconColor : SColors.iconDisabled)), const SizedBox(width: 18)],
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(title, style: SText.listTitle.copyWith(color: fg)),
                if (subtitle != null) ...[const SizedBox(height: 4), Text(subtitle!, style: SText.listSubtitle.copyWith(color: fg))],
              ]),
            ),
            if (detail != null) Text(detail!, style: SText.listDetail.copyWith(color: fg)),
            trailing ?? const SizedBox.shrink(),
            if (chevron) SIcon(SIcons.chevronRight, size: 24, color: p ? SColors.white : (enabled ? SColors.iconChevron : SColors.disabled)),
          ]),
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
        color: SColors.white,
        padding: const EdgeInsets.only(left: 18.4, right: 11.2),
        child: Row(children: [
          Text(title, style: SText.listTitle.copyWith(fontSize: 18)),
          const SizedBox(width: 18.4),
          Expanded(child: Text(detail ?? '', textAlign: TextAlign.right, style: SText.body14.copyWith(color: SColors.subtitleOther))),
        ]),
      );
}

// ============================================================================================
// Switch / Radio / Slider
// ============================================================================================

/// 52×24 recessed track, white thumb, indicator dot on the free side (blue when on, grey when off).
class SSwitch extends StatelessWidget {
  const SSwitch({super.key, required this.value, required this.onChanged});
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(SRadii.pill);
    return GestureDetector(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: Opacity(
        opacity: onChanged == null ? .4 : 1,
        child: SizedBox.fromSize(
          size: SDims.switchSize,
          child: Stack(clipBehavior: Clip.none, children: [
            Positioned.fill(
              child: SInsetShadow(
                shadows: SShadows.insetSwitch,
                borderRadius: r,
                child: DecoratedBox(decoration: BoxDecoration(color: SColors.white, borderRadius: r, border: Border.all(color: SColors.borderList, width: SHair.xs))),
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
                  color: value ? null : const Color(0xFFF4F4F4),
                  gradient: value ? SGradients.switchDotOn : null,
                  border: Border.all(color: value ? const Color(0xFF769DFE) : const Color(0xFFE8E8E8), width: SHair.xs),
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
                decoration: BoxDecoration(shape: BoxShape.circle, gradient: SGradients.white, border: Border.all(color: SColors.borderList, width: SHair.xs), boxShadow: SShadows.thumb),
              ),
            ),
          ]),
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
          shadows: SShadows.insetRadio,
          borderRadius: BorderRadius.circular(11),
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFECECEC)),
            alignment: Alignment.center,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: selected ? SGradients.radioOn : SGradients.radioOff,
                border: Border.all(color: selected ? const Color(0xFF5671C9) : const Color(0xFFECECEC), width: SHair.xs),
                boxShadow: SShadows.radioDot,
              ),
            ),
          ),
        ),
      );
}

/// Radio list item (48dp) for list dialogs.
class SRadioTile extends StatelessWidget {
  const SRadioTile({super.key, required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          height: SDims.radioItem,
          color: SColors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(children: [Expanded(child: Text(label, style: SText.body14)), SRadio(selected: selected)]),
        ),
      );
}

/// Slider: 4dp recessed track, blue gradient fill, 20dp white thumb. [value] is 0…1.
class SSlider extends StatelessWidget {
  const SSlider({super.key, required this.value, required this.onChanged});
  final double value;
  final ValueChanged<double>? onChanged;

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, c) {
        final w = c.maxWidth;
        void update(Offset local) => onChanged?.call((local.dx / w).clamp(0.0, 1.0));
        final v = value.clamp(0.0, 1.0);
        final trackR = BorderRadius.circular(SRadii.pill);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (d) => update(d.localPosition),
          onHorizontalDragUpdate: (d) => update(d.localPosition),
          child: SizedBox(
            height: 24,
            child: Stack(clipBehavior: Clip.none, alignment: Alignment.centerLeft, children: [
              SInsetShadow(
                shadows: SShadows.insetTrack,
                borderRadius: trackR,
                child: Container(height: 4, decoration: BoxDecoration(color: const Color(0xFFEFEFEF), borderRadius: trackR)),
              ),
              Container(
                width: math.max(4, w * v),
                height: 4,
                decoration: BoxDecoration(gradient: SGradients.sliderFill, borderRadius: trackR, border: Border.all(color: const Color(0xFF7198FF), width: .5)),
              ),
              Positioned(
                left: (w - 20) * v,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: SColors.white, border: Border.all(color: const Color(0xFFF1F1F1), width: SHair.xs), boxShadow: SShadows.sliderThumb),
                ),
              ),
            ]),
          ),
        );
      });
}

/// Slider with mute / volume icons (gap 22). Put it in an [SListTile.trailing] wrapped in Expanded-like width,
/// or use [SSliderCard] for the stand-alone white card.
class SSliderRow extends StatelessWidget {
  const SSliderRow({super.key, required this.value, required this.onChanged, this.leading, this.trailing, this.gap = 22});
  final double value;
  final ValueChanged<double>? onChanged;
  final SIconData? leading, trailing;
  final double gap;
  @override
  Widget build(BuildContext context) => Row(children: [
        SIcon(leading ?? SIcons.mute, color: SColors.iconMute),
        SizedBox(width: gap),
        Expanded(child: SSlider(value: value, onChanged: onChanged)),
        SizedBox(width: gap),
        SIcon(trailing ?? SIcons.volume, color: SColors.iconMute),
      ]);
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
          color: SColors.white,
          border: Border.all(color: SColors.borderList, width: SHair.md),
          borderRadius: BorderRadius.circular(SRadii.button),
          boxShadow: SShadows.cardSmall,
        ),
        child: SSliderRow(value: value, onChanged: onChanged),
      );
}

// ============================================================================================
// Chip / Toast / Text field
// ============================================================================================

/// 30dp pill chip. [leading] star / [trailing] chevron like the kit's All/Leading/Trailing styles.
class SChip extends StatelessWidget {
  const SChip(this.label, {super.key, this.colors = SChipColors.white, this.leading, this.trailing = false, this.onTap});
  final String label;
  final SChipColors colors;
  final SIconData? leading;
  final bool trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SPressable(
        onTap: onTap ?? () {},
        builder: (context, p) => Container(
          height: SDims.chip,
          constraints: const BoxConstraints(minWidth: 60),
          padding: EdgeInsets.only(left: leading != null ? 4 : 16, right: trailing ? 0 : 16),
          decoration: BoxDecoration(
            color: p ? null : colors.bg,
            gradient: p ? LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: colors.pressed) : null,
            border: Border.all(color: p ? colors.pressedBorder : colors.border, width: SHair.xs),
            borderRadius: BorderRadius.circular(SRadii.pill),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (leading != null) ...[SIcon(leading!, size: 20, color: colors.text), const SizedBox(width: 4)],
            Text(label, style: SText.chip.copyWith(color: colors.text)),
            if (trailing) ...[const SizedBox(width: 4), SIcon(SIcons.chevronRight, size: 20, color: colors.text)],
          ]),
        ),
      );
}

/// Warm yellow toast box. Use [showSToast] to display it.
class SToast extends StatelessWidget {
  const SToast(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(gradient: SGradients.toast, border: Border.all(color: SColors.toastBorder, width: SHair.xs), borderRadius: BorderRadius.circular(SRadii.md)),
        child: Text(text, style: SText.toast),
      );
}

/// Shows a toast above the bottom navigation for [duration] (fade in/out).
void showSToast(BuildContext context, String text, {Duration duration = const Duration(milliseconds: 1800), double bottom = 78}) {
  final overlay = Overlay.of(context);
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
          builder: (_, v, child) => AnimatedOpacity(opacity: v ? 1 : 0, duration: const Duration(milliseconds: 200), child: child),
          child: Center(child: Material(type: MaterialType.transparency, child: SToast(text))),
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
      shadows: SShadows.insetField,
      borderRadius: r,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(color: SColors.white, borderRadius: r, border: Border.all(color: SColors.borderList, width: SHair.md)),
        child: Material(
          type: MaterialType.transparency,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: SText.body14,
            cursorColor: SColors.blue500,
            decoration: InputDecoration.collapsed(hintText: hint, hintStyle: SText.body14.copyWith(color: SColors.placeholder)),
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
  const SDialog({super.key, this.title, required this.body, required this.actions, this.flushBody = false});
  final String? title;
  final Widget body;
  final List<Widget> actions;
  final bool flushBody;

  @override
  Widget build(BuildContext context) {
    const r = Radius.circular(SRadii.dialog);
    final row = <Widget>[];
    for (var i = 0; i < actions.length; i++) {
      if (i > 0) row.add(Container(width: 1, height: SDims.dialogAction, color: SColors.divider));
      row.add(Expanded(child: actions[i]));
    }
    return Material(
      type: MaterialType.transparency,
      child: SizedBox(
        width: SDims.dialogWidth,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (title != null)
            Container(
              height: SDims.dialogHeader,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: SColors.containerMisc,
                borderRadius: BorderRadius.vertical(top: r),
                border: Border(bottom: BorderSide(color: SColors.dialogHeaderBorder, width: 1)),
              ),
              child: Text(title!, style: SText.dialogTitle),
            ),
          Container(
            padding: flushBody ? EdgeInsets.zero : const EdgeInsets.all(20),
            decoration: BoxDecoration(color: SColors.white, borderRadius: title == null ? const BorderRadius.vertical(top: r) : null),
            child: DefaultTextStyle(style: SText.dialogBody, child: body),
          ),
          DecoratedBox(
            decoration: const BoxDecoration(borderRadius: BorderRadius.vertical(bottom: r), boxShadow: SShadows.dialogActions),
            child: ClipRRect(borderRadius: const BorderRadius.vertical(bottom: r), child: Row(children: row)),
          ),
        ]),
      ),
    );
  }
}

/// One button of the dialog action row.
class SDialogButton extends StatelessWidget {
  const SDialogButton(this.label, {super.key, required this.onTap, this.primary = false});
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
            color: p ? SColors.dialogActionPressed : SColors.dialogAction,
            border: Border(top: BorderSide(color: p && primary ? SColors.dialogActionBorderPressed : SColors.dialogActionBorder, width: SHair.md)),
          ),
          child: Text(label, style: SText.dialogAction.copyWith(color: primary ? SColors.dialogActionText : SColors.titleOther)),
        ),
      );
}

/// Shows a Smartisan dialog over the 60% black scrim (do not use a transparent barrier).
/// Returns the tapped action's value.
Future<T?> showSDialog<T>(BuildContext context, {String? title, required Widget body, required List<SDialogAction<T>> actions, bool barrierDismissible = true, bool flushBody = false}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'dismiss',
    barrierColor: SColors.overlay,
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: (context, anim, secondary, child) => FadeTransition(opacity: anim, child: child),
    pageBuilder: (ctx, anim, secondary) => Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SDialog(
          title: title,
          body: body,
          flushBody: flushBody,
          actions: [for (final a in actions) SDialogButton(a.label, primary: a.primary, onTap: () => Navigator.of(ctx).pop(a.value))],
        ),
      ),
    ),
  );
}

/// Simple dialog: no header/actions, 12dp grey text, dismissed by tapping the scrim.
Future<void> showSSimpleDialog(BuildContext context, String text) => showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'dismiss',
      barrierColor: SColors.overlay,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: (context, anim, secondary, child) => FadeTransition(opacity: anim, child: child),
      pageBuilder: (context, anim, secondary) => Center(
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            width: 376,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            decoration: BoxDecoration(color: SColors.white, borderRadius: BorderRadius.circular(SRadii.dialog)),
            child: Text(text, style: SText.simpleDialog),
          ),
        ),
      ),
    );

/// Bottom-sheet / picker header: gradient white, 20dp top corners, centred 14dp title, optional × and ✓.
class SSheetHeader extends StatelessWidget {
  const SSheetHeader({super.key, required this.title, this.onClose, this.onConfirm});
  final String title;
  final VoidCallback? onClose, onConfirm;
  @override
  Widget build(BuildContext context) => Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 13),
        decoration: BoxDecoration(
          gradient: SGradients.sheetHeader,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(SRadii.sheet)),
          border: const Border(bottom: BorderSide(color: SColors.borderList, width: 1)),
        ),
        child: Stack(alignment: Alignment.center, children: [
          Row(children: [
            if (onClose != null) SIconButtonPlain(icon: SIcons.closeThin, size: 20, onTap: onClose!),
            const Spacer(),
            if (onConfirm != null) SIconButtonPlain(icon: SIcons.confirm, size: 20, onTap: onConfirm!),
          ]),
          IgnorePointer(child: Text(title, style: SText.sheetTitle)),
        ]),
      );
}

/// Shows a bottom sheet with a header and white 48dp option buttons on the #EFEFEF body.
Future<T?> showSBottomSheet<T>(BuildContext context, {required String title, required List<SDialogAction<T>> options}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: SColors.overlay,
    elevation: 0,
    builder: (ctx) => Column(mainAxisSize: MainAxisSize.min, children: [
      SSheetHeader(title: title, onClose: () => Navigator.of(ctx).pop()),
      Container(
        color: SColors.sheetBody,
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 40),
        child: Column(children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(height: 20),
            SButton(options[i].label, kind: SButtonKind.sheet, onPressed: () => Navigator.of(ctx).pop(options[i].value)),
          ],
        ]),
      ),
    ]),
  );
}

/// Wheel picker (date/time style): recessed well, highlighted 44dp band, real scrolling wheels.
class SWheelPicker extends StatelessWidget {
  const SWheelPicker({super.key, required this.columns, required this.selected, required this.onChanged, this.height = 226});
  final List<List<String>> columns;
  final List<int> selected;
  final void Function(int column, int index) onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(SRadii.md);
    return Container(
      height: height,
      decoration: BoxDecoration(gradient: SGradients.pickerBody),
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
      child: SInsetShadow(
        shadows: SShadows.insetWell,
        borderRadius: r,
        child: Container(
          decoration: BoxDecoration(gradient: SGradients.pickerWell, borderRadius: r, border: Border.all(color: const Color(0xFFC6C6C8))),
          child: ClipRRect(
            borderRadius: r,
            child: Stack(alignment: Alignment.center, children: [
              Container(height: 44, decoration: BoxDecoration(gradient: SGradients.pickerBand, border: Border.all(color: const Color(0xFFD9D9D9)))),
              Row(children: [
                for (var c = 0; c < columns.length; c++)
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(border: Border(right: BorderSide(color: c == columns.length - 1 ? Colors.transparent : const Color(0x66CECECE)))),
                      child: _Wheel(items: columns[c], selected: selected[c], onChanged: (i) => onChanged(c, i)),
                    ),
                  ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Wheel extends StatefulWidget {
  const _Wheel({required this.items, required this.selected, required this.onChanged});
  final List<String> items;
  final int selected;
  final ValueChanged<int> onChanged;
  @override
  State<_Wheel> createState() => _WheelState();
}

class _WheelState extends State<_Wheel> {
  late final FixedExtentScrollController _c = FixedExtentScrollController(initialItem: widget.selected);
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
          builder: (_, i) => Center(child: Text(widget.items[i], style: SText.picker.copyWith(color: i == widget.selected ? SColors.pickerSelected : SColors.pickerUnselected))),
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
        decoration: BoxDecoration(color: SColors.white, border: Border.all(color: SColors.borderList, width: SHair.xs), borderRadius: BorderRadius.circular(SRadii.md), boxShadow: SShadows.cardSmall),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SRadii.md),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            for (var i = 0; i < items.length; i++)
              SPressable(
                onTap: items[i].onTap ?? () {},
                builder: (context, p) => Container(
                  height: 43,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(color: p ? SColors.grey200 : SColors.white, border: const Border(bottom: BorderSide(color: SColors.divider))),
                  child: Row(children: [
                    if (items[i].icon != null) ...[SIcon(items[i].icon!), const SizedBox(width: 8)],
                    Text(items[i].label, style: SText.listTitle.copyWith(color: SColors.titleOther)),
                  ]),
                ),
              ),
          ]),
        ),
      );
}

/// Search bar (48dp) with pill field and a cancel ×.
class SSearchBar extends StatelessWidget {
  const SSearchBar({super.key, this.controller, this.hint = '搜索', this.onCancel, this.onChanged});
  final TextEditingController? controller;
  final String hint;
  final VoidCallback? onCancel;
  final ValueChanged<String>? onChanged;
  @override
  Widget build(BuildContext context) => Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(color: SColors.white, boxShadow: SShadows.bar),
        child: Row(children: [
          Expanded(
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(color: const Color(0xFFF5F5F5), border: Border.all(color: SColors.borderList, width: SHair.sm), borderRadius: BorderRadius.circular(SRadii.pill)),
              child: Row(children: [
                SIcon(SIcons.search, size: 16),
                const SizedBox(width: 10),
                Expanded(
                  child: Material(
                    type: MaterialType.transparency,
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      style: SText.body14,
                      decoration: InputDecoration.collapsed(hintText: hint, hintStyle: SText.body14.copyWith(color: SColors.subtitleOther)),
                    ),
                  ),
                ),
              ]),
            ),
          ),
          if (onCancel != null) ...[const SizedBox(width: 16), SIconButtonPlain(icon: SIcons.close, onTap: onCancel!)],
        ]),
      );
}

class SNavItem {
  const SNavItem(this.label, this.icon);
  final String label;
  final SIconData icon;
}

/// Bottom navigation (54dp). Selected item: 28dp #636363 icon; others 22dp light grey.
class SBottomNav extends StatelessWidget {
  const SBottomNav({super.key, required this.items, required this.currentIndex, required this.onTap});
  final List<SNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  @override
  Widget build(BuildContext context) => Container(
        height: SDims.bottomNav,
        color: SColors.white,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 48),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(i),
              child: SizedBox(
                width: 38,
                height: 40,
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  SizedBox(
                    height: 28,
                    child: Center(child: SIcon(items[i].icon, size: i == currentIndex ? 28 : 22, color: i == currentIndex ? SColors.titleOther : SColors.iconDisabled)),
                  ),
                  Text(items[i].label, maxLines: 1, softWrap: false, overflow: TextOverflow.visible, style: SText.navLabel.copyWith(color: i == currentIndex ? SColors.titleOther : SColors.subtitleOther)),
                ]),
              ),
            ),
          ],
        ]),
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
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: SGradients.red, border: Border.all(color: delete ? const Color(0xFFE1554D) : SColors.redStroke, width: delete ? .5 : .4)),
      alignment: Alignment.center,
      child: delete
          ? Container(width: 12, height: 3, color: SColors.white)
          : SIcon(SIcons.check, size: 18, color: SColors.white),
    );
  }
}
