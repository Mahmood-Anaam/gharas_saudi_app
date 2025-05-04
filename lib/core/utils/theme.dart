import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF6A8D73);
  static const Color secondaryColor = Color(0xFF4A6D55);

  static final ThemeData lightTheme = FlexThemeData.light(
    colors: const FlexSchemeColor(
      primary: primaryColor,
      secondary: secondaryColor,
      appBarColor: primaryColor,
      error: Colors.redAccent,
    ),
    surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
    blendLevel: 10,
    appBarStyle: FlexAppBarStyle.background,
    tabBarStyle: FlexTabBarStyle.forBackground,
    useMaterial3: true,
    fontFamily: 'Poppins',
  );

  static final ThemeData darkTheme = FlexThemeData.dark(
    colors: const FlexSchemeColor(
      primary: primaryColor,
      secondary: secondaryColor,
      appBarColor: secondaryColor,
      error: Colors.redAccent,
    ),
    surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
    blendLevel: 10,
    appBarStyle: FlexAppBarStyle.background,
    tabBarStyle: FlexTabBarStyle.forBackground,
    useMaterial3: true,
    fontFamily: 'Poppins',
  );

  static ThemeMode themeMode = ThemeMode.light;
}
