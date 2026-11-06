import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaqItem {
  final String question;
  final String answer;
  final String category;
  final IconData icon;

  const FaqItem({
    required this.question,
    required this.answer,
    required this.category,
    required this.icon,
  });
}

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<FaqItem> _faqs = const [
    FaqItem(
      question: 'How do I book an appointment with a doctor?',
      answer:
          '1. Go to the Home screen and browse doctors or choose a specialty.\n2. Tap "Book" on your selected doctor.\n3. Choose your preferred consultation type (In-Clinic or Video Call).\n4. Pick an available date and time slot.\n5. Confirm and complete your booking!',
      category: 'Appointments',
      icon: Icons.calendar_month_rounded,
    ),
    FaqItem(
      question: 'How can I cancel or reschedule my appointment?',
      answer:
          'Go to "Bookings" tab from the bottom navigation bar. Open your upcoming appointment, tap "Cancel Appointment" or "Reschedule". Cancellations made at least 2 hours prior to the slot are 100% free with no cancellation charge.',
      category: 'Appointments',
      icon: Icons.edit_calendar_rounded,
    ),
    FaqItem(
      question: 'How does Video Call consultation work?',
      answer:
          'When you book a "Video Call" slot, you will receive a reminder notification 15 minutes before the time. At the scheduled time, open your appointment details or the Chat tab and tap "Join Video Call" to consult directly in HD with your doctor.',
      category: 'Video Calls',
      icon: Icons.videocam_rounded,
    ),
    FaqItem(
      question: 'Where can I find and download my prescriptions?',
      answer:
          'Once your consultation is completed by the doctor, your digital prescription is automatically saved. You can view or download it under "My Appointments > Completed" or directly inside your chat conversation with that doctor.',
      category: 'Prescriptions',
      icon: Icons.medication_rounded,
    ),
    FaqItem(
      question: 'What payment methods are supported?',
      answer:
          'We support all major payment modes including UPI (Google Pay, PhonePe, Paytm), Credit & Debit Cards, Net Banking, and Pay at Clinic option during in-person visits.',
      category: 'Payments',
      icon: Icons.payment_rounded,
    ),
    FaqItem(
      question: 'Can I chat with my doctor after the appointment?',
      answer:
          'Yes! Every consultation includes 7 days of free follow-up messaging with your doctor through the Chat tab so you can share recovery updates and ask quick questions.',
      category: 'Appointments',
      icon: Icons.chat_bubble_rounded,
    ),
    FaqItem(
      question: 'How do I update my personal details and phone number?',
      answer:
          'Open the "Profile" screen from the bottom menu, tap "Edit Profile" or the pencil icon next to your name, modify your contact number or details, and tap "Save Changes".',
      category: 'Account',
      icon: Icons.person_rounded,
    ),
  ];

  List<FaqItem> get _filteredFaqs {
    final query = _searchQuery.trim().toLowerCase();
    return _faqs.where((faq) {
      final matchesQuery = query.isEmpty ||
          faq.question.toLowerCase().contains(query) ||
          faq.answer.toLowerCase().contains(query);

      if (!matchesQuery) return false;

      if (_selectedCategory == 'All') return true;
      return faq.category == _selectedCategory;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const categories = ['All', 'Appointments', 'Video Calls', 'Prescriptions', 'Payments', 'Account'];

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient Header
              _buildHeader(context),

              const SizedBox(height: 18),

              // Quick Contact Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quick Assistance',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildQuickActionGrid(context),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // FAQ Section Title & Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Frequently Asked Questions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Find immediate answers to common health & booking questions',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Category Pills
              SizedBox(
                height: 38,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final cat = categories[i];
                    final isSelected = _selectedCategory == cat;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = cat;
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
                          cat,
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
              ),

              const SizedBox(height: 14),

              // FAQs Accordion List
              _buildFaqList(),

              const SizedBox(height: 20),

              // Still Need Help Card
              _buildStillNeedHelpCard(context),

              const SizedBox(height: 30),
            ],
          ),
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
                  'Help & Support',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.headset_mic_rounded, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      '24/7 Desk',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Text(
              'How can we help you today?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search help topics, questions...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF0D9488),
                    size: 22,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 18, color: Color(0xFF64748B)),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.45,
      children: [
        _buildActionCard(
          icon: Icons.support_agent_rounded,
          iconColor: const Color(0xFF0D9488),
          bgColor: const Color(0xFFF0FDFA),
          title: 'Live Chat Support',
          subtitle: 'Instant assistance',
          onTap: () {
            Get.snackbar(
              'Connecting to Live Agent',
              'Our medical support executive is joining in 30 seconds...',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF0D9488),
              colorText: Colors.white,
            );
          },
        ),
        _buildActionCard(
          icon: Icons.phone_in_talk_rounded,
          iconColor: const Color(0xFF2563EB),
          bgColor: const Color(0xFFEFF6FF),
          title: 'Toll-Free Call',
          subtitle: '1800-456-7890',
          onTap: () {
            Get.defaultDialog(
              title: 'Call Support',
              titleStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              middleText: 'Dial our toll-free medical helpline 1800-456-7890?',
              textConfirm: 'Call Now',
              confirmTextColor: Colors.white,
              buttonColor: const Color(0xFF0D9488),
              textCancel: 'Cancel',
              cancelTextColor: const Color(0xFF64748B),
              onConfirm: () {
                Get.back();
                Get.snackbar('Dialing', '1800-456-7890', snackPosition: SnackPosition.BOTTOM);
              },
            );
          },
        ),
        _buildActionCard(
          icon: Icons.mail_outline_rounded,
          iconColor: const Color(0xFF8B5CF6),
          bgColor: const Color(0xFFF5F3FF),
          title: 'Email Us',
          subtitle: 'care@medicare.com',
          onTap: () {
            Get.snackbar(
              'Email Support',
              'Opening your email app to write to care@medicare.com',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xFF0D9488),
              colorText: Colors.white,
            );
          },
        ),
        _buildActionCard(
          icon: Icons.emergency_rounded,
          iconColor: const Color(0xFFEF4444),
          bgColor: const Color(0xFFFEF2F2),
          title: 'Emergency 108',
          subtitle: 'Ambulance & ICU SOS',
          onTap: () {
            Get.defaultDialog(
              title: '🚨 Emergency SOS',
              titleStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Color(0xFFEF4444)),
              middleText: 'Are you in a medical emergency? Call 108 Ambulance immediately.',
              textConfirm: 'Call 108 Now',
              confirmTextColor: Colors.white,
              buttonColor: const Color(0xFFEF4444),
              textCancel: 'Cancel',
              cancelTextColor: const Color(0xFF64748B),
              onConfirm: () {
                Get.back();
                Get.snackbar('Calling 108', 'Emergency services dispatched', snackPosition: SnackPosition.BOTTOM);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D9488).withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqList() {
    final list = _filteredFaqs;

    if (list.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, size: 40, color: Color(0xFF94A3B8)),
            const SizedBox(height: 10),
            const Text(
              'No answers found',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try searching with different keywords or browse all categories',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedCategory = 'All';
                });
              },
              child: const Text('Reset Search', style: TextStyle(color: Color(0xFF0D9488), fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final item = list[i];

        return Container(
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
          child: Theme(
            data: ThemeData(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDFA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  item.icon,
                  color: const Color(0xFF0D9488),
                  size: 20,
                ),
              ),
              title: Text(
                item.question,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Color(0xFF0F172A),
                ),
              ),
              iconColor: const Color(0xFF0D9488),
              collapsedIconColor: const Color(0xFF94A3B8),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 6),
                      Text(
                        item.answer,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text(
                            'Was this helpful?',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Get.snackbar(
                                'Thank you!',
                                'Feedback received',
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 1),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0FDFA),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFCCFBF1)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.thumb_up_alt_outlined, size: 12, color: Color(0xFF0D9488)),
                                  SizedBox(width: 4),
                                  Text('Yes', style: TextStyle(fontSize: 11, color: Color(0xFF0D9488), fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Get.snackbar(
                                'Feedback noted',
                                'We will improve this guide',
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 1),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.thumb_down_alt_outlined, size: 12, color: Color(0xFF64748B)),
                                  SizedBox(width: 4),
                                  Text('No', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStillNeedHelpCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0D9488).withOpacity(0.2),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.contact_support_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Still have questions?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Our patient care specialists reply within minutes',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCCFBF1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () => _openContactForm(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0F766E),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Send Us a Message',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openContactForm(BuildContext context) {
    final queryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Write to Patient Support',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Describe your issue and our team will get back via notification/email.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: queryController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter your question or problem here...',
                    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final text = queryController.text.trim();
                      if (text.isEmpty) return;
                      Navigator.pop(context);
                      Get.snackbar(
                        'Query Submitted!',
                        'Ticket #MED-4091 created. We will reply within 15 minutes.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: const Color(0xFF0D9488),
                        colorText: Colors.white,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Submit Support Ticket',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
