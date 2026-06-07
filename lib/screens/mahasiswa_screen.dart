import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/widgets/mahasiswa_card.dart';
import 'package:siptatif_app/utils/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MahasiswaScreen extends StatelessWidget {
  const MahasiswaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MahasiswaProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/tambah-mahasiswa');
        },
        backgroundColor: AppTheme.primaryPurple,
        child: const Icon(Icons.add, color: Colors.white),
      ).animate().scale(delay: 500.ms),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        child: Column(
          children: [
            const SizedBox(height: 3),
            TextField(
              onChanged: (value) => context.read<MahasiswaProvider>().runFilter(value),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.black26 : Colors.white60,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Search by Nama atau NIM',
                hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
              ),
            ).animate().fade(duration: 500.ms).slideY(begin: -0.2, end: 0),
            const SizedBox(height: 14),
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
                  return MahasiswaCard(mhs: mhs)
                      .animate()
                      .fade(delay: (100 * index).ms)
                      .slideX(begin: 0.1, end: 0, curve: Curves.easeOutBack);
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
