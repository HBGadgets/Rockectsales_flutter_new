import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Analytics"),
        backgroundColor: const Color(0xFF1E4DB7), // blue header
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // 🔹 Salesman of the Month Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            "https://randomuser.me/api/portraits/men/1.jpg",
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Salesman of this month",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 4),
                              Text("Pavan Raghuvanshi",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E4DB7),
                                  )),
                            ],
                          ),
                        ),
                        const Icon(Icons.emoji_events,
                            color: Colors.amber, size: 28),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Attendance Progress
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Attendance"),
                        Text("65%"),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: 0.65,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade300,
                        color: const Color(0xFF1E4DB7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Order / Task / Sales
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _infoBox("Order", "25"),
                        _infoBox("Task", "135"),
                        _infoBox("Sales", "₹45,452"),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Period Card
            _sectionCard(
              title: "Period",
              subtitle: "This Month",
              children: [
                _leaderRow(Icons.shopping_cart_outlined, "Top in Orders",
                    "Priya Sharma", "135"),
                _leaderRow(Icons.task_alt_outlined, "Top in Task",
                    "Pavan Raghuvanshi", "45"),
                _leaderRow(Icons.calendar_today_outlined, "Top in Attendance",
                    "Piyush", "30"),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 Attendance Leaderboard
            _sectionCard(
              title: "Attendance Leaderboard",
              subtitle: "This Month",
              children: [
                _personRow("Pawan Raghuvanshi", crown: true),
                _personRow("Priya Mehra"),
                _personRow("Piyush"),
                TextButton(
                  onPressed: () {},
                  child: const Text("See full leaderboard"),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 Order Leaderboard
            _sectionCard(
              title: "Order Leaderboard",
              subtitle: "This Month",
              children: [
                _personRow("Darlene Robertson", crown: true),
                _personRow("Priya Sharma"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Helper Widgets
  static Widget _infoBox(String title, String value) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  static Widget _sectionCard({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.emoji_events, color: Color(0xFF1E4DB7)),
              title: Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: Text(subtitle,
                  style: const TextStyle(color: Colors.black54)),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  static Widget _leaderRow(
      IconData icon, String label, String name, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1E4DB7)),
      title: Text.rich(
        TextSpan(
          text: "$label\n",
          style: const TextStyle(fontSize: 13, color: Colors.black54),
          children: [
            TextSpan(
              text: name,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1E4DB7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      trailing: Text(value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  static Widget _personRow(String name, {bool crown = false}) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/2.jpg"),
      ),
      title: Text(
        name,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
      ),
      trailing: crown
          ? const Icon(Icons.emoji_events, color: Colors.amber)
          : const Icon(Icons.chevron_right),
    );
  }
}
