import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/penguji.dart';
import 'package:siptatif_app/services/api_service.dart';

class PengujiProvider extends ChangeNotifier {
  List<Penguji> _semuaPenguji = [];
  List<Penguji> _displayedPenguji = [];
  String _searchKeyword = "";
  
  bool isLoading = false;
  String errorMessage = '';

  PengujiProvider() {
    fetchPenguji();
  }

  Future<void> fetchPenguji() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final List<dynamic> data = await ApiService.get('penguji');
      _semuaPenguji = data.map((json) => Penguji.fromJson(json)).toList();
      _displayedPenguji = List.from(_semuaPenguji);
      if (_searchKeyword.isNotEmpty) {
        runFilter(_searchKeyword);
      }
    } catch (e) {
      errorMessage = "Terjadi kesalahan saat memuat data penguji.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Penguji> get listPenguji => _displayedPenguji;

  void runFilter(String enteredKeyword) {
    _searchKeyword = enteredKeyword;
    if (_searchKeyword.isEmpty) {
      _displayedPenguji = List.from(_semuaPenguji);
    } else {
      _displayedPenguji = _semuaPenguji
          .where((penguji) =>
              penguji.nama.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
              penguji.nidn.contains(_searchKeyword))
          .toList();
    }
    notifyListeners();
  }

  Future<void> tambahPenguji(Penguji p) async {
    try {
      final response = await ApiService.post('penguji', p.toJson());
      final newPenguji = Penguji.fromJson(response);
      _semuaPenguji.add(newPenguji);
      _displayedPenguji.add(newPenguji);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menambah penguji');
    }
  }

  Future<void> updatePenguji(Penguji oldP, Penguji newP) async {
    if (oldP.id == null) return;
    newP.id = oldP.id;
    try {
      final response = await ApiService.put('penguji/${newP.id}', newP.toJson());
      final updated = Penguji.fromJson(response);
      
      final indexAll = _semuaPenguji.indexWhere((item) => item.id == newP.id);
      if (indexAll != -1) _semuaPenguji[indexAll] = updated;
      
      final indexDisp = _displayedPenguji.indexWhere((item) => item.id == newP.id);
      if (indexDisp != -1) _displayedPenguji[indexDisp] = updated;
      
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal mengupdate penguji');
    }
  }

  Future<void> hapusPenguji(Penguji p) async {
    if (p.id == null) return;
    try {
      await ApiService.delete('penguji/${p.id}');
      _semuaPenguji.removeWhere((item) => item.id == p.id);
      _displayedPenguji.removeWhere((item) => item.id == p.id);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menghapus penguji');
    }
  }
}
