import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../resources/my_colors.dart';
import 'FiltrationSystemOrderPerformer.dart';
import 'OrderLeaderboardCard.dart';
import 'OrderLeaderboardController.dart';

class OrderLeaderBoardScreen extends StatefulWidget {
  const OrderLeaderBoardScreen({super.key});

  @override
  State<OrderLeaderBoardScreen> createState() => _OrderLeaderBoardScreenState();
}

class _OrderLeaderBoardScreenState extends State<OrderLeaderBoardScreen> {
  final OrderLeaderboardController controller = Get.put(OrderLeaderboardController());

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreOrderPerformerCards();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    Get.delete<OrderLeaderboardController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Leaderboard",
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
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: FiltrationSystemOrderPerformers(),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: MyColor.dashbord,
                      ));
                } else if (controller.orderPerformers.isEmpty) {
                  return const Center(child: Text("No Order Performers found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      controller.getOrderPerformers();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.orderPerformers.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.orderPerformers.length) {
                          final item = controller.orderPerformers[index];
                          return OrderPerformerCard(
                            orderPerformer: item,
                            crown: index == 0,
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
