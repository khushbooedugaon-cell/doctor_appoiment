import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/doctor_model.dart';
import '../services/api_service.dart';
import '../view/booking_screen.dart';
import '../view/doctor_detail_screen.dart';
import '../view/notifications_screen.dart';

class HomeController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final selectedCategory = 0.obs;
  final isLoading = false.obs;

  final categories = <CategoryModel>[
    CategoryModel(title: 'Heart', icon: Icons.favorite_rounded, color: const Color(0xFFEF4444)),
    CategoryModel(title: 'Dental', icon: Icons.medical_services_rounded, color: const Color(0xFF0D9488)),
    CategoryModel(title: 'Eye', icon: Icons.remove_red_eye_rounded, color: const Color(0xFF3B82F6)),
    CategoryModel(title: 'Brain', icon: Icons.psychology_rounded, color: const Color(0xFF8B5CF6)),
    CategoryModel(title: 'Bone', icon: Icons.accessibility_new_rounded, color: const Color(0xFFF59E0B)),
    CategoryModel(title: 'Skin', icon: Icons.spa_rounded, color: const Color(0xFFEC4899)),
  ];

  final doctors = <DoctorModel>[].obs;
  final List<DoctorModel> _allDoctorsCache = [];

  @override
  void onInit() {
    super.onInit();
    loadLiveDoctors();
  }

  /// Fetch doctors from Node.js REST API
  /// GET /api/doctors
  Future<void> loadLiveDoctors() async {
    isLoading.value = true;
    try {
      final list = await ApiService.getDoctors();
      _allDoctorsCache.assignAll(list);
      doctors.assignAll(list);
    } catch (e) {
      debugPrint('Error loading doctors: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchDoctors({String? search}) async {
    final query = (search ?? searchController.text).trim();
    if (query.isEmpty) {
      doctors.assignAll(_allDoctorsCache);
      return;
    }

    try {
      final filtered = await ApiService.getDoctors(search: query);
      doctors.assignAll(filtered);
    } catch (e) {
      // Local filter fallback
      doctors.assignAll(
        _allDoctorsCache.where((d) =>
          d.name.toLowerCase().contains(query.toLowerCase()) ||
          d.specialty.toLowerCase().contains(query.toLowerCase()) ||
          d.hospital.toLowerCase().contains(query.toLowerCase()),
        ).toList(),
      );
    }
  }

  void selectCategory(int index) {
    selectedCategory.value = index;
    final catTitle = categories[index].title.toLowerCase();
    doctors.assignAll(
      _allDoctorsCache.where((d) {
        final spec = d.specialty.toLowerCase();
        if (catTitle == 'heart') return spec.contains('cardio');
        if (catTitle == 'dental') return spec.contains('dent');
        if (catTitle == 'eye') return spec.contains('eye') || spec.contains('ophthal');
        if (catTitle == 'brain') return spec.contains('neuro');
        if (catTitle == 'bone') return spec.contains('ortho');
        if (catTitle == 'skin') return spec.contains('derma');
        return spec.contains(catTitle);
      }).toList(),
    );
  }

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
