// app/controllers/settings_controller.dart
import 'package:freelancer_income_tracker_app/controllers/payment_controllers.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final PaymentsController paymentsController = Get.find();

  void resetAllData() {
    paymentsController.payments.clear();
    paymentsController.applyFilters();
    Get.snackbar(
      'Success',
      'All data has been reset',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}