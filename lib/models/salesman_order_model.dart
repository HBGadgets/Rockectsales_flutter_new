// class Order {
//   final String shopName;
//   final String salesmanName;
//   final String deliveryDate;
//   final String shopAddress;
//
//   Order({
//     required this.shopName,
//     required this.salesmanName,
//     required this.deliveryDate,
//     required this.shopAddress,
//   });
//
//   factory Order.fromJson(Map<String, dynamic> json) {
//     return Order(
//       shopName: json['shopName'] ?? '',
//       salesmanName: json['salesmanName'] ?? '',
//       deliveryDate: json['deliveryDate'] ?? '',
//       shopAddress: json['shopAddress'] ?? '',
//     );
//   }
// }