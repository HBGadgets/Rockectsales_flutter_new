class Order_edit_Model {
  String? message;
  Data? data;

  Order_edit_Model({this.message, this.data});

  Order_edit_Model.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
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
  String? companyId;
  String? branchId;
  String? supervisorId;
  String? salesmanId;
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
    companyId = json['companyId'];
    branchId = json['branchId'];
    supervisorId = json['supervisorId'];
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
    data['companyId'] = this.companyId;
    data['branchId'] = this.branchId;
    data['supervisorId'] = this.supervisorId;
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
