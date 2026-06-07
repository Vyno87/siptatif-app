import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/yudisium.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('yudisium').get();
      _listYudisium = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Yudisium.fromJson(data);
      }).toList();
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
      final docRef = await FirebaseFirestore.instance.collection('yudisium').add(yudisium.toJson());
      yudisium.id = docRef.id;
      _listYudisium.add(yudisium);
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
      await FirebaseFirestore.instance.collection('yudisium').doc(yudisium.id).update(yudisium.toJson());
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
