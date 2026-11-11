import 'package:flutter/material.dart';

class ChatModel {
  final int doctorId;
  final String doctorName;
  final String lastMessage;
  final String time;
  final int unread;
  final bool online;
  final String specialty;
  final String hospital;
  final Color avatarColor;

  ChatModel({
    this.doctorId = 1,
    required this.doctorName,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    this.online = false,
    this.specialty = 'General Physician',
    this.hospital = 'Apollo Hospital',
    this.avatarColor = const Color(0xFF0D9488),
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    Color color = const Color(0xFF0D9488);
    if (json['avatar_color'] != null) {
      final hex = json['avatar_color'].toString().replaceAll('#', '');
      if (hex.length == 6) {
        try {
          color = Color(int.parse('FF$hex', radix: 16));
        } catch (_) {}
      }
    }

    String timeStr = 'Recent';
    if (json['last_message_time'] != null) {
      try {
        final dt = DateTime.parse(json['last_message_time']);
        final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
        final period = dt.hour >= 12 ? 'PM' : 'AM';
        timeStr = '$hour:${dt.minute.toString().padLeft(2, '0')} $period';
      } catch (_) {}
    }

    return ChatModel(
      doctorId: json['doctor_id'] is int
          ? json['doctor_id']
          : int.tryParse(json['doctor_id']?.toString() ?? '1') ?? 1,
      doctorName: json['doctor_name'] ?? 'Doctor',
      specialty: json['specialty'] ?? 'Specialist',
      hospital: json['hospital'] ?? 'Hospital',
      lastMessage: json['last_message'] ?? 'Available for consultation',
      time: timeStr,
      unread: json['unread_count'] is int
          ? json['unread_count']
          : int.tryParse(json['unread_count']?.toString() ?? '0') ?? 0,
      online: json['online'] == true || json['online'] == 1,
      avatarColor: color,
    );
  }
}

class ChatMessage {
  final int? id;
  final String text;
  final bool isMe;
  final String time;
  final bool isRead;

  ChatMessage({
    this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = true,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    String timeStr = 'Now';
    if (json['created_at'] != null) {
      try {
        final dt = DateTime.parse(json['created_at']);
        final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
        final period = dt.hour >= 12 ? 'PM' : 'AM';
        timeStr = '$hour:${dt.minute.toString().padLeft(2, '0')} $period';
      } catch (_) {}
    }

    return ChatMessage(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? ''),
      text: json['message'] ?? '',
      isMe: json['sender'] == 'user',
      time: timeStr,
      isRead: json['is_read'] == true || json['is_read'] == 1,
    );
  }
}
