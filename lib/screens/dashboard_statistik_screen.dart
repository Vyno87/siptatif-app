import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:siptatif_app/providers/sidang_provider.dart';
import 'package:siptatif_app/datas/models/sidang.dart';
import 'package:siptatif_app/utils/app_theme.dart';
import 'package:siptatif_app/widgets/glass_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
      return Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppTheme.darkGlassGradient : AppTheme.neonGradient,
        ),
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final List<Sidang> sidangList = sidangProvider.listSidang;
    
    // Hitung status kelulusan
    int lulus = sidangList.where((s) => s.statusKelulusan == 'Lulus').length;
    int mengulang = sidangList.where((s) => s.statusKelulusan == 'Mengulang').length;
    int belum = sidangList.where((s) => s.statusKelulusan != 'Lulus' && s.statusKelulusan != 'Mengulang').length;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGlassGradient : AppTheme.neonGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Dashboard Statistik V2.0", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: isDark ? Colors.white : Colors.black87,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Status Kelulusan Sidang", isDark).animate().fade(duration: 500.ms).slideX(begin: -0.2, end: 0),
              const SizedBox(height: 16),
              SizedBox(
                height: 300,
                child: GlassCard(
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
                            color: Colors.redAccent,
                            value: mengulang.toDouble(),
                            title: 'Mengulang\n($mengulang)',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          PieChartSectionData(
                            color: Colors.blueAccent,
                            value: belum.toDouble(),
                            title: 'Belum\n($belum)',
                            radius: 60,
                            titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.easeOutBack).fade(),
              ),
              const SizedBox(height: 32),
              _buildSectionTitle("Rekapitulasi Total", isDark).animate().fade(delay: 400.ms).slideX(begin: -0.2, end: 0),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatCard("Total Sidang", "${sidangList.length}", Icons.assignment_rounded, Colors.blueAccent, isDark)
                      .animate().fade(delay: 500.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(width: 16),
                  _buildStatCard("Kelulusan", "${sidangList.isEmpty ? 0 : (lulus / sidangList.length * 100).toStringAsFixed(1)}%", Icons.school_rounded, Colors.green, isDark)
                      .animate().fade(delay: 600.ms).slideY(begin: 0.2, end: 0),
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
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                value, 
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                )
              ),
              const SizedBox(height: 4),
              Text(
                title, 
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54, 
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
