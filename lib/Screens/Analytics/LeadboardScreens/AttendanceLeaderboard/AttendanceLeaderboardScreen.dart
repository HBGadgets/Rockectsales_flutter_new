import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../resources/my_colors.dart';
import '../../../Attendance/NewAttendanceController.dart';
import 'FiltrationSystemAttendancePerformer.dart';
import 'AttendanceLeaderboardCard.dart';
import 'AttendanceLeaderboardController.dart';

class AttendanceLeaderBoardScreen extends StatefulWidget {
  const AttendanceLeaderBoardScreen({super.key});

  @override
  State<AttendanceLeaderBoardScreen> createState() => _AttendanceLeaderBoardScreenState();
}

class _AttendanceLeaderBoardScreenState extends State<AttendanceLeaderBoardScreen> {
  final NewAttendanceController attendanceController =
  Get.find<NewAttendanceController>();
  final AttendanceLeaderboardController controller = Get.put(AttendanceLeaderboardController());

  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreAttendancePerformerCards();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    Get.delete<AttendanceLeaderboardController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Attendance Leaderboard",
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
              child: FiltrationSystemAttendancePerformers(),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(
                        color: MyColor.dashbord,
                      ));
                } else if (controller.attendancePerformers.isEmpty) {
                  return const Center(child: Text("No Attendance Performers found."));
                } else {
                  return RefreshIndicator(
                    backgroundColor: Colors.white,
                    color: MyColor.dashbord,
                    onRefresh: () async {
                      controller.getAttendancePerformers();
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.attendancePerformers.length + 1,
                      itemBuilder: (context, index) {
                        if (index < controller.attendancePerformers.length) {
                          final item = controller.attendancePerformers[index];
                          return AttendanceLeaderBoardCard(
                            attendancePerformer: item,
                            isCrown: index == 0,
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
