import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String _errorMessage = '';

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    checkToken();
  }

  // Fungsi untuk mengecek token saat aplikasi baru dibuka (Auto Login)
  Future<void> checkToken() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userDataStr = prefs.getString('user_profile');

      if (userDataStr != null) {
        // Simulasi jika profil ada, kita asumsikan sesi valid
        final userData = jsonDecode(userDataStr);
        _currentUser = User.fromJson(userData);
      } else {
        _currentUser = null;
      }
    } catch (e) {
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk melakukan login (Simulasi API GET ke users)
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Memeriksa ke Firestore apakah ada user dengan email dan password ini
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final userData = doc.data() as Map<String, dynamic>;
        userData['id'] = doc.id; // Inject ID
        
        final tempUser = User.fromJson(userData);
        
        // Pengecekan Admin Hardcode
        if (tempUser.email == 'vynothea7@gmail.com') {
          tempUser.roles = 'Admin';
          tempUser.status = 'approved';
          userData['roles'] = 'Admin';
          userData['status'] = 'approved';
        } else if (tempUser.status == 'pending') {
          _errorMessage = 'Akun Anda sedang menunggu persetujuan Admin.';
          return false;
        }

        final prefs = await SharedPreferences.getInstance();
        
        // Simpan data user ke SharedPreferences
        await prefs.setString('user_profile', jsonEncode(userData));

        _currentUser = tempUser;
        return true;
      } else {
        _errorMessage = 'Email atau password salah!';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_profile');
    _currentUser = null;
    _errorMessage = '';
    notifyListeners();
  }

  // Fungsi untuk pendaftaran
  Future<bool> register(User newUser) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Cek apakah email sudah ada di Firestore
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: newUser.email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _errorMessage = 'Email sudah terdaftar!';
        return false;
      }

      await FirebaseFirestore.instance.collection('users').add(newUser.toJson());
      return true;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk reset password
  Future<bool> resetPassword(String email, String newPassword) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        _errorMessage = 'Email tidak ditemukan!';
        return false;
      }

      final docId = snapshot.docs.first.id;
      
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        'password': newPassword
      });
      return true;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan saat mereset password.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk mengunggah dan memperbarui foto profil
  Future<bool> uploadProfilePicture(String filePath) async {
    if (_currentUser == null || _currentUser!.id == null) return false;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      final downloadUrl = 'data:image/jpeg;base64,$base64Image';

      // Simpan langsung ke Firestore tanpa Firebase Storage
      await FirebaseFirestore.instance.collection('users').doc(_currentUser!.id).update({
        'profilePict': downloadUrl
      });

      // Update data lokal
      _currentUser!.profilePict = downloadUrl;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile', jsonEncode(_currentUser!.toJson()));

      return true;
    } catch (e) {
      _errorMessage = 'Gagal mengunggah foto profil: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
