import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/yudisium.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/providers/yudisium_provider.dart';
import 'package:siptatif_app/widgets/glass_card.dart';

class ManajemenYudisiumScreen extends StatelessWidget {
  const ManajemenYudisiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mhsProvider = context.watch<MahasiswaProvider>();
    final yudisiumProvider = context.watch<YudisiumProvider>();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Ambil data yudisium yang sudah disetujui pembimbing tapi belum disahkan koordinator
    final listPengesahan = <Map<String, dynamic>>[];
    for (var yudisium in yudisiumProvider.listYudisium) {
      if (yudisium.statusPembimbing == 'Disetujui') {
        try {
          final mhs = mhsProvider.listMahasiswa.firstWhere((m) => m.nim == yudisium.mahasiswaId);
          listPengesahan.add({
            'mahasiswa': mhs,
            'yudisium': yudisium,
          });
        } catch (e) {
          // data mhs tidak ditemukan
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Manajemen Yudisium'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark 
              ? [const Color(0xFF231557), const Color(0xFF44107A), const Color(0xFFFF1361)]
              : [const Color(0xFF8EC5FC), const Color(0xFFE0C3FC)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.verified_user_rounded, color: Colors.purple, size: 30),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pengesahan Yudisium Final', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Sahkan kelulusan mahasiswa yang dokumen revisinya telah disetujui pembimbing.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: listPengesahan.isEmpty
                    ? const Center(child: Text('Belum ada mahasiswa yang menunggu pengesahan yudisium.'))
                    : ListView.builder(
                        itemCount: listPengesahan.length,
                        itemBuilder: (context, index) {
                          final item = listPengesahan[index];
                          final Mahasiswa mhs = item['mahasiswa'];
                          final Yudisium yudisium = item['yudisium'];

                          return _YudisiumAdminCard(mhs: mhs, yudisium: yudisium);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _YudisiumAdminCard extends StatelessWidget {
  final Mahasiswa mhs;
  final Yudisium yudisium;

  const _YudisiumAdminCard({required this.mhs, required this.yudisium});

  void _sahkanKelulusan(BuildContext context) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Konfirmasi Pengesahan'),
        content: Text('Apakah Anda yakin ingin mengesahkan kelulusan untuk ${mhs.nama} (${mhs.nim})?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context); // Tutup dialog

              final yudisiumProvider = context.read<YudisiumProvider>();
              yudisium.statusYudisium = 'Lulus Yudisium';
              
              final success = await yudisiumProvider.updateYudisium(yudisium);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${mhs.nama} berhasil disahkan dan resmi lulus!')),
                );
              }
            },
            child: const Text('Ya, Sahkan Lulus'),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLulus = yudisium.statusYudisium == 'Lulus Yudisium';

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: isLulus ? Colors.green.withValues(alpha: 0.2) : Colors.blue.withValues(alpha: 0.2),
                  child: Icon(isLulus ? Icons.school_rounded : Icons.person, color: isLulus ? Colors.green : Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mhs.nama, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(mhs.nim, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: (isLulus ? Colors.green : Colors.purple).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    yudisium.statusYudisium,
                    style: TextStyle(color: isLulus ? Colors.green : Colors.purple, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 20),
                const SizedBox(width: 8),
                Text(yudisium.dokumenRevisi, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Disetujui Pembimbing: ${mhs.calonDosenPembimbing1}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            if (!isLulus) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _sahkanKelulusan(context),
                  icon: const Icon(Icons.workspace_premium_rounded),
                  label: const Text('Sahkan Kelulusan Yudisium'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}
