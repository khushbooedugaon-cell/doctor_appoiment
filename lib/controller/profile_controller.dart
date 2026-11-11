import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/user_model.dart';
import '../services/api_service.dart';
import '../view/login_screen.dart';

class ProfileController extends GetxController {
  final user = (ApiService.currentUser ??
      UserModel(
        id: 1,
        name: 'Patient',
        email: '',
        phone: '',
        city: 'Patna',
        bloodGroup: 'O+',
        weight: '68 kg',
        height: "5'9\"",
      )).obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final p = await ApiService.getProfile();
      if (p != null) {
        user.value = p;
      }
    } catch (e) {
      debugPrint('ℹ️ [ProfileController] fetchProfile error: $e');
    }
  }

  Future<void> logout() async {
    await ApiService.clearSession();
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
