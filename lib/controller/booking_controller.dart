import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/doctor_model.dart';
import '../services/api_service.dart';
import 'appointment_controller.dart';

class BookingController extends GetxController {
  final DoctorModel doctor;

  BookingController(this.doctor);

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final selectedDate = 0.obs;
  final selectedTime = 0.obs;
  final selectedType = 0.obs;
  final isLoading = false.obs;

  final types = ['In Clinic', 'Video Call'];

  final dates = <Map<String, String>>[
    {'day': 'Wed', 'date': '28', 'month': 'Oct'},
    {'day': 'Thu', 'date': '29', 'month': 'Oct'},
    {'day': 'Fri', 'date': '30', 'month': 'Oct'},
    {'day': 'Sat', 'date': '31', 'month': 'Oct'},
    {'day': 'Sun', 'date': '01', 'month': 'Nov'},
    {'day': 'Mon', 'date': '02', 'month': 'Nov'},
    {'day': 'Tue', 'date': '03', 'month': 'Nov'},
  ];

  final times = [
    '09:00 AM',
    '10:00 AM',
    '11:30 AM',
    '01:00 PM',
    '03:00 PM',
    '04:30 PM',
    '06:00 PM',
    '07:30 PM',
  ];

  @override
  void onInit() {
    super.onInit();
    // Pre-fill patient details from logged-in session
    if (ApiService.currentUser != null) {
      nameController.text = ApiService.currentUser!.name;
      phoneController.text = ApiService.currentUser!.phone;
    }
  }

  void selectDate(int index) => selectedDate.value = index;
  void selectTime(int index) => selectedTime.value = index;
  void selectType(int index) => selectedType.value = index;

  Future<void> confirmBooking() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final scheduledDate =
        '${dates[selectedDate.value]['day']}, ${dates[selectedDate.value]['date']} ${dates[selectedDate.value]['month']}';
    final scheduledTime = times[selectedTime.value];
    final consultationType = types[selectedType.value];

    try {
      final appt = await ApiService.bookAppointment(
        doctorId: doctor.id,
        doctorName: doctor.name,
        specialty: doctor.specialty,
        hospital: doctor.hospital,
        fee: doctor.fee,
        patientName: nameController.text.trim(),
        phone: phoneController.text.trim(),
        date: scheduledDate,
        time: scheduledTime,
        type: consultationType,
        note: noteController.text.trim(),
      );

      // Refresh appointments list if controller exists
      if (Get.isRegistered<AppointmentsController>()) {
        Get.find<AppointmentsController>().loadLiveAppointments();
      }

      Get.back();
      Get.snackbar(
        'Booking Confirmed!',
        '${appt.doctorName} • $scheduledDate at $scheduledTime',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Booking Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE11D48),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
