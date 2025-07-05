import 'package:canuck_mall/app/localization/translation_service.dart';
import 'package:canuck_mall/app/modules/error_screens/error_screen.dart';
import 'package:canuck_mall/app/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'app/data/local/storage_service.dart';
import 'app/routes/app_pages.dart';
import 'app/themes/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  LocalStorage.getAllPrefData();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Lock to portrait mode
  ]).then((_) {
    runApp(
      CanuckMall()
    );
  });
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
      title: "Application",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      translations: AppTranslation(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      theme: lightTheme,
    );
  }
}
