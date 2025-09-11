import 'package:flutter/material.dart';

import 'QRModel.dart';

class QRQuestion extends StatefulWidget {
  final QRQuestions question;
  final Function(String) onAnswer;

  const QRQuestion({
    super.key,
    required this.question,
    required this.onAnswer,
  });

  @override
  State<QRQuestion> createState() => _QRQuestionState();
}

class _QRQuestionState extends State<QRQuestion> {
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildLabel(widget.question.text ?? ""),

        RadioListTile<String>(
          title: const Text("Yes"),
          value: "Yes",
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() => selectedValue = value);
            widget.onAnswer(value!);
          },
        ),

        RadioListTile<String>(
          title: const Text("No"),
          value: "No",
          groupValue: selectedValue,
          onChanged: (value) {
            setState(() => selectedValue = value);
            widget.onAnswer(value!);
          },
        ),
      ],
    );
  }

  Widget buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }
}
