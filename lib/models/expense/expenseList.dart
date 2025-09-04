import 'dart:io';

import 'package:rocketsale_rs/models/admin_attendance_model.dart';

class Expense {
  final String id;
  final String expenceType;
  final String expenceDescription;
  final DateTime? date;
  final String amount;
  final String status;

  Expense({
    required this.id,
    required this.expenceType,
    required this.expenceDescription,
    required this.date,
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
      amount: json['amount'] ?? '0',
      status: json['status'] ?? '',
    );
  }
}

class ExpenseType {
  final String expenceType;
  final CompanyId? companyId;
  final BranchId? branchId;
  final String? id;

  ExpenseType({
    required this.expenceType,
    this.companyId,
    this.branchId,
    this.id,
  });

  factory ExpenseType.fromJson(Map<String, dynamic> json) {
    return ExpenseType(
      expenceType: json['expenceType']?.toString() ?? '',
      branchId: json['branchId'],
      id: json['_id'] ?? '',
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "expenceType": expenceType,
      "branchId": branchId,
      "companyId": companyId,
      if (id != null) "_id": id,
    };
  }
}
