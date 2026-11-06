import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_detail_screen.dart';
import '../services/api_service.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String category; // 'Appointments', 'Messages', 'Alerts'
  bool isRead;
  final String? actionLabel;
  final VoidCallback? onAction;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.category,
    this.isRead = false,
    this.actionLabel,
    this.onAction,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String selectedFilter = 'All';

  late List<NotificationItem> notifications;

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _fetchLiveNotifications();
  }

  Future<void> _fetchLiveNotifications() async {
    try {
      final list = await ApiService.getNotifications();
      if (mounted && list.isNotEmpty) {
        setState(() {
          notifications = list.map((item) {
            final cat = item['category'] ?? 'Alerts';
            IconData icon = Icons.notifications_active_rounded;
            Color iconColor = const Color(0xFF0D9488);
            Color iconBg = const Color(0xFFCCFBF1);

            if (cat == 'Appointments') {
              icon = Icons.event_available_rounded;
              iconColor = const Color(0xFF0D9488);
              iconBg = const Color(0xFFCCFBF1);
            } else if (cat == 'Messages') {
              icon = Icons.chat_bubble_outline_rounded;
              iconColor = const Color(0xFF3B82F6);
              iconBg = const Color(0xFFDBEAFE);
            } else {
              icon = Icons.campaign_rounded;
              iconColor = const Color(0xFFF59E0B);
              iconBg = const Color(0xFFFEF3C7);
            }

            return NotificationItem(
              id: item['id']?.toString() ?? '1',
              title: item['title'] ?? 'Notification',
              message: item['message'] ?? '',
              time: item['time'] ?? 'Recent',
              icon: icon,
              iconColor: iconColor,
              iconBg: iconBg,
              category: cat,
              isRead: item['is_read'] == true || item['is_read'] == 1,
            );
          }).toList();
        });
      }
    } catch (_) {}
  }

  void _initNotifications() {
    notifications = [
      NotificationItem(
        id: '1',
        title: 'Upcoming Appointment Today',
        message: 'Your consultation with Dr. Ananya Sharma (Cardiology) is scheduled today at 4:30 PM.',
        time: '15m ago',
        icon: Icons.event_available_rounded,
        iconColor: const Color(0xFF0D9488),
        iconBg: const Color(0xFFCCFBF1),
        category: 'Appointments',
        isRead: false,
        actionLabel: 'View Details',
        onAction: () {
          Get.snackbar(
            'Appointment Details',
            'Dr. Ananya Sharma • 4:30 PM Today',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF0D9488),
            colorText: Colors.white,
          );
        },
      ),
      NotificationItem(
        id: '2',
        title: 'New Message from Doctor',
        message: 'Dr. Priya Verma: "See you on Friday for the follow-up consultation. Please bring test reports."',
        time: '1 hour ago',
        icon: Icons.chat_bubble_rounded,
        iconColor: const Color(0xFF2563EB),
        iconBg: const Color(0xFFDBEAFE),
        category: 'Messages',
        isRead: false,
        actionLabel: 'Reply Now',
        onAction: () {
          Get.to(() => const ChatDetailScreen(
                doctorName: 'Dr. Priya Verma',
                specialty: 'Neurologist',
                avatarColor: Color(0xFF8B5CF6),
                isDoctorOnline: true,
              ));
        },
      ),
      NotificationItem(
        id: '3',
        title: 'Booking Confirmed!',
        message: 'Your appointment with Dr. Rohan Mehta (Dentist) has been confirmed for tomorrow, 11:30 AM.',
        time: '3 hours ago',
        icon: Icons.check_circle_rounded,
        iconColor: const Color(0xFF10B981),
        iconBg: const Color(0xFFD1FAE5),
        category: 'Appointments',
        isRead: false,
        actionLabel: 'View Slot',
        onAction: () {
          Get.snackbar(
            'City Dental Care',
            'Slot: Tomorrow 11:30 AM with Dr. Rohan Mehta',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF0D9488),
            colorText: Colors.white,
          );
        },
      ),
      NotificationItem(
        id: '4',
        title: 'Digital Prescription Uploaded',
        message: 'Dr. Amit Singh uploaded your digital orthopedic prescription. You can view or download it anytime.',
        time: 'Yesterday',
        icon: Icons.medication_rounded,
        iconColor: const Color(0xFFD97706),
        iconBg: const Color(0xFFFEF3C7),
        category: 'Alerts',
        isRead: true,
        actionLabel: 'View Rx',
        onAction: () {
          Get.snackbar(
            'Prescription Ready',
            'Downloading digital prescription PDF...',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF0D9488),
            colorText: Colors.white,
          );
        },
      ),
      NotificationItem(
        id: '5',
        title: 'Daily Hydration & Vitals Tip',
        message: 'Staying well hydrated improves blood circulation and helps manage mild headaches. Remember to log your water intake!',
        time: '2 days ago',
        icon: Icons.water_drop_rounded,
        iconColor: const Color(0xFF06B6D4),
        iconBg: const Color(0xFFCFFAFE),
        category: 'Alerts',
        isRead: true,
      ),
    ];
  }

  List<NotificationItem> get filteredList {
    if (selectedFilter == 'All') return notifications;
    if (selectedFilter == 'Unread') {
      return notifications.where((n) => !n.isRead).toList();
    }
    return notifications.where((n) => n.category == selectedFilter).toList();
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void _markAllAsRead() {
    setState(() {
      for (var item in notifications) {
        item.isRead = true;
      }
    });
    Get.snackbar(
      'Updated',
      'All notifications marked as read',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void _clearAllNotifications() {
    Get.defaultDialog(
      title: 'Clear Notifications',
      titleStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      middleText: 'Are you sure you want to clear all notifications?',
      textConfirm: 'Clear All',
      confirmTextColor: Colors.white,
      buttonColor: Colors.redAccent,
      textCancel: 'Cancel',
      cancelTextColor: const Color(0xFF64748B),
      onConfirm: () {
        Get.back();
        setState(() {
          notifications.clear();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      body: SafeArea(
        child: Column(
          children: [
            // Teal Gradient Header
            _buildHeader(context),

            // Category Filter Pills
            const SizedBox(height: 16),
            _buildFilterTabs(),

            // Notifications List
            const SizedBox(height: 12),
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 20, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const Expanded(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (unreadCount > 0)
                InkWell(
                  onTap: _markAllAsRead,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.done_all_rounded, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Mark read',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    unreadCount > 0 ? '$unreadCount unread updates' : 'All caught up',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                if (notifications.isNotEmpty)
                  GestureDetector(
                    onTap: _clearAllNotifications,
                    child: const Text(
                      'Clear all',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCCFBF1),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['All', 'Unread', 'Appointments', 'Messages', 'Alerts'];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = filters[i];
          final isSelected = selectedFilter == f;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = f;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0D9488) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0D9488)
                      : const Color(0xFFCCFBF1),
                  width: 1.2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF0D9488).withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                f == 'Unread' ? 'Unread ($unreadCount)' : f,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: filteredList.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final item = filteredList[i];

        return Dismissible(
          key: Key(item.id),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            setState(() {
              notifications.removeWhere((n) => n.id == item.id);
            });
            Get.snackbar(
              'Notification Dismissed',
              item.title,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            );
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Colors.redAccent.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 26),
          ),
          child: InkWell(
            onTap: () {
              setState(() {
                item.isRead = true;
              });
              if (item.onAction != null) {
                item.onAction!();
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: !item.isRead
                      ? const Color(0xFF0D9488).withOpacity(0.4)
                      : Colors.transparent,
                  width: 1.4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D9488).withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon badge
                  Stack(
                    children: [
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: item.iconBg,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          item.icon,
                          color: item.iconColor,
                          size: 24,
                        ),
                      ),
                      if (!item.isRead)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            height: 11,
                            width: 11,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0D9488),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  // Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontWeight:
                                      !item.isRead ? FontWeight.w800 : FontWeight.w700,
                                  fontSize: 14,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                            Text(
                              item.time,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: !item.isRead ? FontWeight.w600 : FontWeight.w400,
                                color: !item.isRead
                                    ? const Color(0xFF0D9488)
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.message,
                          style: TextStyle(
                            fontSize: 13,
                            height: 1.4,
                            color: !item.isRead
                                ? const Color(0xFF334155)
                                : const Color(0xFF64748B),
                          ),
                        ),
                        if (item.actionLabel != null) ...[
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                item.isRead = true;
                              });
                              item.onAction?.call();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDFA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFCCFBF1)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    item.actionLabel!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0D9488),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 14,
                                    color: Color(0xFF0D9488),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 72,
              width: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFF0FDFA),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_off_outlined,
                color: Color(0xFF0D9488),
                size: 38,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You have no updates in this category right now. We will notify you whenever there are new updates.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedFilter = 'All';
                  _initNotifications();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Refresh Notifications',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
