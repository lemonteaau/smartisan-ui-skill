// The app-wide accent colour (强调色).
//
// Smartisan OS apps each pick one brand colour (App Store red, Game Center
// purple, Notes brown, system blue) and use it consistently: the brand bar,
// selected tab / bottom-nav item, primary buttons, switch dot, slider fill,
// check marks, links and the pressed list row. Here the user chooses that one
// colour; every accent-coloured element is derived from it, so screens never
// mix pink with blue.

import 'package:flutter/material.dart';

class SmartisanAccent {
  const SmartisanAccent(this.name, this.color);

  final String name;
  final Color color;

  static const pink = SmartisanAccent('樱花粉', Color(0xFFE0718F));
  static const red = SmartisanAccent('锤子红', Color(0xFFCD3F3A));
  static const blue = SmartisanAccent('锤子蓝', Color(0xFF5B87EB));
  static const purple = SmartisanAccent('游戏紫', Color(0xFF8E5BC4));
  static const green = SmartisanAccent('薄荷绿', Color(0xFF3E9E7E));
  static const brown = SmartisanAccent('便签棕', Color(0xFF9A7350));
  static const graphite = SmartisanAccent('石墨灰', Color(0xFF6B7380));

  static const presets = [blue, red, purple, brown, green, pink, graphite];

  static const SmartisanAccent defaultAccent = blue;

  static SmartisanAccent? presetOf(int argb) {
    for (final a in presets) {
      if (a.color.toARGB32() == argb) return a;
    }
    return null;
  }
}

/// Small HSL helpers used to derive the accent family.
extension SmartisanColorShade on Color {
  Color shade(double lightnessDelta, {double saturationDelta = 0}) {
    final hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness((hsl.lightness + lightnessDelta).clamp(0.0, 1.0))
        .withSaturation((hsl.saturation + saturationDelta).clamp(0.0, 1.0))
        .toColor();
  }

  /// Blend over [base] (e.g. a light tint of the accent over white).
  Color tintOver(Color base, double amount) => Color.lerp(base, this, amount)!;
}
