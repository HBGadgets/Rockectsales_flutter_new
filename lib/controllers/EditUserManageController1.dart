// import 'package:get/get_core/src/get_main.dart';
//
// import '../models/admin_attendance_model.dart';
// import '../screens/saleman/Orders/order/Order_Screen.dart';
//
// class EditUserManageController1 extends GetxController {
//   final TextEditingController storeNameController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController dateController = TextEditingController();
//   final TextEditingController customerNameController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController deliveryStoreController = TextEditingController();
//
//   var productList = <Product>.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     final order = Get.arguments as Data?;
//
//     if (order != null) {
//       // Pre-fill form fields from order
//       storeNameController.text = order.shop?.shopName ?? '';
//       addressController.text = order.shop?.address ?? '';
//       dateController.text = order.date ?? '';
//       customerNameController.text = order.customerName ?? '';
//       phoneNumberController.text = order.customerPhone ?? '';
//       deliveryStoreController.text = order.deliveryStore ?? '';
//       productList.assignAll(order.products ?? []);
//     }
//   }
//
//   @override
//   void onClose() {
//     storeNameController.dispose();
//     addressController.dispose();
//     dateController.dispose();
//     customerNameController.dispose();
//     phoneNumberController.dispose();
//     deliveryStoreController.dispose();
//     super.onClose();
//   }
// }
