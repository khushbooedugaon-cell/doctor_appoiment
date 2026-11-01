import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/doctor_model.dart';
import '../view/booking_screen.dart';
import '../view/doctor_detail_screen.dart';
import '../view/notifications_screen.dart';

class HomeController extends GetxController {
  final searchController = TextEditingController();
  final selectedCategory = 0.obs;
  final selectedNav = 0.obs;
  void changeNav(int index) => selectedNav.value = index;

  final categories = <CategoryModel>[
    CategoryModel(title: 'Heart', icon: Icons.favorite_rounded, color: const Color(0xFFEF4444)),
    CategoryModel(title: 'Dental', icon: Icons.medical_services_rounded, color: const Color(0xFF0D9488)),
    CategoryModel(title: 'Eye', icon: Icons.remove_red_eye_rounded, color: const Color(0xFF3B82F6)),
    CategoryModel(title: 'Brain', icon: Icons.psychology_rounded, color: const Color(0xFF8B5CF6)),
    CategoryModel(title: 'Bone', icon: Icons.accessibility_new_rounded, color: const Color(0xFFF59E0B)),
    CategoryModel(title: 'Skin', icon: Icons.spa_rounded, color: const Color(0xFFEC4899)),
  ];

  final doctors = <DoctorModel>[
    DoctorModel(name: 'Dr. Ananya Sharma', specialty: 'Cardiologist', hospital: 'Apollo Hospital', rating: 4.9, experience: '12 yrs', fee: '₹800', avatarColor: const Color(0xFF0D9488)),
    DoctorModel(name: 'Dr. Rohan Mehta', specialty: 'Dentist', hospital: 'City Dental Care', rating: 4.8, experience: '8 yrs', fee: '₹500', avatarColor: const Color(0xFF3B82F6)),
    DoctorModel(name: 'Dr. Priya Verma', specialty: 'Neurologist', hospital: 'Max Super Speciality', rating: 4.7, experience: '10 yrs', fee: '₹900', avatarColor: const Color(0xFF8B5CF6)),
    DoctorModel(name: 'Dr. Amit Singh', specialty: 'Orthopedic', hospital: 'Fortis Hospital', rating: 4.6, experience: '15 yrs', fee: '₹700', avatarColor: const Color(0xFFF59E0B)),
  ];

  void selectCategory(int index) => selectedCategory.value = index;

  void openDoctor(DoctorModel doctor) {
    Get.to(() => DoctorDetailScreen(doctor: doctor));
  }

  void bookDoctor(DoctorModel doctor) {
    Get.to(() => BookingScreen(doctor: doctor));
  }

  void openNotifications() {
    Get.to(() => const NotificationsScreen());
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}