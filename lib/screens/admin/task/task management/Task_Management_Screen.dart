import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import '../../../../controllers/task_management_controller.dart';
import '../../../../resources/my_assets.dart';
import '../../../../utils/widgets/admin_app_bar.dart';

class TaskManagementScreen extends StatelessWidget {
  TaskManagementScreen({super.key});

  final TaskManagementController controller =
      Get.put(TaskManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white, // Change your color here
        ),
        title: const Text('Task Management', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.dashbord,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          }

          if (controller.salesmanList.isEmpty) {
            return Center(child: Text("No salesmen found."));
          }

          return ListView.builder(
            itemCount: controller.salesmanList.length,
            itemBuilder: (context, index) {
              var salesman = controller.salesmanList[index];
              return GestureDetector(
                onTap: () => controller.onSalesmanTap(salesman.sId),
                child: CustomContainer(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            profile, // Replace with actual image logic
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        // This ensures the column does not overflow
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Name: ${salesman.salesmanName ?? 'N/A'}",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis),
                            // Prevents overflow
                            SizedBox(height: 5),
                            Text("Email: ${salesman.salesmanEmail ?? 'N/A'}",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                                overflow: TextOverflow.ellipsis),
                            SizedBox(height: 5),
                            Text("Phone: ${salesman.salesmanPhone ?? 'N/A'}",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54),
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? margin;

  const CustomContainer({Key? key, required this.child, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
