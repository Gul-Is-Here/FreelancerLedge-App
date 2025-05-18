// lib/app/routes/app_pages.dart
import 'package:get/get.dart';

import '../screens/main_screen.dart';
import '../screens/splash.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => MainScreen(),
    ),
  ];
}