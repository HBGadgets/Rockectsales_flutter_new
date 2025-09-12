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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(
          color: Colors.black12, // border color
          width: 2, // border thickness
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
          tilePadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          controller: expansionController,
          title: Text(widget.leave.reason,
              maxLines: _isExpanded ? 20 : 1,
              softWrap: _isExpanded ? true : false,
              overflow: TextOverflow.fade),
          subtitle: Column(
            children: [
              Text("From Date: ${formatDate(DateTime.parse(widget.leave.leaveStartdate))}"),
              Text("From Date: ${formatDate(DateTime.parse(widget.leave.leaveEnddate))}"),
            ],
          ),
          
          trailing: widget.leave.status == "Accepted"
              ? Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(
                    224, 247, 210, 1), // background color
                border: Border.all(
                  color: Colors.green, // border color
                  width: 1, // border thickness
                ),
                borderRadius:
                BorderRadius.circular(6), // optional: rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 1, left: 8, right: 8, bottom: 1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Color.fromRGBO(37, 87, 9, 1),
                      size: 12,
                    ),
                    Text(
                      widget.leave.status,
                      style: const TextStyle(
                          color: Color.fromRGBO(37, 87, 9, 1)),
                    ),
                  ],
                ),
              ))
              : widget.leave.status == "Pending" ? Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(
                    247, 210, 210, 1), // background color
                border: Border.all(
                  color: Colors.yellow, // border color
                  width: 1, // border thickness
                ),
                borderRadius:
                BorderRadius.circular(6), // optional: rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 1, left: 8, right: 8, bottom: 1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.pending_actions,
                      color: Colors.black87,
                      size: 12,
                    ),
                    Text(
                      widget.leave.status,
                      style: const TextStyle(color: Colors.black87),
                    ),
                  ],
                ),
              )) : Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(
                    247, 210, 210, 1), // background color
                border: Border.all(
                  color: Colors.red, // border color
                  width: 1, // border thickness
                ),
                borderRadius:
                BorderRadius.circular(6), // optional: rounded corners
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 1, left: 8, right: 8, bottom: 1),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cancel_outlined,
                      color: Colors.red,
                      size: 12,
                    ),
                    Text(
                      widget.leave.status,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
