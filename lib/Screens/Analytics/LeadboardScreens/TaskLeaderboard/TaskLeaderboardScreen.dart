import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rocketsales/Screens/Analytics/LeadboardScreens/TaskLeaderboard/TaskLeaderboardCard.dart';
import 'package:rocketsales/Screens/Analytics/LeadboardScreens/TaskLeaderboard/TaskLeaderboardController.dart';

import '../../../../resources/my_colors.dart';
import 'FiltrationSystemTaskPerformers.dart';

class TaskLeaderBoardScreen extends StatefulWidget {
  const TaskLeaderBoardScreen({super.key});

  @override
  State<TaskLeaderBoardScreen> createState() => _TaskLeaderBoardScreenState();
}

class _TaskLeaderBoardScreenState extends State<TaskLeaderBoardScreen> {
  final TaskLeaderboardController controller = Get.put(TaskLeaderboardController());

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreTaskPerformerCards();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    Get.delete<TaskLeaderboardController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Task Leadboard",
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
              child: FiltrationSystemtaskPerformers(),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: MyColor.dashbord,
                      ));
                } else if (controller.taskPerformers.isEmpty) {
                  return const Center(child: Text("No Tasks found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      controller.getTaskPerformers();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.taskPerformers.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.taskPerformers.length) {
                          final item = controller.taskPerformers[index];
                          return TaskPerformerCard(
                            taskPerformer: item,
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
