// widgets/payment_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/payment_model.dart';

class PaymentCard extends StatelessWidget {
  final Payment payment;
  final VoidCallback onTap;
  final VoidCallback onTogglePaid;

  const PaymentCard({
    required this.payment,
    required this.onTap,
    required this.onTogglePaid,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    payment.clientName,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: payment.isPaid
                          ? Colors.green.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      payment.isPaid ? 'Paid' : 'Pending',
                      style: GoogleFonts.poppins(
                        color: payment.isPaid ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                payment.projectName,
                style: GoogleFonts.poppins(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${payment.amount.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: onTogglePaid,
                    icon: Icon(
                      payment.isPaid ? Icons.undo : Icons.check_circle,
                      color: payment.isPaid
                          ? Colors.orange
                          : Theme.of(context).colorScheme.primary,
                    ),
                    label: Text(
                      payment.isPaid ? 'Mark Unpaid' : 'Mark Paid',
                      style: GoogleFonts.poppins(
                        color: payment.isPaid
                            ? Colors.orange
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              if (payment.notes != null && payment.notes!.isNotEmpty) ...[
          SizedBox(height: 8),
      Text(
          'Notes: ${payment.notes}',
          style: GoogleFonts.poppins(
            fontStyle: FontStyle.italic,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
      )],
          SizedBox(height: 4),
      Text(
        'Due: ${payment.date.day}/${payment.date.month}/${payment.date.year}',
        style: GoogleFonts.poppins(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          fontSize: 12,
        ),
      ),
      ],
    ),
    ),
    ),
    );
  }
}