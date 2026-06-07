import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/pembimbing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('pembimbing').get();
      _semuaPembimbing = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Pembimbing.fromJson(data);
      }).toList();
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
      final docRef = await FirebaseFirestore.instance.collection('pembimbing').add(p.toJson());
      p.id = docRef.id;
      _semuaPembimbing.add(p);
      _displayedPembimbing.add(p);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menambah pembimbing');
    }
  }

  Future<void> updatePembimbing(Pembimbing oldP, Pembimbing newP) async {
    if (oldP.id == null) return;
    newP.id = oldP.id;
    try {
      await FirebaseFirestore.instance.collection('pembimbing').doc(newP.id).update(newP.toJson());
      
      final idxSemua = _semuaPembimbing.indexWhere((item) => item.id == newP.id);
      if (idxSemua != -1) _semuaPembimbing[idxSemua] = newP;
      
      final idxDisplay = _displayedPembimbing.indexWhere((item) => item.id == newP.id);
      if (idxDisplay != -1) _displayedPembimbing[idxDisplay] = newP;
      
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal mengupdate pembimbing');
    }
  }

  Future<void> hapusPembimbing(Pembimbing p) async {
    if (p.id == null) return;
    try {
      await FirebaseFirestore.instance.collection('pembimbing').doc(p.id).delete();
      _semuaPembimbing.removeWhere((item) => item.id == p.id);
      _displayedPembimbing.removeWhere((item) => item.id == p.id);
      notifyListeners();
    } catch (e) {
      throw Exception('Gagal menghapus pembimbing');
    }
  }
}
