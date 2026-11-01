import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/booking_controller.dart';
import '../modle/doctor_model.dart';
class BookingScreen extends StatelessWidget {
  final DoctorModel doctor;
  const BookingScreen({super.key, required this.doctor});
  @override
  Widget build(BuildContext context) {
    final c = Get.put(BookingController(doctor), tag: doctor.name);
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FBFA),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: const Text(
          'Book Appointment',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: _ConfirmBar(controller: c),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
          child: Form(
            key: c.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DoctorHeader(doctor: doctor),
                const SizedBox(height: 20),
                const _Label('Appointment Type'),
                const SizedBox(height: 10),
                _TypeRow(controller: c),
                const SizedBox(height: 20),
                const _Label('Select Date'),
                const SizedBox(height: 10),
                _DateRow(controller: c),
                const SizedBox(height: 20),
                const _Label('Available Slots'),
                const SizedBox(height: 10),
                _TimeGrid(controller: c),
                const SizedBox(height: 20),
                const _Label('Patient Details'),
                const SizedBox(height: 10),
                _Field(
                  controller: c.nameController,
                  hint: 'Full name',
                  icon: Icons.person_outline_rounded,
                  validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Name required' : null,
                ),
                const SizedBox(height: 10),
                _Field(
                  controller: c.phoneController,
                  hint: 'Phone number',
                  icon: Icons.phone_outlined,
                  keyboard: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.trim().length < 10) {
                      return 'Valid phone number daalo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _Field(
                  controller: c.noteController,
                  hint: 'Symptoms / note (optional)',
                  icon: Icons.notes_rounded,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _DoctorHeader extends StatelessWidget {
  final DoctorModel doctor;
  const _DoctorHeader({required this.doctor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: doctor.avatarColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(Icons.person_rounded, color: doctor.avatarColor, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  '${doctor.specialty}  •  ${doctor.hospital}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 6),
                Text(
                  'Fee  ${doctor.fee}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D9488),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    );
  }
}
class _TypeRow extends StatelessWidget {
  final BookingController controller;
  const _TypeRow({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Row(
        children: List.generate(controller.types.length, (i) {
          final selected = controller.selectedType.value == i;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: i == 0 ? 10 : 0),
              child: GestureDetector(
                onTap: () => controller.selectType(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF0D9488) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected ? const Color(0xFF0D9488) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        i == 0 ? Icons.local_hospital_outlined : Icons.videocam_outlined,
                        size: 18,
                        color: selected ? Colors.white : const Color(0xFF0D9488),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        controller.types[i],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: selected ? Colors.white : const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
class _DateRow extends StatelessWidget {
  final BookingController controller;
  const _DateRow({required this.controller});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final item = controller.dates[i];
          return Obx(() {
            final selected = controller.selectedDate.value == i;
            return GestureDetector(
              onTap: () => controller.selectDate(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 64,
                decoration: BoxDecoration(
                  color: selected ? const Color(0xFF0D9488) : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(selected ? 0.08 : 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['day']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: selected ? Colors.white70 : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['date']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      item['month']!,
                      style: TextStyle(
                        fontSize: 11,
                        color: selected ? Colors.white70 : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
class _TimeGrid extends StatelessWidget {
  final BookingController controller;
  const _TimeGrid({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Wrap(
        spacing: 10,
        runSpacing: 10,
        children: List.generate(controller.times.length, (i) {
          final selected = controller.selectedTime.value == i;
          return GestureDetector(
            onTap: () => controller.selectTime(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFF0D9488) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? const Color(0xFF0D9488) : const Color(0xFFE2E8F0),
                ),
              ),
              child: Text(
                controller.times[i],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : const Color(0xFF334155),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboard;
  final int maxLines;
  final String? Function(String?)? validator;
  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboard,
    this.maxLines = 1,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF0D9488)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
      ),
    );
  }
}
class _ConfirmBar extends StatelessWidget {
  final BookingController controller;
  const _ConfirmBar({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(
              () => SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.isLoading.value ? null : controller.confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF99F6E4),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: controller.isLoading.value
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
              )
                  : Text(
                'Confirm  •  ${controller.doctor.fee}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}