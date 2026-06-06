import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/widgets/mahasiswa_card.dart';

class MahasiswaScreen extends StatelessWidget {
  const MahasiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MahasiswaProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      child: Column(
        children: [
          const SizedBox(
            height: 3,
          ),
          TextField(
            onChanged: (value) => context.read<MahasiswaProvider>().runFilter(value),
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
            children: provider.listMahasiswa
                .map((mhs) => MahasiswaCard(mhs: mhs))
                .toList(),
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
