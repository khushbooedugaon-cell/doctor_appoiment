import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/appointment_model.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final AppointmentModel item;
  const AppointmentDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FBFA),
        elevation: 0,
        title: const Text('Appointment', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _card([
            _row('Doctor', item.doctorName),
            _row('Specialty', item.specialty),
            _row('Hospital', item.hospital),
            _row('Date', item.date),
            _row('Time', item.time),
            _row('Type', item.type),
            _row('Fee', item.fee),
            _row('Status', item.status),
          ]),
          const SizedBox(height: 16),
          if (item.status == 'upcoming')
            Row(
              children: [
                Expanded(child: _btn('Cancel', Colors.redAccent, () => Get.back())),
                const SizedBox(width: 10),
                Expanded(child: _btn(item.type == 'Video Call' ? 'Join Call' : 'Get Direction', const Color(0xFF0D9488), () {})),
              ],
            ),
        ],
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
      child: Column(children: children),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(k, style: const TextStyle(color: Color(0xFF64748B))),
          const Spacer(),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _btn(String label, Color color, VoidCallback onTap) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label),
      ),
    );
  }
}