// Smartisan OS UI — design tokens for Flutter (no dependencies besides the Flutter SDK).
// Mirrors assets/smartisan.css / assets/tokens.json. Values come from the Figma Community file
// "Smartisan OS UI Kit (Unofficial)" by Paix Chan (CC BY 4.0) and measurements on a real Smartisan R2.
//
// Usage:
//   MaterialApp(theme: smartisanTheme(), ...)
//   Container(color: SColors.page, ...)  /  BoxDecoration(gradient: SGradients.primary, boxShadow: SShadows.button)
//
// Units are logical pixels (dp) — the kit is designed at 432dp wide, which is exactly a Smartisan R2.

import 'package:flutter/material.dart';

/// Colours. Names follow the Figma variables (Grey/*, Blue/*) plus semantic aliases.
class SColors {
  SColors._();

  // Grey/*
  static const white = Color(0xFFFFFFFF);
  static const grey100 = Color(0xFFFAFAFA); // Background/Container/Miscellaneous
  static const grey200 = Color(0xFFF2F2F2); // Divider
  static const grey300 = Color(0xFFEEEEEE); // Border/Button
  static const grey400 = Color(0xFFE2E2E2); // Border/List
  static const grey500 = Color(0xFFBABABA); // Disabled
  static const grey600 = Color(0xFF9D9D9D); // Subtitle/Other
  static const grey700 = Color(0xFF7F7F7F); // Subtitle/List
  static const grey800 = Color(0xFF636363); // Title/Other
  static const grey900 = Color(0xFF333333); // Title/List

  // Blue/*
  static const blue100 = Color(0xFFE7EDFD);
  static const blue300 = Color(0xFF5985EB); // pressed list row
  static const blue400 = Color(0xFF5079D9); // text button
  static const blue500 = Color(0xFF3F68E2); // primary border
  static const blue600 = Color(0xFF2F54D7); // primary pressed border
  static const bluePressed = Color(0xFF4772E6); // Background/Button/Primary/Pressed

  // Semantic
  static const titleList = grey900;
  static const subtitleList = grey700;
  static const titleOther = grey800;
  static const subtitleOther = grey600;
  static const disabled = grey500;
  static const divider = grey200;
  static const borderList = grey400;
  static const borderButton = grey300;
  static const containerMisc = grey100;

  static const page = Color(0xFFF5F5F5); // kit board / page
  static const pageReal = Color(0xFFF0F0F0); // real R2 Settings page (with pinstripes #EEEEEE)
  static const pageStripe = Color(0xFFEEEEEE);
  static const sheetBody = Color(0xFFEFEFEF);
  static const overlay = Color(0x99000000); // rgba(0,0,0,.6) — dialog scrim
  static const appBarBorder = Color(0xFFD8D8D8);
  static const appBarRedBorder = Color(0xFFB7241F);

  static const dialogHeaderBorder = Color(0xFFEDEDED);
  static const dialogAction = Color(0xFFF7F7F7);
  static const dialogActionPressed = Color(0xFFDFDFDF);
  static const dialogActionBorder = Color(0xFFE8E8E8);
  static const dialogActionBorderPressed = Color(0xFFD5D5D5);
  static const dialogActionText = Color(0xFF5E80D0); // Dialog/Action

  static const textBody = Color(0xFF656565);
  static const textDesc = Color(0xFF797979);
  static const textSimpleDialog = Color(0xFF898989);
  static const textTile3 = Color(0xFF787878);
  static const placeholder = Color(0xFFD9D9D9);
  static const outlinedText = Color(0xFF606060);
  static const outlinedBorder = Color(0xFFD3D3D3);
  static const pickerSelected = Color(0xFF55585C);
  static const pickerUnselected = Color(0xFFB3B3B5);

  // Icons (originals use a faint gradient; these are the solid stand-ins)
  static const icon = Color(0xFF929292); // Fill/Icon/Enabled  #8C8C8C→#989898
  static const iconDisabled = Color(0xFFC7C7C7); // Fill/Icon/Disabled #C6C6C6→#C8C8C8
  static const iconListLight = Color(0xFFCDCDCF); // real R2 Settings row icons
  static const iconChevron = Color(0xFFB2B2B2);
  static const iconMore = Color(0xFFBABABA);
  static const iconBlue = Color(0xFF5C89F2);
  static const iconCheckBlue = Color(0xFF6190FF);
  static const iconAdd = Color(0xFFC9CBCF);
  static const iconMute = Color(0xFF808080);

