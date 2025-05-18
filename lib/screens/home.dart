// modules/home/views/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/payment_controllers.dart';
import '../models/payment_model.dart';
import '../widgets/add_payment.dart';
import '../widgets/payment_card.dart';

class HomeView extends StatelessWidget {
  final PaymentsController paymentsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Freelance Income Tracker', style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: // In modules/home/views/home_view.dart - update the Obx(() {...}) part
      // modules/home/views/home_view.dart
      Obx(() {
        if (paymentsController.filteredPayments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.money_off,
                  size: 64,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
                SizedBox(height: 20),
                Text(
                  'No Payments Yet',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    'Start tracking your freelance income by adding your first payment',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _addPayment(context),
                  child: Text(
                    'Add First Payment',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: paymentsController.filteredPayments.length,
          itemBuilder: (context, index) {
            final payment = paymentsController.filteredPayments[index];
            return PaymentCard(
              payment: payment,
              onTap: () => _editPayment(context, payment),
              onTogglePaid: () => paymentsController.togglePaidStatus(payment.id),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addPayment(context),
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Future<void> _addPayment(BuildContext context) async {
    final payment = await showDialog<Payment>(
      context: context,
      builder: (context) => AddPaymentDialog(),
    );
    if (payment != null) {
      paymentsController.addPayment(payment);
    }
  }

  Future<void> _editPayment(BuildContext context, Payment payment) async {
    final updatedPayment = await showDialog<Payment>(
      context: context,
      builder: (context) => AddPaymentDialog(payment: payment),
    );
    if (updatedPayment != null) {
      paymentsController.updatePayment(payment.id, updatedPayment);
    }
  }

  void _showFilterDialog(BuildContext context) {
    final PaymentsController controller = Get.find();
    final now = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Payments', style: GoogleFonts.poppins()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Date Range', style: GoogleFonts.poppins()),
                  subtitle: Text(
                    '${DateFormat('MMM d, y').format(controller.filterStartDate.value)} - '
                        '${DateFormat('MMM d, y').format(controller.filterEndDate.value)}',
                    style: GoogleFonts.poppins(),
                  ),
                  onTap: () async {
                    final DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      initialDateRange: DateTimeRange(
                        start: controller.filterStartDate.value,
                        end: controller.filterEndDate.value,
                      ),
                    );
                    if (picked != null) {
                      controller.filterStartDate.value = picked.start;
                      controller.filterEndDate.value = picked.end;
                      controller.applyFilters();
                    }
                  },
                ),
                Divider(),
                Text('Payment Status', style: GoogleFonts.poppins()),
                RadioListTile<String>(
                  title: Text('All', style: GoogleFonts.poppins()),
                  value: 'all',
                  groupValue: controller.filterPaidStatus.value,
                  onChanged: (value) {
                    controller.filterPaidStatus.value = value!;
                    controller.applyFilters();
                    Get.back();
                  },
                ),
                RadioListTile<String>(
                  title: Text('Paid', style: GoogleFonts.poppins()),
                  value: 'paid',
                  groupValue: controller.filterPaidStatus.value,
                  onChanged: (value) {
                    controller.filterPaidStatus.value = value!;
                    controller.applyFilters();
                    Get.back();
                  },
                ),
                RadioListTile<String>(
                  title: Text('Unpaid', style: GoogleFonts.poppins()),
                  value: 'unpaid',
                  groupValue: controller.filterPaidStatus.value,
                  onChanged: (value) {
                    controller.filterPaidStatus.value = value!;
                    controller.applyFilters();
                    Get.back();
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Reset filters
                controller.filterStartDate.value = now.subtract(Duration(days: 30));
                controller.filterEndDate.value = now;
                controller.filterPaidStatus.value = 'all';
                controller.searchQuery.value = '';
                controller.applyFilters();
                Get.back();
              },
              child: Text('Reset', style: GoogleFonts.poppins()),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Close', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }
}