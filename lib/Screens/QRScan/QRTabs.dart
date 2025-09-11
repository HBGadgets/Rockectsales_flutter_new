import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../resources/my_colors.dart';
import 'QRController.dart';
import 'QRScan.dart';
import 'QRScanHistory.dart';

class Qrtabs extends StatefulWidget {
  const Qrtabs({super.key});

  @override
  State<Qrtabs> createState() => _QrtabsState();
}

class _QrtabsState extends State<Qrtabs> with TickerProviderStateMixin {
  // final QRCardsController controller = Get.put(QRCardsController());

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    int initialIndex = Get.arguments ?? 0;
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    // Get.delete<QRCardsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          'QR',
          style: TextStyle(color: Colors.white),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.white),
          tabs: <Widget>[
            Tab(
              child: Text(
                'QR Scan',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: getResponsiveFontSize(context, 12.0)),
              ),
            ),
            Tab(
              child: Text(
                'Scan History',
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: getResponsiveFontSize(context, 12.0)),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          const QrscanScreen(),
          Qrscanhistory(),
        ],
      ),
    );
  }

  double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double referenceWidth = 375.0; // iPhone 8 width
    return baseFontSize * (screenWidth / referenceWidth);
  }
}
