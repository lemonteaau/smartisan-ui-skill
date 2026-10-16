// Turns Material's defaults into Smartisan OS behaviour for the whole app:
// grey page + white hairline cards, centred grey bold bar titles, no ripples
// (presses change colour), low-saturation blue accent, gradient primary
// buttons, recessed slider tracks, 60% black dialog scrim, warm toast colours.
//
// Values come from the Smartisan OS UI Kit tokens (smartisan_theme.dart); the
// dark variant is derived (see smartisan_palette.dart).

import 'smartisan_motion.dart';
import 'smartisan_palette.dart';
import 'smartisan_theme.dart';
import 'smartisan_accent.dart';
import 'smartisan_icons.dart';
import 'smartisan_widgets.dart' show SIcon;

import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart';

abstract final class SmartisanMaterialTheme {
  static ColorScheme _baseScheme(bool isDark) {
    if (isDark) {
      return const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF6A93F0),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFF26355A),
        onPrimaryContainer: Color(0xFFC9D7FA),
        primaryFixed: Color(0xFFDCE5FC),
        primaryFixedDim: Color(0xFFA9C0F5),
        onPrimaryFixed: Color(0xFF0E2257),
        onPrimaryFixedVariant: Color(0xFF2F54D7),
        secondary: Color(0xFF8FA6DA),
        onSecondary: Color(0xFF14213F),
        secondaryContainer: Color(0xFF2A3245),
        onSecondaryContainer: Color(0xFFC8D3EE),
        tertiary: Color(0xFFD2B89C),
        onTertiary: Color(0xFF3B2C1B),
        tertiaryContainer: Color(0xFF3D3326),
        onTertiaryContainer: Color(0xFFF0DFC8),
        error: Color(0xFFE5645A),
        onError: Color(0xFFFFFFFF),
        errorContainer: Color(0xFF4A2522),
        onErrorContainer: Color(0xFFFFDAD6),
        surface: Color(0xFF1E1E1E),
        onSurface: Color(0xFFE2E2E2),
        onSurfaceVariant: Color(0xFFA6A6A6),
        surfaceDim: Color(0xFF141414),
        surfaceBright: Color(0xFF2C2C2C),
        surfaceContainerLowest: Color(0xFF141414),
        surfaceContainerLow: Color(0xFF1A1A1A),
        surfaceContainer: Color(0xFF222222),
        surfaceContainerHigh: Color(0xFF282828),
        surfaceContainerHighest: Color(0xFF303030),
        outline: Color(0xFF7E7E7E),
        outlineVariant: Color(0xFF333333),
        shadow: Color(0xFF000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFFE2E2E2),
        onInverseSurface: Color(0xFF2A2A2A),
        inversePrimary: Color(0xFF3F68E2),
        surfaceTint: Colors.transparent,
      );
    }
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF5B87EB),
      onPrimary: Color(0xFFFFFFFF),
      primaryContainer: Color(0xFFE7EDFD),
      onPrimaryContainer: Color(0xFF2F54D7),
      primaryFixed: Color(0xFFE7EDFD),
      primaryFixedDim: Color(0xFFA9C0F5),
      onPrimaryFixed: Color(0xFF0E2257),
      onPrimaryFixedVariant: Color(0xFF2F54D7),
      secondary: Color(0xFF5E80D0),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFEDF1FB),
      onSecondaryContainer: Color(0xFF3F5FA8),
      tertiary: Color(0xFFAD8A67),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFFCF6E6),
      onTertiaryContainer: Color(0xFF7A5D3F),
      error: Color(0xFFCD3F3A),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFFFE7E5),
      onErrorContainer: Color(0xFFCC3E39),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF333333),
      onSurfaceVariant: Color(0xFF7F7F7F),
      surfaceDim: Color(0xFFEDEDED),
      surfaceBright: Color(0xFFFFFFFF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFFAFAFA),
      surfaceContainer: Color(0xFFF5F5F5),
      surfaceContainerHigh: Color(0xFFF0F0F0),
      surfaceContainerHighest: Color(0xFFEAEAEA),
      outline: Color(0xFF9D9D9D),
      outlineVariant: Color(0xFFE2E2E2),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF333333),
      onInverseSurface: Color(0xFFF2F2F2),
      inversePrimary: Color(0xFFA9C0F5),
      surfaceTint: Colors.transparent,
    );
  }

  /// Colour scheme whose primary / secondary families come from [accent].
  static ColorScheme colorScheme(bool isDark, Color accent) {
    final a = isDark ? accent.shade(0.06) : accent;
    final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    return _baseScheme(isDark).copyWith(
      primary: a,
      onPrimary: Colors.white,
      primaryContainer: a.tintOver(surface, isDark ? 0.28 : 0.12),
      onPrimaryContainer: isDark ? a.shade(0.22) : a.shade(-0.18),
      primaryFixed: a.tintOver(Colors.white, 0.14),
      primaryFixedDim: a.tintOver(Colors.white, 0.45),
      onPrimaryFixed: a.shade(-0.35),
      onPrimaryFixedVariant: a.shade(-0.18),
      secondary: isDark ? a.shade(0.1) : a.shade(-0.05),
      onSecondary: Colors.white,
      secondaryContainer: a.tintOver(surface, isDark ? 0.18 : 0.08),
      onSecondaryContainer: isDark ? a.shade(0.2) : a.shade(-0.2),
      inversePrimary: isDark ? a.shade(-0.15) : a.tintOver(Colors.white, 0.45),
      surfaceTint: Colors.transparent,
    );
  }

  static ThemeData build({
    Color accent = const Color(0xFF5B87EB),
    required bool isDark,
    String? fontFamily,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    final p = (isDark ? SPalette.dark : SPalette.light).withAccent(accent);
    final cs = colorScheme(isDark, accent);
    final fallback = SText.fallback;

    TextStyle t(double size, FontWeight w, Color c, {double? height}) =>
        TextStyle(
          fontSize: size,
          fontWeight: w,
          color: c,
          height: height,
          fontFamily: fontFamily,
          fontFamilyFallback: fallback,
        );

    // Only override weights when the user picked a non-default weight.
    FontWeight w(FontWeight base) =>
        fontWeight == FontWeight.normal ? base : fontWeight;

    final base = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: cs,
      fontFamily: fontFamily,
      fontFamilyFallback: fallback,
    );
    final textTheme = base.textTheme
        .apply(
          bodyColor: p.title,
          displayColor: p.titleOther,
          fontFamily: fontFamily,
          fontFamilyFallback: fallback,
        )
        .copyWith(
          titleLarge: base.textTheme.titleLarge?.copyWith(
            color: p.titleOther,
            fontWeight: w(FontWeight.w700),
          ),
        );
    final TextTheme effectiveText;
    if (fontWeight != FontWeight.normal) {
      final s = TextStyle(fontWeight: fontWeight);
      effectiveText = textTheme.merge(
        TextTheme(
          displayLarge: s,
          displayMedium: s,
          displaySmall: s,
          headlineLarge: s,
          headlineMedium: s,
          headlineSmall: s,
          titleLarge: s,
          titleMedium: s,
          titleSmall: s,
          bodyLarge: s,
          bodyMedium: s,
          bodySmall: s,
          labelLarge: s,
          labelMedium: s,
          labelSmall: s,
        ),
      );
    } else {
      effectiveText = textTheme;
    }

    const hair = BorderSide(width: SHair.md);
    final pressOverlay = isDark
        ? const Color(0x14FFFFFF)
        : const Color(0x0F000000);

    final barTitle = t(17, w(FontWeight.w700), p.titleOther);

    return base.copyWith(
      textTheme: effectiveText,
      primaryTextTheme: base.primaryTextTheme.apply(
        fontFamily: fontFamily,
        fontFamilyFallback: fallback,
      ),
      scaffoldBackgroundColor: p.page,
      canvasColor: p.page,
      cardColor: p.card,
      dividerColor: p.divider,
      disabledColor: p.disabled,
      hintColor: p.subtitleOther,
      // Smartisan presses change colour – never ripple.
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: pressOverlay,
      hoverColor: pressOverlay.withValues(alpha: pressOverlay.a / 2),
      focusColor: Colors.transparent,
      iconTheme: IconThemeData(color: p.icon, size: 24),
      primaryIconTheme: IconThemeData(color: p.icon),
      extensions: [p],
      appBarTheme: AppBarThemeData(
        // R2: 48dp white bar, no hairline, a soft fade below it.
        elevation: 2.5,
        scrolledUnderElevation: 2.5,
        titleSpacing: 0,
        centerTitle: true,
        toolbarHeight: 48,
        backgroundColor: p.appBar,
        foregroundColor: p.titleOther,
        surfaceTintColor: Colors.transparent,
        shadowColor: isDark ? Colors.black : const Color(0x80000000),
        iconTheme: IconThemeData(color: p.icon, size: 24),
        actionsIconTheme: IconThemeData(color: p.icon, size: 22),
        titleTextStyle: barTitle,
      ),
      actionIconTheme: ActionIconThemeData(
        backButtonIconBuilder: (context) =>
            SIcon(SIcons.back, size: 24, color: SPalette.of(context).icon),
        closeButtonIconBuilder: (context) =>
            SIcon(SIcons.close, size: 22, color: SPalette.of(context).icon),
      ),
      cardTheme: CardThemeData(
        color: p.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(SRadii.button)),
          side: hair.copyWith(color: p.border),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: p.rowDivider,
        thickness: SHair.md,
        space: SHair.md,
      ),
      listTileTheme: ListTileThemeData(
        controlAffinity: ListTileControlAffinity.leading,
        // R2 list rows: very pale filled glyphs, #333 regular titles.
        iconColor: p.iconListLight,
        textColor: p.title,
        titleTextStyle: t(16, w(FontWeight.w400), p.title),
        subtitleTextStyle: t(12, w(FontWeight.w400), p.subtitleOther),
        leadingAndTrailingTextStyle: t(14, w(FontWeight.w400), p.subtitleOther),
        selectedColor: p.accent,
        selectedTileColor: cs.primaryContainer,
        minTileHeight: 56,
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: p.icon,
        collapsedIconColor: p.chevron,
        textColor: p.title,
        collapsedTextColor: p.title,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          // R2: a pressed icon button just darkens its glyph, instantly.
          foregroundColor: WidgetStateProperty<Color?>.fromMap({
            WidgetState.disabled: p.iconDisabled,
            WidgetState.pressed: isDark
                ? const Color(0xFFE6E6E6)
                : const Color(0xFF5F5F5F),
            WidgetState.selected: p.accent,
            WidgetState.any: p.icon,
          }),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
          animationDuration: Duration.zero,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          animationDuration: Duration.zero,
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: WidgetStateProperty<Color?>.fromMap({
            WidgetState.disabled: Colors.white.withValues(alpha: 0.6),
            WidgetState.any: Colors.white,
          }),
          textStyle: WidgetStatePropertyAll(
            t(14, w(FontWeight.w700), Colors.white),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(SRadii.md)),
            ),
          ),
          backgroundBuilder: (context, states, child) =>
              _PrimaryButtonSurface(states: states, palette: p, child: child),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          animationDuration: Duration.zero,
          elevation: const WidgetStatePropertyAll(0),
          shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: WidgetStateProperty<Color?>.fromMap({
            WidgetState.disabled: p.disabled,
            WidgetState.any: p.titleOther,
          }),
          textStyle: WidgetStatePropertyAll(
            t(14, w(FontWeight.w700), p.titleOther),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(SRadii.md)),
            ),
          ),
          backgroundBuilder: (context, states, child) =>
              _WhiteButtonSurface(states: states, palette: p, child: child),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          animationDuration: Duration.zero,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: WidgetStateProperty<Color?>.fromMap({
            WidgetState.disabled: p.disabled,
            WidgetState.any: isDark ? p.titleOther : const Color(0xFF606060),
          }),
          backgroundColor: WidgetStateProperty<Color?>.fromMap({
            WidgetState.pressed: p.knobPressedTop,
            WidgetState.any: p.card,
          }),
          side: WidgetStateProperty<BorderSide?>.fromMap({
            WidgetState.pressed: BorderSide(
              color: isDark ? const Color(0xFF555555) : const Color(0xFFBFBFBF),
              width: SHair.md,
            ),
            WidgetState.any: BorderSide(
              color: isDark ? const Color(0xFF444444) : const Color(0xFFD3D3D3),
              width: SHair.md,
            ),
          }),
          textStyle: WidgetStatePropertyAll(
            t(14, w(FontWeight.w700), p.titleOther),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(SRadii.md)),
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          animationDuration: Duration.zero,
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          foregroundColor: WidgetStateProperty<Color?>.fromMap({
            WidgetState.disabled: p.disabled,
            WidgetState.pressed: p.dialogActionText.shade(isDark ? 0.1 : -0.14),
            WidgetState.any: p.dialogActionText,
          }),
          textStyle: WidgetStatePropertyAll(
            t(14, w(FontWeight.w700), p.dialogActionText),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(SRadii.md)),
            ),
          ),
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          backgroundColor: WidgetStateProperty<Color?>.fromMap({
            WidgetState.selected: p.accent,
            WidgetState.any: p.card,
          }),
          foregroundColor: WidgetStateProperty<Color?>.fromMap({
            WidgetState.selected: Colors.white,
            WidgetState.any: p.titleOther,
          }),
          side: WidgetStatePropertyAll(
            BorderSide(color: p.border, width: SHair.md),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(SRadii.segment)),
            ),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        // A raised white knob instead of a coloured Material FAB.
        backgroundColor: p.knobTop,
        foregroundColor: p.titleOther,
        elevation: 3,
        focusElevation: 3,
        hoverElevation: 4,
        highlightElevation: 1,
        splashColor: Colors.transparent,
        shape: CircleBorder(side: hair.copyWith(color: p.border)),
      ),
      switchTheme: SwitchThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
        splashRadius: 0,
        thumbColor: WidgetStateProperty<Color?>.fromMap({
          WidgetState.disabled: p.knobPressedTop,
          WidgetState.any: p.knobTop,
        }),
        trackColor: WidgetStateProperty<Color?>.fromMap({
          WidgetState.selected: p.accent,
          WidgetState.any: p.groove,
        }),
        trackOutlineColor: WidgetStateProperty<Color?>.fromMap({
          WidgetState.selected: p.accentBorder,
          WidgetState.any: p.border,
        }),
        trackOutlineWidth: const WidgetStatePropertyAll(SHair.md),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        splashRadius: 0,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        fillColor: WidgetStateProperty<Color?>.fromMap({
          WidgetState.selected & WidgetState.disabled: p.disabled,
          WidgetState.selected: p.accent,
          WidgetState.any: p.card,
        }),
        checkColor: const WidgetStatePropertyAll(Colors.white),
        side: WidgetStateBorderSide.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? BorderSide(color: p.accentBorder, width: SHair.md)
              : BorderSide(
                  color: isDark
                      ? const Color(0xFF555555)
                      : const Color(0xFFCECECE),
                  width: 1,
                ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SRadii.small)),
        ),
      ),
      radioTheme: RadioThemeData(
        splashRadius: 0,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        fillColor: WidgetStateProperty<Color?>.fromMap({
          WidgetState.selected: isDark
              ? p.accent.shade(0.04)
              : p.accent.shade(-0.04),
          WidgetState.any: isDark
              ? const Color(0xFF555555)
              : const Color(0xFFCCCCCC),
        }),
      ),
      sliderTheme: SliderThemeData(
        // ignore: deprecated_member_use
        year2023: false,
        trackHeight: 4,
        activeTrackColor: p.accent,
        inactiveTrackColor: p.groove,
        secondaryActiveTrackColor: p.accent.withValues(alpha: 0.35),
        thumbColor: p.knobTop,
        overlayColor: Colors.transparent,
        valueIndicatorColor: p.accent,
        trackShape: SmartisanSliderTrackShape(palette: p),
        thumbShape: SmartisanSliderThumbShape(palette: p),
        rangeThumbShape: SmartisanRangeSliderThumbShape(palette: p),
        overlayShape: SliderComponentShape.noOverlay,
        tickMarkShape: SliderTickMarkShape.noTickMark,
        thumbSize: const WidgetStatePropertyAll(Size(20, 20)),
        trackGap: 0,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        // ignore: deprecated_member_use
        year2023: false,
        color: p.accent,
        linearTrackColor: p.groove,
        circularTrackColor: Colors.transparent,
        refreshBackgroundColor: p.card,
      ),
      tabBarTheme: TabBarThemeData(
        // Fallback only — screens should use SmartisanTabBar (segmented).
        labelColor: p.titleOther,
        unselectedLabelColor: p.tabText,
        labelStyle: t(15, w(FontWeight.w700), p.titleOther),
        unselectedLabelStyle: t(15, w(FontWeight.w700), p.tabText),
        indicatorColor: p.brandSelected,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: p.brandSelected, width: 2),
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          insets: const EdgeInsets.symmetric(horizontal: 4),
        ),
        dividerColor: p.divider,
        dividerHeight: 0,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        splashFactory: NoSplash.splashFactory,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 56,
        elevation: 0,
        backgroundColor: p.appBar,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty<IconThemeData?>.fromMap({
          WidgetState.selected: IconThemeData(color: p.brandSelected, size: 26),
          WidgetState.any: IconThemeData(color: p.iconDisabled, size: 26),
        }),
        labelTextStyle: WidgetStateProperty<TextStyle?>.fromMap({
          WidgetState.selected: t(10, w(FontWeight.w700), p.brandSelected),
          WidgetState.any: t(10, w(FontWeight.w400), p.subtitleOther),
        }),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: p.appBar,
        selectedItemColor: p.brandSelected,
        unselectedItemColor: p.iconDisabled,
        selectedLabelStyle: t(10, w(FontWeight.w700), p.brandSelected),
        unselectedLabelStyle: t(10, w(FontWeight.w400), p.subtitleOther),
        type: BottomNavigationBarType.fixed,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: cs.primaryContainer,
        selectedIconTheme: IconThemeData(color: p.accent),
        unselectedIconTheme: IconThemeData(color: p.icon),
        selectedLabelTextStyle: t(12, w(FontWeight.w700), p.accent),
        unselectedLabelTextStyle: t(12, w(FontWeight.w400), p.subtitle),
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SRadii.md)),
        ),
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: p.page,
        surfaceTintColor: Colors.transparent,
        indicatorColor: cs.primaryContainer,
        indicatorShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SRadii.md)),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: p.page,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        barrierColor: const Color(
          0x99000000,
        ), // 60%, measured on the R2 (two dialogs)
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(SRadii.dialog)),
        ),
        alignment: Alignment.center,
        titleTextStyle: t(18, w(FontWeight.w700), p.titleOther),
        contentTextStyle: t(15, w(FontWeight.w400), p.body, height: 1.5),
        actionsPadding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
        constraints: const BoxConstraints(minWidth: 280, maxWidth: 420),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.card,
        modalBackgroundColor: p.card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        modalBarrierColor: const Color(0x73000000),
        dragHandleColor: p.border,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(SRadii.sheet),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: p.card,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shadowColor: const Color(0x40000000),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(SRadii.md)),
          side: hair.copyWith(color: p.border),
        ),
        textStyle: t(15, w(FontWeight.w400), p.title),
        labelTextStyle: WidgetStatePropertyAll(
          t(15, w(FontWeight.w400), p.title),
        ),
        iconColor: p.icon,
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(p.card),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(SRadii.md)),
              side: hair.copyWith(color: p.border),
            ),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: isDark ? p.card : const Color(0xFFFAFAFA),
        selectedColor: cs.primaryContainer,
        disabledColor: p.groove,
        side: BorderSide(
          color: isDark ? const Color(0xFF444444) : const Color(0xFFCECECE),
          width: SHair.md,
        ),
        shape: const StadiumBorder(),
        labelStyle: t(
          12,
          w(FontWeight.w600),
          isDark ? p.titleOther : const Color(0xFF646464),
        ),
        secondaryLabelStyle: t(12, w(FontWeight.w600), p.accent),
        iconTheme: IconThemeData(color: p.icon, size: 16),
        checkmarkColor: p.accent,
        elevation: 0,
        pressElevation: 0,
        surfaceTintColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 6),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        isDense: true,
        hintStyle: t(
          14,
          FontWeight.w400,
          isDark ? p.subtitleOther : const Color(0xFFBABABA),
        ),
        labelStyle: t(14, FontWeight.w400, p.subtitle),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        focusColor: p.accent,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: p.border, width: SHair.md),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: p.border, width: SHair.md),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: p.accent, width: 1.2),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.accent,
        selectionColor: p.accent.withValues(alpha: 0.25),
        selectionHandleColor: p.accent,
      ),
      snackBarTheme: SnackBarThemeData(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.toastTop,
        actionTextColor: p.accentText,
        closeIconColor: p.toastText,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(SRadii.md)),
          side: hair.copyWith(color: p.toastBorder),
        ),
        contentTextStyle: t(14, w(FontWeight.w700), p.toastText),
      ),
      tooltipTheme: TooltipThemeData(
        textStyle: t(13, w(FontWeight.w400), p.toastText),
        decoration: BoxDecoration(
          gradient: p.toast,
          border: Border.all(color: p.toastBorder, width: SHair.md),
          borderRadius: const BorderRadius.all(Radius.circular(SRadii.md)),
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: p.red,
        textColor: Colors.white,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
          (isDark ? Colors.white : Colors.black).withValues(alpha: 0.22),
        ),
        radius: const Radius.circular(4),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: p.accent,
        selectionHandleColor: p.accent,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        // Smartisan pushes pages horizontally on every platform.
        builders: {
          TargetPlatform.android: SPageTransitionsBuilder(),
          TargetPlatform.iOS: SPageTransitionsBuilder(),
          TargetPlatform.macOS: SPageTransitionsBuilder(),
        },
      ),
    );
  }
}

