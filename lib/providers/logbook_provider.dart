import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/logbook.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    } catch (e) {
      _errorMessage = 'Gagal memuat data logbook: $e';
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
