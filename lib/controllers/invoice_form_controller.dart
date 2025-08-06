import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

class InvoiceFormController extends GetxController {
  // Controllers
  final customerNameController = TextEditingController();
  final customerAddressController = TextEditingController();
  final companyNameController = TextEditingController();
  final companyAddressController = TextEditingController();
  final itemNameController = TextEditingController();
  final quantityController = TextEditingController();
  final gstController = TextEditingController();
  final hsnController = TextEditingController();
  final discountController = TextEditingController();
  final unitPriceController = TextEditingController();
  final dateController = TextEditingController();

  var selectedPDFPath = ''.obs;

  void pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.isNotEmpty) {
        selectedPDFPath.value = result.files.first.path ?? '';
        print('PDF selected: ${selectedPDFPath.value}');
      } else {
        print('No PDF selected');
      }
    } catch (e) {
      print('Error picking PDF: $e');
    }
  }

  void selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerAddressController.dispose();
    companyNameController.dispose();
    companyAddressController.dispose();
    itemNameController.dispose();
    quantityController.dispose();
    gstController.dispose();
    hsnController.dispose();
    discountController.dispose();
    unitPriceController.dispose();
    dateController.dispose();
    super.dispose();
  }
}
