import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/yudisium.dart';
import 'package:siptatif_app/services/api_service.dart';

class YudisiumProvider extends ChangeNotifier {
  List<Yudisium> _listYudisium = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Yudisium> get listYudisium => _listYudisium;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  YudisiumProvider() {
    fetchYudisium();
  }

  Future<void> fetchYudisium() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final List<dynamic> data = await ApiService.get('yudisium');
      _listYudisium = data.map((e) => Yudisium.fromJson(e)).toList();
    } catch (e) {
      _errorMessage = 'Gagal memuat data yudisium: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> ajukanYudisium(Yudisium yudisium) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await ApiService.post('yudisium', yudisium.toJson());
      _listYudisium.add(Yudisium.fromJson(response));
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mengajukan yudisium: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateYudisium(Yudisium yudisium) async {
    if (yudisium.id == null) return false;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await ApiService.put('yudisium/${yudisium.id}', yudisium.toJson());
      final index = _listYudisium.indexWhere((y) => y.id == yudisium.id);
      if (index != -1) {
        _listYudisium[index] = yudisium;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui data yudisium: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