/// Blue primary button body: `#5b87eb → #5883eb`, 0.8dp `#3f68e2` border,
/// short 4dp drop shadow; pressed turns solid `#4772e6`; disabled 30% opacity.
class _PrimaryButtonSurface extends StatelessWidget {
  const _PrimaryButtonSurface({
    required this.states,
    required this.palette,
    this.child,
  });

  final Set<WidgetState> states;
  final SPalette palette;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final pressed = states.contains(WidgetState.pressed);
    final disabled = states.contains(WidgetState.disabled);
    Widget box = DecoratedBox(
      decoration: BoxDecoration(
        color: pressed ? palette.accentPressed : null,
        gradient: pressed ? null : palette.primary,
        borderRadius: const BorderRadius.all(Radius.circular(SRadii.md)),
        border: Border.all(
          color: pressed
              ? palette.accentBorder.shade(-0.04)
              : palette.accentBorder,
          width: SHair.md,
        ),
        boxShadow: pressed || disabled ? null : palette.buttonShadow,
      ),
      child: child,
    );
    if (disabled) {
      box = Opacity(opacity: 0.3, child: box);
    }
    return box;
  }
}

/// White raised button (sheet / secondary): `#fff → #fcfcfc`, hairline border;
/// pressed `#f8f8f8`.
class _WhiteButtonSurface extends StatelessWidget {
  const _WhiteButtonSurface({
    required this.states,
    required this.palette,
    this.child,
  });

