import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ['Appointment reminder', 'Dr. Ananya se aaj 4:30 PM pe appointment hai', Icons.event_available_rounded],
      ['Booking confirmed', 'Dr. Rohan Mehta ke saath booking confirm ho gayi', Icons.check_circle_outline_rounded],
      ['New message', 'Dr. Priya Verma ne message bheja', Icons.chat_bubble_outline_rounded],
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FBFA),
        elevation: 0,
        title: const Text('Notifications', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFCCFBF1),
            child: Icon(items[i][2] as IconData, color: const Color(0xFF0D9488)),
          ),
          title: Text(items[i][0] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          subtitle: Text(items[i][1] as String),
        ),
      ),
    );
  }
}