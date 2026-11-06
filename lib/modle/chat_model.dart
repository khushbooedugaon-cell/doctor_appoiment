import 'package:flutter/material.dart';

class ChatModel {
  final String doctorName;
  final String lastMessage;
  final String time;
  final int unread;
  final bool online;
  final String specialty;
  final String hospital;
  final Color avatarColor;

  ChatModel({
    required this.doctorName,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    this.online = false,
    this.specialty = 'General Physician',
    this.hospital = 'Apollo Hospital',
    this.avatarColor = const Color(0xFF0D9488),
  });
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = true,
  });
}
