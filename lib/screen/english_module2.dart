import 'package:flutter/material.dart';

class EnglishModule2 extends StatelessWidget {
  const EnglishModule2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('English Module 2'),
      ),
      body: const Center(
        child: Text(
          'Coming Soon !!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}