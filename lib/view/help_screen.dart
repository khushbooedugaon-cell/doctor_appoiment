import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      ['How do I book?', 'Home pe doctor choose karo, Book dabao, date/time select karo.'],
      ['Can I cancel?', 'My Appointments > Upcoming > appointment open karke Cancel.'],
      ['Video call kaise?', 'Booking type Video Call choose karo, time pe Join Call.'],
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FBFA),
        elevation: 0,
        title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: faqs.length,
        itemBuilder: (_, i) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: ExpansionTile(
            title: Text(faqs[i][0], style: const TextStyle(fontWeight: FontWeight.w600)),
            children: [Padding(padding: const EdgeInsets.fromLTRB(16, 0, 16, 16), child: Text(faqs[i][1], style: const TextStyle(color: Color(0xFF64748B))))],
          ),
        ),
      ),
    );
  }
}