import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notify = true.obs;
    final dark = false.obs;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FBFA),
        elevation: 0,
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Obx(() => SwitchListTile(
            value: notify.value,
            onChanged: (v) => notify.value = v,
            title: const Text('Push Notifications', style: TextStyle(fontWeight: FontWeight.w600)),
            activeColor: const Color(0xFF0D9488),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          )),
          const SizedBox(height: 10),
          Obx(() => SwitchListTile(
            value: dark.value,
            onChanged: (v) => dark.value = v,
            title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
            activeColor: const Color(0xFF0D9488),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          )),
          const SizedBox(height: 10),
          const ListTile(
            tileColor: Colors.white,
            title: Text('Language', style: TextStyle(fontWeight: FontWeight.w600)),
            trailing: Text('English / Hindi'),
          ),
          const SizedBox(height: 10),
          const ListTile(
            tileColor: Colors.white,
            title: Text('App Version', style: TextStyle(fontWeight: FontWeight.w600)),
            trailing: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}