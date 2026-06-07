import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/logbook.dart';
import 'package:siptatif_app/services/api_service.dart';

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
      final List<dynamic> logbooks = await ApiService.get('logbooks');
      _listLogbook = logbooks.map((e) => Logbook.fromJson(e)).toList();
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
      final response = await ApiService.post('logbooks', logbook.toJson());
      _listLogbook.add(Logbook.fromJson(response));
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
      await ApiService.put('logbooks/${logbook.id}', logbook.toJson());
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
