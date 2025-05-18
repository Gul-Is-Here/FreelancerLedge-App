// modules/home/views/main_screen.dart
import 'package:flutter/material.dart';
import 'package:freelancer_income_tracker_app/screens/settings.dart';
import 'package:freelancer_income_tracker_app/screens/stats.dart';
import 'package:get/get.dart';

import '../widgets/custom_nav_bar.dart';
import 'home.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeView(),
    StatsView(),
    SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}