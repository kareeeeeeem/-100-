import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lms/core/utils/app_colors.dart';
import 'package:lms/core/utils/app_fonts.dart';

ThemeData get lightTheme => ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  fontFamily: AppFonts.cairo,
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    scrolledUnderElevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  ),
  cardTheme: const CardThemeData(color: Colors.white, elevation: 3),
);
