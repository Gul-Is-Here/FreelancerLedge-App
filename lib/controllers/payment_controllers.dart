import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/payment_model.dart';

class PaymentsController extends GetxController {
  var payments = <Payment>[].obs;
  var filteredPayments = <Payment>[].obs;
  var filterStartDate = DateTime.now().subtract(Duration(days: 30)).obs;
  var filterEndDate = DateTime.now().obs;
  var filterPaidStatus = 'all'.obs; // 'all', 'paid', 'unpaid'
  var searchQuery = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await _loadPayments();
    applyFilters();
  }

  // Load payments from SharedPreferences
  Future<void> _loadPayments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final paymentsJson = prefs.getString('payments');
      if (paymentsJson != null) {
        final List<dynamic> decoded = jsonDecode(paymentsJson);
        payments.value = decoded.map((json) => Payment.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading payments: $e');
    }
  }

  // Save payments to SharedPreferences
  Future<void> _savePayments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final paymentsJson = jsonEncode(payments.map((p) => p.toJson()).toList());
      await prefs.setString('payments', paymentsJson);
    } catch (e) {
      print('Error saving payments: $e');
    }
  }

  void addPayment(Payment payment) {
    payments.add(payment);
    applyFilters();
    _savePayments();
  }

  void updatePayment(String id, Payment updatedPayment) {
    final index = payments.indexWhere((p) => p.id == id);
    if (index != -1) {
      payments[index] = updatedPayment;
      applyFilters();
      _savePayments();
    }
  }

  void deletePayment(String id) {
    payments.removeWhere((p) => p.id == id);
    applyFilters();
    _savePayments();
  }

  void togglePaidStatus(String id) {
    final index = payments.indexWhere((p) => p.id == id);
    if (index != -1) {
      payments[index] = payments[index].copyWith(isPaid: !payments[index].isPaid);
      applyFilters();
      _savePayments();
    }
  }

  void resetAllData() {
    payments.clear();
    filteredPayments.clear();
    _savePayments();
  }

  void applyFilters() {
    filteredPayments.value = payments.where((payment) {
      // Date filter
      final isInDateRange = payment.date.isAfter(filterStartDate.value) &&
          payment.date.isBefore(filterEndDate.value.add(Duration(days: 1)));

      // Paid status filter
      final paidStatusMatch = filterPaidStatus.value == 'all' ||
          (filterPaidStatus.value == 'paid' && payment.isPaid) ||
          (filterPaidStatus.value == 'unpaid' && !payment.isPaid);

      // Search query
      final searchMatch = searchQuery.value.isEmpty ||
          payment.clientName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          payment.projectName.toLowerCase().contains(searchQuery.value.toLowerCase());

      return isInDateRange && paidStatusMatch && searchMatch;
    }).toList();
  }

  double get totalEarnings {
    return filteredPayments
        .where((p) => p.isPaid)
        .fold(0, (sum, p) => sum + p.amount);
  }

  double get pendingPayments {
    return filteredPayments
        .where((p) => !p.isPaid)
        .fold(0, (sum, p) => sum + p.amount);
  }
}