  // Red
  static const redTop = Color(0xFFCD3F3A);
  static const redBottom = Color(0xFFC83530);
  static const redIconTop = Color(0xFFE5645A);
  static const redIconBottom = Color(0xFFE55F55);
  static const redStroke = Color(0xFFDA463E); // Red/Button-Stroke-Enabled

  // Toast
  static const toastText = Color(0xFFAD8A67);
  static const toastBorder = Color(0xFFD2B89C);
}

/// Chip colour sets (bg, border, text, pressed gradient, pressed border).
class SChipColors {
  const SChipColors(this.bg, this.border, this.text, this.pressed, this.pressedBorder);
  final Color bg, border, text, pressedBorder;
  final List<Color> pressed;

  static const white = SChipColors(Color(0xFFFAFAFA), Color(0xFFCECECE), Color(0xFF646464), [Color(0xFFE9E9E9), Color(0xFFECECEC)], Color(0xFFBFBFBF));
  static const yellow = SChipColors(Color(0xFFFFF5D9), Color(0xFFCCB08C), Color(0xFFCD9143), [Color(0xFFF2E9D1), Color(0xFFF2E8C9)], Color(0xFFC5AA87));
  static const blue = SChipColors(Color(0xFFFFFFFF), Color(0xFF93B2F7), Color(0xFF6393FF), [Color(0xFFE6EFFF), Color(0xFFE1ECFF)], Color(0xFF93B2F7));
  static const red = SChipColors(Color(0xFFFFE7E5), Color(0xFFEB7F77), Color(0xFFCC3E39), [Color(0xFFF2DCDA), Color(0xFFF2D8D6)], Color(0xFFF0948D));
  static const grey = SChipColors(Color(0xFFF0F0F0), Color(0xFFDADADA), Color(0xFF646464), [Color(0xFFE9E9E9), Color(0xFFECECEC)], Color(0xFFBFBFBF));
}

/// Gradients (all top → bottom unless noted). The gradients are deliberately subtle.
class SGradients {
  SGradients._();
  static const _v = [Alignment.topCenter, Alignment.bottomCenter];
  static LinearGradient _g(List<Color> c, [List<double>? s]) => LinearGradient(begin: _v[0], end: _v[1], colors: c, stops: s);

  static final primary = _g(const [Color(0xFF5B87EB), Color(0xFF5883EB)]); // Background/Button/Primary/Enabled
  static final primarySmallDisabled = _g(const [Color(0xFF628CEC), Color(0xFF517CE8)]);
  static final white = _g(const [Color(0xFFFFFFFF), Color(0xFFFCFCFC)]); // knobs, thumbs
  static final whitePressed = _g(const [Color(0xFFEBEBEB), Color(0xFFF2F2F2)]);
  static final red = _g(const [SColors.redIconTop, SColors.redIconBottom]); // red check / delete
  static final appBarRed = _g(const [SColors.redTop, SColors.redBottom]);
  static final icon = _g(const [Color(0xFF8C8C8C), Color(0xFF989898)]); // Fill/Icon/Enabled
  static final iconDisabled = _g(const [Color(0xFFC6C6C6), Color(0xFFC8C8C8)]);
  static final segment = _g(const [Color(0xFF4878F0), Color(0xFF6997F4)]);
  static final sheetHeader = _g(const [Color(0xFFFFFFFF), Color(0xFFFAFAFA)]);
  static final toast = _g(const [Color(0xFFFCF6E6), Color(0xFFFCF3DC)]);
  static final sliderFill = _g(const [Color(0xFF668FF7), Color(0xFF7CA3FB)]);
  static final switchDotOn = _g(const [Color(0xFF9CBCFF), Color(0xFF7DA7FF)]);
  static final radioOn = _g(const [Color(0xFF95AFE5), Color(0xFF6889DA)]);
  static final radioOff = _g(const [Color(0xFFFBFBFB), Color(0xFFF1F1F1)]);
  static final pickerBody = _g(const [Color(0xFFEDEDED), Color(0xFFF1F1F1), Color(0xFFEDEDED)], const [0, .14, 1]);
  static final pickerWell = _g(const [Color(0xFFFEFEFE), Color(0xFFFEFEFE), Color(0xFFE2E2E3)], const [0, .405, 1]);
  static final pickerBand = _g(const [Color(0xFFFFFFFF), Color(0xFFF5F5F5), Color(0xFFF8F8F8)], const [0, .535, 1]);
  static final chipPressedWhite = _g(SChipColors.white.pressed);
  static const kitHeader = LinearGradient(colors: [Color(0xFF222325), Color(0xFF3B3C3F), Color(0xFF222325)], stops: [0, .49, 1]);
}

