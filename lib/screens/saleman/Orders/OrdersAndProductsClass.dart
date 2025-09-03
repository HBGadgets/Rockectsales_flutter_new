class Order {
  final String id;
  final String shopName;
  final String shopOwnerName;
  final DateTime? deliveryDate;
  final DateTime createdAt;
  final String shopAddress;
  final String status;
  final String phoneNo;
  final List<Product> product;
  final int? grandTotal;
  final int? gst;
  final int? discount;
  final String? gstNumber;

  Order({
    required this.id,
    required this.shopName,
    required this.shopOwnerName,
    this.deliveryDate,
    required this.createdAt,
    required this.shopAddress,
    required this.status,
    required this.phoneNo,
    required this.product,
    this.grandTotal,
    this.gst,
    this.discount,
    this.gstNumber,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'] ?? '',
      shopName: json['shopName'] ?? '',
      shopOwnerName: json['shopOwnerName'] ?? '',
      deliveryDate: json['deliveryDate'] != null && json['deliveryDate'] != ''
          ? DateTime.tryParse(json['deliveryDate'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
      shopAddress: json['shopAddress'] ?? '',
      status: json['status'] ?? '',
      phoneNo: json['phoneNo'] ?? '',
      product: (json['products'] as List?)
              ?.map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      grandTotal: json['grandTotal'] ?? 0,
      gst: json['gst'] ?? 0,
      discount: json['discount'] ?? 0,
      gstNumber: json['gstNumber'] ?? '',
    );
  }
}

class Product {
  final String productName;
  final String quantity;
  final String price;
  final String? id;
  final String hsnCode;

  Product(
      {required this.productName,
      required this.quantity,
      required this.price,
      this.id,
      required this.hsnCode});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['productName']?.toString() ?? '',
      quantity: json['quantity']?.toString() ?? '',
      price: json['price']?.toString() ?? '',
      id: json['_id'] ?? '',
      hsnCode: json['hsnCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productName": productName,
      "quantity": quantity,
      "price": price,
      "hsnCode": hsnCode,
      if (id != null) "_id": id, // only include id if it’s not null
    };
  }
}
