import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/widgets/mahasiswa_card.dart';

class MahasiswaScreen extends StatelessWidget {
  const MahasiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MahasiswaProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tambah-mahasiswa');
        },
        backgroundColor: Colors.amber,
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
      ),
      body: SingleChildScrollView(
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
            height: 14,
          ),
          if (provider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (provider.errorMessage.isNotEmpty)
            Center(
              child: Text(
                provider.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            )
          else
            Column(
              children: provider.listMahasiswa.asMap().entries.map((entry) {
                final index = entry.key;
                final mhs = entry.value;
                return TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 50 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: child,
                      ),
                    );
                  },
                  child: MahasiswaCard(mhs: mhs),
                );
              }).toList(),
            ),
          const SizedBox(
            height: 4,
          ),
          const SizedBox(
            height: 80, // Extra space for FAB
          ),
        ],
      ),
      ),
    );
  }
}
