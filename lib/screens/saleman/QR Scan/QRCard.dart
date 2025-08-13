import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Qrcard extends StatelessWidget {
  final String cardIdString;
  final String cardNameString;
  final String date;
  final String time;

  const Qrcard(
      {super.key,
      required this.cardIdString,
      required this.cardNameString,
      required this.date,
      required this.time});

  String formattedDate(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);
    return DateFormat('dd/MM/yy').format(dateTime);
  }

  String formattedTime(String? dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr!);

    // Format to hh:mm a (12-hour format with AM/PM)
    return DateFormat('hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(
              Icons.qr_code,
              size: 60,
              color: Colors.black54,
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text('QR id: '),
                        Expanded(
                          child: Text(
                            cardIdString,
                            textAlign: TextAlign.start,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Text('Commodity no: '),
                        Expanded(
                          child: Text(
                            cardNameString,
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(formattedDate(date)),
                        const Spacer(),
                        Text(formattedTime(time)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
