import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/notifikasi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotifikasiProvider extends ChangeNotifier {
  List<Notifikasi> _notifikasiList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Notifikasi> get notifikasiList => _notifikasiList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  NotifikasiProvider() {
    fetchNotifikasi();
  }

  Future<void> fetchNotifikasi() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('notifikasi').get();
      _notifikasiList = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Notifikasi.fromJson(data);
      }).toList();
      // Reverse so newest is first
      _notifikasiList = _notifikasiList.reversed.toList();
    } catch (e) {
      _errorMessage = 'Gagal memuat notifikasi: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int get unreadCount {
    return _notifikasiList.where((n) => n.isRead == false).length;
  }

  Future<void> markAllAsRead() async {
    for (var n in _notifikasiList) {
      if (!n.isRead) {
        n.isRead = true;
        await FirebaseFirestore.instance.collection('notifikasi').doc(n.id).update(n.toJson());
      }
    }
    notifyListeners();
  }

  Future<void> tambahNotifikasi(String judul, String pesan) async {
    final now = DateTime.now();
    final timeStr = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
    
    final newNotif = Notifikasi(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      judul: judul,
      pesan: pesan,
      waktu: timeStr,
      isRead: false,
    );

    try {
      final docRef = await FirebaseFirestore.instance.collection('notifikasi').add(newNotif.toJson());
      newNotif.id = docRef.id;
      _notifikasiList.insert(0, newNotif); // Insert at top
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal menambah notifikasi: $e';
      notifyListeners();
    }
  }
}
