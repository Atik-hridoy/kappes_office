import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/themes/text_style.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.white,
  textTheme: appTextTheme,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    hintStyle: TextStyle(fontFamily: "Montserrat", fontSize: AppSize.height(height: 1.60), color: AppColors.lightGray),
    border: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.0))
    ),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.lightGray),
        borderRadius: BorderRadius.circular(AppSize.height(height: 1.0))
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: AppColors.primary,
    surface: AppColors.white,
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.primary,
  textTheme: appTextTheme,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primary,
  ),
);