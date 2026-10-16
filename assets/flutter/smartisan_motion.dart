// Smartisan OS motion. Numbers come from three places (references/motion.md has the table):
//   • the smartisanos framework resources (anim / interpolator / dimen) of Smartisan OS 8;
//   • the community 1:1 rewrites of Smartisan Music 8.1, Weather 8.1.3 and Clock 7.1.1;
//   • 60fps screen recordings on a Smartisan R2.
//
// Page push (300ms): the new page slides in from the right, arrives blank (page colour + a soft
//   left-edge shadow) and its content fades in over the last 40%; the page underneath drifts ⅓
//   left and dims. Pop mirrors it in ≈270ms with a decelerating curve.        → SPageRoute
// Full-screen pages (settings, editors, "new …"): rise from the bottom in 300ms (decelerate
//   cubic) over a page that does not move; leave downward.                    → SModalPageRoute
// Dialogs (R2 recordings): scrim darkens to 60% over 200ms; the card pops in fast — 0.88 → 1 with a
//   fade in ~120ms; on close the card fades in ~100ms while the scrim clears over 200ms.
//                                                                              → SDialogRoute
// Bottom menus: up 300ms decelerate, down 250ms accelerate (see showSBottomSheet).
// Overscroll: elastic rubber band, no glow / stretch.                         → SmartisanScrollBehavior

import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/material.dart';

import 'smartisan_palette.dart';

/// Durations, curves and constants shared by every Smartisan widget.
abstract final class SMotion {
  /// A quick tap stays visibly pressed at least this long (ViewConfiguration pressed-state duration).
  static const pressedMin = Duration(milliseconds: 64);

  /// List rows press only after this tap timeout, so flinging a list never flashes rows.
  static const tapTimeout = Duration(milliseconds: 100);

  static const fast = Duration(milliseconds: 150);
  static const swipe = Duration(milliseconds: 200);
  static const dialog = Duration(milliseconds: 200);
  static const sheetOut = Duration(milliseconds: 250);
  static const pop = Duration(milliseconds: 270);
  static const base = Duration(milliseconds: 300);

  /// (1 − cos πt) / 2 — the calibrated ViewPropertyAnimator default: push, tabs, edit mode, swipe rows.
  static const Curve smooth = Cubic(0.37, 0, 0.63, 1);

  /// 1 − (1 − t)² — DecelerateInterpolator: back, sheets, dialogs.
  static const Curve decelerate = Curves.easeOutQuad;

  /// 1 − (1 − t)³ — decelerate_cubic: full-screen pages, wheel snap.
  static const Curve decelerateCubic = Curves.easeOutCubic;

  /// t² — AccelerateInterpolator: things leaving.
  static const Curve accelerate = Curves.easeInQuad;

  /// Title-bar icons pop to this scale while held (spring, damping .55 / stiffness 800).
  static const double barIconScale = 1.33;
  static const barIconSpring = Duration(milliseconds: 220);
}

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

/// Wrap dialog content to get the Smartisan "scale up + fade" entrance without [SDialogRoute].
class SmartisanDialogEntrance extends StatelessWidget {
  const SmartisanDialogEntrance({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 120),
      curve: SMotion.decelerate,
      builder: (context, t, child) => Opacity(
        opacity: t.clamp(0, 1),
        child: Transform.scale(scale: 0.88 + 0.12 * t, child: child),
      ),
      child: child,
    );
  }
}

/// The Smartisan horizontal push, usable with any [PageRoute] (see [SPageTransitionsBuilder]).
Widget sPushTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  final inCurve = CurvedAnimation(
    parent: animation,
    curve: SMotion.smooth,
    reverseCurve: SMotion.decelerate.flipped,
  );
  final under = CurvedAnimation(
    parent: secondaryAnimation,
    curve: SMotion.smooth,
    reverseCurve: SMotion.decelerate.flipped,
  );
  final page =
      Theme.of(context).extension<SPalette>()?.page ?? const Color(0xFFF5F5F5);
  return SlideTransition(
    position: Tween(
      begin: Offset.zero,
      end: const Offset(-1 / 3, 0),
    ).animate(under),
    child: FadeTransition(
      opacity: Tween(begin: 1.0, end: 0.4).animate(under),
      child: SlideTransition(
        position: Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(inCurve),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: page,
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 12,
                offset: Offset(-6, 0),
              ),
            ],
          ),
          child: FadeTransition(
            // arrives blank, content fades in over the last 40%; stays visible while popping
            opacity: CurvedAnimation(
              parent: animation,
              curve: const Interval(0.6, 1),
              reverseCurve: const Threshold(0),
            ),
            child: child,
          ),
        ),
      ),
    ),
  );
}

/// Push route with the Smartisan timing (300ms in, 270ms back).
class SPageRoute<T> extends PageRoute<T> {
  SPageRoute({required this.builder, super.settings, super.fullscreenDialog});
  final WidgetBuilder builder;

  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => true;
  @override
  Duration get transitionDuration => SMotion.base;
  @override
  Duration get reverseTransitionDuration => SMotion.pop;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => builder(context);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => sPushTransition(context, animation, secondaryAnimation, child);
}

/// Put this in ThemeData.pageTransitionsTheme so MaterialPageRoute / go_router pages push the
/// Smartisan way (smartisan_material_theme.dart already does).
class SPageTransitionsBuilder extends PageTransitionsBuilder {
  const SPageTransitionsBuilder();

  @override
  Duration get transitionDuration => SMotion.base;

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => sPushTransition(context, animation, secondaryAnimation, child);
}

/// Full-screen page that rises from the bottom (pop_up_in: 300ms decelerate cubic) while the page
/// underneath stays still, and slides back down (slide_down_out). Use it for settings, editors,
/// search and "new …" screens; ordinary drill-down uses [SPageRoute].
class SModalPageRoute<T> extends PageRoute<T> {
  SModalPageRoute({required this.builder, super.settings})
    : super(fullscreenDialog: true);
  final WidgetBuilder builder;

  @override
  Color? get barrierColor => null;
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => true;
  @override
  Duration get transitionDuration => SMotion.base;

  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) => false;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => builder(context);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => SlideTransition(
    position: Tween(begin: const Offset(0, 1), end: Offset.zero).animate(
      CurvedAnimation(
        parent: animation,
        curve: SMotion.decelerateCubic,
        reverseCurve: SMotion.decelerateCubic.flipped,
      ),
    ),
    child: child,
  );
}

/// Popup route for dialogs: the scrim fades over 200ms; the card scales 0.88 → 1 and fades in the
/// first ~120ms, and on close fades out in the first ~100ms. Used by showSDialog / showSSimpleDialog.
class SDialogRoute<T> extends PopupRoute<T> {
  SDialogRoute({
    required this.builder,
    required this.barrierColor,
    this.barrierDismissible = true,
    super.settings,
  });

  final WidgetBuilder builder;

  @override
  final bool barrierDismissible;
  @override
  final Color barrierColor;
  @override
  String? get barrierLabel => 'dismiss';
  @override
  Duration get transitionDuration => SMotion.dialog;
  @override
  Duration get reverseTransitionDuration => SMotion.dialog;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => builder(context);

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final t = CurvedAnimation(
      parent: animation,
      curve: const Interval(0, .6, curve: SMotion.decelerate),
      reverseCurve: const Interval(.5, 1, curve: SMotion.accelerate),
    );
    return FadeTransition(
      opacity: t,
      child: ScaleTransition(
        scale: Tween(begin: 0.88, end: 1.0).animate(t),
        child: child,
      ),
    );
  }
}
