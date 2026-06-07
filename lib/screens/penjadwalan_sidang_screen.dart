import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/sidang.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/providers/sidang_provider.dart';
import 'package:siptatif_app/widgets/glass_card.dart';

class PenjadwalanSidangScreen extends StatefulWidget {
  const PenjadwalanSidangScreen({super.key});

  @override
  State<PenjadwalanSidangScreen> createState() => _PenjadwalanSidangScreenState();
}

class _PenjadwalanSidangScreenState extends State<PenjadwalanSidangScreen> {
  void _showPenjadwalanDialog(BuildContext context, Sidang sidang, String namaMhs) {
    final tglController = TextEditingController(text: sidang.tanggalSidang);
    final waktuController = TextEditingController(text: sidang.waktuSidang);
    final ruangController = TextEditingController(text: sidang.ruangan);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Penjadwalan Sidang: $namaMhs'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: tglController,
                  decoration: const InputDecoration(labelText: 'Tanggal Sidang (YYYY-MM-DD)', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: waktuController,
                  decoration: const InputDecoration(labelText: 'Waktu Sidang (HH:MM)', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: ruangController,
                  decoration: const InputDecoration(labelText: 'Ruangan', border: OutlineInputBorder()),
                  validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final sidangProvider = context.read<SidangProvider>();
                  final mhsProvider = context.read<MahasiswaProvider>();

                  final newSidangData = Sidang(
                    id: sidang.id,
                    mahasiswaId: sidang.mahasiswaId,
                    drafLaporan: sidang.drafLaporan,
                    tanggalSidang: tglController.text,
                    waktuSidang: waktuController.text,
                    ruangan: ruangController.text,
                    status: 'Dijadwalkan',
                  );

                  // Cek bentrok penguji
                  try {
                    final targetMhs = mhsProvider.listMahasiswa.firstWhere((m) => m.nim == sidang.mahasiswaId);
                    final isConflict = sidangProvider.checkConflict(newSidangData, targetMhs, mhsProvider.listMahasiswa);

                    if (isConflict) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('⚠️ TERDETEKSI BENTROK: Dosen Penguji sudah ada jadwal sidang di waktu yang sama!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // Jangan simpan, hentikan operasi
                    }
                  } catch (e) {
                    debugPrint('Gagal: $e');
                  }

                  // Jika tidak bentrok, simpan
                  await sidangProvider.updateSidang(newSidangData);
                  
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Jadwal sidang berhasil ditetapkan!')),
                    );
                  }
                }
              },
              child: const Text('Simpan Jadwal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sidangProvider = context.watch<SidangProvider>();
    final mhsProvider = context.watch<MahasiswaProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final sidangList = sidangProvider.listSidang;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Penjadwalan Sidang'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
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
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.calendar_month_rounded, color: Theme.of(context).colorScheme.primary, size: 30),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Manajemen Jadwal Sidang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Daftar pengajuan ujian dari mahasiswa.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: sidangList.isEmpty
                ? const Center(child: Text('Belum ada pendaftar sidang.'))
                : ListView.builder(
                    itemCount: sidangList.length,
                    itemBuilder: (context, index) {
                      final sidang = sidangList[index];
                      // Cari nama mahasiswa
                      String namaMhs = 'Unknown';
                      try {
                        namaMhs = mhsProvider.listMahasiswa.firstWhere((m) => m.nim == sidang.mahasiswaId).nama;
                      } catch (e) {
                        debugPrint('Gagal mencari nama mahasiswa: $e');
                      }

                      return GlassCard(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: sidang.status == 'Menunggu Jadwal' ? Colors.orange : Colors.green,
                            child: Icon(
                              sidang.status == 'Menunggu Jadwal' ? Icons.pending_actions : Icons.event_available,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(namaMhs, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('NIM: ${sidang.mahasiswaId}'),
                              Text('Status: ${sidang.status}', style: TextStyle(color: sidang.status == 'Menunggu Jadwal' ? Colors.orange : Colors.green)),
                              if (sidang.status == 'Dijadwalkan') ...[
                                Text('Waktu: ${sidang.tanggalSidang} | ${sidang.waktuSidang}'),
                                Text('Ruang: ${sidang.ruangan}'),
                              ]
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () => _showPenjadwalanDialog(context, sidang, namaMhs),
                            child: const Text('Tetapkan'),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      ),
    );
  }
}
