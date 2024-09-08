// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class FlutterFlowTheme {
  static FlutterFlowTheme of(BuildContext context) {
    return LightModeTheme();
  }

  late Color primaryColor;
  late Color secondaryColor;
  late Color tertiaryColor;
  late Color alternate;
  late Color primaryBackground;
  late Color secondaryBackground;
  late Color primaryText;
  late Color secondaryText;

  late Color white;
  late Color iconGray;
  late Color grayDark;
  late Color darkBG;
  late Color background;
  late Color grayLines;
  late Color grayIcon;
  late Color gray200;
  late Color gray600;
  late Color black600;
  late Color tertiary400;
  late Color textColor;
  late Color primaryBtnText;
  late Color lineColor;
  late Color backgroundComponents;
  late Color customColor1;

  String get title1Family => typography.title1Family;
  TextStyle get title1 => typography.title1;
  String get title2Family => typography.title2Family;
  TextStyle get title2 => typography.title2;
  String get title3Family => typography.title3Family;
  TextStyle get title3 => typography.title3;
  String get subtitle1Family => typography.subtitle1Family;
  TextStyle get subtitle1 => typography.subtitle1;
  String get subtitle2Family => typography.subtitle2Family;
  TextStyle get subtitle2 => typography.subtitle2;
  String get bodyText1Family => typography.bodyText1Family;
  TextStyle get bodyText1 => typography.bodyText1;
  String get bodyText2Family => typography.bodyText2Family;
  TextStyle get bodyText2 => typography.bodyText2;

  Typography get typography => ThemeTypography(this);
}

class LightModeTheme extends FlutterFlowTheme {
  Color primaryColor = const Color(0xFFEE8B60);
  Color secondaryColor = const Color(0xFF262D34);
  Color tertiaryColor = const Color(0xFFEE8B60);
  Color alternate = const Color(0xFFDBE2E7);
  Color primaryBackground = const Color(0xFFF1F4F8);
  Color secondaryBackground = const Color(0xFFFFFFFF);
  Color primaryText = const Color(0xFF14181B);
  Color secondaryText = const Color(0xFF57636C);

  Color white = Color(0xFFFFFFFF);
  Color iconGray = Color(0xFF8B97A2);
  Color grayDark = Color(0xFF57636C);
  Color darkBG = Color(0xFF111417);
  Color background = Color(0xFFF1F4F8);
  Color grayLines = Color(0xFFDBE2E7);
  Color grayIcon = Color(0xFF95A1AC);
  Color gray200 = Color(0xFFDBE2E7);
  Color gray600 = Color(0xFF262D34);
  Color black600 = Color(0xFF090F13);
  Color tertiary400 = Color(0xFFEE8B60);
  Color textColor = Color(0xFF1E2429);
  Color primaryBtnText = Color(0xFFFFFFFF);
  Color lineColor = Color(0xFFE0E3E7);
  Color backgroundComponents = Color(0xFF1D2428);
  Color customColor1 = Color(0xFF2FB73C);
}

abstract class Typography {
  String get title1Family;
  TextStyle get title1;
  String get title2Family;
  TextStyle get title2;
  String get title3Family;
  TextStyle get title3;
  String get subtitle1Family;
  TextStyle get subtitle1;
  String get subtitle2Family;
  TextStyle get subtitle2;
  String get bodyText1Family;
  TextStyle get bodyText1;
  String get bodyText2Family;
  TextStyle get bodyText2;
}

class ThemeTypography extends Typography {
  ThemeTypography(this.theme);

  final FlutterFlowTheme theme;

  String get title1Family => 'Overpass';
  TextStyle get title1 => GoogleFonts.getFont(
        'Overpass',
        color: theme.darkBG,
        fontWeight: FontWeight.bold,
        fontSize: 30,
      );
  String get title2Family => 'Overpass';
  TextStyle get title2 => GoogleFonts.getFont(
        'Overpass',
        color: theme.darkBG,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      );
  String get title3Family => 'Overpass';
  TextStyle get title3 => GoogleFonts.getFont(
        'Overpass',
        color: theme.darkBG,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      );
  String get subtitle1Family => 'Overpass';
  TextStyle get subtitle1 => GoogleFonts.getFont(
        'Overpass',
        color: theme.primaryColor,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      );
  String get subtitle2Family => 'Overpass';
  TextStyle get subtitle2 => GoogleFonts.getFont(
        'Overpass',
        color: theme.darkBG,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      );
  String get bodyText1Family => 'Overpass';
  TextStyle get bodyText1 => GoogleFonts.getFont(
        'Overpass',
        color: theme.grayDark,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
  String get bodyText2Family => 'Overpass';
  TextStyle get bodyText2 => GoogleFonts.getFont(
        'Overpass',
        color: theme.darkBG,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String? fontFamily,
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? letterSpacing,
    FontStyle? fontStyle,
    bool useGoogleFonts = true,
    TextDecoration? decoration,
    double? lineHeight,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily!,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              letterSpacing: letterSpacing ?? this.letterSpacing,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
              decoration: decoration,
              height: lineHeight,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              letterSpacing: letterSpacing,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              decoration: decoration,
              height: lineHeight,
            );
}
