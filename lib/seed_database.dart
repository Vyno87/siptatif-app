import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Menambahkan Akun Admin
  await FirebaseFirestore.instance.collection('users').doc('admin_siptatif').set({
    'nama': 'Administrator SIPTATIF',
    'nim': '-',
    'email': 'vynothea7@gmail.com',
    'password': 'Nyorean9',
    'role': 'Koordinator TA',
  });

  // Menambahkan Akun Dosen
  await FirebaseFirestore.instance.collection('users').doc('dosen_budi').set({
    'nama': 'Budi Santoso, M.Kom',
    'nidn': '1234567890',
    'email': 'budi@siptatif.com',
    'password': 'dosen123',
    'role': 'Dosen',
  });

  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            "✅ Database Berhasil Di-seed!\nSilakan tutup aplikasi ini dan jalankan ulang SIPTATIF.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ),
  );
}
