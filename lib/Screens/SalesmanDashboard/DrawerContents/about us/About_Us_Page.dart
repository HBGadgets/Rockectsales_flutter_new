import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../resources/my_assets.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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
              leading: BackButton(color: Colors.black87, onPressed: () => Navigator.pop(context),)
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About us',
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
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "At Rocket Sales Tracker, we’re passionate about making the work easier for businesses when it comes to managing field sales operations. "
                          "We’ve built a platform that’s all about real-time tracking, insightful analytics, and user-friendly tools designed to help your team excel. "
                          "Our focus is on innovation and efficiency, but most importantly, on supporting our clients as they grow and succeed. "
                          "Whether you’re running a small business or leading a large enterprise, we’re here to help you reach new heights and achieve your sales target. "
                          "Rocket Sales Tracker is more than just a tool—it’s a partner in your Sales success ",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.circle, size: 8, color: Colors.black45),
                      SizedBox(width: 8),
                      Icon(Icons.circle, size: 8, color: Colors.black45),
                      SizedBox(width: 8),
                      Icon(Icons.circle, size: 8, color: Colors.black45),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'If you have any questions or concerns about this privacy policy or our data practices, please contact us at:',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                const ContactDetail(
                  icon: Icons.phone,
                  text: '+91 7030811155',
                ),
                const ContactDetail(
                  icon: Icons.email,
                  text: 'sales@rocketsales.com',
                ),
                const ContactDetail(
                  icon: Icons.location_on,
                  text:
                      'Block no 07 ,krida square Rd krida chock ,chandan nagar Nagpur ,Maharashtra 440024',
                ),
                const SizedBox(height: 20),
                const Center(
                  child: Column(
                    children: [
                      Text(
                        'Follow us on social media',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialMediaIcon(
                            icon: Icons.camera_alt,
                            label: 'Instagram',
                            color: Colors.orange,
                          ),
                          SizedBox(width: 20),
                          SocialMediaIcon(
                            icon: Icons.facebook,
                            label: 'Facebook',
                            color: Colors.blue,
                          ),
                          SizedBox(width: 20),
                          SocialMediaIcon(
                            icon: Icons.web,
                            label: 'Website',
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContactDetail extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactDetail({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.black),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialMediaIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const SocialMediaIcon(
      {super.key,
      required this.icon,
      required this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
