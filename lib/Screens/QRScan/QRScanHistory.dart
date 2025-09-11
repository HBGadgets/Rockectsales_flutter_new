import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../resources/my_colors.dart';
import 'FiltrationSystemQR.dart';
import 'QRCard.dart';
import 'QRController.dart';
import 'QRInformationScreen.dart';

class Qrscanhistory extends StatefulWidget {
  Qrscanhistory({super.key});

  @override
  State<Qrscanhistory> createState() => _QrscanhistoryState();
}

class _QrscanhistoryState extends State<Qrscanhistory> {
  // final QRCardsController controller = Get.put(QRCardsController());
  final QRCardsController controller =
      Get.put(QRCardsController(), permanent: false);
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('reached end');
        controller.isMoreCardsAvailable.value = true;
        controller.getMoreQrCards();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    Get.delete<QRCardsController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          const FiltrationsystemQR(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: MyColor.dashbord,
                ));
              } else if (controller.qrCards.isEmpty) {
                return const Center(child: Text("No QR Scan history found."));
              } else {
                return RefreshIndicator(
                  backgroundColor: Colors.white,
                  color: MyColor.dashbord,
                  onRefresh: () async {
                    controller.getQRCards();
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: controller.qrCards.length + 1,
                    itemBuilder: (context, index) {
                      if (index < controller.qrCards.length) {
                        final item = controller.qrCards[index];
                        return Qrcard(
                          cardIdString: item.qrId ?? '',
                          cardNameString: item.cardTitle ?? '',
                          date: item.dateTime ?? '',
                          time: item.dateTime ?? '',
                          addressString: item.addressString ?? '',
                          cardObjectId: item.qrObjectId ?? '',
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
    );
  }
}
