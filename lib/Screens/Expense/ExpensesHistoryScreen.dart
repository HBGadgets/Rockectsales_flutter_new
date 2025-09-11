import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../../resources/my_colors.dart';
import 'CreateAndEditExpense/CreateAndEditExpenseScreen.dart';
import 'ExpensesCard.dart';
import 'ExpensesController.dart';
import 'FilterExpensesBar.dart';

class ExpensesHistoryScreen extends StatefulWidget {
  const ExpensesHistoryScreen({super.key});

  @override
  State<ExpensesHistoryScreen> createState() => _ExpensesHistoryScreenState();
}

class _ExpensesHistoryScreenState extends State<ExpensesHistoryScreen> {
  final ExpensesController controller = Get.put(ExpensesController());

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreExpensesCards();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    Get.delete<ExpensesController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(CreateAndEditExpenseScreen(), arguments: {
            "screenType": "edit",
          });
        },
        icon: const Icon(Icons.add),
        // Optional icon
        label: const Text('Create Expense'),
        // The text label
        backgroundColor: MyColor.dashbord,
        // Optional background color
        foregroundColor: Colors.white, // Optional text and icon color
      ),
      appBar: AppBar(
        title: const Text(
          "Expenses",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: MyColor.dashbord,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8),
              child: FiltrationsystemExpenses(),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: MyColor.dashbord,
                  ));
                } else if (controller.expenses.isEmpty) {
                  return const Center(child: Text("No Expenses found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      controller.getExpenses();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.expenses.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.expenses.length) {
                          final item = controller.expenses[index];
                          return ExpenseCard(
                            expense: item,
                          );
                        } else {
                          if (controller.isMoreCardsAvailable.value) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: MyColor.dashbord,
                                ),
                              ),
                            );
                          } else {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Center(child: Text('')),
                            );
                          }
                        }
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
