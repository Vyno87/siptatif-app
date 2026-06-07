import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';

class DosenScreen extends StatefulWidget {
  const DosenScreen({super.key});

  @override
  State<DosenScreen> createState() => _DosenScreenState();
}

class _DosenScreenState extends State<DosenScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final mahasiswaProvider = context.watch<MahasiswaProvider>();
    final String namaLengkap = user?.fullName ?? '-';

    // Filter mahasiswa berdasarkan dosen yang login
    final List<Mahasiswa> mahasiswaBimbingan = mahasiswaProvider.listMahasiswa
        .where((m) =>
            m.calonDosenPembimbing1 == namaLengkap ||
            m.calonDosenPembimbing2 == namaLengkap)
        .toList();

    final List<Mahasiswa> mahasiswaPenguji = mahasiswaProvider.listMahasiswa
        .where((m) =>
            m.dosenPenguji1 == namaLengkap ||
            m.dosenPenguji2 == namaLengkap)
        .toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Header Selamat Datang
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFFFF1361), const Color(0xFF8E2DE2)]
                            : [const Color(0xFF8EC5FC), const Color(0xFFE0C3FC)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school_rounded,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Selamat Datang,',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        Text(
                          namaLengkap,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Stat cards
              Row(
                children: [
                  _buildStatCard(
                    context,
                    icon: Icons.people_alt_rounded,
                    label: 'Mahasiswa\nBimbingan',
                    count: mahasiswaBimbingan.length,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    context,
                    icon: Icons.fact_check_rounded,
                    label: 'Mahasiswa\nPenguji',
                    count: mahasiswaPenguji.length,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    context,
                    icon: Icons.check_circle_rounded,
                    label: 'Berkas\nDisetujui',
                    count: mahasiswaBimbingan
                        .where((m) => m.statusBerkas == 'Disetujui')
                        .length,
                    color: Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Tab bar
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: colorScheme.primary,
                  unselectedLabelColor: colorScheme.onSurface.withValues(alpha: 0.5),
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorScheme.primary.withValues(alpha: 0.15),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: 'Bimbingan'),
                    Tab(text: 'Penguji'),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMahasiswaList(context, mahasiswaBimbingan, isBimbingan: true),
              _buildMahasiswaList(context, mahasiswaPenguji, isBimbingan: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isDark
              ? color.withValues(alpha: 0.15)
              : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMahasiswaList(
    BuildContext context,
    List<Mahasiswa> list, {
    required bool isBimbingan,
  }) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isBimbingan ? Icons.groups_2_outlined : Icons.assignment_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              isBimbingan
                  ? 'Belum ada mahasiswa\nbimbingan'
                  : 'Belum ada mahasiswa\nyang diuji',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                fontSize: 15,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final mhs = list[index];
        return _DosenMahasiswaCard(mhs: mhs, index: index, isBimbingan: isBimbingan);
      },
    );
  }
}

class _DosenMahasiswaCard extends StatelessWidget {
  final Mahasiswa mhs;
  final int index;
  final bool isBimbingan;

  const _DosenMahasiswaCard({
    required this.mhs,
    required this.index,
    required this.isBimbingan,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'Disetujui': return Colors.green;
      case 'Ditolak': return Colors.red;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 350 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Transform.translate(
        offset: Offset(0, 30 * (1 - value.clamp(0.0, 1.0))),
        child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
      ),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          '/mhs-detail-screen',
          arguments: mhs,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.07)
                : Colors.white.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    (isBimbingan ? Colors.blueAccent : Colors.orange)
                        .withValues(alpha: 0.15),
                child: Text(
                  mhs.nama.isNotEmpty ? mhs.nama[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isBimbingan ? Colors.blueAccent : Colors.orange,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mhs.nama,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'NIM: ${mhs.nim}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mhs.judulTugasAkhir,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(mhs.statusBerkas).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _statusColor(mhs.statusBerkas).withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  mhs.statusBerkas,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: _statusColor(mhs.statusBerkas),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
