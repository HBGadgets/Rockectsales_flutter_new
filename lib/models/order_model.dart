class OrderModel {
  bool? success;
  List<Data>? data;

  OrderModel({this.success, this.data});

  OrderModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? sId;
  List<Products>? products;
  String? shopName;
  String? shopAddress;
  String? deliveryDate;
  String? shopOwnerName;
  String? status;
  String? phoneNo;
  CompanyId? companyId;
  BranchId? branchId;
  SupervisorId? supervisorId;
  Null? salesmanId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.products,
      this.shopName,
      this.shopAddress,
      this.deliveryDate,
      this.shopOwnerName,
      this.status,
      this.phoneNo,
      this.companyId,
      this.branchId,
      this.supervisorId,
      this.salesmanId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    shopName = json['shopName'];
    shopAddress = json['shopAddress'];
    deliveryDate = json['deliveryDate'];
    shopOwnerName = json['shopOwnerName'];
    status = json['status'];
    phoneNo = json['phoneNo'];
    companyId = json['companyId'] != null
        ? new CompanyId.fromJson(json['companyId'])
        : null;
    branchId = json['branchId'] != null
        ? new BranchId.fromJson(json['branchId'])
        : null;
    supervisorId = json['supervisorId'] != null
        ? new SupervisorId.fromJson(json['supervisorId'])
        : null;
    salesmanId = json['salesmanId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['shopName'] = this.shopName;
    data['shopAddress'] = this.shopAddress;
    data['deliveryDate'] = this.deliveryDate;
    data['shopOwnerName'] = this.shopOwnerName;
    data['status'] = this.status;
    data['phoneNo'] = this.phoneNo;
    if (this.companyId != null) {
      data['companyId'] = this.companyId!.toJson();
    }
    if (this.branchId != null) {
      data['branchId'] = this.branchId!.toJson();
    }
    if (this.supervisorId != null) {
      data['supervisorId'] = this.supervisorId!.toJson();
    }
    data['salesmanId'] = this.salesmanId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Products {
  String? productName;
  int? quantity;
  int? price;
  String? sId;

  Products({this.productName, this.quantity, this.price, this.sId});

  Products.fromJson(Map<String, dynamic> json) {
    productName = json['productName'];
    quantity = json['quantity'];
    price = json['price'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['_id'] = this.sId;
    return data;
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
  String? branchLocation;

  BranchId({this.sId, this.branchName, this.branchLocation});

  BranchId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    branchName = json['branchName'];
    branchLocation = json['branchLocation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['branchName'] = this.branchName;
    data['branchLocation'] = this.branchLocation;
    return data;
  }
}

class SupervisorId {
  String? sId;
  String? supervisorName;

  SupervisorId({this.sId, this.supervisorName});

  SupervisorId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    supervisorName = json['supervisorName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['supervisorName'] = this.supervisorName;
    return data;
  }
}
