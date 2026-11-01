import 'package:get/get.dart';
import '../modle/user_model.dart';
import '../view/login_screen.dart';

class ProfileController extends GetxController {
  final user = UserModel(
    name: 'Rahul Kumar',
    email: 'rahul@gmail.com',
    phone: '+91 98765 43210',
    city: 'Patna',
  ).obs;

  void logout() {
    Get.offAll(() => const LoginScreen());
  }
}