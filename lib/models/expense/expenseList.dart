class Expense {
  final String id;
  final String expenceType;
  final String expenceDescription;
  final DateTime? date;
  final String? billDoc;
  final String amount;
  final String status;

  Expense({
    required this.id,
    required this.expenceType,
    required this.expenceDescription,
    required this.date,
    required this.billDoc,
    required this.amount,
    required this.status,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['_id'] ?? '',
      expenceType: json['expenceType'] ?? '',
      expenceDescription: json['expenceDescription'] ?? '',
      date: json['date'] != null && json['date'] != ''
          ? DateTime.tryParse(json['date'])
          : null,
      billDoc: json['billDoc'],
      amount: json['amount'] ?? '0',
      status: json['status'] ?? '',
    );
  }
}
