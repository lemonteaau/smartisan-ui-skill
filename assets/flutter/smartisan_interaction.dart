// Smartisan OS framework-level widgets the Figma kit does not draw but the system apps use
// everywhere: swipe-right rows, the A–Z quick bar, empty states, section bars, multi-select check
// circles and round add/remove buttons. Behaviour follows the smartisanos framework and the
// community 1:1 rewrites of Music / Weather / Clock (references/motion.md).

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

import 'smartisan_palette.dart';
import 'smartisan_widgets.dart';

// ============================================================================================
// Swipe-right row
// ============================================================================================

/// Smartisan swipes RIGHT: the row slides right and uncovers [actions] on the left (Music, Clock,
/// Notes). The row follows the finger up to [actionsWidth], then moves at 1/5 speed (Clock); it
/// opens if released past a quarter of the tray, settling in 150–200ms. Only one row is open at a
/// time; tapping the open row or anywhere outside it closes it.
class SSwipeRow extends StatefulWidget {
  const SSwipeRow({
    super.key,
    required this.child,
    required this.actions,
    this.actionsWidth = 72,
    this.onOpenChanged,
    this.enabled = true,
  });

  final Widget child;
  final Widget actions;
  final double actionsWidth;
  final ValueChanged<bool>? onOpenChanged;
  final bool enabled;

  @override
  State<SSwipeRow> createState() => _SSwipeRowState();
}

class _SSwipeRowState extends State<SSwipeRow>
    with SingleTickerProviderStateMixin {
  static _SSwipeRowState? _openRow;
  late final AnimationController _x = AnimationController(
    vsync: this,
    lowerBound: 0,
    upperBound: double.infinity,
  );
  double _raw = 0;
  bool _open = false;

  void _animate(double to, Duration d) =>
      _x.animateTo(to, duration: d, curve: SMotion.smooth);

  void close() {
    _animate(0, SMotion.swipe);
    if (_open) {
      _open = false;
      widget.onOpenChanged?.call(false);
    }
    if (_openRow == this) _openRow = null;
    setState(() {});
  }

  @override
  void dispose() {
    if (_openRow == this) _openRow = null;
    _x.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.actionsWidth;
    return TapRegion(
      onTapOutside: _open ? (_) => close() : null,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        dragStartBehavior: DragStartBehavior.down,
        onHorizontalDragStart: !widget.enabled
            ? null
            : (_) {
                if (_openRow != null && _openRow != this) _openRow!.close();
                _x.stop();
                _raw = _x.value;
              },
        onHorizontalDragUpdate: !widget.enabled
            ? null
            : (d) {
                _raw = math.max(0, _raw + d.delta.dx);
                _x.value = _raw <= w
                    ? _raw
                    : w + math.min(_raw - w, 360 - w) / 5;
              },
        onHorizontalDragEnd: !widget.enabled
            ? null
            : (_) {
                final open = _raw > w / 4;
                if (open) {
                  _animate(w, _raw > w ? SMotion.swipe : SMotion.fast);
                  if (!_open) widget.onOpenChanged?.call(true);
                  _open = true;
                  _openRow = this;
                  setState(() {});
                } else {
                  close();
                }
              },
        child: ClipRect(
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: w,
                child: SInsetShadow(
                  shadows: const [
                    BoxShadow(color: Color(0x29000000), blurRadius: 4),
                  ],
                  child: ColoredBox(
                    color: context.sp.page,
                    child: Center(child: widget.actions),
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _x,
                builder: (context, child) => Transform.translate(
                  offset: Offset(_x.value, 0),
                  child: child,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 4,
                        offset: Offset(-2, 0),
                      ),
                    ],
                    color: context.sp.card,
                  ),
                  child: _open
                      ? GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: close,
                          child: AbsorbPointer(child: widget.child),
                        )
                      : widget.child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================================
// Quick bar (A–Z index)
// ============================================================================================

/// The A–Z# strip on the right edge of a long list. Bare until touched; while the finger is on it a
/// pale backing and shadow appear and the touched letter shows in a bubble. Calls [onLetter] (with
/// a selection haptic) each time the letter under the finger changes. Put it in a Stack over the
/// list, aligned to the right.
class SQuickBar extends StatefulWidget {
  const SQuickBar({super.key, required this.onLetter, this.letters = _az});
  static const _az = [
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', //
    'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '#',
  ];
  final ValueChanged<String> onLetter;
  final List<String> letters;

  @override
  State<SQuickBar> createState() => _SQuickBarState();
}

class _SQuickBarState extends State<SQuickBar> {
  int? _current;
  bool _active = false;
  Timer? _fade;

  @override
  void dispose() {
    _fade?.cancel();
    super.dispose();
  }

  void _at(Offset p, double height) {
    final i = (p.dy / height * widget.letters.length).floor().clamp(
      0,
      widget.letters.length - 1,
    );
    if (i == _current) return;
    setState(() => _current = i);
    HapticFeedback.selectionClick();
    widget.onLetter(widget.letters[i]);
  }

  void _end() {
    _fade?.cancel();
    _fade = Timer(SMotion.swipe, () {
      if (mounted && !_active) setState(() => _current = null);
    });
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final h = c.maxHeight - 12;
      final row = h / widget.letters.length;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragDown: (d) {
          setState(() => _active = true);
          _at(d.localPosition - const Offset(0, 6), h);
        },
        onVerticalDragUpdate: (d) =>
            _at(d.localPosition - const Offset(0, 6), h),
        onVerticalDragEnd: (_) {
          setState(() => _active = false);
          _end();
        },
        onVerticalDragCancel: () {
          setState(() => _active = false);
          _end();
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 34,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: _active || _current != null
                  ? BoxDecoration(
                      color: context.sp.page,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 8,
                          offset: Offset(-3, 0),
                        ),
                      ],
                    )
                  : null,
              child: Column(
                children: [
                  for (var i = 0; i < widget.letters.length; i++)
                    SizedBox(
                      height: row,
                      child: Center(
                        child: Text(
                          widget.letters[i],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 1,
                            color: i == _current
                                ? context.sp.accent
                                : const Color(0xFF9A9A9A),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (_current != null)
              Positioned(
                right: 48,
                top: 6 + row * (_current! + .5) - 30,
                child: IgnorePointer(
                  child: Container(
                    width: 60,
                    height: 60,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x8C000000),
                    ),
                    child: Text(
                      widget.letters[_current!],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

// ============================================================================================
// Section title, empty state
// ============================================================================================

/// 30dp grey strip above a flush list (list_section_title): 12dp grey text, 12dp left padding.
class SSectionTitle extends StatelessWidget {
  const SSectionTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    height: 30,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      color: context.sp.page,
      border: const Border(bottom: BorderSide(color: Color(0x0A000000))),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 12, color: context.sp.subtitleOther),
    ),
  );
}

/// Blank view: a big pale glyph, a bold grey title and a lighter hint, centred with 60dp side
/// margins; optionally an action (e.g. an SButton or SRoundButton) under it.
class SEmptyState extends StatelessWidget {
  const SEmptyState({
    super.key,
    required this.title,
    this.icon,
    this.description,
    this.action,
  });
  final String title;
  final SIconData? icon;
  final String? description;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 120,
          child: Center(
            child: icon != null
                ? SIcon(icon!, size: 96, color: const Color(0xFFD6D6D6))
                : Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD6D6D6),
                        width: 12,
                      ),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: context.sp.disabled,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 5),
          Text(
            description!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFFC8C8C8)),
          ),
        ],
        if (action != null) ...[const SizedBox(height: 24), action!],
      ],
    ),
  );
}

