import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/booking_model.dart';
import '../modle/doctor_model.dart';

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

  void selectDate(int index) => selectedDate.value = index;
  void selectTime(int index) => selectedTime.value = index;
  void selectType(int index) => selectedType.value = index;

  Future<void> confirmBooking() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));

    final booking = BookingModel(
      doctorName: doctor.name,
      specialty: doctor.specialty,
      date: '${dates[selectedDate.value]['day']}, ${dates[selectedDate.value]['date']} ${dates[selectedDate.value]['month']}',
      time: times[selectedTime.value],
      type: types[selectedType.value],
      patientName: nameController.text.trim(),
      phone: phoneController.text.trim(),
      note: noteController.text.trim(),
    );

    isLoading.value = false;

    Get.back();
    Get.snackbar(
      'Booking Confirmed',
      '${booking.doctorName} • ${booking.date} • ${booking.time}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    noteController.dispose();
    super.onClose();
  }
}