import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class TentangAplikasiScreen extends StatefulWidget {
  const TentangAplikasiScreen({super.key});

  @override
  State<TentangAplikasiScreen> createState() => _TentangAplikasiScreenState();
}

class _TentangAplikasiScreenState extends State<TentangAplikasiScreen> {
  String _version = 'Loading...';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version;
      _buildNumber = info.buildNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Tentang Aplikasi",
          style: TextStyle(
            fontFamily: "Montserrat-Bold",
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]
                : [Colors.purple.shade50, Colors.blue.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // LOGO
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: isDark ? Colors.white10 : Colors.white,
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Image.asset(
                              'assets/images/siptatif_logo.png', // Assuming we have this, or fallback to an icon
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.school_rounded,
                                  size: 80,
                                  color: Theme.of(context).colorScheme.primary,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // NAMA APLIKASI
                  Text(
                    "SIPTATIF",
                    style: TextStyle(
                      fontFamily: "Montserrat-Bold",
                      fontSize: 32,
                      letterSpacing: -1,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  // VERSI
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Versi $_version ($_buildNumber)",
                      style: TextStyle(
                        fontFamily: "Montserrat-SemiBold",
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // DESKRIPSI
                  Text(
                    "Sistem Informasi Penjadwalan Tugas Akhir Teknik Informatika (SIPTATIF) merupakan aplikasi Sistem Informasi Tugas Akhir yang digunakan untuk membantu mahasiswa, dosen pembimbing, dan penguji dalam proses pengelolaan tugas akhir.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Montserrat-Medium",
                      fontSize: 15,
                      height: 1.6,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // KARTU INFORMASI GLASSMORPHISM
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.6),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            _buildInfoTile(
                              icon: Icons.person_rounded,
                              title: "Developer",
                              subtitle: "Ahmad Novy Mufasir (Mod by Vynothea)",
                              isDark: isDark,
                            ),
                            const Divider(height: 1, indent: 20, endIndent: 20),
                            _buildInfoTile(
                              icon: Icons.email_rounded,
                              title: "Email",
                              subtitle: "vynothea7@gmail.com",
                              isDark: isDark,
                            ),
                            const Divider(height: 1, indent: 20, endIndent: 20),
                            _buildInfoTile(
                              icon: Icons.code_rounded,
                              title: "Framework",
                              subtitle: "Flutter & Provider SDK",
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  Text(
                    "© 2024 Universitas Pamulang\nFakultas Ilmu Komputer",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Montserrat-Medium",
                      color: isDark ? Colors.white30 : Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Icon(icon, color: isDark ? Colors.white70 : Colors.black54),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "Montserrat-Bold",
          fontSize: 14,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: "Montserrat-Medium",
          fontSize: 13,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }
}