// ============================================================================================
// Check circle, round add / remove
// ============================================================================================

/// Multi-select check circle (check_box_mini): off = thin grey ring, on = accent disc + white ✓.
/// [red] for "select to delete".
class SCheck extends StatelessWidget {
  const SCheck({
    super.key,
    required this.value,
    this.onChanged,
    this.red = false,
  });
  final bool value;
  final ValueChanged<bool>? onChanged;
  final bool red;

  @override
  Widget build(BuildContext context) {
    final on = red
        ? const [Color(0xFFEC6A60), Color(0xFFE5584E)]
        : [
            Color.lerp(context.sp.accent, const Color(0xFFFFFFFF), .08)!,
            context.sp.accent,
          ];
    return Semantics(
      checked: value,
      child: GestureDetector(
        onTap: onChanged == null ? null : () => onChanged!(!value),
        child: Opacity(
          opacity: onChanged == null ? .4 : 1,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? null : context.sp.card,
              gradient: value
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: on,
                    )
                  : null,
              border: Border.all(
                color: value
                    ? Color.lerp(on.last, const Color(0xFF000000), .12)!
                    : const Color(0xFFC9C9C9),
                width: 1.2,
              ),
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: on.last.withValues(alpha: .3),
                        blurRadius: 1.5,
                        offset: const Offset(0, 1),
                      ),
                    ]
                  : null,
            ),
            child: value ? const CustomPaint(painter: _TickPainter()) : null,
          ),
        ),
      ),
    );
  }
}

class _TickPainter extends CustomPainter {
  const _TickPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 22;
    canvas.drawPath(
      Path()
        ..moveTo(6 * s, 11.2 * s)
        ..lineTo(9.4 * s, 14.4 * s)
        ..lineTo(15.8 * s, 7.6 * s),
      Paint()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_TickPainter oldDelegate) => false;
}

