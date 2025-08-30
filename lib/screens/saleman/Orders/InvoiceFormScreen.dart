import 'package:flutter/material.dart';

import '../../../resources/my_colors.dart';

class InvoiceFormScreen extends StatelessWidget {
  const InvoiceFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Invoice",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(color: Colors.white),
        backgroundColor: MyColor.dashbord,
      ),
    );
  }
}
