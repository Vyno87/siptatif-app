import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/providers/pembimbing_provider.dart';
import 'package:siptatif_app/providers/penguji_provider.dart';
import 'package:siptatif_app/widgets/beranda_card.dart';
import 'package:siptatif_app/services/pdf_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BerandaObject {
  String nama;
  int terdaftar;
  int kuota;

  BerandaObject(
      {required this.nama, required this.terdaftar, required this.kuota});
}

List<BerandaObject> berandaData = [
  BerandaObject(
    nama: "Mahasiswa",
    terdaftar: 24,
    kuota: 120,
  ),
  BerandaObject(
    nama: "Penguji",
    terdaftar: 37,
    kuota: 13,
  ),
  BerandaObject(
    nama: "Pembimbing",
    terdaftar: 42,
    kuota: 12,
  ),
];



class HomeScreen extends StatefulWidget {
  final void Function(int)? onNavigate;
  const HomeScreen({super.key, this.onNavigate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final mahasiswaProvider = context.watch<MahasiswaProvider>();
    final pembimbingProvider = context.watch<PembimbingProvider>();
    final pengujiProvider = context.watch<PengujiProvider>();

    int mhsCount = mahasiswaProvider.listMahasiswa.length;
    int mhsDisetujui = mahasiswaProvider.listMahasiswa.where((m) => m.statusBerkas == 'Disetujui').length;

    int pembimbingCount = pembimbingProvider.listPembimbing.length;
    int pembimbingKuotaTotal = pembimbingProvider.listPembimbing.fold(0, (sum, item) => sum + item.kuota);

    int pengujiCount = pengujiProvider.listPenguji.length;
    int pengujiKuotaTotal = pengujiProvider.listPenguji.fold(0, (sum, item) => sum + item.kuota);

    // Menghindari pembagian dengan 0 jika data kosong
    int total = mhsCount + pembimbingCount + pengujiCount;
    if (total == 0) total = 1;

    List<BerandaObject> dynamicBerandaData = [
      BerandaObject(nama: "Mahasiswa", terdaftar: mhsCount, kuota: mhsDisetujui),
      BerandaObject(nama: "Penguji", terdaftar: pengujiCount, kuota: pengujiKuotaTotal),
      BerandaObject(nama: "Pembimbing", terdaftar: pembimbingCount, kuota: pembimbingKuotaTotal),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            "Dashboard Analitik",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          // Bagian Pie Chart
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    color: Colors.blueAccent,
                    value: (mhsCount / total) * 100,
                    title: '${((mhsCount / total) * 100).toStringAsFixed(1)}%',
                    radius: touchedIndex == 0 ? 60.0 : 50.0,
                    titleStyle: TextStyle(
                        fontSize: touchedIndex == 0 ? 18.0 : 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Colors.green,
                    value: (pembimbingCount / total) * 100,
                    title: '${((pembimbingCount / total) * 100).toStringAsFixed(1)}%',
                    radius: touchedIndex == 1 ? 60.0 : 50.0,
                    titleStyle: TextStyle(
                        fontSize: touchedIndex == 1 ? 18.0 : 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Colors.orange,
                    value: (pengujiCount / total) * 100,
                    title: '${((pengujiCount / total) * 100).toStringAsFixed(1)}%',
                    radius: touchedIndex == 2 ? 60.0 : 50.0,
                    titleStyle: TextStyle(
                        fontSize: touchedIndex == 2 ? 18.0 : 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegend(context, Colors.blueAccent, "Mahasiswa"),
              const SizedBox(width: 10),
              _buildLegend(context, Colors.green, "Pembimbing"),
              const SizedBox(width: 10),
              _buildLegend(context, Colors.orange, "Penguji"),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          // Bagian Card
          Column(
            children: dynamicBerandaData
                .map((ret) => BerandaCard(
                      berandaData: ret,
                      onTapDetail: () {
                        if (ret.nama == 'Mahasiswa') {
                          widget.onNavigate?.call(1);
                        } else if (ret.nama == 'Penguji') {
                          widget.onNavigate?.call(2);
                        } else if (ret.nama == 'Pembimbing') {
                          widget.onNavigate?.call(3);
                        }
                      },
                    ))
                .toList(),
          ),
          const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await PdfService.exportLaporanSidang(mahasiswaProvider.listMahasiswa);
                  },
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: const Text(
                    "Export Laporan Sidang (PDF)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                ),
              ),
            ).animate().fade(delay: 500.ms).slideY(begin: 0.5, end: 0),
            const SizedBox(height: 20),
          ],
        ).animate().fadeIn(duration: 500.ms),
    );
  }

  Widget _buildLegend(BuildContext context, Color color, String text) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
        ),
      ],
    );
  }
}
