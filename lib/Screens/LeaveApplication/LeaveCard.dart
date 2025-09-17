import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../resources/my_colors.dart';
import 'LeaveModel.dart';

class LeaveCard extends StatefulWidget {
  final Leave leave;
  const LeaveCard({super.key, required this.leave});

  @override
  State<LeaveCard> createState() => _LeaveCardState();
}

class _LeaveCardState extends State<LeaveCard> {
  final ExpansibleController expansionController = ExpansibleController();
  bool _isExpanded = false;

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  DateTime parseCustomDate(String dateString) {
    // Your API gives: "17-09-2025"
    return DateFormat("dd-MM-yyyy").parse(dateString);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: Colors.black12,
          width: 2,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          if (expansionController.isExpanded) {
            expansionController.collapse();
          } else {
            expansionController.expand();
          }
        },
        child: ExpansionTile(
          shape: const Border(),
          collapsedShape: const Border(),
          tilePadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          controller: expansionController,
          title: Text(
            widget.leave.reason,
            maxLines: _isExpanded ? 20 : 1,
            softWrap: _isExpanded,
            overflow: TextOverflow.fade,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "From Date: ${formatDate(parseCustomDate(widget.leave.leaveStartdate))}"),
              Text(
                  "To Date: ${formatDate(parseCustomDate(widget.leave.leaveEnddate))}"),
            ],
          ),
          // ✅ status widget (unchanged)
          trailing: widget.leave.status == "Approved"
              ? _statusBox(widget.leave.status, Colors.green,
              const Color.fromRGBO(224, 247, 210, 1))
              : widget.leave.status == "Pending"
              ? _statusBox(widget.leave.status, Colors.black87,
              Colors.yellow,
              icon: Icons.pending_actions)
              : _statusBox(widget.leave.status, Colors.red,
              const Color.fromRGBO(247, 210, 210, 1),
              icon: Icons.cancel_outlined),
        ),
      ),
    );
  }

  Widget _statusBox(String status, Color textColor, Color bgColor,
      {IconData icon = Icons.check_circle_outline}) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: textColor, width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textColor, size: 12),
            const SizedBox(width: 4),
            Text(status, style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }
}
