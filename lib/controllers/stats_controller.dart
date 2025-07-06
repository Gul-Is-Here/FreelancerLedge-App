import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/payment_model.dart';
import 'payment_controllers.dart';

class StatsController extends GetxController {
  final PaymentsController paymentsController = Get.find<PaymentsController>();

  Map<String, double> getMonthlyEarnings() {
    // Get paid payments from PaymentsController (loaded from SharedPreferences)
    final payments =
        paymentsController.filteredPayments.where((p) => p.isPaid).toList();

    // Generate list of last 12 months
    final now = DateTime.now();
    final months = List.generate(
      12,
      (i) => DateTime(now.year, now.month - 11 + i, 1),
    );

    // Initialize result map
    final result = <String, double>{};

    // Calculate earnings for each month
    for (var month in months) {
      final monthPayments = payments.where(
        (p) => p.date.year == month.year && p.date.month == month.month,
      );
      final monthKey = DateFormat('MMM yyyy').format(month);
      result[monthKey] = monthPayments.fold(0, (sum, p) => sum + p.amount);
    }

    return result;
  }

  Map<String, double> getEarningsByClient() {
    // Get paid payments from PaymentsController (loaded from SharedPreferences)
    final payments =
        paymentsController.filteredPayments.where((p) => p.isPaid).toList();

    // Initialize result map
    final result = <String, double>{};

    // Aggregate earnings by client
    for (var payment in payments) {
      result[payment.clientName] =
          (result[payment.clientName] ?? 0) + payment.amount;
    }

    // Sort clients by earnings (descending) for better visualization
    final sortedResult = Map<String, double>.fromEntries(
      result.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
    );

    return sortedResult;
  }
}
