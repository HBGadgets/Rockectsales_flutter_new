import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../models/expense/expenseList.dart';
import '../ExpensesController.dart';

class CreateAndEditExpenseScreen extends StatelessWidget {
  final Expense? expense;

  CreateAndEditExpenseScreen({super.key, this.expense});

  final ExpensesController controller = Get.put(ExpensesController());

  final ExpenseInfoFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
          key: ExpenseInfoFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Order Info:",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              buildLabel("Shop Name:"),
              buildTextEditField(controller.shopName),
              buildLabel("Shop Owner Name:"),
              buildTextEditField(controller.shopOwnerName),
              buildLabel("Delivery by:"),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  side: const BorderSide(color: Colors.black54),
                ),
                onPressed: () => _selectTillDate(context),
                icon: const Icon(
                  Icons.date_range,
                  color: Colors.black,
                ),
                label: Text(
                  controller.tillDate.value != null
                      ? DateFormat('dd/MM/yyyy')
                          .format(controller.tillDate.value!)
                      : "N/A",
                  style: const TextStyle(color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              buildLabel("Address:"),
              buildTextEditField(controller.address),
              buildLabel("Phone No. :"),
              buildTextEditField(controller.phoneNo),
            ],
          )),
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget buildTextEditField(TextEditingController controller,
      {String hint = "",
      TextInputType inputType = TextInputType.text,
      bool isDisabled = false}) {
    return TextFormField(
      readOnly: isDisabled,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        hint: Text(hint),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: MyColor.dashbord, width: 2), // On focus
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          // Default border color
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
