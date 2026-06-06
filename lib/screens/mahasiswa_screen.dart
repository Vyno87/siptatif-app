import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/mahasiswa_data.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';
import 'package:siptatif_app/widgets/mahasiswa_card.dart';

class MahasiswaScreen extends StatefulWidget {
  const MahasiswaScreen({super.key});

  @override
  State<MahasiswaScreen> createState() => _MahasiswaScreenState();
}

class _MahasiswaScreenState extends State<MahasiswaScreen> {
  List<Mahasiswa> _displayedData = [];

  @override
  void initState() {
    super.initState();
    _displayedData = List.from(mahasiswaData);
  }

  void _runFilter(String enteredKeyword) {
    List<Mahasiswa> results = [];
    if (enteredKeyword.isEmpty) {
      results = List.from(mahasiswaData);
    } else {
      results = mahasiswaData
          .where((mhs) =>
              mhs.nama.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              mhs.nim.contains(enteredKeyword))
          .toList();
    }

    setState(() {
      _displayedData = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      child: Column(
        children: [
          const SizedBox(
            height: 3,
          ),
          TextField(
            onChanged: (value) => _runFilter(value),
            style: const TextStyle(height: 1),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              hintText: 'Search by Nama atau NIM',
            ),
          ),
          const SizedBox(
            height: 3,
          ),
          Column(
            children:
                _displayedData.map((mhs) => MahasiswaCard(mhs: mhs)).toList(),
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
