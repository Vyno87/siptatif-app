import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser = User(
    email: '221091900024@students.unpam.ac.id',
    fullName: 'Ahmad Novy Mufasir',
    profilePict: 'assets/img/novy.jpeg',
    roles: 'Admin',
  );

  User? get currentUser => _currentUser;

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
