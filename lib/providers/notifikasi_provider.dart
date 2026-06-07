import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/notifikasi.dart';
import 'package:siptatif_app/services/api_service.dart';

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
      final List<dynamic> data = await ApiService.get('notifikasi');
      _notifikasiList = data.map((json) => Notifikasi.fromJson(json)).toList();
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
        await ApiService.put('notifikasi/${n.id}', n.toJson());
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
      final response = await ApiService.post('notifikasi', newNotif.toJson());
      _notifikasiList.insert(0, Notifikasi.fromJson(response));
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Gagal menambah notifikasi: $e';
      notifyListeners();
    }
  }
}
