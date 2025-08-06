import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Super Likes Me Page/Super_Likes_Me_Page.dart';

class ProfileInfoBigCard extends StatelessWidget {
  final String firstText;
  final Widget icon;
  final VoidCallback onTap;

  const ProfileInfoBigCard({
    super.key,
    required this.firstText,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: onTap,
        child: Container(
          child: SizedBox(
            height: 144, // Set your desired height
            width: 65, // Set your desired width
            child: Card(
              color: Colors.white, // Set your desired background color here
              // margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
              elevation: 5,
              margin: const EdgeInsets.only(top: 10 , bottom: 8, left: 10, right: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 0,
                  bottom: 8,
                  right: 16.0,
                ),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          firstText,
                          style: titleStyle,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: icon, // Replace with the actual icon widget
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18), // Adjust the value as needed
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_outlined,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //       onTap: onTap,
  //       child: Container(
  //         width: MediaQuery.of(context).size.width * 0.20,
  //         height: MediaQuery.of(context).size.height * 0.18,
  //
  //         child: Column(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(10.0),
  //               child: Align(
  //                 alignment: Alignment.topCenter,
  //                 child: Text(
  //                   firstText,
  //                   style: titleStyle,
  //                 ),
  //               ),
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Padding(
  //                   padding: const EdgeInsets.all(0.0),
  //                   child: icon, // Replace with the actual icon widget
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(top: 0, right: 2), // Adjust the value as needed
  //                   child: Container(
  //                     height: 45,
  //                     width: 45,
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: Colors.white,
  //                       border: Border.all(color: Colors.grey),
  //                     ),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(5.0),
  //                       child: Container(
  //                         height: 45,
  //                         width: 45,
  //                         decoration: BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           color: Colors.grey,
  //                           border: Border.all(color: Colors.grey.shade300),
  //                         ),
  //                         child: const Icon(
  //                           Icons.arrow_forward_outlined,
  //                           color: Colors.white,
  //                           size: 25,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             )
  //           ],
  //         ),
  //       )
  //   );
  // }
}
