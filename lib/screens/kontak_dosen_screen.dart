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
      "nama": "Agus Suhendi, S.Kom., M.Kom.",
      "email": "dosen10007@unpam.ac.id",
      "telp": "089636011182",
    },
    {
      "nama": "Amin Widodo, S.T., M.Kom.",
      "email": "dosen10096@unpam.ac.id",
      "telp": "081574639794",
    },
    {
      "nama": "Angelina Hadriani, S.Kom., M.Kom.",
      "email": "dosen03234@unpam.ac.id",
      "telp": "081806353255",
    },
    {
      "nama": "Asep Suryadi, S.Kom., M.Kom.",
      "email": "dosen10008@unpam.ac.id",
      "telp": "0895391063077",
    },
    {
      "nama": "Aurell Layalia Safara Az-Zahra Gunawan, S.Kom., M.T.",
      "email": "dosen03350@unpam.ac.id",
      "telp": "08562255899",
    },
    {
      "nama": "Dr. Meida Fitriana, S.Pd., M.Pd.",
      "email": "dosen02943@unpam.ac.id",
      "telp": "087771055432",
    },
    {
      "nama": "Encik Yoega Renaldi, S.Kom., M.Kom.",
      "email": "dosen03347@unpam.ac.id",
      "telp": "082391540154",
    },
    {
      "nama": "Eneng Susilistia Agustini, S.Kom., M.Kom.",
      "email": "dosen10009@unpam.ac.id",
      "telp": "085697275198",
    },
    {
      "nama": "Eva Hendrawati, S.Pd., M.Sc.",
      "email": "dosen10014@unpam.ac.id",
      "telp": "081353346880",
    },
    {
      "nama": "Hasan Amin, S.T., M.Sc.",
      "email": "dosen03037@unpam.ac.id",
      "telp": "08994983673",
    },
    {
      "nama": "Hayadi Hamuda, S.Kom., M.T.",
      "email": "dosen02886@unpam.ac.id",
      "telp": "085691533240",
    },
    {
      "nama": "Imam Hidayat, S.Kom., M.Kom.",
      "email": "dosen02714@unpam.ac.id",
      "telp": "08989225519",
    },
    {
      "nama": "Irfan Fathoni, S.Kom., M.Kom.",
      "email": "dosen02883@unpam.ac.id",
      "telp": "089653738072",
    },
    {
      "nama": "Layliana, S.Mat, M.Kom.",
      "email": "dosen03084@unpam.ac.id",
      "telp": "08984947333",
    },
    {
      "nama": "M. Fauzi Firdaus, S.T., M.Kom.",
      "email": "dosen03039@unpam.ac.id",
      "telp": "0895259150xx",
    },
    {
      "nama": "M. Riza Syahputra, S.E., M.Kom.",
      "email": "dosen03440@unpam.ac.id",
      "telp": "082174326675",
    },
    {
      "nama": "Maisan Dewi Puspa Khairani, S.Kom., M.Kom.",
      "email": "dosen03348@unpam.ac.id",
      "telp": "082386449183",
    },
    {
      "nama": "Majid Rahman Aziz, S.Kom., M.Kom.",
      "email": "dosen03442@unpam.ac.id",
      "telp": "082392033261",
    },
    {
      "nama": "Muhammad Afif Rizki Andika, S.T., M.T.",
      "email": "afifrizkiandika@unpam.ac.id",
      "telp": "085176842621",
    },
    {
      "nama": "Muhammad Aldi Aulia Fathurohman, S.Kom., M.Kom.",
      "email": "dosen03233@unpam.ac.id",
      "telp": "081214751486",
    },
    {
      "nama": "Resty Amelia Putri, S.Kom., M.Kom.",
      "email": "dosen03342@unpam.ac.id",
      "telp": "081274882898",
    },
    {
      "nama": "Rikil Amri, S.Pd., M.Pd.",
      "email": "dosen02899@unpam.ac.id",
      "telp": "087808633384",
    },
    {
      "nama": "Rizka Ardiantika, S.Kom., M.Kom.",
      "email": "dosen03344@unpam.ac.id",
      "telp": "085863813700",
    },
    {
      "nama": "Salma Nofri Yanti, S.Pd., M.Kom.",
      "email": "dosen03341@unpam.ac.id",
      "telp": "082173793225",
    },
    {
      "nama": "Sarah Anjani, S.Kom., M.Cs.",
      "email": "dosen03345@unpam.ac.id",
      "telp": "081936083535",
    },
    {
      "nama": "Seni Oknora Firza, S.Pd., M.Kom.",
      "email": "dosen03346@unpam.ac.id",
      "telp": "081367319575",
    },
    {
      "nama": "Sugiyanti, S.Kom., M.Kom.",
      "email": "dosen03040@unpam.ac.id",
      "telp": "089665889267",
    },
    {
      "nama": "Susi, S.Kom., M.Kom.",
      "email": "dosen03445@unpam.ac.id",
      "telp": "083813323392",
    },
    {
      "nama": "Theofilus Herly Hatonangan Samosir, S.Kom., M.Kom.",
      "email": "dosen03232@unpam.ac.id",
      "telp": "08995006606",
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
