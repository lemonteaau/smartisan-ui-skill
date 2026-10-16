// Smartisan OS motion, recorded at 60fps on a Smartisan R2:
//
// Page push (≈300ms): the new page slides in from the right with a faint
// shadow on its left edge while the page underneath moves ~⅓ to the left
// (parallax). Flutter's CupertinoPageTransitionsBuilder matches this geometry;
// set it for every platform in ThemeData.pageTransitionsTheme (the theme in
// smartisan_material_theme.dart does).
//
// Overscroll: elastic bounce (no Android glow / stretch).
//
// Dialogs: scale 0.85 → 1 with a fade, ≈250ms.

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';

/// Bouncing (elastic) overscroll everywhere, no glow / stretch indicator.
class SmartisanScrollBehavior extends MaterialScrollBehavior {
  const SmartisanScrollBehavior({this.desktopDrag = false});

  /// Allow mouse / trackpad drag scrolling (desktop builds).
  final bool desktopDrag;

  @override
  Set<PointerDeviceKind> get dragDevices =>
      desktopDrag ? PointerDeviceKind.values.toSet() : super.dragDevices;

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: RangeMaintainingScrollPhysics());

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) => child;
}

/// Wrap dialog content to get the Smartisan "scale up + fade" entrance.
class SmartisanDialogEntrance extends StatelessWidget {
  const SmartisanDialogEntrance({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0, 1),
        child: Transform.scale(scale: 0.85 + 0.15 * t, child: child),
      ),
      child: child,
    );
  }
}
