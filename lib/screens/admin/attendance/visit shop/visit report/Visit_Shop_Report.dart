import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VisitShopReport extends StatefulWidget {
  const VisitShopReport({super.key});

  @override
  State<VisitShopReport> createState() => _VisitShopReportState();
}

class _VisitShopReportState extends State<VisitShopReport> {
  String? _selectedValue = 'This week'; // Initial selected value
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        title: const Text('Visit Shop Report'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {

            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text("Option 1")),
              const PopupMenuItem(child: Text("Option 2")),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Section
          Container(
            padding: const EdgeInsets.all(16.0),
            width: 330.0, // Set the width here
            height: 80.0, // Set the height here
            decoration: BoxDecoration(
              color: Colors
                  .grey.shade200, // Set your desired background color here
              borderRadius: BorderRadius.circular(35.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(0.2), // Shadow color with opacity
                  spreadRadius: 2, // Amount of space the shadow covers
                  blurRadius: 5, // Blur radius of the shadow
                  offset: const Offset(0, 3), // Offset of the shadow
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/person_1.png'),
                ),
                const SizedBox(width: 12.0),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                    MainAxisAlignment.center, // Centers content vertically
                    children: [
                      Text(
                        "Karan Sharma",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text("ID - 0001"),
                      // Spacer to push the DropdownButton to the right
                      Spacer(),
                    ],
                  ),
                ),
                // Align DropdownButton to the right
                Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 120, // Set your desired width here
                      height: 40, // Set your desired height here
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0), // Optional padding
                      decoration: BoxDecoration(
                        color:
                        Colors.white, // Background color of the container
                        borderRadius: BorderRadius.circular(
                            14.0), // Rounded corners (optional)
                        boxShadow: [
                          BoxShadow(
                            color:
                            Colors.black.withOpacity(0.1), // Shadow color
                            spreadRadius: 2, // Spread radius
                            blurRadius: 4, // Blur radius
                            offset: const Offset(0, 2), // Offset of the shadow
                          ),
                        ],
                      ), // Set your desired background color here
                      // padding: const EdgeInsets.symmetric(horizontal: 5.0), // Optional padding
                      child: DropdownButton<String>(
                        value: _selectedValue,
                        items: <String>['This week', 'Last week', 'This month']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedValue =
                                newValue; // Update the selected value
                          });
                        },
                        underline: const SizedBox(), // Hide the underline
                      ),
                    )),
              ],
            ),
          ),
          // Visit List Section
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: const [
                ShopVisitCard(visitSuccess: true),
                ShopVisitCard(visitSuccess: false),
                ShopVisitCard(visitSuccess: true),
                ShopVisitCard(visitSuccess: false),
                ShopVisitCard(visitSuccess: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShopVisitCard extends StatelessWidget {
  final bool visitSuccess;

  const ShopVisitCard({super.key, required this.visitSuccess});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      color: Colors.white,
      child: ListTile(
        leading: const Icon(
          Icons.store,
          color: Colors.red,
          size: 28.0,
        ),
        title: const Text(
          "Shiv Kirana Store",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold, // Set your desired font size here
          ),
        ),
        subtitle: const Text(
            "Chandan nagar, volly ball ground medical sq , nagpur, -449900"),
        trailing: Icon(
          visitSuccess ? Icons.check_circle_sharp : Icons.cancel,
          color: visitSuccess ? Colors.green : Colors.red,
          size: 35.0,
        ),
      ),
    );
  }
}
