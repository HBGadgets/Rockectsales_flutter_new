import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:rocketsale_rs/resources/my_assets.dart';
import 'package:rocketsale_rs/screens/saleman/Expense/ExpensesController.dart';
import 'package:rocketsale_rs/screens/saleman/Orders/OrdersController.dart';
import 'package:rocketsale_rs/screens/saleman/Orders/OrdersHistoryScreen.dart';

import '../../../../models/expense/expenseList.dart';
import '../../../../resources/my_colors.dart';
import '../../../../utils/token_manager.dart';

class CreateEditExpenseController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<ExpenseType> expenseTypeList = <ExpenseType>[].obs;

  final TextEditingController amount = TextEditingController();

  final TextEditingController description = TextEditingController();

  final TextEditingController location = TextEditingController();

  var tillDate = Rxn<DateTime>();

  var file = Rxn<File?>();

  var dropdownValue = Rxn<ExpenseType>();

  final ExpensesController controller = Get.find<ExpensesController>();

  //Conditional rendering of the screen
  var expenseToEdit = Rxn<Expense>();
  final RxString appBarTitle = "".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    getExpenseTypeForDropDown();
  }

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: MyColor.dashbord),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> updateExpense(BuildContext context) async {
    showLoading(context);
    try {
      final uri = Uri.parse(
          '${dotenv.env['BASE_URL']}/api/api/expence/${expenseToEdit.value!.id}');

      final token = await TokenManager.getToken();

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      final companyId = decodedToken['companyId'];
      final branchId = decodedToken['branchId'];
      final supervisorId = decodedToken['supervisorId'];
      final salesmanId = decodedToken['id'];

      final response = await http.put(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'salesmanId': salesmanId,
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
          'deliveryDate': tillDate.value?.toIso8601String(),
          'amount': amount.text,
          'date': tillDate,
          'expenceDescription': description.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        controller.getExpenses();
        Get.snackbar("Success", "Order info submitted");
      } else {
        Navigator.of(context).pop();
        print("❌ Order submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in posting qr: $e");
      Get.snackbar("Exception", e.toString());
    }
  }

  Future<void> uploadExpense(BuildContext context) async {
    showLoading(context);
    try {
      final uri = Uri.parse('${dotenv.env['BASE_URL']}/api/api/expence');

      final token = await TokenManager.getToken();

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
      final companyId = decodedToken['companyId'];
      final branchId = decodedToken['branchId'];
      final supervisorId = decodedToken['supervisorId'];
      final salesmanId = decodedToken['id'];

      final response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(<String, dynamic>{
          'salesmanId': salesmanId,
          'companyId': companyId,
          'branchId': branchId,
          'supervisorId': supervisorId,
          'status': expenseToEdit.value!.status,
          'deliveryDate': tillDate.value?.toIso8601String(),
          'amount': amount.text,
          'billDoc': file.value,
          'date': tillDate,
          'expenceDescription': description.text,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        controller.getExpenses();
        Get.snackbar("Success", "Order info submitted");
      } else {
        Navigator.of(context).pop();
        print("❌ Order submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
      // isLoading.value = false;
      Navigator.of(context).pop();
      print("⚠️ Exception in posting qr: $e");
      Get.snackbar("Exception", e.toString());
    }
  }

  void getExpenseTypeForDropDown() async {
    isLoading.value = true;
    try {
      final token = await TokenManager.getToken();

      if (token == null || token.isEmpty) {
        Get.snackbar("Auth Error", "Token not found");
        return;
      }

      final url = Uri.parse('${dotenv.env['BASE_URL']}/api/api/expencetype');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print(jsonData);
        final List<dynamic> dataList = jsonData['data'];
        print("expensetypeList ========>>>>>> $dataList");
        final downloadedExpenseTypes =
            dataList.map((item) => ExpenseType.fromJson(item)).toList();
        expenseTypeList.assignAll(downloadedExpenseTypes);
        dropdownValue.value = expenseTypeList[0];
        isLoading.value = false;
      } else {
        expenseTypeList.clear();
        Get.snackbar("Error connect",
            "Failed to Connect to DB (Code: ${response.statusCode})");

        isLoading.value = false;
      }
    } catch (e) {
      expenseTypeList.clear();
      // Get.snackbar("Exception", e.toString());
      Get.snackbar("Exception", "Couldn't get expense types");
    } finally {
      isLoading.value = false;
    }
  }
}
