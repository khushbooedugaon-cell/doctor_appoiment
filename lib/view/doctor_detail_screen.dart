import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/doctor_model.dart';
import 'booking_screen.dart';

class DoctorDetailScreen extends StatelessWidget {
  final DoctorModel doctor;
  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FBFA),
        elevation: 0,
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
        title: const Text('Doctor Details', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () => Get.to(() => BookingScreen(doctor: doctor)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D9488),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Book Appointment  •  ${doctor.fee}', style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: doctor.avatarColor.withOpacity(0.12),
                  child: Icon(Icons.person_rounded, size: 44, color: doctor.avatarColor),
                ),
                const SizedBox(height: 12),
                Text(doctor.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                Text(doctor.specialty, style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(doctor.hospital, style: const TextStyle(color: Color(0xFF64748B))),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _stat(Icons.star_rounded, '${doctor.rating}', 'Rating', const Color(0xFFF59E0B)),
                    _stat(Icons.work_outline_rounded, doctor.experience, 'Experience', const Color(0xFF0D9488)),
                    _stat(Icons.payments_outlined, doctor.fee, 'Fee', const Color(0xFF3B82F6)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            doctor.about.isNotEmpty
                ? doctor.about
                : '${doctor.name} is a dedicated ${doctor.specialty.toLowerCase()} at ${doctor.hospital}, committed to delivering high-quality and compassionate healthcare.',
            style: const TextStyle(color: Color(0xFF64748B), height: 1.5),
          ),
          const SizedBox(height: 18),
          const Text('Available', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Mon - Sat  •  9:00 AM to 7:30 PM', style: TextStyle(color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _stat(IconData icon, String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
        ],
      ),
    );
  }
}