/// Radii.
class SRadii {
  SRadii._();
  static const double segment = 3, small = 4, md = 6, sheetButton = 8, button = 10, dialog = 12, sheet = 20, pill = 100;
}

/// Hairline widths (logical px).
class SHair {
  SHair._();
  static const double xs = 0.4, sm = 0.5, md = 0.8;
}

/// Drop shadows. Inner ("inset") shadows are not supported by BoxShadow — use SInsetShadow
/// (smartisan_widgets.dart) with the S*Inset lists below.
/// Shadows, converted from the kit's CSS values. CSS blur = 2σ while Flutter's BoxShadow uses
/// σ = blurRadius × 0.57735 + 0.5, so every blurRadius here is converted (see [cssBlur]); copying the
/// CSS number straight into BoxShadow makes shadows ~25% heavier.
/// Inner ("inset") shadows are not supported by BoxShadow — wrap with SInsetShadow (smartisan_widgets.dart)
/// and pass the inset* lists below.
class SShadows {
  SShadows._();

  /// Converts a CSS box-shadow blur length to Flutter's BoxShadow.blurRadius.
  static double cssBlur(double css) => css <= 1 ? 0 : (css / 2 - 0.5) / 0.57735;

  /// BoxShadow from CSS-style numbers: SShadows.css(0, 4, 12, Color(0x1A000000)).
  static BoxShadow css(double x, double y, double blur, Color color, [double spread = 0]) =>
      BoxShadow(offset: Offset(x, y), blurRadius: cssBlur(blur), spreadRadius: spread, color: color);

  static const button = [BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 0.866 /* css 2px */)];
  static const card = [BoxShadow(color: Color(0x0A000000), offset: Offset(0, 10), blurRadius: 12.990 /* css 16px */)];
  static const cardSmall = [BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 4.330 /* css 6px */)];
  static const dialogActions = [BoxShadow(color: Color(0x12000000), offset: Offset(0, 4), blurRadius: 0.953 /* css 2.1px */)];
  static const bar = [BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 2.598 /* css 4px */)];
  static const knob = [BoxShadow(color: Color(0x36000000), offset: Offset(0, 5), blurRadius: 13.510 /* css 16.6px */)];
  static const knobSmall = [BoxShadow(color: Color(0x1F000000), offset: Offset(0, 4), blurRadius: 2.598 /* css 4px */)];
  static const thumb = [BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 2.598 /* css 4px */)];
  static const sliderThumb = [BoxShadow(color: Color(0x29000000), offset: Offset(0, 4), blurRadius: 6.062 /* css 8px */)];
  static const radioDot = [BoxShadow(color: Color(0x0F000000), offset: Offset(0, 2), blurRadius: 2.598 /* css 4px */)];

  // inset
  static const insetTrack = [BoxShadow(color: Color(0x0F000000), offset: Offset(0, 4), blurRadius: 2.598 /* css 4px */)];
  static const insetSwitch = [BoxShadow(color: Color(0x1A000000), offset: Offset(0, 4), blurRadius: 9.526 /* css 12px */)];
  static const insetWell = [BoxShadow(color: Color(0x2E000000), offset: Offset(0, 4), blurRadius: 9.526 /* css 12px */)];
  static const insetField = [BoxShadow(color: Color(0x0A000000), offset: Offset(0, 4), blurRadius: 2.598 /* css 4px */)];
  static const insetTab = [BoxShadow(color: Color(0x0F000000), offset: Offset(0, 4), blurRadius: 7.794 /* css 10px */)];
  static const insetSwipe = [BoxShadow(color: Color(0x29000000), blurRadius: 2.598 /* css 4px */)];
  static const insetRadio = [BoxShadow(color: Color(0x14000000), blurRadius: 0.866 /* css 2px */)];
}