/// Round add (green +) / remove (red −) buttons of edit lists, e.g. the world clock editor.
class SRoundEditButton extends StatelessWidget {
  const SRoundEditButton.add({super.key, required this.onTap}) : remove = false;
  const SRoundEditButton.remove({super.key, required this.onTap})
    : remove = true;
  final bool remove;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SPressable(
    onTap: onTap,
    builder: (context, p) {
      final colors = remove
          ? [const Color(0xFFEC6A60), const Color(0xFFE3564C)]
          : [const Color(0xFFA5D65C), const Color(0xFF8FC445)];
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: p ? colors.last : null,
          gradient: p
              ? null
              : LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: colors,
                ),
          border: Border.all(
            color: remove ? const Color(0xFFCF453B) : const Color(0xFF7FB236),
            width: SHair.md,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 1.5,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 11,
                height: 2.4,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              if (!remove)
                Container(
                  width: 2.4,
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

// ============================================================================================
// Part choreography (Clock 7.1.1 tab switch)
// ============================================================================================

/// One moving part of a persistent component. When it is first built it animates in from
/// [fromOffset] / [fromTurns] / [fromScale] (and from transparent) after [delay], over
/// [duration] — e.g. clock hands chasing in from behind (−1/6, −1/4, −1/3 turn over 700 / 900 /
/// 1000ms), alarm "ears" sliding back from a diagonal (700ms), stopwatch keys popping with
/// [Curves.easeOutBack]. Give it a new key to replay. Pair it with [SPartSwitcher].
class SPartEntrance extends StatefulWidget {
  const SPartEntrance({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.delay = Duration.zero,
    this.fromOffset = Offset.zero,
    this.fromTurns = 0,
    this.fromScale = 1,
    this.curve = SMotion.decelerate,
  });

  final Widget child;
  final Duration duration, delay;
  final Offset fromOffset;
  final double fromTurns, fromScale;
  final Curve curve;

  @override
  State<SPartEntrance> createState() => _SPartEntranceState();
}

class _SPartEntranceState extends State<SPartEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  Timer? _start;

  @override
  void initState() {
    super.initState();
    if (widget.delay == Duration.zero) {
      _c.forward();
    } else {
      _start = Timer(widget.delay, () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _start?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _c,
    child: widget.child,
    builder: (context, child) {
      final t = widget.curve.transform(_c.value);
      final u = 1 - t;
      return Opacity(
        opacity: SMotion.decelerate.transform(_c.value.clamp(0, 1)),
        child: Transform.translate(
          offset: widget.fromOffset * u,
          child: Transform.rotate(
            angle: widget.fromTurns * u * 2 * math.pi,
            child: Transform.scale(
              scale: widget.fromScale + (1 - widget.fromScale) * t,
              child: child,
            ),
          ),
        ),
      );
    },
  );
}

/// Swaps the moving layer of a persistent component, the Smartisan way: the old layer leaves in
/// 300ms (accelerating fade, optionally still turning by [exitTurns] so hands "keep going"), then
/// the new [child] is built — its [SPartEntrance]s run on their own clocks. Keep the anchor (the
/// dial, card or gauge body) outside this widget so it never moves. Change [child]'s key to swap.
class SPartSwitcher extends StatefulWidget {
  const SPartSwitcher({super.key, required this.child, this.exitTurns = 0});
  final Widget child;
  final double exitTurns;

  @override
  State<SPartSwitcher> createState() => _SPartSwitcherState();
}

class _SPartSwitcherState extends State<SPartSwitcher>
    with SingleTickerProviderStateMixin {
  late Widget _shown = widget.child;
  late final AnimationController _out = AnimationController(
    vsync: this,
    duration: SMotion.base,
  );

  @override
  void didUpdateWidget(SPartSwitcher old) {
    super.didUpdateWidget(old);
    if (!Widget.canUpdate(old.child, widget.child)) {
      _out.forward(from: 0).whenComplete(() {
        if (!mounted) return;
        setState(() => _shown = widget.child);
        _out.value = 0;
      });
    } else if (!_out.isAnimating) {
      _shown = widget.child;
    }
  }

  @override
  void dispose() {
    _out.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _out,
    child: _shown,
    builder: (context, child) {
      final t = SMotion.accelerate.transform(_out.value);
      return Opacity(
        opacity: 1 - t,
        child: widget.exitTurns == 0
            ? child
            : Transform.rotate(
                angle: widget.exitTurns * t * 2 * math.pi,
                child: child,
              ),
      );
    },
  );
}
