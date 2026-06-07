import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:siptatif_app/providers/sidang_provider.dart';
import 'package:siptatif_app/datas/models/sidang.dart';

class DashboardStatistikScreen extends StatefulWidget {
  const DashboardStatistikScreen({super.key});

  @override
  State<DashboardStatistikScreen> createState() => _DashboardStatistikScreenState();
}

class _DashboardStatistikScreenState extends State<DashboardStatistikScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SidangProvider>().fetchSidang();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sidangProvider = context.watch<SidangProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (sidangProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final List<Sidang> sidangList = sidangProvider.listSidang;
    
    // Hitung status kelulusan
    int lulus = sidangList.where((s) => s.statusKelulusan == 'Lulus').length;
    int mengulang = sidangList.where((s) => s.statusKelulusan == 'Mengulang').length;
    int belum = sidangList.where((s) => s.statusKelulusan != 'Lulus' && s.statusKelulusan != 'Mengulang').length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Statistik V2.0", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0F2F5),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Status Kelulusan Sidang", isDark),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            value: lulus.toDouble(),
                            title: 'Lulus\n($lulus)',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            value: mengulang.toDouble(),
                            title: 'Mengulang\n($mengulang)',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.blue[300],
                            value: belum.toDouble(),
                            title: 'Belum\n($belum)',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle("Rekapitulasi Total", isDark),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatCard("Total Sidang", "${sidangList.length}", Icons.assignment, Colors.blue, isDark),
                  const SizedBox(width: 16),
                  _buildStatCard("Tingkat Kelulusan", "${sidangList.isEmpty ? 0 : (lulus / sidangList.length * 100).toStringAsFixed(1)}%", Icons.school, Colors.green, isDark),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black87,
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
