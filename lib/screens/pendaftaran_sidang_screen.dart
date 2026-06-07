import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/sidang.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/providers/sidang_provider.dart';
import 'package:siptatif_app/widgets/glass_card.dart';

class PendaftaranSidangScreen extends StatefulWidget {
  const PendaftaranSidangScreen({super.key});

  @override
  State<PendaftaranSidangScreen> createState() => _PendaftaranSidangScreenState();
}

class _PendaftaranSidangScreenState extends State<PendaftaranSidangScreen> {
  final _drafController = TextEditingController();
  bool _isUploading = false;

  @override
  void dispose() {
    _drafController.dispose();
    super.dispose();
  }

  void _ajukanSidang(String nim) async {
    if (_drafController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih draf laporan terlebih dahulu!')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    // Simulasi loading upload
    await Future.delayed(const Duration(seconds: 1));

    final newSidang = Sidang(
      mahasiswaId: nim,
      drafLaporan: _drafController.text,
      tanggalSidang: '',
      waktuSidang: '',
      ruangan: '',
      status: 'Menunggu Jadwal',
    );

    if (!mounted) return;
    final success = await context.read<SidangProvider>().addSidang(newSidang);

    setState(() {
      _isUploading = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pendaftaran Sidang Berhasil Dikirim!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final nim = user?.nimNidn ?? '';
    final sidangProvider = context.watch<SidangProvider>();

    final mySidangList = sidangProvider.listSidang.where((s) => s.mahasiswaId == nim).toList();
    final hasApplied = mySidangList.isNotEmpty;
    final mySidang = hasApplied ? mySidangList.first : null;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Pendaftaran Sidang'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: hasApplied ? _buildStatusSidang(mySidang!, isDark) : _buildFormPendaftaran(nim, isDark),
        ),
      ),
    );
  }

  Widget _buildFormPendaftaran(String nim, bool isDark) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.school_rounded, size: 60, color: Colors.blueAccent),
            const SizedBox(height: 16),
            const Text(
              'Pengajuan Sidang Akhir',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Unggah Draf Final Tugas Akhir Anda untuk divalidasi oleh Koordinator dan dijadwalkan sidangnya.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _drafController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Draf Laporan Final (PDF)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.upload_file_rounded),
                  onPressed: () {
                    setState(() {
                      _drafController.text = 'draf_tugas_akhir_final_$nim.pdf';
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isUploading ? null : () => _ajukanSidang(nim),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isUploading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Ajukan Pendaftaran',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSidang(Sidang sidang, bool isDark) {
    Color statusColor;
    IconData statusIcon;

    if (sidang.status == 'Dijadwalkan') {
      statusColor = Colors.green;
      statusIcon = Icons.event_available_rounded;
    } else if (sidang.status == 'Selesai') {
      statusColor = Colors.blue;
      statusIcon = Icons.verified_rounded;
    } else {
      statusColor = Colors.orange;
      statusIcon = Icons.pending_actions_rounded;
    }

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(statusIcon, size: 80, color: statusColor),
            const SizedBox(height: 16),
            Text(
              'Status: ${sidang.status}',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: statusColor),
            ),
            const SizedBox(height: 20),
            if (sidang.status == 'Menunggu Jadwal')
              const Text(
                'Pendaftaran Anda sedang diproses oleh Koordinator. Harap menunggu penetapan jadwal.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              )
            else ...[
              const Text(
                'Jadwal Ujian Sidang Anda:',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(Icons.calendar_today_rounded, 'Tanggal', sidang.tanggalSidang),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.access_time_rounded, 'Waktu', sidang.waktuSidang),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.room_rounded, 'Ruangan', sidang.ruangan),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
