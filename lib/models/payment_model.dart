import 'package:intl/intl.dart';

class Payment {
  final String id;
  final String clientName;
  final String projectName;
  final double amount;
  final DateTime date;
  final bool isPaid;
  final String? notes;

  Payment({
    required this.id,
    required this.clientName,
    required this.projectName,
    required this.amount,
    required this.date,
    this.isPaid = false,
    this.notes,
  });

  Payment copyWith({
    String? id,
    String? clientName,
    String? projectName,
    double? amount,
    DateTime? date,
    bool? isPaid,
    String? notes,
  }) {
    return Payment(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      projectName: projectName ?? this.projectName,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      isPaid: isPaid ?? this.isPaid,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientName': clientName,
      'projectName': projectName,
      'amount': amount,
      'date': date.toIso8601String(),
      'isPaid': isPaid,
      'notes': notes,
    };
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      clientName: json['clientName'] as String,
      projectName: json['projectName'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      isPaid: json['isPaid'] as bool,
      notes: json['notes'] as String?,
    );
  }
}