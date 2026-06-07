import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/sidang.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/providers/sidang_provider.dart';
import 'package:siptatif_app/widgets/glass_card.dart';

class PenilaianSidangScreen extends StatefulWidget {
  const PenilaianSidangScreen({super.key});

  @override
  State<PenilaianSidangScreen> createState() => _PenilaianSidangScreenState();
}

class _PenilaianSidangScreenState extends State<PenilaianSidangScreen> {
  void _showPenilaianDialog(BuildContext context, Sidang sidang, String namaMhs, String peranDosen) {
    final formKey = GlobalKey<FormState>();
    final nilaiController = TextEditingController();
    final catatanController = TextEditingController(text: sidang.catatanRevisi ?? '');

    // Set nilai awal jika sudah pernah diinput
    if (peranDosen == 'Pembimbing' && sidang.nilaiPembimbing != null) {
      nilaiController.text = sidang.nilaiPembimbing.toString();
    } else if (peranDosen == 'Penguji 1' && sidang.nilaiPenguji1 != null) {
      nilaiController.text = sidang.nilaiPenguji1.toString();
    } else if (peranDosen == 'Penguji 2' && sidang.nilaiPenguji2 != null) {
      nilaiController.text = sidang.nilaiPenguji2.toString();
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Penilaian Sidang: $namaMhs'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Anda menilai sebagai: $peranDosen', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nilaiController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Nilai Total (0 - 100)', border: OutlineInputBorder()),
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Wajib diisi';
                    final n = double.tryParse(val);
                    if (n == null || n < 0 || n > 100) return 'Input tidak valid (0-100)';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: catatanController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Catatan / Revisi (Opsional)', border: OutlineInputBorder()),
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
                  final nilai = double.parse(nilaiController.text);

                  if (peranDosen == 'Pembimbing') {
                    sidang.nilaiPembimbing = nilai;
                  } else if (peranDosen == 'Penguji 1') {
                    sidang.nilaiPenguji1 = nilai;
                  } else if (peranDosen == 'Penguji 2') {
                    sidang.nilaiPenguji2 = nilai;
                  }

                  if (catatanController.text.isNotEmpty) {
                    // Gabungkan catatan jika ada dosen lain yang sudah input
                    if (sidang.catatanRevisi != null && sidang.catatanRevisi!.isNotEmpty) {
                       sidang.catatanRevisi = '${sidang.catatanRevisi}\n[$peranDosen] ${catatanController.text}';
                    } else {
                       sidang.catatanRevisi = '[$peranDosen] ${catatanController.text}';
                    }
                  }

                  // Hitung kelulusan otomatis jika semua sudah menilai
                  sidangProvider.hitungKelulusan(sidang);

                  await sidangProvider.updateSidang(sidang);

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nilai berhasil disimpan!')),
                    );
                  }
                }
              },
              child: const Text('Simpan Nilai'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final sidangProvider = context.watch<SidangProvider>();
    final mhsProvider = context.watch<MahasiswaProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter daftar sidang yang sudah "Dijadwalkan" atau "Selesai"
    final sidangValid = sidangProvider.listSidang.where((s) => s.status == 'Dijadwalkan' || s.status == 'Selesai').toList();
    
    // Filter sidang di mana dosen ini terlibat
    final List<Map<String, dynamic>> sidangTerkait = [];

    for (var sidang in sidangValid) {
      try {
        final mhs = mhsProvider.listMahasiswa.firstWhere((m) => m.nim == sidang.mahasiswaId);
        String peran = '';
        if (mhs.calonDosenPembimbing1 == user?.fullName || mhs.calonDosenPembimbing2 == user?.fullName) {
          peran = 'Pembimbing';
        } else if (mhs.dosenPenguji1 == user?.fullName) {
          peran = 'Penguji 1';
        } else if (mhs.dosenPenguji2 == user?.fullName) {
          peran = 'Penguji 2';
        }

        if (peran.isNotEmpty) {
          sidangTerkait.add({
            'sidang': sidang,
            'mahasiswa': mhs,
            'peran': peran,
          });
        }
      } catch (e) {
        // Mhs tidak ditemukan
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Penilaian Sidang'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                      color: Colors.green.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.grading_rounded, color: Colors.green, size: 30),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Form Penilaian Sidang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Input nilai sidang mahasiswa bimbingan atau ujian Anda.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: sidangTerkait.isEmpty
                  ? const Center(child: Text('Belum ada jadwal sidang yang memerlukan penilaian Anda.'))
                  : ListView.builder(
                      itemCount: sidangTerkait.length,
                      itemBuilder: (context, index) {
                        final item = sidangTerkait[index];
                        final Sidang sidang = item['sidang'];
                        final namaMhs = item['mahasiswa'].nama;
                        final peran = item['peran'];

                        // Cek apakah dosen ini sudah menilai
                        bool sudahDinilai = false;
                        if (peran == 'Pembimbing' && sidang.nilaiPembimbing != null) sudahDinilai = true;
                        if (peran == 'Penguji 1' && sidang.nilaiPenguji1 != null) sudahDinilai = true;
                        if (peran == 'Penguji 2' && sidang.nilaiPenguji2 != null) sudahDinilai = true;

                        return GlassCard(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: CircleAvatar(
                              backgroundColor: sudahDinilai ? Colors.blue : Colors.orange,
                              child: Icon(
                                sudahDinilai ? Icons.check_circle : Icons.edit_document,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(namaMhs, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('Peran Anda: $peran', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                                Text('Waktu: ${sidang.tanggalSidang} | ${sidang.waktuSidang}'),
                                if (sudahDinilai) const Text('Status Anda: Sudah Dinilai', style: TextStyle(color: Colors.blue)),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _showPenilaianDialog(context, sidang, namaMhs, peran),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: sudahDinilai ? Colors.grey : null,
                              ),
                              child: Text(sudahDinilai ? 'Edit Nilai' : 'Beri Nilai'),
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
