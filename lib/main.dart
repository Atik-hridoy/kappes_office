import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/localization/translation_service.dart';
import 'package:canuck_mall/app/modules/error_screens/error_screen.dart';
import 'package:canuck_mall/app/routes/app_pages.dart';
import 'package:canuck_mall/app/themes/app_theme.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Lock orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Load local preferences
  await LocalStorage.getAllPrefData(); // Load local preferences

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
      title: "Canuck Mall",
      theme: lightTheme,
      translations: AppTranslation(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),

      // 👇 Set initial route dynamically based on saved login
      initialRoute: LocalStorage.isLogIn && LocalStorage.token.isNotEmpty
          ? Routes.bottomNav // or home/dashboard
          : Routes.login,

      getPages: AppPages.routes,
    );
  }
}
