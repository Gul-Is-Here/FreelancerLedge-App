// app/controllers/stats_controller.dart
import 'package:freelancer_income_tracker_app/controllers/payment_controllers.dart';
import 'package:get/get.dart';

class StatsController extends GetxController {
  final PaymentsController paymentsController = Get.find();

  Map<String, double> getMonthlyEarnings() {
    final payments = paymentsController.filteredPayments
        .where((p) => p.isPaid)
        .toList();

    final now = DateTime.now();
    final months = List.generate(12, (i) =>
        DateTime(now.year, now.month - 11 + i));

    final result = <String, double>{};

    for (var month in months) {
      final monthPayments = payments.where((p) =>
      p.date.year == month.year && p.date.month == month.month);

      result['${month.month}/${month.year}'] =
          monthPayments.fold(0, (sum, p) => sum + p.amount);
    }

    return result;
  }

  Map<String, double> getEarningsByClient() {
    final payments = paymentsController.filteredPayments
        .where((p) => p.isPaid)
        .toList();

    final result = <String, double>{};

    for (var payment in payments) {
      result[payment.clientName] =
          (result[payment.clientName] ?? 0) + payment.amount;
    }

    return result;
  }
}