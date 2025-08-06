import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsale_rs/resources/my_font.dart';
import '../../../controllers/user_list_controller.dart';
import '../../../resources/my_colors.dart';
import '../../../resources/my_assets.dart';
import '../../../utils/widgets/admin_app_bar.dart';
import 'live tracking/Live_Tracking_Screen.dart';

class UserListScreen extends StatelessWidget {
  UserListScreen({Key? key}) : super(key: key);

  final UserListController controller = Get.put(UserListController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white, // Change your color here
        ),
        title: const Text('Track Status', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.dashbord,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search by name or username',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              return RefreshIndicator(
                onRefresh: () async {
                  controller.refreshData();
                },
                child: controller.filteredData.isEmpty
                    ? Center(child: Text('No users found'))
                    : ListView.builder(
                        itemCount: controller.filteredData.length,
                        itemBuilder: (context, index) {
                          var user = controller.filteredData[index];
                          if (user is! Map) return const SizedBox.shrink();

                          String salesmanName =
                              user['salesmanName'] ?? "Unknown";
                          String username = user['username'] ?? "Unknown";
                          String userId = user['_id'] ?? "Unknown";
                          String? profileImage = user['profileImage'];
                          String speed = user['speed']?.toString() ?? "N/A";
                          String timestamp =
                              user['timestamp']?.toString() ?? "N/A";
                          String address = controller.addressMap[userId] ??
                              "Fetching location...";

                          return Container(
                            height: size.height * 0.25,
                            child: InkWell(
                              onTap: () {
                                if (username != "Unknown") {
                                  Get.to(() =>
                                      LiveTrackingScreen(username: username));
                                }
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Card(
                                color: Colors.white,
                                margin: EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: profileImage !=
                                                        null &&
                                                    profileImage.isNotEmpty &&
                                                    Uri.tryParse(profileImage)
                                                            ?.hasAbsolutePath ==
                                                        true
                                                ? NetworkImage(profileImage)
                                                : const AssetImage(
                                                        "assets/images/Rectangle 24.png")
                                                    as ImageProvider,
                                            radius: 25,
                                          ),
                                          SizedBox(width: size.width * 0.01),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 8.0),
                                                child: Text(
                                                  salesmanName,
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.03,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        MyFont.interBold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Image(
                                                image: meater,
                                                height: size.height * 0.028),
                                          ),
                                          SizedBox(width: size.width * 0.03),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Text(
                                              speed,
                                              style: TextStyle(
                                                fontSize: size.height * 0.015,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: MyFont.interLight,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Image(
                                                image: clock,
                                                height: size.height * 0.028),
                                          ),
                                          SizedBox(width: size.width * 0.03),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Text(
                                              timestamp,
                                              style: TextStyle(
                                                fontSize: size.height * 0.015,
                                                fontWeight: FontWeight.normal,
                                                fontFamily: MyFont.interLight,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: size.height * 0.01),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Image(
                                                image: location,
                                                height: size.height * 0.028),
                                          ),
                                          SizedBox(width: size.width * 0.03),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 13.0),
                                              child: Text(
                                                address,
                                                style: TextStyle(
                                                  fontSize: size.height * 0.015,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: MyFont.interLight,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
