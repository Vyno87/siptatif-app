import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siptatif_app/services/api_service.dart';

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
      // Memeriksa ke backend apakah ada user dengan email dan password ini
      final List<dynamic> users = await ApiService.get('users?email=$email&password=$password');

      if (users.isNotEmpty) {
        final userData = users.first;
        final prefs = await SharedPreferences.getInstance();
        
        // Simpan data user ke SharedPreferences
        await prefs.setString('user_profile', jsonEncode(userData));

        _currentUser = User.fromJson(userData);
        return true;
      } else {
        _errorMessage = 'Email atau password salah!';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan.';
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
    notifyListeners();
  }

  // Fungsi untuk pendaftaran
  Future<bool> register(User newUser) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Cek apakah email sudah ada
      final List<dynamic> existing = await ApiService.get('users?email=${newUser.email}');
      if (existing.isNotEmpty) {
        _errorMessage = 'Email sudah terdaftar!';
        return false;
      }

      await ApiService.post('users', newUser.toJson());
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
      final List<dynamic> users = await ApiService.get('users?email=$email');
      if (users.isEmpty) {
        _errorMessage = 'Email tidak ditemukan!';
        return false;
      }

      final userData = users.first;
      userData['password'] = newPassword; // update password
      
      await ApiService.put('users/${userData['id']}', userData);
      return true;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan saat mereset password.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
