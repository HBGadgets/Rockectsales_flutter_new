import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rocketsale_rs/resources/my_colors.dart';
import '../../../../controllers/user_management_controller.dart';
import '../../../../resources/my_assets.dart';
import '../../../../utils/widgets/admin_app_bar.dart';
import '../../dashboard_admin.dart';

class UserManagementScreen extends StatelessWidget {
  UserManagementScreen({super.key});

  final UserManagementController controller =
      Get.put(UserManagementController());
  final double radius = 40.0;

  TableRow _tableCell(String label, String value, Size size) {
    return TableRow(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.w600, fontSize: size.height * 0.015)),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(value, style: TextStyle(fontSize: size.height * 0.015)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white, // Change your color here
        ),
        title: const Text('User Management', style: TextStyle(color: Colors.white)),
        backgroundColor: MyColor.dashbord,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                height: size.height * 0.05,
                child: TextField(
                  onChanged: controller.updateSearchText,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    hintStyle: TextStyle(fontSize: size.height * 0.017),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.015),
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.15,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.filteredSalesmenList.length,
                        itemBuilder: (context, index) {
                          final salesman =
                              controller.filteredSalesmenList[index];
                          final name = salesman.salesmanName ?? 'Salesman';
                          final imageUrl = '';

                          final isSelected = controller.userName.value == name;

                          return GestureDetector(
                            onTap: () {
                              controller.selectedSalesman.value = salesman;
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: radius,
                                    backgroundColor: Colors.grey.shade300,
                                    backgroundImage:
                                        controller.imageUrl.value.isNotEmpty
                                            ? NetworkImage(
                                                controller.imageUrl.value)
                                            : null,
                                    child: controller.imageUrl.value.isEmpty
                                        ? Image(image: profile)
                                        : null,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: size.height * 0.016,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
              Container(
                width: size.width,
                child: TextButton(
                  onPressed: controller.onBoxButtonPressed,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.black),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  ),
                  child: Text(
                    'Register New User',
                    style: TextStyle(
                        fontSize: size.height * 0.016,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.015),
              Divider(),
              Obx(() {
                final salesman = controller.selectedSalesman.value;
                final idController =
                    TextEditingController(text: '${salesman?.sId}');
                final nameController = TextEditingController(
                    text: '${salesman?.salesmanName ?? 'N/A'}');
                final emailController = TextEditingController(
                    text: '${salesman?.salesmanEmail ?? 'N/A'}');
                final usernameController = TextEditingController(
                    text: '${salesman?.username ?? 'N/A'}');
                final passwordController = TextEditingController(
                    text: '${salesman?.password ?? 'N/A'}');
                final mobileController = TextEditingController(
                    text: '${salesman?.salesmanPhone ?? 'N/A'}');
                final roleController =
                    TextEditingController(text: '${salesman?.role ?? 'N/A'}');
                if (salesman == null) {
                  return Text("Please select a user to view details.");
                }

                return Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        salesman.salesmanName ?? 'Salesman',
                        style: TextStyle(
                            fontSize: size.height * 0.025,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "User Details",
                        style: TextStyle(
                            fontSize: size.height * 0.015,
                            color: Colors.black38),
                      ),
                      SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(
                          color: Colors.grey, // Border color
                          width: 1, // Border width
                        ),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                        },
                        children: [
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('ID')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: idController,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('Employee Name')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: nameController,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('Email')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: emailController,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('Username')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: usernameController,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('Password')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: passwordController,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('Mobile No.')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: mobileController,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text('Employee Role')),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: roleController,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    border: InputBorder.none),
                              ),
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(height: size.height * 0.015),
                      Text('Status',
                          style: TextStyle(fontSize: size.height * 0.015)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              controller.onFirstButtonPressed(
                                id: idController.text,
                                name: nameController.text,
                                email: emailController.text,
                                username: usernameController.text,
                                password: passwordController.text,
                                phone: mobileController.text,
                                role: roleController.text,
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Text('Update',
                                style:
                                    TextStyle(fontSize: size.height * 0.015)),
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            onPressed: () => controller
                                .onSecondButtonPressed("${salesman.sId}"),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                                side: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Text(
                              'Delete',
                              style: TextStyle(fontSize: size.height * 0.015),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
              SizedBox(height: size.height * 0.015),
              Center(child: SizedBox(width: 100, child: Divider(thickness: 4))),
            ],
          ),
        );
      }),
    );
  }
}
