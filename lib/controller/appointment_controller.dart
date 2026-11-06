import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/appointment_model.dart';
import '../services/api_service.dart';

class AppointmentsController extends GetxController {
  final tab = 0.obs;
  final isLoading = false.obs;

  final appointments = <AppointmentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLiveAppointments();
  }

  /// Fetch live appointments from REST API
  /// GET /api/appointments
  Future<void> loadLiveAppointments() async {
    isLoading.value = true;
    try {
      final list = await ApiService.getMyAppointments();
      appointments.assignAll(list);
    } catch (e) {
      debugPrint('Error loading appointments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancel appointment
  /// PUT /api/appointments/:id/cancel
  Future<void> cancelAppointment(String id) async {
    try {
      final success = await ApiService.cancelAppointment(id);
      if (success) {
        await loadLiveAppointments();
        Get.snackbar(
          'Appointment Cancelled',
          'Your appointment has been cancelled.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFE11D48),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Action Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  List<AppointmentModel> get filtered {
    final status = tab.value == 0
        ? 'upcoming'
        : tab.value == 1
            ? 'completed'
            : 'cancelled';
    return appointments.where((a) => a.status.toLowerCase() == status).toList();
  }

  void changeTab(int i) => tab.value = i;
}