  final Set<WidgetState> states;
  final SPalette palette;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final pressed = states.contains(WidgetState.pressed);
    return DecoratedBox(
      decoration: BoxDecoration(
        // R2 "安装" button: pressing inverts the gradient (darker top), so it
        // reads as pushed in.
        gradient: pressed
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [palette.knobPressedTop, palette.knobBottom],
              )
            : palette.knob,
        borderRadius: const BorderRadius.all(Radius.circular(SRadii.md)),
        border: Border.all(color: palette.border, width: SHair.md),
        boxShadow: pressed ? null : palette.barShadow,
      ),
      child: child,
    );
  }
}

/// 4dp recessed groove; the active part is the kit's light-blue gradient fill.
class SmartisanSliderTrackShape extends SliderTrackShape
    with BaseSliderTrackShape {
  const SmartisanSliderTrackShape({required this.palette});

  final SPalette palette;

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
  }) {
    final rect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    final canvas = context.canvas;
    final h = rect.height;
    final r = Radius.circular(h / 2);
    final track = RRect.fromRectAndRadius(rect, r);

    // groove
    canvas.drawRRect(
      track,
      Paint()..color = sliderTheme.inactiveTrackColor ?? palette.groove,
    );
    // inner top shadow (inset)
    canvas.save();
    canvas.clipRRect(track);
    canvas.drawRRect(
      track.shift(const Offset(0, -2)).inflate(2),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..color = Colors.black.withValues(alpha: palette.isDark ? 0.35 : 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5),
    );
    canvas.restore();
    canvas.drawRRect(
      track,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = SHair.xs
        ..color = palette.border,
    );

    // secondary (buffered) part
    if (secondaryOffset != null) {
      final sec = Rect.fromLTRB(
        rect.left,
        rect.top,
        secondaryOffset.dx.clamp(rect.left, rect.right),
        rect.bottom,
      );
      if (sec.width > 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(sec, r),
          Paint()
            ..color =
                sliderTheme.secondaryActiveTrackColor ??
                palette.accent.withValues(alpha: 0.35),
        );
      }
    }

    // active fill
    final isLtr = textDirection == TextDirection.ltr;
    final active = isLtr
        ? Rect.fromLTRB(
            rect.left,
            rect.top,
            thumbCenter.dx.clamp(rect.left, rect.right),
            rect.bottom,
          )
        : Rect.fromLTRB(
            thumbCenter.dx.clamp(rect.left, rect.right),
            rect.top,
            rect.right,
            rect.bottom,
          );
    if (active.width > 0) {
      final activeColor = sliderTheme.activeTrackColor ?? palette.accent;
      final fill = RRect.fromRectAndRadius(active, r);
      final custom = activeColor.toARGB32() != palette.accent.toARGB32();
      canvas.drawRRect(
        fill,
        Paint()
          ..color = isEnabled ? activeColor : palette.disabled
          ..shader = isEnabled && !custom
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    palette.accent.shade(0.03),
                    palette.accent.shade(0.09),
                  ],
                ).createShader(active)
              : null,
      );
      canvas.drawRRect(
        fill,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.5
          ..color = isEnabled
              ? (custom ? activeColor : palette.accent.shade(0.02))
              : palette.disabled,
      );
    }
  }
}

