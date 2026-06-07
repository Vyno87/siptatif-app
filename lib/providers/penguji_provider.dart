import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/penguji.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('penguji').get();
      _semuaPenguji = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Penguji.fromJson(data);
      }).toList();
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
      final docRef = await FirebaseFirestore.instance.collection('penguji').add(p.toJson());
      p.id = docRef.id;
      _semuaPenguji.add(p);
      _displayedPenguji.add(p);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menambah penguji');
    }
  }

  Future<void> updatePenguji(Penguji oldP, Penguji newP) async {
    if (oldP.id == null) return;
    newP.id = oldP.id;
    try {
      await FirebaseFirestore.instance.collection('penguji').doc(newP.id).update(newP.toJson());
      
      final idxSemua = _semuaPenguji.indexWhere((item) => item.id == newP.id);
      if (idxSemua != -1) _semuaPenguji[idxSemua] = newP;
      
      final idxDisplay = _displayedPenguji.indexWhere((item) => item.id == newP.id);
      if (idxDisplay != -1) _displayedPenguji[idxDisplay] = newP;
      
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal mengupdate penguji');
    }
  }

  Future<void> hapusPenguji(Penguji p) async {
    if (p.id == null) return;
    try {
      await FirebaseFirestore.instance.collection('penguji').doc(p.id).delete();
      _semuaPenguji.removeWhere((item) => item.id == p.id);
      _displayedPenguji.removeWhere((item) => item.id == p.id);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menghapus penguji');
    }
  }
}
