import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// List of public routes that don't require authentication
const _publicRoutes = [
  Routes.login,
  Routes.signUP,
  Routes.forgotPassword,
  Routes.verifyOtp,
  Routes.resetPassword,
  Routes.onboarding,
];

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Allow public routes
    if (_publicRoutes.any((r) => route?.startsWith(r) ?? false)) {
      return null;
    }

    // If user is not logged in, redirect to login page
    if (!LocalStorage.isLogIn) {
      return const RouteSettings(name: Routes.login);
    }
    
    // If user is logged in but tries to access login/signup, redirect to home
    if ((route == Routes.login || route == Routes.signUP) && LocalStorage.isLogIn) {
      return const RouteSettings(name: Routes.bottomNav);
    }

    return null;
  }
}
