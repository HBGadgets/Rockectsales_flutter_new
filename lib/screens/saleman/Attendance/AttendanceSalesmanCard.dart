import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../resources/my_colors.dart';
import 'AttendanceSalesManController.dart';

class Attendancecard extends StatelessWidget {
  Attendancecard({super.key});

  final AttendanceSalesmanController controller =
      Get.put(AttendanceSalesmanController());

  @override
  Widget build(BuildContext context) {
    if (controller.addressString.value.isEmpty) {
      controller.getAddress();
    }
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: Colors.black12, // border color
          width: 2, // border thickness
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Row(
              children: [
                controller.salesManSelfie.value != null
                    ? CircleAvatar(
                        radius: 80, // half of container size
                        backgroundImage: FileImage(
                          controller.salesManSelfie.value!,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         const Selfietakingscreen(),
                              //   ),
                              // );
                            },
                            style: OutlinedButton.styleFrom(
                                minimumSize:
                                    const Size(40, 80), // 👈 button's own size
                                side: const BorderSide(color: Colors.white70),
                                backgroundColor: Colors.black12),
                            child: const Icon(
                              Icons.person_2_outlined,
                              color: Colors.black45,
                              size: 45,
                            ),
                          ),
                        ],
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Obx(() {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Expanded(
                            child: Text(
                              softWrap: true,
                              maxLines: 4,
                              overflow: TextOverflow.visible,
                              controller.salesmanName.value,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: MyColor.dashbord,
                                  fontSize: 20),
                            ),
                          ),
                        );
                      }),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(
                              Icons.calendar_month,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                              '${controller.formattedTime(DateTime.now().toString())}, '),
                          Text(controller
                              .formattedDate(DateTime.now().toString()))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const Divider(
              color: Colors.black,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(Icons.location_on_outlined),
                ),
                Obx(() {
                  final isGettingLocation = controller.gettingLocation.value;
                  if (isGettingLocation) {
                    return const CircularProgressIndicator(
                      color: MyColor.dashbord,
                    );
                  } else {
                    return Expanded(
                      child: Text(
                        controller.addressString.value,
                        softWrap: true,
                        maxLines: 4,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                })
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the radius for desired roundness
                          ),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white),
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle_outline),
                          Text("Check in")
                        ],
                      )),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // Adjust the radius for desired roundness
                          ),
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white),
                      onPressed: () {},
                      child: const Row(
                        children: [Icon(Icons.output), Text("Check out")],
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the radius for desired roundness
                      ),
                      backgroundColor: MyColor.dashbord,
                      foregroundColor: Colors.white),
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Text(
                        "Apply for Leave",
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
