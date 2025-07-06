import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await _loadTheme();
  }

  // Load theme preference from SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getBool('isDarkMode');
      if (savedTheme != null) {
        isDarkMode.value = savedTheme;
        Get.changeThemeMode(themeMode);
      }
    } catch (e) {
      print('Error loading theme: $e');
    }
  }

  // Save theme preference to SharedPreferences
  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', isDarkMode.value);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }

  ThemeMode get themeMode =>
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme(bool isDark) {
    isDarkMode.value = isDark;
    Get.changeThemeMode(themeMode);
    _saveTheme();
  }
}
