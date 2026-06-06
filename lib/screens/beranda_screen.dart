import 'package:flutter/material.dart';
import 'package:siptatif_app/widgets/beranda_card.dart';

class BerandaObject {
  String nama;
  int terdaftar;
  int kuota;

  BerandaObject(
      {required this.nama, required this.terdaftar, required this.kuota});
}

List<BerandaObject> berandaData = [
  BerandaObject(
    nama: "Mahasiswa",
    terdaftar: 24,
    kuota: 120,
  ),
  BerandaObject(
    nama: "Penguji",
    terdaftar: 37,
    kuota: 13,
  ),
  BerandaObject(
    nama: "Pembimbing",
    terdaftar: 42,
    kuota: 12,
  ),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: berandaData
            .map((ret) => BerandaCard(berandaData: ret))
            .toList(),
      ),
    );
  }
}
