import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../resources/my_assets.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                floating: true,
                snap: true,
                backgroundColor: Colors.grey.shade50,
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Get.back();
                  },
                ),
              )
            ];
          },
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Privacy-Policy',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Image(image: rocket_sale, height: 160),
                          const SizedBox(height: 16),
                          const Text(
                            'Information Collect',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "When you use the Rocket Sales Tracker app, we collect certain personal information from you to provide and improve our services. This information may include:",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 5),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Personal Identifiers:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                          text:
                                              'Such as your name, email address, and phone number when you create an account or contact us.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Usage Data:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                          text:
                                              'Information about how you interact with the app, including the features you use and the actions you take.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Device Information: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                          text:
                                              'Details about the device you use to access the app, such as your IP address, operating system, and browser type.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Location Data:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                          text:
                                              'If you enable location services, we may collect your precise or approximate location to enhance your experience with the app.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'How We Use Your Information',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "We use the information we collect to:\n"
                                    "• Provide and maintain the Rocket Sales Tracker app and its features.\n"
                                    "• Personalize your experience based on your preferences and usage patterns.\n"
                                    "• Communicate with you, including sending updates, promotions, and support messages.\n"
                                    "• Analyze app usage to improve functionality and performance.\n"
                                    "• Ensure the security of our services and prevent fraud.",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Sharing Your Information',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "We may share your personal information with third parties in the following situations:",
                                  ),
                                  SizedBox(height: 5),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Service Providers: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                          text:
                                              'We work with third-party service providers to assist in operating our app, such as hosting services, analytics, and customer support.',
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Legal Compliance: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                          text:
                                              'We may disclose your information if required by law or in response to legal requests, such as subpoenas or court orders',
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                            text: 'Business Transfers: ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                          text:
                                              'If we are involved in a merger, acquisition, or asset sale, your information may be transferred as part of that transaction.',
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        ],
                      ),
                    )
                  ]),
            ),
          ),
        ));
  }
}
