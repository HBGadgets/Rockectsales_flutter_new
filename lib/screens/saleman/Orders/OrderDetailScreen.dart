import 'package:flutter/material.dart';

import '../../../resources/my_colors.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Orders",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: MyColor.dashbord,
      ),
    );
  }
}
