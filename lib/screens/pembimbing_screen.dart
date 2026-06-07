import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/pembimbing.dart';
import 'package:siptatif_app/providers/pembimbing_provider.dart';
import 'package:siptatif_app/providers/notifikasi_provider.dart';
import 'package:siptatif_app/widgets/glass_card.dart';
import 'package:siptatif_app/utils/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PembimbingScreen extends StatelessWidget {
  const PembimbingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PembimbingProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      child: Column(
        children: [
          const SizedBox(height: 3),
          TextField(
            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: isDark ? Colors.black26 : Colors.white60,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide.none,
              ),
              hintText: 'Search Pembimbing',
              hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
            ),
          ).animate().fade(duration: 500.ms).slideY(begin: -0.2, end: 0),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/tambah-pembimbing");
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primaryPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("+ Tambah Data", style: TextStyle(fontWeight: FontWeight.bold)),
              ).animate().scale(delay: 500.ms),
            ],
          ),
          const SizedBox(height: 10),
          if (provider.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          else if (provider.errorMessage.isNotEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  provider.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          else
            Column(
              children: provider.listPembimbing.asMap().entries.map((entry) {
                final index = entry.key;
                final pembimbing = entry.value;
                return _templatePembimbingCard(context, pembimbing)
                    .animate()
                    .fade(delay: (100 * index).ms)
                    .slideX(begin: 0.1, end: 0, curve: Curves.easeOutBack);
              }).toList(),
            ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _templatePembimbingCard(BuildContext context, Pembimbing pembimbing) {
    return GlassCard(
        color: Theme.of(context).brightness == Brightness.light ? Colors.white.withValues(alpha: 0.5) : Colors.black.withValues(alpha: 0.5),
        margin: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _generateRowDataPoint(
                      Icons.account_circle_rounded, pembimbing.nama),
                  _generateRowDataPoint(
                      Icons.calendar_view_day_rounded, pembimbing.nidn),
                  _generateRowDataPoint(
                      Icons.transgender_rounded, pembimbing.jenisKelamin),
                  const SizedBox(
                    height: 4,
                  ),
                  Divider(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                    thickness: 0.8,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    '"${pembimbing.keahlian}"',
                    textAlign: TextAlign.start,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.amber[200]),
                        child: Text(
                          "${pembimbing.kuota.toString()} kuota tersedia",
                          style: const TextStyle(
                            fontFamily: "Montserrat-SemiBold",
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton.filledTonal(
                        onPressed: () {
                          Navigator.pushNamed(
                              context, "/pembimbing-update-screen",
                              arguments: pembimbing);
                        },
                        icon: const Icon(Icons.edit_note_outlined),
                      ),
                      IconButton.filled(
                        onPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                        'Apakah anda yakin ingin menghapus data dosen pembimbing ini?'),
                                    const SizedBox(height: 15),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.amber[100],
                                          ),
                                          child: const Text(
                                            'Batalkan',
                                            style: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: -0.2),
                                          )),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<PembimbingProvider>().hapusPembimbing(pembimbing);
                                        context.read<NotifikasiProvider>().tambahNotifikasi(
                                          "Data Pembimbing Dihapus",
                                          "Data pembimbing bernama ${pembimbing.nama} telah dihapus dari sistem."
                                        );
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Data berhasil dihapus secara real-time!')),
                                        );
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.red[100],
                                          ),
                                          child: const Text(
                                            'Iya, Saya Yakin',
                                            style: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: -0.2),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        // onPressed: () {
                        // AwesomeDialog(
                        //   context: context,
                        //   dialogType: DialogType.warning,
                        //   title: "Data Removed Warning!",
                        //   desc: "Apakah anda yakin ingin menghapus data pengajuan mahasiswa ini?"
                        // ).show();
                        // },
                        icon: const Icon(Icons.delete_outline_sharp),
                      )
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }

  Row _generateRowDataPoint(IconData icon, String label) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        )
      ],
    );
  }
}
