class ChatModel {
  final String doctorName;
  final String lastMessage;
  final String time;
  final int unread;
  final bool online;

  ChatModel({
    required this.doctorName,
    required this.lastMessage,
    required this.time,
    this.unread = 0,
    this.online = false,
  });
}

class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({required this.text, required this.isMe, required this.time});
}