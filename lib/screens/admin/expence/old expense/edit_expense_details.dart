import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../controllers/manage_expense_controller.dart';

class EditExpense extends StatelessWidget {
  final String expenseId;

  EditExpense({super.key, required this.expenseId});

  final controller = Get.put(ManageExpenseController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upadate Task'),
      ),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Obx(() => SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Fill details below :",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 20),
                    const Text("Empolyee Name :",
                        style: TextStyle(fontSize: 16)),
                    TextField(
                      controller: controller.EmpolyName,
                      keyboardType: TextInputType.text,
                      decoration:
                          const InputDecoration(hintText: "your name..."),
                    ),
                    const SizedBox(height: 12),
                    const Text("Expense Type ", style: TextStyle(fontSize: 16)),
                    Obx(() => DropdownButton<String>(
                          isExpanded: true,
                          value: controller.selectedExpenseType.value.isEmpty
                              ? null
                              : controller.selectedExpenseType.value,
                          hint: const Text("Select Expense Type"),
                          items: controller.expenseTypeList.map((type) {
                            return DropdownMenuItem(
                              value: type.name,
                              child: Text(type.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            controller.selectedExpenseType.value = value!;
                          },
                        )),
                    const SizedBox(height: 12),
                    const Text("Description :", style: TextStyle(fontSize: 16)),
                    TextField(
                      controller: controller.descriptionController,
                      decoration: const InputDecoration(
                        hintText: "Enter Expense Description",
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text("Amount :", style: TextStyle(fontSize: 16)),
                    TextField(
                      controller: controller.amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(hintText: "amount..."),
                    ),
                    const SizedBox(height: 12),
                    const Text("Date :", style: TextStyle(fontSize: 16)),
                    InkWell(
                      onTap: () => controller.pickFromDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          controller.fromDate.value != null
                              ? DateFormat('dd-MM-yyyy')
                                  .format(controller.fromDate.value!)
                              : 'Select Date',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            controller.resetFields();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Reset",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                        SizedBox(width: 20),
                        Expanded(
                          child: Obx(() => GestureDetector(
                                onTap: controller.isLoading.value
                                    ? null // disables button when loading
                                    : () {
                                        controller.updateExpense(expenseId);
                                        print("${expenseId}");
                                      },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade700,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  alignment: Alignment.center,
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2),
                                        )
                                      : const Text(
                                          "Update",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text("$title :", style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