void _paintKnob(Canvas canvas, Offset center, double radius, SPalette p) {
  final rect = Rect.fromCircle(center: center, radius: radius);
  // drop shadow: 0 4px 8px rgba(0,0,0,.16)
  canvas.drawCircle(
    center.translate(0, 3),
    radius,
    Paint()
      ..color = Colors.black.withValues(alpha: p.isDark ? 0.45 : 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
  );
  canvas.drawCircle(
    center,
    radius,
    Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [p.knobTop, p.knobBottom],
      ).createShader(rect),
  );
  canvas.drawCircle(
    center,
    radius,
    Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = SHair.xs
      ..color = p.isDark ? const Color(0xFF555555) : const Color(0xFFE6E6E6),
  );
}

/// 20dp white knob with a soft drop shadow.
class SmartisanSliderThumbShape extends SliderComponentShape {
  const SmartisanSliderThumbShape({required this.palette, this.radius = 10});

  final SPalette palette;
  final double radius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    _paintKnob(context.canvas, center, radius, palette);
  }
}

class SmartisanRangeSliderThumbShape extends RangeSliderThumbShape {
  const SmartisanRangeSliderThumbShape({
    required this.palette,
    this.radius = 10,
  });

  final SPalette palette;
  final double radius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    TextDirection? textDirection,
    required SliderThemeData sliderTheme,
    Thumb? thumb,
    bool? isPressed,
  }) {
    _paintKnob(context.canvas, center, radius, palette);
  }
}
