import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../resources/my_assets.dart';
import '../../../../resources/my_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          leading: BackButton(color: Colors.black87, onPressed: () => Navigator.pop(context),),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Help and Support',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Image(image: rocket_sale, height: 160),
                // const SizedBox(height: 16),
                // Container(
                //   padding: const EdgeInsets.all(2.0), // Outer border padding
                //   decoration: BoxDecoration(
                //     color: Colors.grey[300],
                //     // Outer border color
                //     borderRadius: BorderRadius.circular(20),
                //     // Outer border radius
                //     border: Border.all(
                //         color:
                //             Colors.grey[600]!), // Outer border width and color
                //   ),
                //   child: TextField(
                //     decoration: InputDecoration(
                //       prefixIcon: const Icon(Icons.search),
                //       hintText: 'Search for help......',
                //       filled: true,
                //       // Enable background color
                //       fillColor: Colors.grey.shade200,
                //       // Background color
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(18),
                //         // Inner border radius
                //         borderSide: BorderSide.none, // Remove default border
                //       ),
                //       focusedBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(18),
                //         borderSide: BorderSide
                //             .none, // Remove default border when focused
                //       ),
                //       enabledBorder: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(18),
                //         borderSide: BorderSide
                //             .none, // Remove default border when enabled
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: () => {}, child: Text("Call our executive"), style: TextButton.styleFrom(foregroundColor: MyColor.dashbord),),
                    TextButton(onPressed: () => {}, child: Text("Email our executive"), style: TextButton.styleFrom(foregroundColor: MyColor.dashbord),),
                  ],
                ),
                const SizedBox(height: 16),
                const ExpansionTile(
                  title: Text('What is rocket sales?'),
                  children: <Widget>[
                    ListTile(
                        title: Text(
                            'Rocket sales is a fast and efficient sales method.')),
                  ],
                ),
                const ExpansionTile(
                  title: Text('Does it have live tracking?'),
                  children: <Widget>[
                    ListTile(
                        title:
                            Text('Yes, it includes live tracking features.')),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
