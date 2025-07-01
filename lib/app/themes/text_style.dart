import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

// AppSize.height(height: 2.50) => 18.0
// AppSize.height(height: 2.80) => 20.0
// AppSize.height(height: 2.0) => 16.0
// AppSize.height(height: 1.70) => 14.0
// AppSize.height(height: 1.50) => 12.0

TextTheme appTextTheme = TextTheme(
  /// title large
  titleLarge: TextStyle(
    fontFamily: "Comfortaa",
    fontSize: AppSize.height(height: 3.0), // 24.0
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  ),

  /// title medium
  titleMedium: TextStyle(
    fontFamily: "Comfortaa",
    fontSize: AppSize.height(height: 2.50), // 18.0
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  ),

  /// title small
  titleSmall: TextStyle(
    fontFamily: "Comfortaa",
    fontSize: AppSize.height(height: 1.70), // 14.0
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  ),

  /// body large
  bodyLarge: TextStyle(
    fontFamily: "montserrat",
    fontSize: AppSize.height(height: 2.0), // 16.0
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  ),
  bodyMedium: TextStyle(
    fontFamily: "montserrat",
    fontSize: AppSize.height(height: 1.70), // 14.0
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  ),
  bodySmall: TextStyle(
    fontFamily: "montserrat",
    fontSize: AppSize.height(height: 1.50), // 12.0
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  ),
);