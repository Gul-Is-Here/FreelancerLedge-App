// widgets/add_payment_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/payment_model.dart';

class AddPaymentDialog extends StatefulWidget {
  final Payment? payment;

  const AddPaymentDialog({this.payment});

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

  @override
  void initState() {
    super.initState();
    _clientController = TextEditingController(
        text: widget.payment?.clientName ?? '');
    _projectController = TextEditingController(
        text: widget.payment?.projectName ?? '');
    _amountController = TextEditingController(
        text: widget.payment?.amount.toString() ?? '');
    _dateController = TextEditingController(
        text: widget.payment != null
            ? DateFormat('yyyy-MM-dd').format(widget.payment!.date)
            : DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _notesController = TextEditingController(
        text: widget.payment?.notes ?? '');
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
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.payment == null ? 'Add Payment' : 'Edit Payment',
        style: GoogleFonts.poppins(),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _clientController,
                decoration: InputDecoration(
                  labelText: 'Client Name',
                  border: OutlineInputBorder(),
                ),
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
                  border: OutlineInputBorder(),
                ),
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
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
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
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 12),
              SwitchListTile(
                title: Text('Paid', style: GoogleFonts.poppins()),
                value: _isPaid,
                onChanged: (value) {
                  setState(() {
                    _isPaid = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel', style: GoogleFonts.poppins()),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final payment = Payment(
                id: widget.payment?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                clientName: _clientController.text,
                projectName: _projectController.text,
                amount: double.parse(_amountController.text),
                date: DateFormat('yyyy-MM-dd').parse(_dateController.text),
                isPaid: _isPaid,
                notes: _notesController.text.isEmpty ? null : _notesController.text,
              );
              Get.back(result: payment);
            }
          },
          child: Text('Save', style: GoogleFonts.poppins()),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}