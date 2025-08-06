import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SuperLikesMePage extends StatelessWidget {
  const SuperLikesMePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Likes Me'),
      ),
      body: const Center(child: Text('Details about super likes')),
    );
  }
}

const TextStyle titleStyle = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.bold,
);

const TextStyle subTitleStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey,
);