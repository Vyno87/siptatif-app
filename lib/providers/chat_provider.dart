import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/chat.dart';
import 'package:siptatif_app/services/api_service.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> _chats = [];
  bool isLoading = false;
  String errorMessage = '';

  List<Chat> get chats => _chats;

  Future<void> fetchChats() async {
    isLoading = true;
    errorMessage = '';
    // Don't notifyListeners here unless you want to show full loading indicator every time it polls

    try {
      final List<dynamic> data = await ApiService.get('chats');
      _chats = data.map((json) => Chat.fromJson(json)).toList();
      _chats.sort((a, b) => DateTime.parse(a.timestamp).compareTo(DateTime.parse(b.timestamp)));
    } catch (e) {
      errorMessage = "Terjadi kesalahan saat memuat chat.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String senderId, String receiverId, String message, {String? fileUrl}) async {
    try {
      final chat = Chat(
        senderId: senderId,
        receiverId: receiverId,
        message: message,
        timestamp: DateTime.now().toIso8601String(),
        fileUrl: fileUrl,
      );

      final response = await ApiService.post('chats', chat.toJson());
      
      // Optimistic update
      _chats.add(Chat.fromJson(response));
      notifyListeners();
    } catch (e) {
      errorMessage = "Gagal mengirim pesan.";
      notifyListeners();
    }
  }

  // Helper to get chats between two specific users
  List<Chat> getChatsBetween(String userId1, String userId2) {
    return _chats.where((chat) =>
      (chat.senderId == userId1 && chat.receiverId == userId2) ||
      (chat.senderId == userId2 && chat.receiverId == userId1)
    ).toList();
  }
}
