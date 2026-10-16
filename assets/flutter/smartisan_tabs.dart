// Smartisan segmented tabs (replaces Material's underlined TabBar).
//
// On the device (App Store "周排行 / 总排行 / 游戏榜", Music, Settings) tabs are a
// full-width segmented control: a light white→#f4f4f4 frame with a 0.8dp
// border and hairline separators; the selected segment is *recessed* — a grey
// gradient with an inner top shadow and white bold text.
//
// SmartisanTabBar wraps a Material TabBar so TabController / swiping /
// scrollable behaviour keep working; only the look changes.

import 'smartisan_palette.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';

class SmartisanTabBar extends StatelessWidget implements PreferredSizeWidget {
  const SmartisanTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.isScrollable,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.height = 30,
    this.minSegmentWidth = 72,
    this.dragStartBehavior,
    this.physics,
    this.background,
    this.maxWidth = 560,
  });

  /// `Tab` widgets (their text/icon/child is extracted) or any widgets.
  final List<Widget> tabs;
  final TabController? controller;

  /// Defaults to scrollable when there are more than 5 tabs.
  final bool? isScrollable;
  final ValueChanged<int>? onTap;
  final EdgeInsetsGeometry margin;
  final double height;
  final double minSegmentWidth;
  final DragStartBehavior? dragStartBehavior;
  final ScrollPhysics? physics;

  /// Strip colour behind the control; defaults to the app bar colour.
  final Color? background;

  /// Fixed (non-scrolling) segmented controls stay phone-sized and centred
  /// on wide screens instead of stretching each segment across a tablet.
  final double maxWidth;

  @override
  Size get preferredSize {
    final m = margin.resolve(TextDirection.ltr);
    return Size.fromHeight(height + m.vertical);
  }

  static Widget _label(Widget tab) {
    if (tab is Tab) {
      final Widget? text =
          tab.child ?? (tab.text != null ? Text(tab.text!) : null);
      if (tab.icon != null && text != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconTheme.merge(
              data: const IconThemeData(size: 16),
              child: tab.icon!,
            ),
            const SizedBox(width: 4),
            text,
          ],
        );
      }
      return text ?? tab.icon ?? const SizedBox.shrink();
    }
    return tab;
  }

  @override
  Widget build(BuildContext context) {
    final p = SPalette.of(context);
    final scrollable = isScrollable ?? tabs.length > 5;
    final radius = BorderRadius.circular(6);
    final n = tabs.length;

    final segments = <Widget>[
      for (var i = 0; i < n; i++)
        Container(
          height: height,
          constraints: scrollable
              ? BoxConstraints(minWidth: minSegmentWidth)
              : null,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          decoration: i == n - 1
              ? null
              : BoxDecoration(
                  border: Border(
                    right: BorderSide(color: p.tabFrameBorder, width: 0.8),
                  ),
                ),
          child: DefaultTextStyle.merge(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            child: _label(tabs[i]),
          ),
        ),
    ];

    return Container(
      color: background ?? p.appBar,
      padding: margin,
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: scrollable ? double.infinity : maxWidth,
        ),
        child: _control(p, radius, segments, scrollable),
      ),
    );
  }

  Widget _control(
    SPalette p,
    BorderRadius radius,
    List<Widget> segments,
    bool scrollable,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: p.tabFrame,
        borderRadius: radius,
        border: Border.all(color: p.tabFrameBorder, width: 0.8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.2),
        child: SizedBox(
          height: height,
          child: TabBar(
            controller: controller,
            tabs: segments,
            isScrollable: scrollable,
            tabAlignment: scrollable ? TabAlignment.start : TabAlignment.fill,
            onTap: onTap,
            padding: EdgeInsets.zero,
            labelPadding: EdgeInsets.zero,
            indicatorPadding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: _RecessedSegment(p),
            dividerHeight: 0,
            dividerColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: p.tabText,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
            overlayColor: const WidgetStatePropertyAll(Colors.transparent),
            splashFactory: NoSplash.splashFactory,
            dragStartBehavior: dragStartBehavior ?? DragStartBehavior.start,
            physics: physics,
          ),
        ),
      ),
    );
  }
}

/// Grey recessed fill for the selected segment, with an inner top shadow.
class _RecessedSegment extends Decoration {
  const _RecessedSegment(this.p);

  final SPalette p;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _RecessedPainter(p);
}

class _RecessedPainter extends BoxPainter {
  _RecessedPainter(this.p);

  final SPalette p;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (size == null) return;
    final rect = offset & size;
    canvas.drawRect(rect, Paint()..shader = p.tabSelected.createShader(rect));
    // inner shadow along the top and sides: the segment reads as pressed in.
    final top = Rect.fromLTWH(rect.left, rect.top, rect.width, 6);
    canvas.drawRect(
      top,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: p.isDark ? 0.35 : 0.16),
            Colors.black.withValues(alpha: 0),
          ],
        ).createShader(top),
    );
    for (final side in [
      Rect.fromLTWH(rect.left, rect.top, 3, rect.height),
      Rect.fromLTWH(rect.right - 3, rect.top, 3, rect.height),
    ]) {
      canvas.drawRect(
        side,
        Paint()
          ..shader = LinearGradient(
            begin: side.left == rect.left
                ? Alignment.centerLeft
                : Alignment.centerRight,
            end: side.left == rect.left
                ? Alignment.centerRight
                : Alignment.centerLeft,
            colors: [
              Colors.black.withValues(alpha: p.isDark ? 0.25 : 0.08),
              Colors.black.withValues(alpha: 0),
            ],
          ).createShader(side),
      );
    }
  }
}
