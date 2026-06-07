import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/sidang.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SidangProvider extends ChangeNotifier {
  List<Sidang> _listSidang = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Sidang> get listSidang => _listSidang;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  SidangProvider() {
    fetchSidang();
  }

  Future<void> fetchSidang() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('sidang').get();
      _listSidang = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Sidang.fromJson(data);
      }).toList();
    } catch (e) {
      _errorMessage = 'Gagal memuat data sidang: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addSidang(Sidang sidang) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final docRef = await FirebaseFirestore.instance.collection('sidang').add(sidang.toJson());
      sidang.id = docRef.id;
      _listSidang.add(sidang);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal mendaftar sidang: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateSidang(Sidang sidang) async {
    if (sidang.id == null) return false;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('sidang').doc(sidang.id).update(sidang.toJson());
      final index = _listSidang.indexWhere((s) => s.id == sidang.id);
      if (index != -1) {
        _listSidang[index] = sidang;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Gagal memperbarui jadwal sidang: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cek apakah ada dosen penguji yang bentrok pada tanggal dan waktu yang sama
  bool checkConflict(Sidang newSidang, Mahasiswa targetMahasiswa, List<Mahasiswa> allMahasiswa) {
    if (newSidang.tanggalSidang.isEmpty || newSidang.waktuSidang.isEmpty) return false;

    final targetPenguji1 = targetMahasiswa.dosenPenguji1;
    final targetPenguji2 = targetMahasiswa.dosenPenguji2;

    if (targetPenguji1 == null && targetPenguji2 == null) return false;

    for (var existing in _listSidang) {
      // Abaikan jika id sama (sedang update) atau status Selesai
      if (existing.id == newSidang.id || existing.status == 'Selesai' || existing.status == 'Menunggu Jadwal') {
        continue;
      }

      if (existing.tanggalSidang == newSidang.tanggalSidang && existing.waktuSidang == newSidang.waktuSidang) {
        // Cari data mahasiswa untuk sidang ini
        try {
          final existingMhs = allMahasiswa.firstWhere((m) => m.nim == existing.mahasiswaId);
          final existingP1 = existingMhs.dosenPenguji1;
          final existingP2 = existingMhs.dosenPenguji2;

          if (targetPenguji1 != null && (targetPenguji1 == existingP1 || targetPenguji1 == existingP2)) {
            return true; // Bentrok di penguji 1
          }
          if (targetPenguji2 != null && (targetPenguji2 == existingP1 || targetPenguji2 == existingP2)) {
            return true; // Bentrok di penguji 2
          }
        } catch (e) {
          // Mahasiswa tidak ditemukan
        }
      }
    }
    return false;
  }

  void hitungKelulusan(Sidang sidang) {
    if (sidang.nilaiPenguji1 != null && sidang.nilaiPenguji2 != null && sidang.nilaiPembimbing != null) {
      // Hitung rata-rata
      double total = sidang.nilaiPenguji1! + sidang.nilaiPenguji2! + sidang.nilaiPembimbing!;
      double rataRata = total / 3;
      
      sidang.nilaiAkhir = double.parse(rataRata.toStringAsFixed(2));

      // Tentukan status kelulusan
      if (rataRata >= 80) {
        sidang.statusKelulusan = 'Lulus';
      } else if (rataRata >= 60) {
        sidang.statusKelulusan = 'Lulus Bersyarat';
      } else {
        sidang.statusKelulusan = 'Tidak Lulus';
      }

      // Jika semua nilai sudah masuk, otomatis ubah status sidang jadi Selesai
      sidang.status = 'Selesai';
    }
  }
}
