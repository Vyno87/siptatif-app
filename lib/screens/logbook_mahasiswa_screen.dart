import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/logbook.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/providers/logbook_provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Catat Bimbingan Baru'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              controller: _materiController,
              decoration: const InputDecoration(
                labelText: 'Materi / Progres Bimbingan',
                border: OutlineInputBorder(),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
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
              child: const Text('Simpan'),
            ),
          ],
        );
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Asumsi dosenNidn didapat dari relasi (kita isi '0001' untuk simulasi)
          _showAddLogbookDialog(context, nim, '0001');
        },
        icon: const Icon(Icons.add_comment_rounded),
        label: const Text('Catat Bimbingan'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: myLogbooks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_edu_rounded, size: 80, color: Colors.grey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada catatan logbook.\nMulai bimbingan pertamamu!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
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
                  statusColor = Colors.green;
                  statusIcon = Icons.check_circle_rounded;
                } else if (logbook.status == 'Direvisi') {
                  statusColor = Colors.orange;
                  statusIcon = Icons.warning_rounded;
                } else {
                  statusColor = Colors.grey;
                  statusIcon = Icons.schedule_rounded;
                }

                return TimelineTile(
                  isFirst: isFirst,
                  isLast: isLast,
                  indicatorStyle: IndicatorStyle(
                    width: 30,
                    color: statusColor,
                    iconStyle: IconStyle(
                      iconData: statusIcon,
                      color: Colors.white,
                    ),
                  ),
                  beforeLineStyle: LineStyle(color: statusColor.withValues(alpha: 0.5)),
                  endChild: Container(
                    margin: const EdgeInsets.only(left: 16, bottom: 20, top: 10),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              logbook.tanggal,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          logbook.materiProgres,
                          style: const TextStyle(fontSize: 14),
                        ),
                        if (logbook.catatanDosen.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(Icons.feedback_rounded, size: 14, color: Colors.orange),
                                    SizedBox(width: 4),
                                    Text(
                                      'Catatan Dosen:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  logbook.catatanDosen,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
