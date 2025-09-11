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
      id: json['_id'] ?? '',
      companyId: json['companyId'] != null
          ? CompanyId.fromJson(json['companyId'])
          : null,
      branchId: json['branchId'] != null
          ? BranchId.fromJson(json['branchId'])
          : null,
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

class CompanyId {
  String? sId;
  String? companyName;

  CompanyId({this.sId, this.companyName});

  CompanyId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['companyName'] = this.companyName;
    return data;
  }
}

class BranchId {
  String? sId;
  String? branchName;

  BranchId({this.sId, this.branchName});

  BranchId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    branchName = json['branchName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['branchName'] = this.branchName;
    return data;
  }
}
