import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class KontakDosenScreen extends StatelessWidget {
  KontakDosenScreen({super.key});

  final List<Map<String, String>> dosenList = [
    {
      "nama": "Ade Sumaedi, S.T., M.Kom.",
      "email": "adesumaedi10093@unpam.ac.id",
      "telp": "081818993063",
    },
    {
      "nama": "Adiyaksha, S.Kom., M.Kom.",
      "email": "dosen03349@unpam.ac.id",
      "telp": "082299966105",
    },
    {
      "nama": "Salma Nofri Yanti, S.Pd., M.Kom.",
      "email": "dosen03341@unpam.ac.id",
      "telp": "082173793225",
    },
  ];

  Future<void> _launchUrl(String scheme, String path) async {
    final Uri url = Uri(scheme: scheme, path: path);
    if (!await launchUrl(url)) {
      debugPrint('Could not launch $url');
    }
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
          "Kontak Dosen",
          style: TextStyle(
            fontFamily: "Montserrat-Bold",
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F2027), const Color(0xFF203A43), const Color(0xFF2C5364)]
                : [Colors.blue.shade50, Colors.purple.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: dosenList.length,
            itemBuilder: (context, index) {
              final dosen = dosenList[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.blue.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.6),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    dosen["nama"]!,
                                    style: TextStyle(
                                      fontFamily: "Montserrat-Bold",
                                      fontSize: 16,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const Divider(height: 1),
                            const SizedBox(height: 15),
                            InkWell(
                              onTap: () => _launchUrl('mailto', dosen["email"]!),
                              child: Row(
                                children: [
                                  Icon(Icons.email_rounded, color: Colors.blue.shade400, size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      dosen["email"]!,
                                      style: TextStyle(
                                        color: isDark ? Colors.white70 : Colors.black54,
                                        fontFamily: "Montserrat-Medium",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () => _launchUrl('tel', dosen["telp"]!),
                              child: Row(
                                children: [
                                  Icon(Icons.phone_rounded, color: Colors.green.shade400, size: 20),
                                  const SizedBox(width: 10),
                                  Text(
                                    dosen["telp"]!,
                                    style: TextStyle(
                                      color: isDark ? Colors.white70 : Colors.black54,
                                      fontFamily: "Montserrat-Medium",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
