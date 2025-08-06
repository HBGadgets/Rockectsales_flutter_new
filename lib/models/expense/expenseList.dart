class Expense {
  final String id;
  final String expenceType;
  final String expenceDescription;
  final String date;
  final String? billDoc;
  final String amount;

  Expense({
    required this.id,
    required this.expenceType,
    required this.expenceDescription,
    required this.date,
    required this.billDoc,
    required this.amount,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['_id'] ?? '',
      expenceType: json['expenceType'] ?? '',
      expenceDescription: json['expenceDescription'] ?? '',
      date: json['date'] ?? '',
      billDoc: json['billDoc'],
      amount: json['amount'] ?? '0',
    );
  }
}
