import 'package:get/get.dart';

class MainController extends GetxController {
  final selectedNav = 0.obs;

  void changeNav(int index) {
    selectedNav.value = index;
  }
}