import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import 'profile_controller.dart';
import '../view/login_screen.dart';
import '../view/main_screen.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _handleStartup();
  }

  Future<void> _handleStartup() async {
    // 2.5s smooth brand animation duration
    await Future.delayed(const Duration(milliseconds: 2500));

    try {
      final user = await ApiService.restoreSession();
      if (user != null && user.token != null && user.token!.isNotEmpty) {
        // Restore user to profile controller
        if (Get.isRegistered<ProfileController>()) {
          Get.find<ProfileController>().user.value = user;
        } else {
          Get.put(ProfileController()).user.value = user;
        }

        // Silently refresh profile in background
        ApiService.getProfile().then((fresh) {
          if (fresh != null && Get.isRegistered<ProfileController>()) {
            Get.find<ProfileController>().user.value = fresh;
          }
        }).catchError((e) {
          debugPrint('ℹ️ [SplashController] Background sync error: $e');
        });

        Get.offAll(() => const MainScreen());
        return;
      }
    } catch (e) {
      debugPrint('ℹ️ [SplashController] Startup error: $e');
    }

    Get.offAll(() => const LoginScreen());
  }
}
