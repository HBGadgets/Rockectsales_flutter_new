import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../resources/my_colors.dart';
import '../ExpenseModel.dart';
import '../ExpensesController.dart';
import 'CreateEditExpenseController.dart';

class CreateAndEditExpenseScreen extends StatefulWidget {
  final Expense? expense;

  CreateAndEditExpenseScreen({super.key, this.expense});

  @override
  State<CreateAndEditExpenseScreen> createState() =>
      _CreateAndEditExpenseScreenState();
}

class _CreateAndEditExpenseScreenState
    extends State<CreateAndEditExpenseScreen> {
  final CreateEditExpenseController controller =
      Get.put(CreateEditExpenseController());

  final ExpenseInfoFormKey = GlobalKey<FormState>();

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );

    if (result != null && result.files.single.path != null) {
      controller.file.value = File(result.files.single.path!);
    }
  }

  Future<void> _selectTillDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      // initialDate: fromDate ?? DateTime.now(),
      initialDate: controller.tillDate.value ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: MyColor.dashbord,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      // setState(() {
      //   tillDate = picked;
      // });
      controller.tillDate.value = picked;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Expense",
            style: TextStyle(color: Colors.white),
          ),
          leading: const BackButton(
            color: Colors.white,
          ),
          backgroundColor: MyColor.dashbord,
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
                child: CircularProgressIndicator(
              color: MyColor.dashbord,
            ));
          } else {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                    key: ExpenseInfoFormKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Order Info:",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        buildLabel("Expense type"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownMenu<ExpenseType>(
                            initialSelection: controller.dropdownValue.value,
                            onSelected: (ExpenseType? value) {
                              controller.dropdownValue.value = value!;
                            },
                            dropdownMenuEntries: controller.expenseTypeList
                                .map((expenseType) =>
                                    DropdownMenuEntry<ExpenseType>(
                                      value: expenseType,
                                      label: expenseType.expenceType,
                                    ))
                                .toList(),
                          ),
                        ),
                        buildLabel("Description"),
                        buildTextEditField(controller.description),
                        buildLabel("Bill of expense"),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColor.dashbord,
                            foregroundColor: Colors.white
                          ),
                          onPressed: pickFile,
                          child: Text("Pick"),
                        ),
                        if (controller.file.value != null) ...[
                          Text(
                              "Selected: ${controller.file.value!.path.split('/').last}"),
                          if (controller.file.value!.path.endsWith(".pdf"))
                            const Icon(Icons.picture_as_pdf,
                                size: 40, color: Colors.red)
                          else
                            Image.file(
                              controller.file.value!,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                        ],
                        buildLabel("Date:"),
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
                        buildLabel("Amount:"),
                        buildTextEditField(controller.amount, inputType: TextInputType.number),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MyColor.dashbord,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16), // optional for taller button
                              ),
                              onPressed: () {
                                controller.uploadExpense(context);
                              },
                              child: const Text(
                                "Submit",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),

                      ],
                    )),
              ),
            );
          }
        }));
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
      keyboardType: inputType,
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
