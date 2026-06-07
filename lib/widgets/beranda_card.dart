import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:siptatif_app/screens/beranda_screen.dart';
import 'package:siptatif_app/widgets/glass_card.dart';
import 'package:siptatif_app/utils/app_theme.dart';

class BerandaCard extends StatelessWidget {
  final BerandaObject berandaData;
  final VoidCallback? onTapDetail;

  const BerandaCard({super.key, required this.berandaData, this.onTapDetail});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GlassCard(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: AppTheme.neonGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: Text(
                    berandaData.nama,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                Icon(
                  Icons.analytics_rounded,
                  color: AppTheme.primaryPurple.withValues(alpha: 0.7),
                  size: 28,
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              children: [
                SvgPicture.asset(
                  "assets/svgs/person-non-bg.svg",
                  width: 30,
                  colorFilter: ColorFilter.mode(
                    isDark ? Colors.white : Colors.black87,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${berandaData.terdaftar} ${berandaData.nama == 'Mahasiswa' ? 'orang mendaftar' : 'dosen terdaftar'}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: isDark ? Colors.white : Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.check_circle, size: 20, color: Colors.greenAccent.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "${berandaData.kuota} ${berandaData.nama == 'Mahasiswa' ? 'telah disetujui' : 'kuota masih tersedia'}",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  berandaData.nama == 'Mahasiswa'
                      ? '*data perbulan ini'
                      : '*data keseluruhan',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: onTapDetail,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "Cek detail",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.purpleAccent : AppTheme.primaryPurple,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: isDark ? Colors.purpleAccent : AppTheme.primaryPurple,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
