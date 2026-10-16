// Brightness-aware Smartisan colours.
//
// The Figma kit (and the R2 system) only define a light look; the dark values
// below are derived with the same rules: low-contrast vertical gradients,
// hairline borders a step lighter than the surface, grey text hierarchy and a
// single low-saturation blue accent.
//
// Read them with `SPalette.of(context)` inside widgets that must follow the
// app's light / dark mode. `SColors` (smartisan_theme.dart) stays the light,
// kit-exact constant table.

import 'smartisan_accent.dart';
import 'package:flutter/material.dart';

@immutable
class SPalette extends ThemeExtension<SPalette> {
  const SPalette({
    required this.isDark,
    required this.page,
    required this.pageStripe,
    required this.card,
    required this.cardPressed,
    required this.border,
    required this.borderButton,
    required this.divider,
    required this.title,
    required this.titleOther,
    required this.subtitle,
    required this.subtitleOther,
    required this.body,
    required this.disabled,
    required this.icon,
    required this.iconDisabled,
    required this.chevron,
    required this.accent,
    required this.accentPressed,
    required this.accentBorder,
    required this.accentText,
    required this.rowPressed,
    required this.appBar,
    required this.appBarBorder,
    required this.sheetBody,
    required this.groove,
    required this.knobTop,
    required this.knobBottom,
    required this.knobPressedTop,
    required this.knobPressedBottom,
    required this.dialogAction,
    required this.dialogActionPressed,
    required this.dialogActionBorder,
    required this.dialogActionText,
    required this.toastTop,
    required this.toastBottom,
    required this.toastBorder,
    required this.toastText,
    required this.red,
    required this.shadow,
    required this.brandTop,
    required this.brandBottom,
    required this.brandWell,
    required this.brandHighlight,
    required this.brandSelected,
    required this.iconListLight,
    required this.tabFrameTop,
    required this.tabFrameBottom,
    required this.tabFrameBorder,
    required this.tabSelectedTop,
    required this.tabSelectedBottom,
    required this.tabText,
    required this.sectionGap,
    required this.sectionGapLine,
    required this.barShadowTop,
    required this.dialogHeader,
    required this.rowDivider,
  });

  final bool isDark;

  /// Page background (behind cards).
  final Color page;
  final Color pageStripe;

  /// White content blocks: list cards, video cards, dialogs.
  final Color card;
  final Color cardPressed;

  /// Hairline borders (#e2e2e2 / #eeeeee in light).
  final Color border;
  final Color borderButton;
  final Color divider;

  /// Text hierarchy.
  final Color title; // #333 – list titles, body
  final Color titleOther; // #636363 – bar titles, button text
  final Color subtitle; // #7f7f7f
  final Color subtitleOther; // #9d9d9d
  final Color body; // #656565 – dialog body
  final Color disabled; // #bababa

  final Color icon; // #929292
  final Color iconDisabled;
  final Color chevron; // #b2b2b2

  /// Low-saturation blue.
  final Color accent; // #5b87eb
  final Color accentPressed; // #4772e6
  final Color accentBorder; // #3f68e2
  final Color accentText; // #5079d9
  final Color rowPressed; // #5985eb – whole list row turns blue when pressed

  final Color appBar;
  final Color appBarBorder;
  final Color sheetBody; // #efefef – bottom sheet body under white buttons

  /// Inset grooves (switch / slider track / selected tab).
  final Color groove;
  final Color knobTop;
  final Color knobBottom;
  final Color knobPressedTop;
  final Color knobPressedBottom;

  final Color dialogAction;
  final Color dialogActionPressed;
  final Color dialogActionBorder;
  final Color dialogActionText;

  final Color toastTop;
  final Color toastBottom;
  final Color toastBorder;
  final Color toastText;

  final Color red;
  final Color shadow;

  /// Desaturated Bilibili pink brand bar (home), top of the gradient.
  final Color brandTop;

  /// Brand bar gradient bottom.
  final Color brandBottom;

