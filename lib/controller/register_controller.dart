import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/main_screen.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;

  void togglePassword() => isPasswordHidden.value = !isPasswordHidden.value;

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    Get.offAll(() => const MainScreen());
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}