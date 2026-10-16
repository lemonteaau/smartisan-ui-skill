// Exact light-kit variants absent from the core palette, with semantic dark equivalents.
// Keep these local to S* components so the app-wide palette remains unchanged.
import 'smartisan_accent.dart';
import 'smartisan_palette.dart';
import 'smartisan_theme.dart';
import 'package:flutter/material.dart';

extension SmartisanComponentPalette on SPalette {
  Color get switchGroove => isDark ? groove : card;
  Color get scrim => shadow.withValues(alpha: .6);
  Color get pageReal => isDark ? page : SColors.pageReal;
  Color get containerMisc => isDark ? cardPressed : SColors.containerMisc;
  Color get blue100 => accent.withValues(alpha: isDark ? .16 : .12);
  Color get blue600 => accentBorder;
  Color get appBarRedBorder => isDark ? red : SColors.appBarRedBorder;
  Color get outlinedText => isDark ? titleOther : SColors.outlinedText;
  Color get outlinedBorder => isDark ? border : SColors.outlinedBorder;
  Color get iconBlue => accent;
  Color get iconListLight => isDark ? iconDisabled : SColors.iconListLight;
  Color get iconMute => isDark ? icon : SColors.iconMute;
  Color get placeholder => isDark ? subtitleOther : SColors.placeholder;
  Color get dialogHeaderBorder => isDark ? border : SColors.dialogHeaderBorder;
  Color get dialogActionBorderPressed =>
      isDark ? border : SColors.dialogActionBorderPressed;
  Color get pickerSelected => isDark ? title : SColors.pickerSelected;
  Color get pickerUnselected =>
      isDark ? subtitleOther : SColors.pickerUnselected;
  Color get redStroke => isDark ? red : SColors.redStroke;
  Color get smallDisabledBorder => accentBorder;
  Color get iconButtonPressed => accent.withValues(alpha: isDark ? .24 : .18);
  Color get roundWell => isDark ? groove : const Color(0xFFEDEDED);
  Color get segmentBorder => accentBorder;
  Color get selectedTab => isDark ? groove : const Color(0xFFB2B2B2);
  Color get switchDotOff => isDark ? cardPressed : const Color(0xFFF4F4F4);
  Color get switchDotBorderOn => accent.shade(0.03);
  Color get switchDotBorderOff => isDark ? border : const Color(0xFFE8E8E8);
  Color get radioWell => isDark ? groove : const Color(0xFFECECEC);
  Color get radioBorderOn => accentBorder;
  Color get sliderGroove => isDark ? groove : const Color(0xFFEFEFEF);
  Color get sliderFillBorder => accent.shade(0.04);
  Color get sliderThumbBorder => isDark ? border : const Color(0xFFF1F1F1);
  Color get pickerBorder => isDark ? border : const Color(0xFFC6C6C8);
  Color get pickerBandBorder => isDark ? border : const Color(0xFFD9D9D9);
  Color get pickerColumnBorder =>
      isDark ? border.withValues(alpha: .4) : const Color(0x66CECECE);
  Color get deleteBorder => isDark ? red : const Color(0xFFE1554D);
  Color get descriptionText => isDark ? subtitle : SColors.textDesc;
  Color get simpleDialogText => isDark ? subtitle : SColors.textSimpleDialog;
  LinearGradient get smallDisabledGradient => primary;
  LinearGradient get redBarGradient => isDark
      ? _vertical([red, Color.lerp(red, shadow, .03)!])
      : SGradients.appBarRed;
  LinearGradient get segmentGradient => primary;
  LinearGradient get switchDotGradient =>
      _vertical([accent.shade(0.12), accent.shade(0.05)]);
  LinearGradient get radioOnGradient =>
      _vertical([accent.shade(0.08), accent.shade(-0.02)]);
  LinearGradient get radioOffGradient => isDark ? knob : SGradients.radioOff;
  LinearGradient get sheetHeaderGradient =>
      isDark ? _vertical([appBar, card]) : SGradients.sheetHeader;
  LinearGradient get sliderFillGradient =>
      isDark ? primary : SGradients.sliderFill;
  LinearGradient get pickerBodyGradient => isDark
      ? _vertical([sheetBody, groove, sheetBody], const [0, .14, 1])
      : SGradients.pickerBody;
  LinearGradient get pickerWellGradient => isDark
      ? _vertical([card, card, groove], const [0, .405, 1])
      : SGradients.pickerWell;
  LinearGradient get pickerBandGradient => isDark
      ? _vertical([cardPressed, card, cardPressed], const [0, .535, 1])
      : SGradients.pickerBand;
  LinearGradient get redBadgeGradient => isDark
      ? _vertical([red, Color.lerp(red, shadow, .025)!])
      : SGradients.red;
  List<BoxShadow> get cardSmallShadow => _shadows(SShadows.cardSmall);
  List<BoxShadow> get dialogActionsShadow => _shadows(SShadows.dialogActions);
  List<BoxShadow> get insetFieldShadow => _shadows(SShadows.insetField);
  List<BoxShadow> get insetRadioShadow => _shadows(SShadows.insetRadio);
  List<BoxShadow> get insetSwitchShadow => _shadows(SShadows.insetSwitch);
  List<BoxShadow> get insetTabShadow => _shadows(SShadows.insetTab);
  List<BoxShadow> get insetTrackShadow => _shadows(SShadows.insetTrack);
  List<BoxShadow> get insetWellShadow => _shadows(SShadows.insetWell);
  List<BoxShadow> get knobShadow => _shadows(SShadows.knob);
  List<BoxShadow> get knobSmallShadow => _shadows(SShadows.knobSmall);
  List<BoxShadow> get radioDotShadow => _shadows(SShadows.radioDot);
  List<BoxShadow> get sliderThumbShadow => _shadows(SShadows.sliderThumb);

  List<BoxShadow> _shadows(List<BoxShadow> kit) => [
    for (final s in kit)
      s.copyWith(
        color: shadow.withValues(
          alpha: isDark ? (s.color.a * 2).clamp(0, .5) : s.color.a,
        ),
      ),
  ];

  SChipColors chipColors(SChipColors kit) {
    if (!isDark) return kit;
    final tint = identical(kit, SChipColors.yellow)
        ? toastText
        : identical(kit, SChipColors.red)
        ? red
        : identical(kit, SChipColors.blue)
        ? accent
        : titleOther;
    final neutral =
        identical(kit, SChipColors.white) || identical(kit, SChipColors.grey);
    return SChipColors(
      neutral ? card : Color.alphaBlend(tint.withValues(alpha: .12), card),
      neutral ? border : tint.withValues(alpha: .5),
      tint,
      [
        cardPressed,
        neutral
            ? cardPressed
            : Color.alphaBlend(tint.withValues(alpha: .2), card),
      ],
      neutral ? border : tint,
    );
  }
}

LinearGradient _vertical(List<Color> colors, [List<double>? stops]) =>
    LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: colors,
      stops: stops,
    );
