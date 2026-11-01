import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/main_controller.dart';
import 'appointments_screen.dart';
import 'chat_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(MainController());

    return Obx(() {
      return Scaffold(
        body: IndexedStack(
          index: c.selectedNav.value,
          children: const [
            HomeScreen(),
            AppointmentsScreen(),
            ChatScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          height: 68,
          selectedIndex: c.selectedNav.value,
          onDestinationSelected: (i) => c.changeNav(i),
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFCCFBF1),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: Color(0xFF0D9488)),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_today_outlined),
              selectedIcon: Icon(Icons.calendar_month_rounded, color: Color(0xFF0D9488)),
              label: 'Bookings',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              selectedIcon: Icon(Icons.chat_bubble_rounded, color: Color(0xFF0D9488)),
              label: 'Chat',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded, color: Color(0xFF0D9488)),
              label: 'Profile',
            ),
          ],
        ),
      );
    });
  }
}