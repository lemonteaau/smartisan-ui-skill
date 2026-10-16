// Smartisan bars and page surfaces measured on a Smartisan R2:
// - SmartisanBrandBar: the brand-coloured top bar of content apps (App Store
//   red, Game Center purple; here a desaturated Bilibili pink) that extends
//   under the status bar and holds a recessed search well.
// - SmartisanBarShadow: the ~14dp soft fade under white app bars.
// - SmartisanPinstripe: the vertical pinstripe page of Settings-like screens.
// - SmartisanSectionGap: the grey band between full-bleed content sections.

import 'smartisan_icons.dart';
import 'smartisan_palette.dart';
import 'smartisan_widgets.dart'
    show SIcon, SInsetShadow;
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter/material.dart';

/// Brand-coloured top bar. Paints behind the status bar and switches the
/// status bar icons to light.
class SmartisanBrandBar extends StatelessWidget {
  const SmartisanBrandBar({
    super.key,
    required this.child,
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.shadow = true,
  });

  /// Bar content (typically a Row with the search well and actions).
  final Widget child;
  final double height;
  final EdgeInsetsGeometry padding;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final p = SPalette.of(context);
    final top = MediaQuery.paddingOf(context).top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: p.brand,
          boxShadow: shadow
              ? [
                  BoxShadow(
                    color: p.barShadowTop.withValues(
                      alpha: p.barShadowTop.a * 1.4,
                    ),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: EdgeInsets.only(top: top),
          child: DecoratedBox(
            // the thin highlight that separates the bar from the status bar
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: p.brandHighlight, width: 0.8),
              ),
            ),
            child: SizedBox(
              height: height,
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// The recessed search field inside [SmartisanBrandBar].
class SmartisanSearchWell extends StatelessWidget {
  const SmartisanSearchWell({
    super.key,
    this.hint,
    this.onTap,
    this.height = 34,
    this.trailing,
  });

  final String? hint;
  final VoidCallback? onTap;
  final double height;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final p = SPalette.of(context);
    final r = BorderRadius.circular(height / 2);
    final fg = Colors.white.withValues(alpha: 0.6);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SInsetShadow(
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: p.isDark ? 0.35 : 0.18),
            offset: const Offset(0, 2),
            blurRadius: 3,
          ),
        ],
        borderRadius: r,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: p.brandWell,
            borderRadius: r,
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.18),
                width: 0.8,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              SIcon(SIcons.search, size: 18, color: fg),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  hint ?? '搜索',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14, color: fg, height: 1.2),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// The soft fade below a white Smartisan app bar (#dfdfdf → transparent).
class SmartisanBarShadow extends StatelessWidget {
  const SmartisanBarShadow({super.key, this.height = 10});

  final double height;

  @override
  Widget build(BuildContext context) {
    final p = SPalette.of(context);
    return IgnorePointer(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [p.barShadowTop, p.barShadowTop.withValues(alpha: 0)],
          ),
        ),
      ),
    );
  }
}

/// Vertical pinstripe background of Settings-like pages (#f4f4f4 / #f2f2f2,
/// period ≈ 3.6dp on the R2).
class SmartisanPinstripe extends StatelessWidget {
  const SmartisanPinstripe({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final p = SPalette.of(context);
    return CustomPaint(
      painter: _StripePainter(p.page, p.pageStripe),
      child: child,
    );
  }
}

class _StripePainter extends CustomPainter {
  _StripePainter(this.base, this.stripe);

  final Color base;
  final Color stripe;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = base);
    final paint = Paint()..color = stripe;
    const period = 3.6;
    for (double x = period / 2; x < size.width; x += period) {
      canvas.drawRect(Rect.fromLTWH(x, 0, period / 2, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_StripePainter old) =>
      old.base != base || old.stripe != stripe;
}

/// The band between full-bleed content sections (App Store): ~6dp, a darker
/// hairline on top and a soft inner fade, a lighter hairline at the bottom.
/// With [label] it becomes the File-manager style caption band (30dp).
class SmartisanSectionGap extends StatelessWidget {
  const SmartisanSectionGap({super.key, this.height = 6, this.label});

  final double height;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final p = SPalette.of(context);
    if (label != null) {
      final line = BorderSide(color: p.sectionGapLine, width: 0.8);
      return Container(
        height: 30,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: p.sectionGap,
          border: Border(top: line, bottom: line),
        ),
        child: Text(
          label!,
          style: TextStyle(fontSize: 12, color: p.subtitleOther),
        ),
      );
    }
    return Container(
      height: height,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: p.sectionGapLine, width: 0.8),
          bottom: BorderSide(
            color: Color.lerp(p.sectionGapLine, p.sectionGap, 0.5)!,
            width: 0.8,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(p.sectionGapLine, p.sectionGap, 0.35)!,
            p.sectionGap,
          ],
        ),
      ),
    );
  }
}
