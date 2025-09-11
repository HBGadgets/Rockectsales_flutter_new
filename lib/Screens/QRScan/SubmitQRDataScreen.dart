import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:rocketsales/Screens/QRScan/SubmitQRDataScreenController.dart';

import '../../resources/my_colors.dart';
import '../SalesmanDashboard/SalesmanDashboardScreen.dart';
import 'QRController.dart';
import 'QRModel.dart';
import 'QRQuestion.dart';
import 'SelfieTakingScreen.dart';

class Submitqrdatascreen extends StatefulWidget {
  final cardNameString;
  final cardIdString;
  final questionSetId;

  Submitqrdatascreen(
      {super.key, required this.cardNameString, required this.cardIdString, required this.questionSetId});

  @override
  State<Submitqrdatascreen> createState() => _SubmitqrdatascreenState();
}

class _SubmitqrdatascreenState extends State<Submitqrdatascreen> {
  // final addressString;
  final Submitqrdatascreencontroller submitController = Get.put(Submitqrdatascreencontroller());
  final QRCardsController controller = Get.find<QRCardsController>();

  @override
  void dispose() {
    controller.salesManSelfie.value = null;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColor.dashbord,
        title: const Text(
          'Submit Information',
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(17.0),
          child: Obx(() {
            if (controller.addressString.value.isEmpty) {
              controller.getAddress();
            }
            if (controller.isLoading.value || submitController.isLoadingQuestions.value) {
              return const AlertDialog(
                backgroundColor: Colors.white,
                content: Center(
                  child: CircularProgressIndicator(
                    color: MyColor.dashbord,
                  ),
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "QR code Submission",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            "Complete your submission by capturing required photo",
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 8, right: 4, left: 4),
                          child: Container(
                            width: double.infinity, // 👈 full width container
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Center(
                              // 👈 centers the button
                              child: controller.salesManSelfie.value != null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 160,
                                          // same as diameter of CircleAvatar (radius * 2)
                                          height: 160,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.green,
                                              // border color
                                              width: 2, // border width
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius:
                                                80, // half of container size
                                            backgroundImage: FileImage(
                                              controller.salesManSelfie.value!,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(7),
                                          child: TextButton.icon(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: MyColor.dashbord,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Selfietakingscreen(),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.camera_alt_outlined,
                                                size: 20),
                                            label: const Text(
                                              'Retake',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Selfietakingscreen(),
                                              ),
                                            );
                                          },
                                          style: OutlinedButton.styleFrom(
                                              minimumSize: const Size(100,
                                                  100), // 👈 button's own size
                                              side: const BorderSide(
                                                  color: Colors.white70),
                                              backgroundColor: Colors.black12),
                                          child: const Icon(
                                            Icons.person_2_outlined,
                                            color: Colors.black45,
                                            size: 45,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(7),
                                          child: TextButton.icon(
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: MyColor.dashbord,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Selfietakingscreen(),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                                Icons.camera_alt_outlined,
                                                size: 20),
                                            label: const Text(
                                              'Start Camera',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "QR ID:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.cardIdString,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Date:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                controller
                                    .formattedDate(DateTime.now().toString()),
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Time:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                controller
                                    .formattedTime(DateTime.now().toString()),
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Commodity no:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.cardNameString,
                            style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Address:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Obx(() {
                            final isGettingLocation =
                                controller.gettingLocation.value;
                            if (isGettingLocation) {
                              return const CircularProgressIndicator(
                                color: MyColor.dashbord,
                              );
                            } else {
                              return Text(
                                controller.addressString.value,
                                style: const TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              );
                            }
                          })
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Questions:",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Obx(() {
                            if (submitController.qrQuestions.isEmpty) {
                              return const Text("No questions available");
                            }

                            return Column(
                              children: submitController.qrQuestions.map((q) {
                                return QRQuestion(
                                  question: q,
                                  onAnswer: (value) {
                                    // Update or add answer
                                    final existing = controller.answers.indexWhere((a) => a.question == q.text);
                                    if (existing >= 0) {
                                      controller.answers[existing] = AnsweredQuestion(
                                        question: q.text ?? "",
                                        answer: value,
                                      );
                                    } else {
                                      controller.answers.add(AnsweredQuestion(
                                        question: q.text ?? "",
                                        answer: value,
                                      ));
                                    }
                                  },
                                );
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          side: BorderSide(color: Colors.red))),
                                  backgroundColor: WidgetStateProperty.all(
                                      Colors.redAccent)),
                              onPressed: () {
                                // Navigator.pop(context);
                                controller.salesManSelfie.value = null;
                                Navigator.pushAndRemoveUntil<dynamic>(
                                    context,
                                    MaterialPageRoute<dynamic>(
                                      builder: (BuildContext context) =>
                                          DashboardSalesman(),
                                    ),
                                    (Route<dynamic> route) =>
                                        false //if you want to disable back feature set to false
                                    );
                              },
                              child: const Text('Cancel',
                                  style: TextStyle(color: Colors.white))),
                        ),
                        const SizedBox(width: 8),
                        Obx(() {
                          final isGettingLocation =
                              controller.gettingLocation.value;
                          return Expanded(
                              child: ElevatedButton(
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        side: BorderSide(color: Colors.green))),
                                backgroundColor: isGettingLocation ||
                                        controller.salesManSelfie.value == null
                                    ? WidgetStateProperty.all(Colors.grey)
                                    : WidgetStateProperty.all(Colors.green)),
                            onPressed: isGettingLocation ||
                                    controller.salesManSelfie.value == null
                                ? null
                                : () {
                                    controller.postQR(
                                      boxNumber: widget.cardNameString,
                                      qrID: widget.cardIdString,
                                      context: context,
                                    );
                                  },
                            child: const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                          ));
                        })
                      ],
                    ),
                    // Spacer(),
                  ],
                ),
              );
            }
          })),
    );
  }
}
