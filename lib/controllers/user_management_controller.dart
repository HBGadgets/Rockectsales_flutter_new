import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/salesman_model.dart';
import '../screens/admin/user/user registration/User_Registration_Screen.dart';
import '../service_class/common_service.dart';

class UserManagementController extends GetxController {
  var salesmenList = <Salesmandata>[].obs;
  var filteredSalesmenList = <Salesmandata>[].obs;
  var isLoading = false.obs;
  var imageUrl = ''.obs;
  var userName = 'Karan Sharma'.obs;
  var searchText = ''.obs;
  var selectedSalesman = Rxn<Salesmandata>();

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final roleController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchSalesmen();
    ever(searchText, (_) => filterSalesmen());
  }

  Future<void> fetchSalesmen() async {
    try {
      isLoading(true);
      final response = await ApiServiceCommon.request(
        method: 'GET',
        endpoint: '/api/salesman',
      );

      final result = Salesman_model.fromJson(response);
      salesmenList.value = result.salesmandata ?? [];
      filteredSalesmenList.value = salesmenList;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch salesmen: $e");
    } finally {
      isLoading(false);
    }
  }

  void filterSalesmen() {
    final query = searchText.value.trim().toLowerCase();

    if (query.isEmpty) {
      filteredSalesmenList.value = salesmenList;
    } else {
      filteredSalesmenList.value = salesmenList.where((s) {
        final name = s.salesmanName?.toLowerCase() ?? '';
        final email = s.salesmanEmail?.toLowerCase() ?? '';
        final phone = s.salesmanPhone?.toLowerCase() ?? '';
        return name.contains(query) ||
            email.contains(query) ||
            phone.contains(query);
      }).toList();
    }
  }

  void selectSalesman(Salesmandata salesman) {
    selectedSalesman.value = salesman;
    setSalesmanDataToFields(salesman);
  }

  void setSalesmanDataToFields(Salesmandata salesman) {
    nameController.text = salesman.salesmanName ?? '';
    usernameController.text = salesman.username ?? '';
    passwordController.text = salesman.password ?? '';
    emailController.text = salesman.salesmanEmail ?? '';
    phoneController.text = salesman.salesmanPhone ?? '';
    roleController.text = salesman.role?.toString() ?? '';
  }

  void updateSearchText(String query) {
    searchText.value = query;
  }

  Future<void> updateSalesman({
    required String id,
    required String name,
    required String email,
    required String username,
    required String password,
    required String phone,
    required String role,
  }) async {
    try {
      final response = await ApiServiceCommon.request(
        method: 'PUT',
        endpoint: '/api/salesman/$id',
        payload: {
          "salesmanName": name,
          "salesmanEmail": email.trim(),
          "username": username,
          "password": password,
          "salesmanPhone": phone,
        },
      );

      Get.snackbar(
        'Success',
        response['message'] ?? 'Salesman updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      fetchSalesmen();
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteSalesman(String salesmanId) async {
    try {
      await ApiServiceCommon.request(
        method: 'DELETE',
        endpoint: '/api/salesman/$salesmanId',
      );

      Get.snackbar(
        'Deleted',
        'Salesman deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      fetchSalesmen();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete salesman: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> refreshSalesmen() async {
    await fetchSalesmen();
    filterSalesmen();
  }

  void onBoxButtonPressed() {
    Get.to(() => UserRegistrationScreen());
  }

  void onFirstButtonPressed({
    required String id,
    required String name,
    required String email,
    required String username,
    required String password,
    required String phone,
    required String role,
  }) {
    updateSalesman(
      id: id,
      name: name,
      email: email,
      username: username,
      password: password,
      phone: phone,
      role: role,
    );
  }

  void onSecondButtonPressed(String salesmanId) {
    deleteSalesman(salesmanId);
  }
}
