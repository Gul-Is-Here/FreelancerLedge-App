import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/setting_controller.dart';
import '../../../controllers/theme_controller.dart';

class SettingsView extends StatelessWidget {
  final SettingsController controller = Get.put(SettingsController());
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: GoogleFonts.poppins()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            Obx(() => SwitchListTile(
              title: Text('Dark Mode', style: GoogleFonts.poppins()),
              value: themeController.isDarkMode.value,
              onChanged: (value) => themeController.toggleTheme(value),
            )),
            SizedBox(height: 16),
            Text('Data Management', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text('Reset All Data', style: GoogleFonts.poppins()),
                subtitle: Text('Delete all payment records', style: GoogleFonts.poppins()),
                leading: Icon(Icons.delete_outline, color: Colors.red),
                onTap: () => _showResetConfirmation(context),
              ),
            ),
            SizedBox(height: 32),
            Text('App Information', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                title: Text('Version', style: GoogleFonts.poppins()),
                subtitle: Text('1.0.0', style: GoogleFonts.poppins()),
                leading: Icon(Icons.info_outline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Reset', style: GoogleFonts.poppins()),
        content: Text(
          'Are you sure you want to delete all payment records? This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () {
              controller.resetAllData();
              Get.back();
            },
            child: Text('Reset', style: GoogleFonts.poppins(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
