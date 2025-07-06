import 'package:flutter/material.dart';
import 'package:freelancer_income_tracker_app/routes/app_pages.dart';
import 'package:freelancer_income_tracker_app/theme/app_theme.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_bindings.dart';
import 'controllers/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    return GetMaterialApp(
      title: 'GigVault',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeController.themeMode,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: AppBindings(),
    );
  }
}
