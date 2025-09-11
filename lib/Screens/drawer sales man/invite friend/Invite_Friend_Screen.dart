import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InviteFriendScreen extends StatelessWidget {
  const InviteFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
// Define the diameter of the avatar if needed

    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          backgroundColor: Colors.grey.shade300,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.of(context)
                  .pop(); // Navigate back to the previous screen
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(children: [
                  Container(
                      height: screenHeight * 0.7,
                      width: screenWidth,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(55.0),
                          bottomRight: Radius.circular(55.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 4.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0), // Adjust the value as needed
                        child: Column(
                            children: [
                              Image.asset(
                                'assets/images/add-friend2.png', // Path to your asset image
                                height: 200,
                                width: 190,
                              ),
                              const SizedBox(height: 5.0),
                              // Space between CircleAvatar and text
                              const Text(
                                'Invite your friends', // Example name
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black, // Changed to black for contrast
                                ),
                              ),
                              const SizedBox(height: 100.0),
                              Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                        },
                                        icon: const Icon(Icons.person_add, color: Colors.black), // Icon for the button
                                        label: const Text(
                                          'Invite Your Friends',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.black, // Text color
                                          backgroundColor: Colors.grey.shade300, // Button background color
                                          //side: const BorderSide(color: Colors.grey, width: 2), // Border color and width
                                          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 14), // Button padding
                                          textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Text size
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Stack(
                              //   children: [
                              //     Align(
                              //       alignment: Alignment.bottomCenter,
                              //       child: Padding(
                              //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                              //
                              //         child: ElevatedButton(
                              //           onPressed: () => (context), // Navigate to LoginForm on press
                              //           style: ElevatedButton.styleFrom(
                              //             foregroundColor: Colors.black, // Text color
                              //             backgroundColor: Colors.grey.shade300, // Button background color
                              //             //side:  const BorderSide(color: Colors.grey, width: 2), // Border color and width
                              //             padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 14), // Button padding
                              //             textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Text size
                              //           ),
                              //           child:
                              //           const Text('Invite Your Friends',style: TextStyle(
                              //               color: Colors.black,fontSize: 18,fontWeight: FontWeight.w500
                              //           ),),
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),


                            ]
                        ),


                      )
                  )

                ]
                ))));
  }
}