import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siptatif_app/screens/login_screen.dart';
import 'package:siptatif_app/screens/lupa_password_screen.dart';
import 'package:siptatif_app/screens/mahasiswa_detail_screen.dart';
import 'package:siptatif_app/screens/main_screen.dart';
import 'package:siptatif_app/screens/pembimbing_update_screen.dart';
import 'package:siptatif_app/screens/penguji_update_screen.dart';
import 'package:siptatif_app/screens/register_screen.dart';
import 'package:siptatif_app/screens/reset_password_screen.dart';
import 'package:siptatif_app/screens/tambah_pembimbing.dart';
import 'package:siptatif_app/screens/tambah_penguji.dart';

import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/providers/pembimbing_provider.dart';
import 'package:siptatif_app/providers/penguji_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MahasiswaProvider()),
        ChangeNotifierProvider(create: (_) => PembimbingProvider()),
        ChangeNotifierProvider(create: (_) => PengujiProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        routes: {
          "/login": (context) => const LoginScreen(),
          "/register": (context) => const RegisterScreen(),
          "/lupa-password": (context) => const LupaPasswordScreen(),
          "/reset-password": (context) => const ResetPassword(),
          "/main": (context) => const MainScreen(),
          "/mhs-detail-screen": (context) => const MahasiswaDetailScreen(),
          "/tambah-penguji": (context) => const PengujiTambahScreen(),
          "/tambah-pembimbing": (context) => const PembimbingTambahScreen(),
          "/penguji-update-screen": (context) => const PengujiUpdateScreen(),
          "/pembimbing-update-screen": (context) =>
              const PembimbingUpdateScreen(),
        },
        title: "SIPTATIF Mobile",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.montserratTextTheme(),
        ),
        home: const MainScreen(),
      ),
    );
  }
}
