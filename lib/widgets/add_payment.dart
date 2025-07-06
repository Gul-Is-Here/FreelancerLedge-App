import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/payment_controllers.dart';
import '../models/payment_model.dart';
import '../theme/app_theme.dart';

class AddPaymentDialog extends StatefulWidget {
  final Payment? payment;

  const AddPaymentDialog({this.payment, super.key});

  @override
  _AddPaymentDialogState createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clientController;
  late TextEditingController _projectController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;
  late TextEditingController _notesController;
  late bool _isPaid;
  final PaymentsController _paymentsController = Get.find<PaymentsController>();

  @override
  void initState() {
    super.initState();
    _clientController = TextEditingController(
      text: widget.payment?.clientName ?? '',
    );
    _projectController = TextEditingController(
      text: widget.payment?.projectName ?? '',
    );
    _amountController = TextEditingController(
      text: widget.payment?.amount.toString() ?? '',
    );
    _dateController = TextEditingController(
      text:
          widget.payment != null
              ? DateFormat('MMM d, yyyy').format(widget.payment!.date)
              : DateFormat('MMM d, yyyy').format(DateTime.now()),
    );
    _notesController = TextEditingController(text: widget.payment?.notes ?? '');
    _isPaid = widget.payment?.isPaid ?? false;
  }

  @override
  void dispose() {
    _clientController.dispose();
    _projectController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.payment?.date ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: AppColors.lightCard,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('MMM d, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: Duration(milliseconds: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  widget.payment == null ? 'Add Payment' : 'Edit Payment',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _clientController,
                        decoration: InputDecoration(
                          labelText: 'Client Name',
                          labelStyle: GoogleFonts.poppins(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.lightCard.withOpacity(0.9),
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter client name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _projectController,
                        decoration: InputDecoration(
                          labelText: 'Project Name',
                          labelStyle: GoogleFonts.poppins(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.lightCard.withOpacity(0.9),
                          prefixIcon: Icon(
                            Icons.work,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter project name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: 'Amount',
                          labelStyle: GoogleFonts.poppins(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                          ),
                          prefixText: '\$ ',
                          prefixStyle: GoogleFonts.poppins(
                            color: AppColors.primaryColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.lightCard.withOpacity(0.9),
                          prefixIcon: Icon(
                            Icons.attach_money,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: GoogleFonts.poppins(fontSize: 14),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          labelStyle: GoogleFonts.poppins(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.lightCard.withOpacity(0.9),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14),
                        onTap: () => _selectDate(context),
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a date';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: 'Notes (optional)',
                          labelStyle: GoogleFonts.poppins(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor.withOpacity(0.5),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColors.lightCard.withOpacity(0.9),
                          prefixIcon: Icon(
                            Icons.note,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        style: GoogleFonts.poppins(fontSize: 14),
                        maxLines: 2,
                      ),
                      SizedBox(height: 12),
                      SwitchListTile(
                        title: Text(
                          'Paid',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        value: _isPaid,
                        onChanged: (value) {
                          setState(() {
                            _isPaid = value;
                          });
                        },
                        activeColor: AppColors.primaryColor,
                        activeTrackColor: AppColors.primaryColor.withOpacity(
                          0.4,
                        ),
                        inactiveThumbColor: AppColors.secondaryColor,
                        inactiveTrackColor: AppColors.secondaryColor
                            .withOpacity(0.4),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final payment = Payment(
                                id:
                                    widget.payment?.id ??
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                clientName: _clientController.text,
                                projectName: _projectController.text,
                                amount: double.parse(_amountController.text),
                                date: DateFormat(
                                  'MMM d, yyyy',
                                ).parse(_dateController.text),
                                isPaid: _isPaid,
                                notes:
                                    _notesController.text.isEmpty
                                        ? null
                                        : _notesController.text,
                              );

                              if (widget.payment == null) {
                                _paymentsController.addPayment(payment);
                                Get.snackbar(
                                  'Success',
                                  'Payment added successfully',
                                  backgroundColor: AppColors.primaryColor,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                  margin: EdgeInsets.all(16),
                                  borderRadius: 12,
                                );
                              } else {
                                _paymentsController.updatePayment(
                                  widget.payment!.id,
                                  payment,
                                );
                                Navigator.of(context).pop();
                                Get.snackbar(
                                  'Success',
                                  'Payment updated successfully',
                                  backgroundColor: AppColors.primaryColor,
                                  colorText: Colors.white,
                                  snackPosition: SnackPosition.TOP,
                                  margin: EdgeInsets.all(16),
                                  borderRadius: 12,
                                );
                              }
                              Navigator.of(context).pop();
                              
                            } catch (e) {
                              Get.snackbar(
                                'Error',
                                'Failed to save payment: $e',
                                backgroundColor: AppColors.secondaryColor,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.TOP,
                                margin: EdgeInsets.all(16),
                                borderRadius: 12,
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          elevation: 2,
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