  /// Recessed search well inside the brand bar.
  final Color brandWell;

  /// 1px light line at the top edge of the brand bar.
  final Color brandHighlight;

  /// Selected bottom-nav item / brand-coloured selected states.
  final Color brandSelected;

  /// Very pale filled glyphs in front of list rows (Settings).
  final Color iconListLight;

  /// Segmented tabs frame gradient top.
  final Color tabFrameTop;

  /// Segmented tabs frame gradient bottom.
  final Color tabFrameBottom;

  /// Segmented tabs frame border / separators.
  final Color tabFrameBorder;

  /// Recessed selected segment, top.
  final Color tabSelectedTop;

  /// Recessed selected segment, bottom.
  final Color tabSelectedBottom;

  /// Unselected segment label.
  final Color tabText;

  /// Grey band between full-bleed content sections.
  final Color sectionGap;

  /// Hairlines above/below a section gap.
  final Color sectionGapLine;

  /// Soft shadow under white app bars, darkest row.
  final Color barShadowTop;

  /// Dialog title strip background.
  final Color dialogHeader;

  /// Divider between list rows inside cards.
  final Color rowDivider;

  LinearGradient get knob => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [knobTop, knobBottom],
  );

  LinearGradient get knobPressed => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [knobPressedTop, knobPressedBottom],
  );

  LinearGradient get primary => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [accent, accent.shade(isDark ? -0.04 : -0.01)],
  );

  LinearGradient get brand => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [brandTop, brandBottom],
  );

  LinearGradient get tabFrame => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [tabFrameTop, tabFrameBottom],
  );

  LinearGradient get tabSelected => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [tabSelectedTop, tabSelectedBottom],
  );

  LinearGradient get toast => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [toastTop, toastBottom],
  );

  /// Soft, wide card shadow: `0 10px 16px rgba(0,0,0,.04)` in light.
  List<BoxShadow> get cardShadow => [
    BoxShadow(
      // R2 Settings cards: a soft ~8dp fade below the bottom edge
      color: isDark ? const Color(0x33000000) : const Color(0x12000000),
      offset: const Offset(0, 2),
      blurRadius: 6,
    ),
  ];

  /// Short, crisp button shadow: `0 4px 2px rgba(0,0,0,.1)`.
  List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: isDark ? const Color(0x40000000) : const Color(0x1A000000),
      offset: const Offset(0, 4),
      blurRadius: 0.866,
    ),
  ];

  /// Bar / knob shadow: `0 4px 4px rgba(0,0,0,.08)`.
  List<BoxShadow> get barShadow => [
    BoxShadow(
      color: isDark ? const Color(0x4D000000) : const Color(0x14000000),
      offset: const Offset(0, 4),
      blurRadius: 2.598,
    ),
  ];

  static const light = SPalette(
    isDark: false,
    page: Color(0xFFF5F5F5),
    pageStripe: Color(0xFFF0F0F0),
    card: Color(0xFFFFFFFF),
    cardPressed: Color(0xFFF8F8F8),
    border: Color(0xFFE2E2E2),
    borderButton: Color(0xFFEEEEEE),
    divider: Color(0xFFF2F2F2),
    title: Color(0xFF333333),
    titleOther: Color(0xFF636363),
    subtitle: Color(0xFF7F7F7F),
    subtitleOther: Color(0xFF9D9D9D),
    body: Color(0xFF656565),
    disabled: Color(0xFFBABABA),
    icon: Color(0xFF929292),
    iconDisabled: Color(0xFFC7C7C7),
    chevron: Color(0xFFB2B2B2),
    accent: Color(0xFF5B87EB),
    accentPressed: Color(0xFF4772E6),
    accentBorder: Color(0xFF3F68E2),
    accentText: Color(0xFF5079D9),
    rowPressed: Color(0xFF5985EB),
    appBar: Color(0xFFFFFFFF),
    appBarBorder: Color(0xFFD8D8D8),
    sheetBody: Color(0xFFEFEFEF),
    groove: Color(0xFFF7F7F7),
    knobTop: Color(0xFFFFFFFF),
    knobBottom: Color(0xFFFCFCFC),
    knobPressedTop: Color(0xFFEBEBEB),
    knobPressedBottom: Color(0xFFF2F2F2),
    dialogAction: Color(0xFFF7F7F7),
    dialogActionPressed: Color(0xFFDFDFDF),
    dialogActionBorder: Color(0xFFE8E8E8),
    dialogActionText: Color(0xFF5E80D0),
    toastTop: Color(0xFFFCF6E6),
    toastBottom: Color(0xFFFCF3DC),
    toastBorder: Color(0xFFD2B89C),
    toastText: Color(0xFFAD8A67),
    red: Color(0xFFCD3F3A),
    shadow: Color(0xFF000000),
    brandTop: Color(0xFFE8789A),
    brandBottom: Color(0xFFE06D8F),
    brandWell: Color(0xFFC95A79),
    brandHighlight: Color(0x40FFFFFF),
    brandSelected: Color(0xFFDB5D80),
    iconListLight: Color(0xFFC8C8C8),
    tabFrameTop: Color(0xFFFFFFFF),
    tabFrameBottom: Color(0xFFF4F4F4),
    tabFrameBorder: Color(0xFFD6D6D6),
    tabSelectedTop: Color(0xFFB4B4B4),
    tabSelectedBottom: Color(0xFFA9A9A9),
    tabText: Color(0xFF8A8A8A),
    sectionGap: Color(0xFFF0F0F0),
    sectionGapLine: Color(0xFFE4E4E4),
    barShadowTop: Color(0x1F000000),
    dialogHeader: Color(0xFFF8F8F8),
    rowDivider: Color(0xFFF2F2F2),
  );

  static const dark = SPalette(
    isDark: true,
    page: Color(0xFF161616),
    pageStripe: Color(0xFF191919),
    card: Color(0xFF222222),
    cardPressed: Color(0xFF2A2A2A),
    border: Color(0xFF333333),
    borderButton: Color(0xFF2E2E2E),
    divider: Color(0xFF2C2C2C),
    title: Color(0xFFE2E2E2),
    titleOther: Color(0xFFC4C4C4),
    subtitle: Color(0xFF9A9A9A),
    subtitleOther: Color(0xFF7E7E7E),
    body: Color(0xFFBDBDBD),
    disabled: Color(0xFF5C5C5C),
    icon: Color(0xFF9C9C9C),
    iconDisabled: Color(0xFF555555),
    chevron: Color(0xFF666666),
    accent: Color(0xFF6A93F0),
    accentPressed: Color(0xFF4F78DE),
    accentBorder: Color(0xFF3F68E2),
    accentText: Color(0xFF7FA2F2),
    rowPressed: Color(0xFF4A72D6),
    appBar: Color(0xFF1E1E1E),
    appBarBorder: Color(0xFF2E2E2E),
    sheetBody: Color(0xFF1A1A1A),
    groove: Color(0xFF1A1A1A),
    knobTop: Color(0xFF4A4A4A),
    knobBottom: Color(0xFF3C3C3C),
    knobPressedTop: Color(0xFF353535),
    knobPressedBottom: Color(0xFF3A3A3A),
    dialogAction: Color(0xFF2A2A2A),
    dialogActionPressed: Color(0xFF333333),
    dialogActionBorder: Color(0xFF333333),
    dialogActionText: Color(0xFF7FA2F2),
    toastTop: Color(0xFF3A3326),
    toastBottom: Color(0xFF342D20),
    toastBorder: Color(0xFF5E5040),
    toastText: Color(0xFFE0C7A8),
    red: Color(0xFFE5645A),
    shadow: Color(0xFF000000),
    brandTop: Color(0xFF8E4256),
    brandBottom: Color(0xFF853D50),
    brandWell: Color(0xFF6C3242),
    brandHighlight: Color(0x20FFFFFF),
    brandSelected: Color(0xFFE58AA3),
    iconListLight: Color(0xFF6A6A6A),
    tabFrameTop: Color(0xFF2E2E2E),
    tabFrameBottom: Color(0xFF262626),
    tabFrameBorder: Color(0xFF3C3C3C),
    tabSelectedTop: Color(0xFF4A4A4A),
    tabSelectedBottom: Color(0xFF404040),
    tabText: Color(0xFF9A9A9A),
    sectionGap: Color(0xFF121212),
    sectionGapLine: Color(0xFF2A2A2A),
    barShadowTop: Color(0x66000000),
    dialogHeader: Color(0xFF2A2A2A),
    rowDivider: Color(0xFF2E2E2E),
  );

  /// This palette with every accent-coloured token derived from [accent]
  /// (the user's 强调色). Greys, surfaces and text are unchanged.
  SPalette withAccent(Color accent) {
    final a = isDark ? accent.shade(0.06) : accent;
    return SPalette(
      isDark: isDark,
      page: page,
      pageStripe: pageStripe,
      card: card,
      cardPressed: cardPressed,
      border: border,
      borderButton: borderButton,
      divider: divider,
      title: title,
      titleOther: titleOther,
      subtitle: subtitle,
      subtitleOther: subtitleOther,
      body: body,
      disabled: disabled,
      icon: icon,
      iconDisabled: iconDisabled,
      chevron: chevron,
      accent: a,
      accentPressed: a.shade(isDark ? -0.04 : -0.07),
      accentBorder: a.shade(isDark ? -0.10 : -0.13, saturationDelta: 0.04),
      accentText: a.shade(isDark ? 0.06 : -0.04),
      rowPressed: a,
      appBar: appBar,
      appBarBorder: appBarBorder,
      sheetBody: sheetBody,
      groove: groove,
      knobTop: knobTop,
      knobBottom: knobBottom,
      knobPressedTop: knobPressedTop,
      knobPressedBottom: knobPressedBottom,
      dialogAction: dialogAction,
      dialogActionPressed: dialogActionPressed,
      dialogActionBorder: dialogActionBorder,
      dialogActionText: a.shade(isDark ? 0.06 : -0.05),
      toastTop: toastTop,
      toastBottom: toastBottom,
      toastBorder: toastBorder,
      toastText: toastText,
      red: red,
      shadow: shadow,
      brandTop: isDark ? a.shade(-0.22, saturationDelta: -0.18) : a.shade(0.04),
      brandBottom: isDark ? a.shade(-0.25, saturationDelta: -0.18) : a,
      brandWell: isDark
          ? a.shade(-0.32, saturationDelta: -0.2)
          : a.shade(-0.11),
      brandHighlight: brandHighlight,
      brandSelected: isDark ? a.shade(0.08) : a.shade(-0.03),
      iconListLight: iconListLight,
      tabFrameTop: tabFrameTop,
      tabFrameBottom: tabFrameBottom,
      tabFrameBorder: tabFrameBorder,
      tabSelectedTop: tabSelectedTop,
      tabSelectedBottom: tabSelectedBottom,
      tabText: tabText,
      sectionGap: sectionGap,
      sectionGapLine: sectionGapLine,
      barShadowTop: barShadowTop,
      dialogHeader: dialogHeader,
      rowDivider: rowDivider,
    );
  }

  static SPalette of(BuildContext context) =>
      Theme.of(context).extension<SPalette>() ?? light;

  static SPalette ofTheme(ThemeData theme) =>
      theme.extension<SPalette>() ?? light;

  @override
  SPalette copyWith() => this;

  @override
  SPalette lerp(SPalette? other, double t) {
    if (other == null) return this;
    return t < 0.5 ? this : other;
  }
}

extension SPaletteContext on BuildContext {
  SPalette get sp => SPalette.of(this);
}
