import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modle/chat_model.dart';

class ChatController extends GetxController {
  final chats = <ChatModel>[
    ChatModel(doctorName: 'Dr. Ananya Sharma', lastMessage: 'Please drink more water today', time: '4:12 PM', unread: 2, online: true),
    ChatModel(doctorName: 'Dr. Rohan Mehta', lastMessage: 'Your reports look fine', time: 'Yesterday', unread: 0),
    ChatModel(doctorName: 'Dr. Priya Verma', lastMessage: 'See you on Friday', time: 'Mon', unread: 1, online: true),
  ];
}

class ChatDetailController extends GetxController {
  final String doctorName;
  ChatDetailController(this.doctorName);

  final messageController = TextEditingController();
  final messages = <ChatMessage>[
    ChatMessage(text: 'Hello Doctor, I have a mild headache.', isMe: true, time: '4:00 PM'),
    ChatMessage(text: 'How long has this been going on?', isMe: false, time: '4:05 PM'),
    ChatMessage(text: 'Since last night.', isMe: true, time: '4:07 PM'),
    ChatMessage(text: 'Please drink more water today', isMe: false, time: '4:12 PM'),
  ].obs;

  void send() {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    messages.add(ChatMessage(text: text, isMe: true, time: 'Now'));
    messageController.clear();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }
}