import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('QR id: '),
                  Text(
                    cardIdString,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
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
                  Text(
                    cardNameString,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(date),
                  const Spacer(),
                  Text(time),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
