import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/localization/translation_service.dart';
import 'package:canuck_mall/app/modules/error_screens/error_screen.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_theme.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:canuck_mall/app/modules/saved/controllers/saved_controller.dart';

/// Main entry point for the app.
///
/// This function is responsible for initializing the app, setting up the
/// system UI, loading local preferences, and running the app.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style to white background with dark icons
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  // Lock the app's orientation to portrait up
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Load local preferences from storage
  await LocalStorage.getAllPrefData();

  // Register SavedController globally for GetX
  Get.put(SavedController());
  // Run the app
  runApp(const CanuckMall());
}

class CanuckMall extends StatelessWidget {
  const CanuckMall({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.screenHeight = MediaQuery.of(context).size.height;
    AppSize.screenWidth = MediaQuery.of(context).size.width;

    return GetMaterialApp(
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return ErrorScreen(errorDetails: errorDetails);
        };
        return child!;
      },
      debugShowCheckedModeBanner: false,
      title: "Kappes Office",
      theme: lightTheme,
      translations: AppTranslation(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute:
          LocalStorage.isLogIn && LocalStorage.token.isNotEmpty
              ? Routes.bottomNav
              : Routes.onboarding,
      getPages: AppPages.routes,
    );
  }
}
