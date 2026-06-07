import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/yudisium.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/providers/yudisium_provider.dart';
import 'package:siptatif_app/widgets/glass_card.dart';

class PengesahanRevisiScreen extends StatelessWidget {
  const PengesahanRevisiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final dosenName = user?.fullName ?? '';

    final mhsProvider = context.watch<MahasiswaProvider>();
    final yudisiumProvider = context.watch<YudisiumProvider>();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter mahasiswa yang bimbingan dosen ini
    final mhsBimbingan = mhsProvider.listMahasiswa.where((m) => 
      m.calonDosenPembimbing1 == dosenName || m.calonDosenPembimbing2 == dosenName
    ).toList();

    // Dapatkan data Yudisium untuk mahasiswa bimbingan tersebut
    final listPengajuan = <Map<String, dynamic>>[];
    for (var mhs in mhsBimbingan) {
      try {
        final yudisium = yudisiumProvider.listYudisium.firstWhere((y) => y.mahasiswaId == mhs.nim);
        listPengajuan.add({
          'mahasiswa': mhs,
          'yudisium': yudisium,
        });
      } catch (e) {
        // Belum ada pengajuan yudisium
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Persetujuan Yudisium'),
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
                        color: Colors.blue.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.assignment_turned_in_rounded, color: Colors.blue, size: 30),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pengesahan Dokumen Revisi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Validasi dokumen revisi skripsi final mahasiswa bimbingan Anda.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: listPengajuan.isEmpty
                    ? const Center(child: Text('Belum ada pengajuan revisi yudisium dari mahasiswa bimbingan Anda.'))
                    : ListView.builder(
                        itemCount: listPengajuan.length,
                        itemBuilder: (context, index) {
                          final item = listPengajuan[index];
                          final Mahasiswa mhs = item['mahasiswa'];
                          final Yudisium yudisium = item['yudisium'];

                          return _PengajuanCard(mhs: mhs, yudisium: yudisium);
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

class _PengajuanCard extends StatelessWidget {
  final Mahasiswa mhs;
  final Yudisium yudisium;

  const _PengajuanCard({required this.mhs, required this.yudisium});

  void _validasiRevisi(BuildContext context, String status) async {
    final yudisiumProvider = context.read<YudisiumProvider>();
    yudisium.statusPembimbing = status;
    
    final success = await yudisiumProvider.updateYudisium(yudisium);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Revisi berhasil di-${status.toLowerCase()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.orange;
    if (yudisium.statusPembimbing == 'Disetujui') statusColor = Colors.green;
    if (yudisium.statusPembimbing == 'Ditolak') statusColor = Colors.red;

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor.withValues(alpha: 0.2),
                  child: Icon(Icons.person, color: statusColor),
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
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    yudisium.statusPembimbing,
                    style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Text('Dokumen Diajukan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 20),
                const SizedBox(width: 8),
                Text(yudisium.dokumenRevisi, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
              ],
            ),
            const SizedBox(height: 16),
            if (yudisium.statusPembimbing == 'Menunggu') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _validasiRevisi(context, 'Ditolak'),
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Minta Perbaikan'),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () => _validasiRevisi(context, 'Disetujui'),
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Setujui Dokumen'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  )
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}
