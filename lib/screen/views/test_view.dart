import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class TestView extends StatelessWidget {
  const TestView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Text(
          "sat_test_hub".tr(),
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        _buildTestCard("mock_exam_title".tr(), "mock_exam_duration".tr(), Icons.assignment, Colors.blue),
        _buildTestCard("reading_section_title".tr(), "reading_section_duration".tr(), Icons.menu_book, Colors.purple),
        _buildTestCard("math_module_title".tr(), "math_module_duration".tr(), Icons.calculate, Colors.green),
      ],
    );
  }

  Widget _buildTestCard(String title, String duration, IconData icon, Color accentColor) {
    return Card(
      color: const Color(0xFF1A1632),
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: accentColor.withValues(alpha: 0.2),
          child: Icon(icon, color: accentColor),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(duration, style: const TextStyle(color: Color(0xFF94A3B8))),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
        onTap: () {},
      ),
    );
  }
}