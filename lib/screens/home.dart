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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          'GigVault',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.filter_alt, size: 28),
                if (paymentsController.filterPaidStatus.value != 'all' ||
                    paymentsController.searchQuery.value.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          SizedBox(width: 8),
        ],
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              onChanged: (value) {
                paymentsController.searchQuery.value = value;
                paymentsController.applyFilters();
              },
              decoration: InputDecoration(
                hintText: 'Search payments...',
                hintStyle: GoogleFonts.poppins(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surface.withOpacity(0.9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
              style: GoogleFonts.poppins(),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (paymentsController.filteredPayments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                ),
                SizedBox(height: 16),
                Text(
                  'No Payments Yet',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'Start tracking your freelance income by adding your first payment.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => _addPayment(context),
                  child: Text(
                    'Add First Payment',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    elevation: 4,
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: paymentsController.filteredPayments.length,
          itemBuilder: (context, index) {
            final payment = paymentsController.filteredPayments[index];
            return AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(milliseconds: 300 + (index * 100)),
              child: PaymentCard(
                payment: payment,
                onTap: () => _editPayment(context, payment),
                onTogglePaid:
                    () => paymentsController.togglePaidStatus(payment.id),
              ),
            );
          },
        );
      }),
      floatingActionButton: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 1.2).animate(
          CurvedAnimation(
            parent: AnimationController(
              vsync: Navigator.of(context),
              duration: Duration(milliseconds: 200),
            )..forward(),
            curve: Curves.easeInOut,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () => _addPayment(context),
          child: Icon(Icons.add, size: 28),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: CircleBorder(),
        ),
      ),
    );
  }

  Future<void> _addPayment(BuildContext context) async {
    final payment = await showModalBottomSheet<Payment>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddPaymentDialog(),
    );
    if (payment != null) {
      paymentsController.addPayment(payment);
    }
  }

  Future<void> _editPayment(BuildContext context, Payment payment) async {
    final updatedPayment = await showModalBottomSheet<Payment>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddPaymentDialog(payment: payment),
    );
    if (updatedPayment != null) {
      paymentsController.updatePayment(payment.id, updatedPayment);
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    final PaymentsController controller = Get.find();
    final now = DateTime.now();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Filter Payments',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      title: Text(
                        'Date Range',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        '${DateFormat('MMM d, y').format(controller.filterStartDate.value)} - '
                        '${DateFormat('MMM d, y').format(controller.filterEndDate.value)}',
                        style: GoogleFonts.poppins(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      trailing: Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).colorScheme.primary,
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
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: Theme.of(
                                  context,
                                ).colorScheme.copyWith(
                                  primary:
                                      Theme.of(context).colorScheme.primary,
                                  onPrimary: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (picked != null) {
                          controller.filterStartDate.value = picked.start;
                          controller.filterEndDate.value = picked.end;
                          controller.applyFilters();
                        }
                      },
                    ),
                    Divider(),
                    Text(
                      'Payment Status',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    ),
                    RadioListTile<String>(
                      title: Text('All', style: GoogleFonts.poppins()),
                      value: 'all',
                      groupValue: controller.filterPaidStatus.value,
                      activeColor: Theme.of(context).colorScheme.primary,
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
                      activeColor: Theme.of(context).colorScheme.primary,
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
                      activeColor: Theme.of(context).colorScheme.primary,
                      onChanged: (value) {
                        controller.filterPaidStatus.value = value!;
                        controller.applyFilters();
                        Get.back();
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              controller.filterStartDate.value = now.subtract(
                                Duration(days: 30),
                              );
                              controller.filterEndDate.value = now;
                              controller.filterPaidStatus.value = 'all';
                              controller.searchQuery.value = '';
                              controller.applyFilters();
                              Get.back();
                            },
                            child: Text(
                              'Reset',
                              style: GoogleFonts.poppins(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'Apply',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
