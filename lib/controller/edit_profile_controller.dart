import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import '../services/api_service.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<ProfileController>()) {
      final u = Get.find<ProfileController>().user.value;
      nameController.text = u.name;
      emailController.text = u.email;
      phoneController.text = u.phone;
      cityController.text = u.city;
    }
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    try {
      final updated = await ApiService.updateProfile(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        city: cityController.text.trim(),
      );

      if (Get.isRegistered<ProfileController>()) {
        Get.find<ProfileController>().user.value = updated;
      }

      Get.back();
      Get.snackbar(
        'Profile Updated',
        'Your profile changes have been saved successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE11D48),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    super.onClose();
  }
}
