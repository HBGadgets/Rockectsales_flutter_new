import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'FiltrationSystemTask.dart';
import 'TaskCard.dart';
import 'saleTask_controller.dart';
import '../../../resources/my_colors.dart';

class TaskManagementSalesMan extends StatefulWidget {
  const TaskManagementSalesMan({super.key});

  @override
  State<TaskManagementSalesMan> createState() => _TaskManagementSalesManState();
}

class _TaskManagementSalesManState extends State<TaskManagementSalesMan> {
  final TaskController controller = Get.put(TaskController());

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreTaskCards();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    Get.delete<TaskController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tasks",
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
            const Padding(
              padding: EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Filtrationsystemtask(),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: MyColor.dashbord,
                  ));
                } else if (controller.tasks.isEmpty) {
                  return const Center(child: Text("No Tasks found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      controller.getTasks();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.tasks.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.tasks.length) {
                          final item = controller.tasks[index];
                          return Taskcard(
                            task: item,
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
