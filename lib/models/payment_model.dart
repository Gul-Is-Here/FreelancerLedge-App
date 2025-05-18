// app/models/payment_model.dart
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
}