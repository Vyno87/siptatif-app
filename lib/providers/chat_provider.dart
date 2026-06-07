import 'dart:async';
import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatProvider extends ChangeNotifier {
  List<Chat> _chats = [];
  bool isLoading = false;
  String errorMessage = '';
  StreamSubscription<QuerySnapshot>? _chatSubscription;

  List<Chat> get chats => _chats;

  Future<void> fetchChats() async {
    isLoading = true;
    errorMessage = '';
    
    _chatSubscription?.cancel();
    _chatSubscription = FirebaseFirestore.instance
        .collection('chats')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
          _chats = snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return Chat.fromJson(data);
          }).toList();
          
          isLoading = false;
          notifyListeners();
        }, onError: (e) {
          errorMessage = "Terjadi kesalahan saat memuat chat.";
          isLoading = false;
          notifyListeners();
        });
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

      await FirebaseFirestore.instance.collection('chats').add(chat.toJson());
      // No need to update _chats manually, the stream will trigger notifyListeners automatically.
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

  @override
  void dispose() {
    _chatSubscription?.cancel();
    super.dispose();
  }
}
