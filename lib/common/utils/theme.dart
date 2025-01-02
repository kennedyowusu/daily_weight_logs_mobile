import 'package:daily_weight_logs_mobile/common/constants/colors.dart';
import 'package:flutter/material.dart';

ThemeData buildThemeData() {
  return ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      secondary: secondaryColor,
      surface: Colors.white,
    ),
    useMaterial3: true,
  );
}
