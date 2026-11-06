import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/appointment_controller.dart';
import '../modle/appointment_model.dart';
import 'appointment_detail_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(AppointmentsController());
    const tabs = ['Upcoming', 'Completed', 'Cancelled'];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FBFA),
        elevation: 0,
        title: const Text('My Appointments', style: TextStyle(fontWeight: FontWeight.w700)),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => c.loadLiveAppointments(),
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF0D9488)),
            tooltip: 'Refresh appointments',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Obx(
              () => Row(
                children: List.generate(tabs.length, (i) {
                  final selected = c.tab.value == i;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => c.changeTab(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFF0D9488) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFF0D9488).withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          tabs[i],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected ? Colors.white : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (c.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF0D9488)),
                );
              }

              final list = c.filtered;
              if (list.isEmpty) {
                return RefreshIndicator(
                  onRefresh: () => c.loadLiveAppointments(),
                  color: const Color(0xFF0D9488),
                  child: ListView(
                    children: const [
                      SizedBox(height: 100),
                      Center(
                        child: Text(
                          'No appointments in this category',
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => c.loadLiveAppointments(),
                color: const Color(0xFF0D9488),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: list.length,
                  itemBuilder: (_, i) => _AppointmentCard(item: list[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  final AppointmentModel item;
  const _AppointmentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => AppointmentDetailScreen(item: item)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFCCFBF1),
                  child: Icon(Icons.person_rounded, color: Color(0xFF0D9488)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.doctorName, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('${item.specialty}  •  ${item.type}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                Text(item.fee, style: const TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.event, size: 16, color: Color(0xFF0D9488)),
                const SizedBox(width: 6),
                Text('${item.date}  •  ${item.time}', style: const TextStyle(fontSize: 13)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.status == 'upcoming'
                        ? const Color(0xFFF0FDFA)
                        : item.status == 'completed'
                            ? const Color(0xFFEFF6FF)
                            : const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: item.status == 'upcoming'
                          ? const Color(0xFF0D9488)
                          : item.status == 'completed'
                              ? const Color(0xFF2563EB)
                              : const Color(0xFFE11D48),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
