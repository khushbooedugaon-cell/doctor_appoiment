import 'package:doctor_appoinment/view/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/user_model.dart';
import '../view/home_screen.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isPasswordHidden = true.obs;
  final isLoading = false.obs;
  final rememberMe = false.obs;
  void togglePassword() => isPasswordHidden.value = !isPasswordHidden.value;
  void toggleRememberMe(bool? value) => rememberMe.value = value ?? false;
  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    isLoading.value = true;
    final user = UserModel(
      name: 'Rahul l',
      email: emailController.text.trim(),
      phone: '+91 98765 43210',
      password: passwordController.text.trim(),
    );
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    // TODO: yahan apna API call lagao
    Get.snackbar(
      'Welcome',
      'Logged in as ${user.email}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
    Get.off(() => const MainScreen());
  }
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
