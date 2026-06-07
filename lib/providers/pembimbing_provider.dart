import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/pembimbing.dart';
import 'package:siptatif_app/services/api_service.dart';

class PembimbingProvider extends ChangeNotifier {
  List<Pembimbing> _semuaPembimbing = [];
  List<Pembimbing> _displayedPembimbing = [];
  String _searchKeyword = "";
  
  bool isLoading = false;
  String errorMessage = '';

  PembimbingProvider() {
    fetchPembimbing();
  }

  Future<void> fetchPembimbing() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final List<dynamic> data = await ApiService.get('pembimbing');
      _semuaPembimbing = data.map((json) => Pembimbing.fromJson(json)).toList();
      _displayedPembimbing = List.from(_semuaPembimbing);
      if (_searchKeyword.isNotEmpty) {
        runFilter(_searchKeyword);
      }
    } catch (e) {
      errorMessage = "Terjadi kesalahan saat memuat data pembimbing.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Pembimbing> get listPembimbing => _displayedPembimbing;

  void runFilter(String enteredKeyword) {
    _searchKeyword = enteredKeyword;
    if (_searchKeyword.isEmpty) {
      _displayedPembimbing = List.from(_semuaPembimbing);
    } else {
      _displayedPembimbing = _semuaPembimbing
          .where((p) =>
              p.nama.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
              p.nidn.contains(_searchKeyword))
          .toList();
    }
    notifyListeners();
  }

  Future<void> tambahPembimbing(Pembimbing p) async {
    try {
      final response = await ApiService.post('pembimbing', p.toJson());
      final newPembimbing = Pembimbing.fromJson(response);
      _semuaPembimbing.add(newPembimbing);
      _displayedPembimbing.add(newPembimbing);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menambah pembimbing');
    }
  }

  Future<void> updatePembimbing(Pembimbing oldP, Pembimbing newP) async {
    if (oldP.id == null) return;
    newP.id = oldP.id;
    try {
      final response = await ApiService.put('pembimbing/${newP.id}', newP.toJson());
      final updated = Pembimbing.fromJson(response);
      
      final indexAll = _semuaPembimbing.indexWhere((item) => item.id == newP.id);
      if (indexAll != -1) _semuaPembimbing[indexAll] = updated;
      
      final indexDisp = _displayedPembimbing.indexWhere((item) => item.id == newP.id);
      if (indexDisp != -1) _displayedPembimbing[indexDisp] = updated;
      
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal mengupdate pembimbing');
    }
  }

  Future<void> hapusPembimbing(Pembimbing p) async {
    if (p.id == null) return;
    try {
      await ApiService.delete('pembimbing/${p.id}');
      _semuaPembimbing.removeWhere((item) => item.id == p.id);
      _displayedPembimbing.removeWhere((item) => item.id == p.id);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menghapus pembimbing');
    }
  }
}
