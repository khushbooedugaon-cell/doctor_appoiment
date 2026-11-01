import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/main_controller.dart';
import '../controller/profile_controller.dart';
import 'edit_profile_screen.dart';
import 'help_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            const Text('Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
            const SizedBox(height: 18),
            Obx(() {
              final u = c.user.value;
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Color(0xFFCCFBF1),
                      child: Icon(Icons.person_rounded, color: Color(0xFF0D9488), size: 34),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                          Text(u.email, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                          Text(u.phone, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.to(() => const EditProfileScreen()),
                      icon: const Icon(Icons.edit_outlined, color: Color(0xFF0D9488)),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            Row(
              children: [
                _mini('2', 'Upcoming'),
                const SizedBox(width: 10),
                _mini('1', 'Completed'),
                const SizedBox(width: 10),
                _mini('1', 'Cancelled'),
              ],
            ),
            const SizedBox(height: 20),
            _menu(Icons.person_outline_rounded, 'Edit Profile', () => Get.to(() => const EditProfileScreen())),
            _menu(Icons.calendar_month_outlined, 'My Appointments', () => Get.find<MainController>().changeNav(1)),
            _menu(Icons.notifications_none_rounded, 'Notifications', () => Get.to(() => const NotificationsScreen())),
            _menu(Icons.settings_outlined, 'Settings', () => Get.to(() => const SettingsScreen())),
            _menu(Icons.help_outline_rounded, 'Help & Support', () => Get.to(() => const HelpScreen())),
            _menu(Icons.logout_rounded, 'Logout', c.logout, color: Colors.redAccent),
          ],
        ),
      ),
    );
  }

  Widget _mini(String n, String l) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            Text(n, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF0D9488))),
            Text(l, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
          ],
        ),
      ),
    );
  }

  Widget _menu(IconData icon, String title, VoidCallback onTap, {Color color = const Color(0xFF0F172A)}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color == Colors.redAccent ? Colors.redAccent : const Color(0xFF0D9488)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
      ),
    );
  }
}