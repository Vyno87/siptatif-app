import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/yudisium.dart';
import 'package:siptatif_app/datas/models/sidang.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/providers/sidang_provider.dart';
import 'package:siptatif_app/providers/yudisium_provider.dart';
import 'package:siptatif_app/widgets/glass_card.dart';

class YudisiumMahasiswaScreen extends StatefulWidget {
  const YudisiumMahasiswaScreen({super.key});

  @override
  State<YudisiumMahasiswaScreen> createState() => _YudisiumMahasiswaScreenState();
}

class _YudisiumMahasiswaScreenState extends State<YudisiumMahasiswaScreen> {
  final _drafController = TextEditingController();
  bool _isUploading = false;

  @override
  void dispose() {
    _drafController.dispose();
    super.dispose();
  }

  void _ajukanYudisium(String nim) async {
    if (_drafController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih dokumen revisi final terlebih dahulu!')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    await Future.delayed(const Duration(seconds: 1)); // Simulasi upload

    final newYudisium = Yudisium(
      mahasiswaId: nim,
      dokumenRevisi: _drafController.text,
      statusPembimbing: 'Menunggu',
      statusYudisium: 'Proses Pengesahan',
    );

    if (!mounted) return;
    final success = await context.read<YudisiumProvider>().ajukanYudisium(newYudisium);

    setState(() {
      _isUploading = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dokumen revisi berhasil diajukan untuk Yudisium!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final nim = user?.nimNidn ?? '';
    
    final sidangProvider = context.watch<SidangProvider>();
    final yudisiumProvider = context.watch<YudisiumProvider>();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Cari data sidang
    final mySidangList = sidangProvider.listSidang.where((s) => s.mahasiswaId == nim).toList();
    Sidang? mySidang = mySidangList.isNotEmpty ? mySidangList.first : null;

    // Cari data yudisium
    final myYudisiumList = yudisiumProvider.listYudisium.where((y) => y.mahasiswaId == nim).toList();
    Yudisium? myYudisium = myYudisiumList.isNotEmpty ? myYudisiumList.first : null;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
            ? [const Color(0xFF231557), const Color(0xFF44107A), const Color(0xFFFF1361)]
            : [const Color(0xFF8EC5FC), const Color(0xFFE0C3FC)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Yudisium & Kelulusan'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: _buildBodyContent(mySidang, myYudisium, nim, isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent(Sidang? sidang, Yudisium? yudisium, String nim, bool isDark) {
    if (sidang == null || sidang.status != 'Selesai') {
      return GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Icon(Icons.block_rounded, size: 80, color: Colors.orange.withValues(alpha: 0.8)),
              const SizedBox(height: 20),
              const Text(
                'Belum Memenuhi Syarat',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Anda belum dapat mengajukan yudisium karena sidang akhir belum selesai atau nilai belum lengkap. Silakan selesaikan tahapan sebelumnya.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (yudisium != null && yudisium.statusYudisium == 'Lulus Yudisium') {
      return _buildLulusYudisiumView(sidang);
    }

    if (yudisium != null) {
      return _buildStatusYudisiumView(yudisium);
    }

    return _buildFormPengajuan(nim, sidang);
  }

  Widget _buildFormPengajuan(String nim, Sidang sidang) {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.workspace_premium_rounded, size: 60, color: Colors.blueAccent),
            const SizedBox(height: 16),
            const Text(
              'Pengajuan Yudisium',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Selamat! Sidang akhir Anda telah selesai dengan predikat ${sidang.statusKelulusan}. Silakan unggah dokumen revisi final untuk pengesahan.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            if (sidang.catatanRevisi != null && sidang.catatanRevisi!.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Catatan Revisi Sidang:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                    const SizedBox(height: 8),
                    Text(sidang.catatanRevisi!),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 30),
            TextField(
              controller: _drafController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Dokumen Revisi Final (PDF)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.upload_file_rounded),
                  onPressed: () {
                    setState(() {
                      _drafController.text = 'revisi_final_skripsi_$nim.pdf';
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isUploading ? null : () => _ajukanYudisium(nim),
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
                      'Ajukan Dokumen Yudisium',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusYudisiumView(Yudisium yudisium) {
    Color statusColor = Colors.orange;
    IconData statusIcon = Icons.hourglass_top_rounded;

    if (yudisium.statusPembimbing == 'Ditolak') {
      statusColor = Colors.red;
      statusIcon = Icons.error_outline_rounded;
    } else if (yudisium.statusPembimbing == 'Disetujui' && yudisium.statusYudisium == 'Proses Pengesahan') {
      statusColor = Colors.blue;
      statusIcon = Icons.verified_user_rounded;
    }

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(statusIcon, size: 80, color: statusColor),
            const SizedBox(height: 16),
            const Text(
              'Status Pengesahan Revisi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildDetailRow(Icons.file_present_rounded, 'Dokumen Diajukan', yudisium.dokumenRevisi),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.person_rounded, 'Status Pembimbing', yudisium.statusPembimbing),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.admin_panel_settings_rounded, 'Status Koordinator', yudisium.statusYudisium),
            const SizedBox(height: 20),
            if (yudisium.statusPembimbing == 'Ditolak') ...[
              const Text(
                'Dokumen revisi Anda ditolak atau membutuhkan perbaikan lebih lanjut. Silakan perbaiki dan unggah ulang.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                   setState(() {
                     _drafController.text = 'revisi_final_skripsi_v2_${yudisium.mahasiswaId}.pdf';
                   });
                   // Simulate re-upload and update
                   final yudisiumProvider = context.read<YudisiumProvider>();
                   yudisium.dokumenRevisi = _drafController.text;
                   yudisium.statusPembimbing = 'Menunggu';
                   yudisiumProvider.updateYudisium(yudisium);
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Unggah Ulang Revisi'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
              )
            ] else if (yudisium.statusPembimbing == 'Disetujui') ...[
               const Text(
                'Dokumen revisi telah disetujui oleh Pembimbing. Saat ini sedang menunggu pengesahan final oleh Koordinator untuk menerbitkan kelulusan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ] else ...[
               const Text(
                'Menunggu persetujuan Dosen Pembimbing untuk dokumen revisi yang telah diunggah.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildLulusYudisiumView(Sidang sidang) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.yellow.withValues(alpha: 0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.yellow.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 5,
          )
        ]
      ),
      child: Column(
        children: [
          const Icon(Icons.stars_rounded, size: 100, color: Colors.yellow),
          const SizedBox(height: 16),
          const Text(
            'SELAMAT!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.yellow, letterSpacing: 2),
          ),
          const SizedBox(height: 10),
          const Text(
            'Anda Telah Lulus Yudisium',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 30),
          _buildDetailRow(Icons.score_rounded, 'Nilai Akhir', sidang.nilaiAkhir?.toString() ?? '-'),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.verified_rounded, 'Predikat', sidang.statusKelulusan ?? '-'),
          const SizedBox(height: 30),
          const Text(
            'Terima kasih atas perjuangan Anda. Semoga ilmu yang didapat bermanfaat untuk masa depan yang gemilang!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
             onPressed: () {
               showDialog(
                 context: context,
                 builder: (_) => AlertDialog(
                   title: const Text('SKL Digital'),
                   content: const Text('Mengunduh Surat Keterangan Lulus (Simulasi).'),
                   actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
                 )
               );
             },
             icon: const Icon(Icons.download_rounded),
             label: const Text('Unduh SKL'),
             style: ElevatedButton.styleFrom(
               backgroundColor: Colors.green,
               foregroundColor: Colors.white,
               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)
             ),
          )
        ],
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
