import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(RegisterController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: Form(
          key: c.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create Account', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              const Text('Sign up to book appointments', style: TextStyle(color: Color(0xFF64748B))),
              const SizedBox(height: 28),
              _field(c.nameController, 'Full name', Icons.person_outline_rounded, (v) => v == null || v.isEmpty ? 'Name required' : null),
              const SizedBox(height: 12),
              _field(c.emailController, 'Email', Icons.email_outlined, (v) => GetUtils.isEmail(v ?? '') ? null : 'Valid email daalo', type: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _field(c.phoneController, 'Phone', Icons.phone_outlined, (v) => (v ?? '').length < 10 ? 'Valid phone daalo' : null, type: TextInputType.phone),
              const SizedBox(height: 12),
              Obx(() => TextFormField(
                controller: c.passwordController,
                obscureText: c.isPasswordHidden.value,
                validator: (v) => (v ?? '').length < 6 ? 'Min 6 characters' : null,
                decoration: _dec('Password', Icons.lock_outline_rounded, IconButton(
                  onPressed: c.togglePassword,
                  icon: Icon(c.isPasswordHidden.value ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF0D9488)),
                )),
              )),
              const SizedBox(height: 24),
              Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: c.isLoading.value ? null : c.register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: c.isLoading.value
                      ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.4))
                      : const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint, IconData icon, String? Function(String?) v, {TextInputType? type}) {
    return TextFormField(
      controller: c,
      keyboardType: type,
      validator: v,
      decoration: _dec(hint, icon, null),
    );
  }

  InputDecoration _dec(String hint, IconData icon, Widget? suffix) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF0D9488)),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFF0D9488))),
    );
  }
}