import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/user_model.dart';
import '../services/api_service.dart';
import '../view/login_screen.dart';

class ProfileController extends GetxController {
  final user = (ApiService.currentUser ??
      UserModel(
        id: 1,
        name: 'Rahul Kumar',
        email: 'rahul@gmail.com',
        phone: '+91 98765 43210',
        city: 'Patna',
        bloodGroup: 'O+',
        weight: '68 kg',
        height: "5'9\"",
      )).obs;

  void logout() {
    ApiService.currentUser = null;
    Get.snackbar(
      'Signed Out',
      'You have been logged out of your account.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
    Get.offAll(() => const LoginScreen());
  }
}
