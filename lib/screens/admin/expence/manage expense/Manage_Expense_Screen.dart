import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import 'package:rocketsale_rs/screens/admin/expence/old%20expense/edit_expense_details.dart';
import '../../../../controllers/manage_expense_controller.dart';
import '../../../../controllers/user_management_controller.dart';
import '../../../../resources/my_assets.dart';
import '../../../../utils/widgets/admin_app_bar.dart';

class ManageExpenseScreen extends StatefulWidget {
  final String salesmanId;

  const ManageExpenseScreen({super.key, required this.salesmanId});

  @override
  State<ManageExpenseScreen> createState() => _ManageExpenseScreenState();
}

class _ManageExpenseScreenState extends State<ManageExpenseScreen> {
  final ManageExpenseController controller = Get.put(ManageExpenseController());
  final UserManagementController userController =
      Get.put(UserManagementController());

  final double radius = 40.0;

  @override
  void initState() {
    super.initState();
    controller.fetchExpenses(widget.salesmanId);
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white, // Change your color here
        ),
        title: const Text('Expense Management',
            style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.dashbord,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Search
              SizedBox(
                height: size.height * 0.05,
                child: TextField(
                  onChanged: userController.updateSearchText,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    hintStyle: TextStyle(fontSize: size.height * 0.017),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.015),

              // Salesmen Horizontal List
              SizedBox(
                height: size.height * 0.15,
                child: Obx(() => ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: userController.filteredSalesmenList.length,
                      itemBuilder: (context, index) {
                        final salesman =
                            userController.filteredSalesmenList[index];
                        final name = salesman.salesmanName ?? 'Salesman';
                        final isSelected = controller.userName.value == name;

                        return GestureDetector(
                          onTap: () {
                            controller.userName.value = name;
                            controller.selectedSalesmanId.value =
                                salesman.sId ?? '';
                            controller.fetchExpenses(salesman.sId ?? '');
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: radius,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage: controller
                                          .imageUrl.value.isNotEmpty
                                      ? NetworkImage(controller.imageUrl.value)
                                      : null,
                                  child: controller.imageUrl.value.isEmpty
                                      ? Image(image: profile)
                                      : null,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: size.height * 0.016,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ),
              const Divider(),

              // Manual Expense Section
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => Text(
                                controller.userName.value,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              )),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text("Manual Expense"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    const SizedBox(height: 16),

                    // Date Range
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.pickFromDate(context),
                            child: Obx(() {
                              final from = controller.fromDate.value;
                              final date = from != null
                                  ? DateFormat('dd-MM-yyyy').format(from)
                                  : 'From Date';
                              final time = from != null
                                  ? DateFormat('hh:mm a').format(from)
                                  : '--:--';
                              return _buildDateBox(date, time);
                            }),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => controller.pickToDate(context),
                            child: Obx(() {
                              final to = controller.toDate.value;
                              final date = to != null
                                  ? DateFormat('dd-MM-yyyy').format(to)
                                  : 'To Date';
                              final time = to != null
                                  ? DateFormat('hh:mm a').format(to)
                                  : '--:--';
                              return _buildDateBox(date, time);
                            }),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Obx(() {
                            final loading = controller.isLoading.value;

                            return GestureDetector(
                              onTap: loading ? null : controller.submitFilter,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 18),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade700,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: loading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        "Submit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Expense List
                    Obx(() {
                      if (controller.expenses.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Expenses Found",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.expenses.length,
                        itemBuilder: (context, index) {
                          final expense = controller.expenses[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🔹 Header Row
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Date",
                                        style: TextStyle(color: Colors.grey)),
                                    Text("Expense Type",
                                        style: TextStyle(color: Colors.grey)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Text(expense.date ?? '',
                                    //     style: const TextStyle(
                                    //         fontWeight: FontWeight.bold)),
                                    Text(expense.expenceType ?? '',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                const Text("Amount",
                                    style: TextStyle(color: Colors.grey)),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("₹ ${expense.amount}",
                                        style: const TextStyle(fontSize: 16)),
                                    if (expense.billDoc != null &&
                                        expense.billDoc!.isNotEmpty)
                                      OutlinedButton.icon(
                                        onPressed: () {
                                          // TODO: implement View Receipt
                                        },
                                        icon: const Icon(Icons.image, size: 16),
                                        label: const Text("View Receipt"),
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          side: BorderSide(
                                              color: Colors.grey.shade300),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 8),
                                          textStyle:
                                              const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                  ],
                                ),
                                Divider(
                                  height: 30,
                                  thickness: 1,
                                  color: Colors.grey.shade300,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        Get.to(EditExpense(
                                          expenseId: expense.id,
                                        ));
                                      },
                                      icon: const Icon(Icons.edit, size: 16),
                                      label: const Text("Edit Expense"),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        side: BorderSide(
                                            color: Colors.grey.shade300),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        textStyle:
                                            const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        Get.defaultDialog(
                                          title: "Confirm",
                                          middleText:
                                              "Are you sure you want to delete this expense?",
                                          textCancel: "Cancel",
                                          textConfirm: "Delete",
                                          confirmTextColor: Colors.white,
                                          onConfirm: () {
                                            Get.back(); // Close dialog
                                            controller
                                                .deleteExpense(expense.id);
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.delete, size: 16),
                                      label: const Text("Delete Expense"),
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        side: BorderSide(
                                            color: Colors.grey.shade300),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        textStyle:
                                            const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDateBox(String date, String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 14),
          const SizedBox(width: 6),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date,
                    style: const TextStyle(fontSize: 10),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(time,
                    style: const TextStyle(fontSize: 10),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
