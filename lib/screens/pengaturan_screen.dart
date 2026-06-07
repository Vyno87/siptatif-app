import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/theme_provider.dart';
import 'package:siptatif_app/providers/auth_provider.dart';

class PengaturanScreen extends StatefulWidget {
  const PengaturanScreen({super.key});

  @override
  State<PengaturanScreen> createState() => _PengaturanScreenState();
}

class _PengaturanScreenState extends State<PengaturanScreen> {
  bool _isNotifikasiAktif = true;

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode 
            ? [const Color(0xFF231557), const Color(0xFF44107A), const Color(0xFFFF1361)]
            : [const Color(0xFF8EC5FC), const Color(0xFFE0C3FC)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Pengaturan'),
        titleSpacing: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          _buildSectionHeader("Akun & Profil"),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(user?.fullName ?? "Pengguna"),
            subtitle: Text(user?.email ?? "email@domain.com"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showSimulasiSnackbar(context, "Membuka halaman Edit Profil...");
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.orangeAccent,
              child: Icon(Icons.lock, color: Colors.white),
            ),
            title: const Text("Ubah Kata Sandi"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showSimulasiSnackbar(context, "Membuka formulir Ubah Kata Sandi...");
            },
          ),
          const Divider(),

          _buildSectionHeader("Tampilan & Tema"),
          SwitchListTile(
            secondary: const CircleAvatar(
              backgroundColor: Colors.purpleAccent,
              child: Icon(Icons.dark_mode, color: Colors.white),
            ),
            title: const Text("Mode Gelap (Dark Mode)"),
            subtitle: const Text("Aktifkan tema gelap untuk kenyamanan mata"),
            value: isDarkMode,
            onChanged: (bool value) {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          const Divider(),

          _buildSectionHeader("Preferensi Aplikasi"),
          SwitchListTile(
            secondary: const CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.notifications_active, color: Colors.white),
            ),
            title: const Text("Notifikasi Sistem"),
            subtitle: const Text("Terima pemberitahuan pop-up dan lonceng"),
            value: _isNotifikasiAktif,
            onChanged: (bool value) {
              setState(() {
                _isNotifikasiAktif = value;
              });
              _showSimulasiSnackbar(context, value ? "Notifikasi diaktifkan" : "Notifikasi dimatikan");
            },
          ),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.language, color: Colors.white),
            ),
            title: const Text("Bahasa (Language)"),
            subtitle: const Text("Bahasa Indonesia"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showSimulasiSnackbar(context, "Membuka menu pilihan Bahasa...");
            },
          ),
          const Divider(),

          _buildSectionHeader("Privasi & Keamanan"),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.devices, color: Colors.white),
            ),
            title: const Text("Sesi Perangkat"),
            subtitle: const Text("Kelola perangkat yang sedang login"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showSimulasiSnackbar(context, "Membuka manajemen sesi perangkat...");
            },
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.purple,
          fontWeight: FontWeight.bold,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showSimulasiSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$message (Simulasi)")),
    );
  }
}
