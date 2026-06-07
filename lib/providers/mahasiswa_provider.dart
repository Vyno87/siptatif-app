import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';
import 'package:siptatif_app/services/api_service.dart';

class MahasiswaProvider extends ChangeNotifier {
  List<Mahasiswa> _semuaMahasiswa = [];
  List<Mahasiswa> _displayedMahasiswa = [];
  String _searchKeyword = "";
  
  bool isLoading = false;
  String errorMessage = '';

  MahasiswaProvider() {
    fetchMahasiswa();
  }

  Future<void> fetchMahasiswa() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final List<dynamic> data = await ApiService.get('mahasiswa');
      _semuaMahasiswa = data.map((json) => Mahasiswa.fromJson(json)).toList();
      _displayedMahasiswa = List.from(_semuaMahasiswa);
      if (_searchKeyword.isNotEmpty) {
        runFilter(_searchKeyword);
      }
    } catch (e) {
      errorMessage = "Terjadi kesalahan saat memuat data mahasiswa.";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<Mahasiswa> get listMahasiswa => _displayedMahasiswa;

  void runFilter(String enteredKeyword) {
    _searchKeyword = enteredKeyword;
    if (_searchKeyword.isEmpty) {
      _displayedMahasiswa = List.from(_semuaMahasiswa);
    } else {
      _displayedMahasiswa = _semuaMahasiswa
          .where((mhs) =>
              mhs.nama.toLowerCase().contains(_searchKeyword.toLowerCase()) ||
              mhs.nim.contains(_searchKeyword))
          .toList();
    }
    notifyListeners();
  }

  Future<void> addMahasiswa(Mahasiswa m) async {
    try {
      final response = await ApiService.post('mahasiswa', m.toJson());
      final newMhs = Mahasiswa.fromJson(response);
      _semuaMahasiswa.add(newMhs);
      _displayedMahasiswa.add(newMhs);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menambah mahasiswa');
    }
  }

  Future<void> hapusMahasiswa(Mahasiswa m) async {
    if (m.id == null) return;
    try {
      await ApiService.delete('mahasiswa/${m.id}');
      _semuaMahasiswa.removeWhere((item) => item.id == m.id);
      _displayedMahasiswa.removeWhere((item) => item.id == m.id);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menghapus mahasiswa');
    }
  }

  Future<void> updateMahasiswa(Mahasiswa m) async {
    if (m.id == null) return;
    try {
      final response = await ApiService.put('mahasiswa/${m.id}', m.toJson());
      final updatedMhs = Mahasiswa.fromJson(response);
      
      final idxSemua = _semuaMahasiswa.indexWhere((item) => item.id == m.id);
      if (idxSemua != -1) _semuaMahasiswa[idxSemua] = updatedMhs;
      
      final idxDisplay = _displayedMahasiswa.indexWhere((item) => item.id == m.id);
      if (idxDisplay != -1) _displayedMahasiswa[idxDisplay] = updatedMhs;
      
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal mengupdate mahasiswa: $e');
    }
  }
}
