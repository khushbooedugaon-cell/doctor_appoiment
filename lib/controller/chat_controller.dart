import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/chat_model.dart';

class ChatController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedFilter = 'All'.obs; // 'All', 'Unread', 'Online'

  final chats = <ChatModel>[
    ChatModel(
      doctorName: 'Dr. Ananya Sharma',
      specialty: 'Cardiologist',
      hospital: 'Apollo Hospital',
      lastMessage: 'Please drink more water today and avoid heavy exercise.',
      time: '4:12 PM',
      unread: 2,
      online: true,
      avatarColor: const Color(0xFF0D9488),
    ),
    ChatModel(
      doctorName: 'Dr. Rohan Mehta',
      specialty: 'Dentist',
      hospital: 'City Dental Care',
      lastMessage: 'Your dental X-ray reports look completely normal.',
      time: '11:30 AM',
      unread: 0,
      online: false,
      avatarColor: const Color(0xFF3B82F6),
    ),
    ChatModel(
      doctorName: 'Dr. Priya Verma',
      specialty: 'Neurologist',
      hospital: 'Max Super Speciality',
      lastMessage: 'See you on Friday for the follow-up consultation.',
      time: 'Yesterday',
      unread: 1,
      online: true,
      avatarColor: const Color(0xFF8B5CF6),
    ),
    ChatModel(
      doctorName: 'Dr. Amit Singh',
      specialty: 'Orthopedic',
      hospital: 'Fortis Hospital',
      lastMessage: 'Take the prescribed calcium supplements after breakfast.',
      time: '2 days ago',
      unread: 0,
      online: true,
      avatarColor: const Color(0xFFF59E0B),
    ),
    ChatModel(
      doctorName: 'Dr. Neha Gupta',
      specialty: 'Dermatologist',
      hospital: 'Skin & Cure Clinic',
      lastMessage: 'Apply the prescribed sunscreen 20 mins before going outside.',
      time: '3 days ago',
      unread: 0,
      online: false,
      avatarColor: const Color(0xFFEC4899),
    ),
  ].obs;

  List<ChatModel> get filteredChats {
    final query = searchQuery.value.trim().toLowerCase();
    return chats.where((chat) {
      final matchesQuery = query.isEmpty ||
          chat.doctorName.toLowerCase().contains(query) ||
          chat.specialty.toLowerCase().contains(query) ||
          chat.lastMessage.toLowerCase().contains(query);

      if (!matchesQuery) return false;

      if (selectedFilter.value == 'Unread') {
        return chat.unread > 0;
      } else if (selectedFilter.value == 'Online') {
        return chat.online;
      }
      return true;
    }).toList();
  }

  List<ChatModel> get onlineDoctors =>
      chats.where((chat) => chat.online).toList();

  int get totalUnread =>
      chats.fold(0, (sum, chat) => sum + chat.unread);

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void updateSearch(String val) {
    searchQuery.value = val;
  }

  void markAsRead(String doctorName) {
    final index = chats.indexWhere((c) => c.doctorName == doctorName);
    if (index != -1 && chats[index].unread > 0) {
      final old = chats[index];
      chats[index] = ChatModel(
        doctorName: old.doctorName,
        specialty: old.specialty,
        hospital: old.hospital,
        lastMessage: old.lastMessage,
        time: old.time,
        unread: 0,
        online: old.online,
        avatarColor: old.avatarColor,
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}

class ChatDetailController extends GetxController {
  final String doctorName;
  final String specialty;
  final bool isDoctorOnline;
  final Color avatarColor;

  ChatDetailController(
    this.doctorName, {
    this.specialty = 'Specialist',
    this.isDoctorOnline = true,
    this.avatarColor = const Color(0xFF0D9488),
  });

  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final isTyping = false.obs;

  final messages = <ChatMessage>[
    ChatMessage(
      text: 'Hello Doctor, I have been having a mild headache since yesterday.',
      isMe: true,
      time: '4:00 PM',
      isRead: true,
    ),
    ChatMessage(
      text: 'Hello! How long has this headache been persisting? Any dizziness or blurred vision?',
      isMe: false,
      time: '4:05 PM',
      isRead: true,
    ),
    ChatMessage(
      text: 'Since last night. No dizziness, just mild throbbing in the forehead after working on the laptop.',
      isMe: true,
      time: '4:07 PM',
      isRead: true,
    ),
    ChatMessage(
      text: 'Understood. Please drink at least 2-3 liters of water, take regular 20-20-20 screen breaks, and rest in a well-ventilated room.',
      isMe: false,
      time: '4:12 PM',
      isRead: true,
    ),
  ].obs;

  void send([String? customText]) {
    final text = (customText ?? messageController.text).trim();
    if (text.isEmpty) return;

    messages.add(
      ChatMessage(
        text: text,
        isMe: true,
        time: _currentTime(),
        isRead: false,
      ),
    );

    if (customText == null) {
      messageController.clear();
    }
    _scrollToBottom();

    // Simulated doctor response after 1.2 seconds
    _simulateDoctorReply(text);
  }

  void _simulateDoctorReply(String userMsg) {
    isTyping.value = true;
    Future.delayed(const Duration(milliseconds: 1400), () {
      isTyping.value = false;
      String reply = 'Thank you for updating me. Continue the prescribed routine and let me know if symptoms persist.';
      if (userMsg.toLowerCase().contains('pain') || userMsg.toLowerCase().contains('headache')) {
        reply = 'Please take Paracetamol 500mg if the headache intensifies, and make sure to get 8 hours of sleep.';
      } else if (userMsg.toLowerCase().contains('report') || userMsg.toLowerCase().contains('test')) {
        reply = 'I reviewed your reports. Everything is in the normal range. Keep up the healthy lifestyle!';
      } else if (userMsg.toLowerCase().contains('thank')) {
        reply = 'You are most welcome! Take care and stay healthy. 😊';
      }

      messages.add(
        ChatMessage(
          text: reply,
          isMe: false,
          time: _currentTime(),
          isRead: true,
        ),
      );
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _currentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
