import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/logbook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogbookProvider extends ChangeNotifier {
  List<Logbook> _listLogbook = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Logbook> get listLogbook => _listLogbook;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  LogbookProvider() {
    fetchLogbooks();
  }

  Future<void> fetchLogbooks() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('logbooks').get();
      _listLogbook = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Logbook.fromJson(data);
      }).toList();

      // Simpan data ke local cache
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(_listLogbook.map((e) => e.toJson()).toList());
      await prefs.setString('offline_logbook', encodedData);

    } catch (e) {
      // Ambil data dari local cache jika offline
      try {
        final prefs = await SharedPreferences.getInstance();
        final String? cachedData = prefs.getString('offline_logbook');
        if (cachedData != null) {
          final List<dynamic> decodedData = jsonDecode(cachedData);
          _listLogbook = decodedData.map((e) => Logbook.fromJson(e)).toList();
          _errorMessage = 'Mode Offline: Menampilkan data logbook tersimpan.';
        } else {
          _errorMessage = 'Gagal memuat data logbook: $e';
        }
      } catch (cacheError) {
        _errorMessage = 'Gagal memuat data logbook: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addLogbook(Logbook logbook) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final docRef = await FirebaseFirestore.instance.collection('logbooks').add(logbook.toJson());
      logbook.id = docRef.id;
      _listLogbook.add(logbook);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal menambahkan logbook: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateLogbook(Logbook logbook) async {
    if (logbook.id == null) return false;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('logbooks').doc(logbook.id).update(logbook.toJson());
      final index = _listLogbook.indexWhere((l) => l.id == logbook.id);
      if (index != -1) {
        _listLogbook[index] = logbook;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui logbook: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