/// Layout constants (dp).
class SDims {
  SDims._();
  static const double screen = 432, appBar = 48, listRow = 60, buttonLarge = 60, buttonSheet = 48, buttonSmall = 30;
  static const double dialogWidth = 368, dialogHeader = 48, dialogAction = 54, bottomNav = 54, popupItem = 42;
  static const double chip = 30, radio = 22, radioItem = 48, searchField = 30, tabs = 28.8, picker = 274;
  static const Size switchSize = Size(52, 24);
  static const double pageGutter = 12; // card / large button side margin on a 432dp screen
}

/// Typography. The device uses Smartisan Compact (Latin) + Noto Sans CJK SC; the kit uses Inter.
/// Neither is bundled — add the fonts to pubspec.yaml if you have them, otherwise the fallbacks apply.
class SText {
  SText._();
  static const fallback = ['Smartisan Compact', 'Inter', 'Noto Sans CJK SC', 'Source Han Sans SC', 'Noto Sans SC', 'PingFang SC', 'Microsoft YaHei'];

  static TextStyle _t(double size, FontWeight w, Color c, {double? height, double? spacing}) =>
      TextStyle(fontSize: size, fontWeight: w, color: c, height: height, letterSpacing: spacing, fontFamilyFallback: fallback, leadingDistribution: TextLeadingDistribution.even);

  static final dialogTitle = _t(18, FontWeight.w700, SColors.titleOther);
  static final barTitle = _t(16, FontWeight.w700, SColors.titleOther);
  static final buttonLarge = _t(16, FontWeight.w700, SColors.white, height: 1);
  static final buttonSmall = _t(14, FontWeight.w700, SColors.white, height: 1);
  static final listTitle = _t(16, FontWeight.w400, SColors.titleList); // "List Title"
  static final listSubtitle = _t(12, FontWeight.w400, SColors.subtitleList);
  static final listDetail = _t(16, FontWeight.w400, SColors.subtitleList);
  static final sectionHeader = _t(14, FontWeight.w600, SColors.subtitleList);
  static final description = _t(14, FontWeight.w400, SColors.textDesc, height: 1);
  static final dialogBody = _t(16, FontWeight.w400, SColors.textBody, height: 24 / 16);
  static final dialogAction = _t(14, FontWeight.w700, SColors.titleOther);
  static final sheetTitle = _t(14, FontWeight.w700, SColors.textBody);
  static final body14 = _t(14, FontWeight.w400, SColors.titleList);
  static final searchResult = _t(14, FontWeight.w400, SColors.titleList, height: 24 / 14, spacing: .5);
  static final chip = _t(12, FontWeight.w600, SColors.subtitleList);
  static final tab = _t(12, FontWeight.w700, SColors.titleOther);
  static final textButton = _t(12, FontWeight.w400, SColors.blue400, height: 1);
  static final simpleDialog = _t(12, FontWeight.w400, SColors.textSimpleDialog, height: 28 / 12);
  static final navLabel = _t(8, FontWeight.w400, SColors.subtitleOther);
  static final toast = _t(14, FontWeight.w700, SColors.toastText);
  static final picker = _t(16, FontWeight.w400, SColors.pickerUnselected);
}

/// A ThemeData that turns Material defaults into Smartisan behaviour:
/// grey page, no ripple/splash (Smartisan presses change colour instead), Smartisan text colours.
ThemeData smartisanTheme() {
  final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
  return base.copyWith(
    scaffoldBackgroundColor: SColors.page,
    colorScheme: base.colorScheme.copyWith(
      primary: SColors.blue500,
      onPrimary: SColors.white,
      surface: SColors.white,
      onSurface: SColors.titleList,
      outline: SColors.borderList,
      outlineVariant: SColors.divider,
    ),
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    dividerColor: SColors.divider,
    dividerTheme: const DividerThemeData(color: SColors.divider, thickness: SHair.md, space: SHair.md),
    textTheme: base.textTheme.apply(fontFamilyFallback: SText.fallback, bodyColor: SColors.titleList, displayColor: SColors.titleOther),
    iconTheme: const IconThemeData(color: SColors.icon, size: 24),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: SColors.blue500),
  );
}
