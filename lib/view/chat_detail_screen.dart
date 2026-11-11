import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';

class ChatDetailScreen extends StatelessWidget {
  final int doctorId;
  final String doctorName;
  final String specialty;
  final Color avatarColor;
  final bool isDoctorOnline;

  const ChatDetailScreen({
    super.key,
    this.doctorId = 1,
    required this.doctorName,
    this.specialty = 'Specialist',
    this.avatarColor = const Color(0xFF0D9488),
    this.isDoctorOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.put(
      ChatDetailController(
        doctorName,
        doctorId: doctorId,
        specialty: specialty,
        avatarColor: avatarColor,
        isDoctorOnline: isDoctorOnline,
      ),
      tag: '${doctorName}_$doctorId',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(68),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x200F766E),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.person_rounded,
                            color: avatarColor,
                            size: 26,
                          ),
                        ),
                      ),
                      if (isDoctorOnline)
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 11,
                            width: 11,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 6,
                              width: 6,
                              decoration: BoxDecoration(
                                color: isDoctorOnline
                                    ? const Color(0xFF34D399)
                                    : Colors.white54,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              isDoctorOnline
                                  ? '$specialty • Active Now'
                                  : '$specialty • Offline',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFFCCFBF1),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _callDoctor(context),
                    icon: const Icon(
                      Icons.phone_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _videoCallDoctor(context),
                    icon: const Icon(
                      Icons.videocam_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Security / consultation header pill
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE6FFFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFCCFBF1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.verified_user_rounded,
                  size: 14,
                  color: Color(0xFF0F766E),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Direct encrypted consultation with $doctorName',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F766E),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Messages list
          Expanded(
            child: Obx(
              () => ListView.builder(
                controller: c.scrollController,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                physics: const BouncingScrollPhysics(),
                itemCount: c.messages.length + (c.isTyping.value ? 1 : 0),
                itemBuilder: (_, i) {
                  if (i == c.messages.length && c.isTyping.value) {
                    return _buildTypingIndicator();
                  }

                  final m = c.messages[i];
                  return _buildMessageBubble(context, m);
                },
              ),
            ),
          ),

          // Quick replies row
          _buildQuickReplies(c),

          // Input field container
          _buildInputBar(context, c),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, dynamic m) {
    final isMe = m.isMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: isMe
              ? const LinearGradient(
                  colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isMe ? null : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 20),
          ),
          boxShadow: [
            BoxShadow(
              color: isMe
                  ? const Color(0xFF0D9488).withOpacity(0.18)
                  : Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              m.text,
              style: TextStyle(
                fontSize: 14,
                height: 1.35,
                color: isMe ? Colors.white : const Color(0xFF0F172A),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  m.time,
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe
                        ? Colors.white.withOpacity(0.75)
                        : const Color(0xFF94A3B8),
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all_rounded,
                    size: 14,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Doctor is typing',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              height: 10,
              width: 10,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: const Color(0xFF0D9488).withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickReplies(ChatDetailController c) {
    final replies = [
      '💊 Prescription query',
      '📅 Next follow-up',
      '👍 Feeling much better',
      '❓ Diet instructions',
    ];

    return Container(
      height: 38,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: replies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          return ActionChip(
            label: Text(replies[i]),
            labelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F766E),
            ),
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFCCFBF1)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onPressed: () => c.send(replies[i]),
          );
        },
      ),
    );
  }

  Widget _buildInputBar(BuildContext context, ChatDetailController c) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Get.snackbar(
                  'Attach File',
                  'Select prescriptions, reports or photos',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF0F766E),
                  colorText: Colors.white,
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 42,
                width: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0FDFA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Color(0xFF0D9488),
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: TextField(
                  controller: c.messageController,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => c.send(),
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: c.send,
              borderRadius: BorderRadius.circular(22),
              child: Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D9488).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _callDoctor(BuildContext context) {
    Get.defaultDialog(
      title: 'Voice Call',
      titleStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      middleText: 'Connecting direct audio call to $doctorName...',
      textConfirm: 'Start Call',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF0D9488),
      textCancel: 'Cancel',
      cancelTextColor: const Color(0xFF64748B),
      onConfirm: () {
        Get.back();
        Get.snackbar(
          'Connecting...',
          'Calling $doctorName',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0D9488),
          colorText: Colors.white,
        );
      },
    );
  }

  void _videoCallDoctor(BuildContext context) {
    Get.defaultDialog(
      title: 'Video Consultation',
      titleStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
      middleText: 'Start HD encrypted video consultation with $doctorName?',
      textConfirm: 'Join Video Call',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFF0D9488),
      textCancel: 'Cancel',
      cancelTextColor: const Color(0xFF64748B),
      onConfirm: () {
        Get.back();
        Get.snackbar(
          'Video Room Opened',
          'Connecting with $doctorName...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0D9488),
          colorText: Colors.white,
        );
      },
    );
  }
}
