// app/bindings/app_bindings.dart
import 'package:get/get.dart';

import 'controllers/payment_controllers.dart';
import 'controllers/setting_controller.dart';
import 'controllers/stats_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentsController(), fenix: true);
    Get.lazyPut(() => StatsController(), fenix: true);
    Get.lazyPut(() => SettingsController(), fenix: true);
  }
}