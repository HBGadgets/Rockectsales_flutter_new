import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../resources/my_assets.dart';
import '../../../../resources/my_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
    '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: Text("Help and Support"),
          foregroundColor: Colors.white,
          backgroundColor: MyColor.dashbord,
          leading: BackButton(onPressed: () => Navigator.pop(context),),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Image(image: rocket_sale, height: 160),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 📞 Call Executive
                    FilledButton(
                      onPressed: () async {
                        final Uri callUri = Uri(
                          scheme: 'tel',
                          path: "${dotenv.env['SUPPORT_PHONE']}",
                        );

                        if (await canLaunchUrl(callUri)) {
                          await launchUrl(callUri, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No dialer app found on this device')),
                          );
                        }
                      },
                      style: FilledButton.styleFrom(backgroundColor: MyColor.dashbord, foregroundColor: Colors.white),
                      child: Text("Call our executive"),
                    ),

                    // 📧 Email Executive
                    FilledButton(
                      onPressed: () async {
                        final Uri emailUri = Uri(
                          scheme: 'mailto',
                          path: "${dotenv.env['SUPPORT_EMAIL']}",
                          query: encodeQueryParameters(<String, String>{
                            'subject': 'Support Needed',
                          }), // encoding is safer
                        );

                        if (await canLaunchUrl(emailUri)) {
                          await launchUrl(emailUri, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('No email app found on this device')),
                          );
                        }
                      },
                      style: TextButton.styleFrom(backgroundColor: MyColor.dashbord, foregroundColor: Colors.white),
                      child: Text("Email our executive"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FaQTile("What is RocketSales?", "RocketSales is a sales tracker and field force management app that helps businesses monitor their sales teams in real time. It offers features like GPS tracking, lead management, expense verification, and automated reporting. With RocketSales, managers get complete visibility, and sales reps can focus more on closing deals instead of wasting time on manual reports."),
                FaQTile("Who can use RocketSales?", "RocketSales is designed for any business that has a field sales team. It is widely used by industries like FMCG, Pharma, Insurance, Real Estate, Retail, and Distribution. Whether you run a small startup or a large enterprise, RocketSales gives you the tools to track, manage, and boost your sales productivity."),
                FaQTile("How does RocketSales help sales teams?", "RocketSales helps sales teams by automating daily tasks like attendance, task updates, and expense claims. It allows managers to track sales reps through a GPS sales app, optimize their routes, and monitor performance in real time. Sales executives benefit from reduced paperwork, while managers get accurate insights to improve team efficiency and revenue."),
                FaQTile("What makes RocketSales different from other sales tracker apps?", "Unlike basic tracking apps, RocketSales is a complete sales tracker app for field sales management. It offers automated reports, expense verification, route optimization, and lead-to-closing tracking—all in one tool to boost sales productivity."),
                FaQTile("How do I update the RocketSales app?", "Updating RocketSales is simple.\nIf you use Android, go to the Google Play Store, search for “RocketSales,” and tap Update.\nIf you use iOS, open the App Store, find “RocketSales,” and tap Update. Always keep the app updated to enjoy the latest features, bug fixes, and improved performance."),
                FaQTile("How do I log in to the RocketSales app?", "Open the RocketSales app, enter your username and password provided by your company, and tap Login. If you forget your password, use Forgot Password or contact your manager."),
                FaQTile("How do I check in and check out?", "·  Log in to the RocketSales app.\n·  On the dashboard, you’ll see two buttons: Check-In and Check-Out.\n·  Tap Check-In when you begin your workday.\n·  At the end of your shift, tap Check-Out.\n·  Keep your GPS enabled so your attendance is tracked correctly. "),
                FaQTile("Can I use the app without internet connection?", "No. The RocketSales app requires an active internet connection. Please keep your mobile data turned on to record visits, updates, and sync data in real time."),
                FaQTile("What should I do if the app is not showing my correct location?", "Make sure your phone’s GPS and mobile data are on, and the RocketSales app has location permission set to “Always Allow.” Restart the app if needed."),
                FaQTile("How do I submit my travel expenses?", "Go to the Expenses section in the RocketSales app, enter your travel details, attach bills or receipts if required, and submit for manager approval."),
              ],
            ),
          ),
        ));
  }

  Widget FaQTile(String question, String answer) {
    return ExpansionTile(
      title: Text(question),
      children: <Widget>[
        ListTile(
            subtitle: Text(
              textAlign: TextAlign.justify,
                answer)),
      ],
    );
  }
}
