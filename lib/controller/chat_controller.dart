import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/chat_model.dart';
import '../services/api_service.dart';

class ChatController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedFilter = 'All'.obs; // 'All', 'Unread', 'Online'
  final isLoading = false.obs;

  final chats = <ChatModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }

  Future<void> loadConversations() async {
    isLoading.value = true;
    try {
      final list = await ApiService.getChatConversations();
      if (list.isNotEmpty) {
        chats.assignAll(list);
      } else {
        // Fallback to live doctors so user can start conversation with any doctor
        final doctors = await ApiService.getDoctors();
        if (doctors.isNotEmpty) {
          chats.assignAll(
            doctors.map((d) => ChatModel(
              doctorId: d.id,
              doctorName: d.name,
              specialty: d.specialty,
              hospital: d.hospital,
              lastMessage: 'Tap to start consultation',
              time: 'Available',
              unread: 0,
              online: d.online,
              avatarColor: d.avatarColor,
            )).toList(),
          );
        }
      }
    } catch (e) {
      debugPrint('ℹ️ [ChatController] loadConversations error: $e');
    } finally {
      isLoading.value = false;
    }
  }

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
        doctorId: old.doctorId,
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
  final int doctorId;
  final String doctorName;
  final String specialty;
  final bool isDoctorOnline;
  final Color avatarColor;

  ChatDetailController(
    this.doctorName, {
    this.doctorId = 1,
    this.specialty = 'Specialist',
    this.isDoctorOnline = true,
    this.avatarColor = const Color(0xFF0D9488),
  });

  final messageController = TextEditingController();
  final scrollController = ScrollController();
  final isTyping = false.obs;
  final isLoading = false.obs;

  final messages = <ChatMessage>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  Future<void> loadMessages() async {
    isLoading.value = true;
    try {
      final list = await ApiService.getChatMessages(doctorId);
      if (list.isNotEmpty) {
        messages.assignAll(list);
        _scrollToBottom();
      } else {
        // Initial friendly greeting from doctor
        messages.assignAll([
          ChatMessage(
            text: 'Hello! I am $doctorName. How may I assist with your health today?',
            isMe: false,
            time: 'Recent',
            isRead: true,
          ),
        ]);
      }
    } catch (e) {
      debugPrint('ℹ️ [ChatDetailController] loadMessages error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> send([String? customText]) async {
    final text = (customText ?? messageController.text).trim();
    if (text.isEmpty) return;

    if (customText == null) {
      messageController.clear();
    }

    final newMsg = ChatMessage(
      text: text,
      isMe: true,
      time: _currentTime(),
      isRead: false,
    );
    messages.add(newMsg);
    _scrollToBottom();

    try {
      // Send message to REST API to save into MySQL database
      await ApiService.sendChatMessage(doctorId, text);
    } catch (e) {
      debugPrint('ℹ️ [ChatDetailController] send error: $e');
    }

    // Dynamic doctor reply
    _simulateDoctorReply(text);
  }

  void _simulateDoctorReply(String userMsg) {
    isTyping.value = true;
    Future.delayed(const Duration(milliseconds: 1400), () {
      isTyping.value = false;
      String reply = 'Thank you for updating me. Continue the prescribed routine and let me know if symptoms persist.';
      final lower = userMsg.toLowerCase();
      if (lower.contains('pain') || lower.contains('headache') || lower.contains('fever')) {
        reply = 'Please rest and stay hydrated. If symptoms persist for more than 24 hours, let me know.';
      } else if (lower.contains('report') || lower.contains('test')) {
        reply = 'I reviewed your clinical details. Everything appears in the safe range. Keep maintaining your routine!';
      } else if (lower.contains('thank')) {
        reply = 'You are most welcome! Take good care of your health. 😊';
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
