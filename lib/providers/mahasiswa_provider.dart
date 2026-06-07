import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('mahasiswa').get();
      _semuaMahasiswa = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Mahasiswa.fromJson(data);
      }).toList();
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
      final docRef = await FirebaseFirestore.instance.collection('mahasiswa').add(m.toJson());
      m.id = docRef.id;
      _semuaMahasiswa.add(m);
      _displayedMahasiswa.add(m);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menambah mahasiswa');
    }
  }

  Future<void> hapusMahasiswa(Mahasiswa m) async {
    if (m.id == null) return;
    try {
      await FirebaseFirestore.instance.collection('mahasiswa').doc(m.id).delete();
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
      await FirebaseFirestore.instance.collection('mahasiswa').doc(m.id).update(m.toJson());
      
      final idxSemua = _semuaMahasiswa.indexWhere((item) => item.id == m.id);
      if (idxSemua != -1) _semuaMahasiswa[idxSemua] = m;
      
      final idxDisplay = _displayedMahasiswa.indexWhere((item) => item.id == m.id);
      if (idxDisplay != -1) _displayedMahasiswa[idxDisplay] = m;
      
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal mengupdate mahasiswa: $e');
    }
  }
}
