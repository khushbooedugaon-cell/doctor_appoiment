import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/main_controller.dart';
import '../controller/profile_controller.dart';
import 'edit_profile_screen.dart';
import 'help_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Hero Profile Gradient Header
              _buildProfileHeader(context, c),

              // Vitals Quick Glance
              const SizedBox(height: 16),
              _buildVitalsCard(),

              // Appointments Mini Stats
              const SizedBox(height: 16),
              _buildAppointmentStats(),

              // Grouped Menu Options
              const SizedBox(height: 20),
              _buildMenuSection(
                title: 'Medical & Consultations',
                items: [
                  _MenuItem(
                    icon: Icons.calendar_month_rounded,
                    title: 'My Appointments',
                    subtitle: 'View upcoming & past schedules',
                    onTap: () => Get.find<MainController>().changeNav(1),
                  ),
                  _MenuItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'Doctor Messages',
                    subtitle: 'Direct chat & follow-ups',
                    onTap: () => Get.find<MainController>().changeNav(2),
                  ),
                  _MenuItem(
                    icon: Icons.description_outlined,
                    title: 'Prescriptions & Records',
                    subtitle: 'Digital medical reports & Rx',
                    onTap: () {
                      Get.snackbar(
                        'Medical Records',
                        '3 Digital Prescriptions available',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF0D9488),
                        colorText: Colors.white,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _buildMenuSection(
                title: 'Account & Preferences',
                items: [
                  _MenuItem(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profile',
                    subtitle: 'Update name, contact & city',
                    onTap: () => Get.to(() => const EditProfileScreen()),
                  ),
                  _MenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications & Alerts',
                    subtitle: 'Reminders & appointment alerts',
                    onTap: () => Get.to(() => const NotificationsScreen()),
                  ),
                  _MenuItem(
                    icon: Icons.settings_outlined,
                    title: 'App Settings',
                    subtitle: 'Language, privacy & security',
                    onTap: () => Get.to(() => const SettingsScreen()),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              _buildMenuSection(
                title: 'Help & Session',
                items: [
                  _MenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & 24/7 Support',
                    subtitle: 'FAQs, toll-free helpline & ticket',
                    onTap: () => Get.to(() => const HelpScreen()),
                  ),
                  _MenuItem(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    subtitle: 'Sign out from this device',
                    isDestructive: true,
                    onTap: () => _confirmLogout(context, c),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, ProfileController c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x200F766E),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                'My Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => Get.to(() => const SettingsScreen()),
                icon: const Icon(
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final u = c.user.value;
            return Row(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 72,
                      width: 72,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF99F6E4), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          size: 42,
                          color: Color(0xFF0D9488),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => Get.to(() => const EditProfileScreen()),
                        child: Container(
                          height: 24,
                          width: 24,
                          decoration: const BoxDecoration(
                            color: Color(0xFF10B981),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              u.name,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_rounded,
                            size: 18,
                            color: Color(0xFF5EEAD4),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        u.email,
                        style: const TextStyle(
                          color: Color(0xFFCCFBF1),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${u.phone} • ${u.city}',
                        style: const TextStyle(
                          color: Color(0xFFE6FFFA),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.24)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shield_rounded, size: 16, color: Color(0xFF99F6E4)),
                SizedBox(width: 8),
                Text(
                  'Verified Patient Account • ID: #MED-8821',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _vitalItem('Blood', 'O+', Icons.water_drop_rounded, const Color(0xFFEF4444)),
          _divider(),
          _vitalItem('Weight', '68 kg', Icons.monitor_weight_outlined, const Color(0xFF3B82F6)),
          _divider(),
          _vitalItem('Height', "5'9\"", Icons.height_rounded, const Color(0xFF10B981)),
          _divider(),
          _vitalItem('Pulse', '74 bpm', Icons.favorite_rounded, const Color(0xFFF59E0B)),
        ],
      ),
    );
  }

  Widget _vitalItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F172A),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      height: 28,
      width: 1,
      color: const Color(0xFFE2E8F0),
    );
  }

  Widget _buildAppointmentStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _statCard('2', 'Upcoming', Icons.event_available_rounded, const Color(0xFF0D9488), const Color(0xFFF0FDFA), () {
            Get.find<MainController>().changeNav(1);
          }),
          const SizedBox(width: 10),
          _statCard('1', 'Completed', Icons.check_circle_rounded, const Color(0xFF10B981), const Color(0xFFF0FDF4), () {
            Get.find<MainController>().changeNav(1);
          }),
          const SizedBox(width: 10),
          _statCard('1', 'Cancelled', Icons.cancel_rounded, const Color(0xFFEF4444), const Color(0xFFFEF2F2), () {
            Get.find<MainController>().changeNav(1);
          }),
        ],
      ),
    );
  }

  Widget _statCard(
    String count,
    String label,
    IconData icon,
    Color color,
    Color bg,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0D9488).withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  color: bg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(height: 6),
              Text(
                count,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection({
    required String title,
    required List<_MenuItem> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF475569),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D9488).withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: List.generate(items.length, (i) {
                final item = items[i];
                final isLast = i == items.length - 1;

                return Column(
                  children: [
                    InkWell(
                      onTap: item.onTap,
                      borderRadius: BorderRadius.vertical(
                        top: i == 0 ? const Radius.circular(20) : Radius.zero,
                        bottom: isLast ? const Radius.circular(20) : Radius.zero,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: item.isDestructive
                                    ? const Color(0xFFFEF2F2)
                                    : const Color(0xFFF0FDFA),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                item.icon,
                                color: item.isDestructive
                                    ? Colors.redAccent
                                    : const Color(0xFF0D9488),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: item.isDestructive
                                          ? Colors.redAccent
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  if (item.subtitle != null) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      item.subtitle!,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: item.isDestructive
                                  ? Colors.redAccent.withOpacity(0.5)
                                  : const Color(0xFF94A3B8),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast)
                      const Divider(
                        height: 1,
                        indent: 70,
                        endIndent: 16,
                        color: Color(0xFFF1F5F9),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, ProfileController c) {
    Get.defaultDialog(
      title: 'Logout',
      titleStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      middleText: 'Are you sure you want to sign out from MediCare?',
      textConfirm: 'Logout',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      textCancel: 'Cancel',
      cancelTextColor: const Color(0xFF64748B),
      onConfirm: () {
        Get.back();
        c.logout();
      },
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _MenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.isDestructive = false,
  });
}
