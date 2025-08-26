class Order {
  final String shopName;
  final String salesmanName;
  final String deliveryDate;
  final String shopAddress;
  final String status;
  final String phoneNo;
  final List<Product> product;

  Order(
      {required this.shopName,
      required this.salesmanName,
      required this.deliveryDate,
      required this.shopAddress,
      required this.status,
      required this.phoneNo,
      required this.product});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        shopName: json['shopName'] ?? '',
        salesmanName: json['salesmanName'] ?? '',
        deliveryDate: json['deliveryDate'] ?? '',
        shopAddress: json['shopAddress'] ?? '',
        status: json['shopAddress'] ?? '',
        phoneNo: json['phoneNo'] ?? '',
        product: (json['products'] as List<dynamic>?)
                ?.map((item) => Product.fromJson(item))
                .toList() ??
            []);
  }
}

class Product {
  final String productName;
  final String quantity;
  final String price;
  final String id;

  Product({
    required this.productName,
    required this.quantity,
    required this.price,
    required this.id,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? '',
      price: json['price'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}
