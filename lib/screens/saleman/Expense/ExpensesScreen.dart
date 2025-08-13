import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:rocketsale_rs/screens/saleman/Expense/FilterExpensesBar.dart';

import '../../../resources/my_colors.dart';
import 'ExpensesController.dart';

class Expensesscreen extends StatelessWidget {
  Expensesscreen({super.key});

  final ExpensesController controller = Get.put(ExpensesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expenses',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: MyColor.dashbord,
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
        child: Column(
          children: [
            // SizedBox(height: size.width * 0.02),
            FilterExpensesBar(),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.expensesList.isEmpty) {
                  return const Center(child: Text("No attendance data found."));
                } else {
                  return RefreshIndicator(
                    onRefresh: () async => controller.refreshExpenses(),
                    child: ListView.builder(
                      itemCount: controller.expensesListFromSearch.length,
                      itemBuilder: (context, index) {
                        final item = controller.expensesListFromSearch[index];
                        return Text(item.expenceDescription);
                      },
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}
