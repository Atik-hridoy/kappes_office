import 'dart:developer';
import 'package:canuck_mall/app/themes/app_colors.dart';
import 'package:canuck_mall/app/widgets/app_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class AppUtils {
  // >>>>>>>>>>>>>>>>>>>>>> when show message bottom  <<<<<<<<<<<<<<<<<<<<<<

  // >>>>>>>>>>>>>>>>>>>>>> error message snack bar  <<<<<<<<<<<<<<<<<<<<<<
  static showError(String parameterValue) {
    // Use addPostFrameCallback to avoid calling showSnackbar during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.showSnackbar(
        GetSnackBar(
          backgroundColor: Colors.red,
          animationDuration: const Duration(seconds: 2),
          duration: const Duration(seconds: 3),
          messageText: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                  title: "Error!",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white)
                      ),
              AppText(
                  title: parameterValue,
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white)
                      ),
            ],
          ),
        ),
      );
    });
  }

  // >>>>>>>>>>>>>>>>>>>>>> success message <<<<<<<<<<<<<<<<<<<<<<

  // Show success message in Snackbar
  static showSuccess(String parameterValue) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.showSnackbar(
        GetSnackBar(
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.TOP,
          animationDuration: const Duration(seconds: 2),
          duration: const Duration(seconds: 3),
          messageText: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                title: "Success!",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white),
              ),
              AppText(
                title: parameterValue,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: AppColors.white),
              ),
            ],
          ),
        ),
      );
    });
  }


  static void appError(dynamic value, {String title = "error from"}) {
    try {
      if (kDebugMode) {
        log(""""
        😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡
        $title >>>>>>>>>>>>>> $value
        😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡😡
        """);
      }
    } catch (e) {
      log("error form AppLog: $e");
    }
  }
}
