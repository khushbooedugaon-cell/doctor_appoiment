import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import '../modle/user_model.dart';

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
    await Future.delayed(const Duration(seconds: 1));
    if (Get.isRegistered<ProfileController>()) {
      Get.find<ProfileController>().user.value = UserModel(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        city: cityController.text.trim(),
      );
    }
    isLoading.value = false;
    Get.back();
    Get.snackbar('Saved', 'Profile update ho gaya', snackPosition: SnackPosition.BOTTOM);
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