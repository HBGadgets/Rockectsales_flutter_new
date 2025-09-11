import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../../../resources/my_colors.dart';
import '../../../TokenManager.dart';
import '../ExpenseModel.dart';
import '../ExpensesController.dart';

class CreateEditExpenseController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<ExpenseType> expenseTypeList = <ExpenseType>[].obs;

  final TextEditingController amount = TextEditingController();

  final TextEditingController description = TextEditingController();

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

      var request = http.MultipartRequest("POST", uri);
      request.headers['Authorization'] = 'Bearer $token';

      // Add fields
      request.fields['expenceType'] = dropdownValue.value!.expenceType;
      request.fields['salesmanId'] = salesmanId;
      request.fields['companyId'] = companyId;
      request.fields['branchId'] = branchId;
      request.fields['supervisorId'] = supervisorId;
      request.fields['deliveryDate'] = tillDate.value?.toIso8601String() ?? "";
      request.fields['amount'] = amount.text;
      request.fields['date'] = tillDate.value?.toIso8601String() ?? "";
      request.fields['expenceDescription'] = description.text;

      // Attach file if exists
      if (file.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'billDoc', // field name expected by backend
            file.value!.path,
          ),
        );
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      Navigator.of(context).pop(); // close loading dialog

      if (response.statusCode == 201) {
        Navigator.of(context).pop(); // go back
        controller.getExpenses();
        Get.snackbar("Success", "Expense submitted");
      } else {
        print("❌ Order submission Failed: ${response.body}");
        Get.snackbar("Error", response.body);
      }
    } catch (e) {
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
