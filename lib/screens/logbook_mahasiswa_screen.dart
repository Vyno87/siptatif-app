import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/logbook.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/providers/logbook_provider.dart';
import 'package:siptatif_app/utils/app_theme.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class LogbookMahasiswaScreen extends StatefulWidget {
  const LogbookMahasiswaScreen({super.key});

  @override
  State<LogbookMahasiswaScreen> createState() => _LogbookMahasiswaScreenState();
}

class _LogbookMahasiswaScreenState extends State<LogbookMahasiswaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _materiController = TextEditingController();

  @override
  void dispose() {
    _materiController.dispose();
    super.dispose();
  }

  void _showAddLogbookDialog(BuildContext context, String nim, String dosenNidn) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.7),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.note_add_rounded, size: 48, color: Colors.blueAccent),
                    const SizedBox(height: 16),
                    Text(
                      'Catat Bimbingan Baru',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _materiController,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Materi / Progres Bimbingan',
                          labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
                          filled: true,
                          fillColor: isDark ? Colors.black26 : Colors.white60,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Materi tidak boleh kosong';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Batal', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primaryPurple,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final newLogbook = Logbook(
                                mahasiswaId: nim,
                                dosenNidn: dosenNidn, // Di V1 ini asumsi otomatis ke pembimbing pertama
                                tanggal: DateTime.now().toIso8601String().split('T')[0],
                                materiProgres: _materiController.text,
                                catatanDosen: '',
                                status: 'Menunggu Validasi',
                              );
                              
                              final success = await context.read<LogbookProvider>().addLogbook(newLogbook);
                              
                              if (!context.mounted) return;
                              if (success) {
                                _materiController.clear();
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Logbook berhasil ditambahkan')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Gagal menambahkan logbook')),
                                );
                              }
                            }
                          },
                          child: const Text('Simpan', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fade(duration: 400.ms);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final logbookProvider = context.watch<LogbookProvider>();
    final nim = user?.nimNidn ?? '';

    // Filter logbook hanya untuk mahasiswa yang login
    final myLogbooks = logbookProvider.listLogbook.where((l) => l.mahasiswaId == nim).toList();
    // Urutkan dari yang terbaru
    myLogbooks.sort((a, b) => b.tanggal.compareTo(a.tanggal));

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGlassGradient : AppTheme.neonGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Asumsi dosenNidn didapat dari relasi (kita isi '0001' untuk simulasi)
            _showAddLogbookDialog(context, nim, '0001');
          },
          icon: const Icon(Icons.add_comment_rounded, color: Colors.white),
          label: const Text('Catat Bimbingan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: AppTheme.primaryPurple,
          elevation: 4,
        ).animate().scale(delay: 800.ms, duration: 500.ms, curve: Curves.easeOutBack),
        body: myLogbooks.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history_edu_rounded, size: 80, color: Colors.white.withValues(alpha: 0.5)),
                    const SizedBox(height: 16),
                    const Text(
                      'Belum ada catatan logbook.\nMulai bimbingan pertamamu!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white70),
                    ),
                  ],
                ).animate().fade(duration: 800.ms).slideY(begin: 0.2, end: 0),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                itemCount: myLogbooks.length,
                itemBuilder: (context, index) {
                  final logbook = myLogbooks[index];
                  final isFirst = index == 0;
                  final isLast = index == myLogbooks.length - 1;

                  Color statusColor;
                  IconData statusIcon;
                  if (logbook.status == 'Disetujui') {
                    statusColor = Colors.greenAccent;
                    statusIcon = Icons.check_circle_rounded;
                  } else if (logbook.status == 'Direvisi') {
                    statusColor = Colors.orangeAccent;
                    statusIcon = Icons.warning_rounded;
                  } else {
                    statusColor = Colors.white70;
                    statusIcon = Icons.schedule_rounded;
                  }

                  return TimelineTile(
                    isFirst: isFirst,
                    isLast: isLast,
                    indicatorStyle: IndicatorStyle(
                      width: 35,
                      color: statusColor,
                      iconStyle: IconStyle(
                        iconData: statusIcon,
                        color: isDark ? Colors.black87 : Colors.white,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    beforeLineStyle: LineStyle(color: statusColor.withValues(alpha: 0.5), thickness: 3),
                    endChild: Container(
                      margin: const EdgeInsets.only(left: 16, bottom: 20, top: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.5),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      logbook.tanggal,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        logbook.status,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: statusColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Materi / Progres:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? Colors.lightBlueAccent : Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  logbook.materiProgres,
                                  style: TextStyle(fontSize: 14, color: isDark ? Colors.white : Colors.black87),
                                ),
                                if (logbook.catatanDosen.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.orangeAccent.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.orangeAccent.withValues(alpha: 0.3)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Row(
                                          children: [
                                            Icon(Icons.feedback_rounded, size: 14, color: Colors.orangeAccent),
                                            SizedBox(width: 6),
                                            Text(
                                              'Catatan Dosen:',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.orangeAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          logbook.catatanDosen,
                                          style: TextStyle(fontSize: 13, color: isDark ? Colors.white : Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fade(delay: (100 * index).ms).slideX(begin: 0.1, end: 0, curve: Curves.easeOutBack);
                },
              ),
      ),
    );
  }
}
