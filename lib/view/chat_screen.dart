import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ChatController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7FBFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7FBFA),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        itemCount: c.chats.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final chat = c.chats[i];
          return ListTile(
            onTap: () => Get.to(() => ChatDetailScreen(doctorName: chat.doctorName)),
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            leading: Stack(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFCCFBF1),
                  child: Icon(Icons.person_rounded, color: Color(0xFF0D9488)),
                ),
                if (chat.online)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white)),
                    ),
                  ),
              ],
            ),
            title: Text(chat.doctorName, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            subtitle: Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(chat.time, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                if (chat.unread > 0) ...[
                  const SizedBox(height: 6),
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: const Color(0xFF0D9488),
                    child: Text('${chat.unread}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}