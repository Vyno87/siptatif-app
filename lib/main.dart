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
import 'package:siptatif_app/screens/tambah_mahasiswa_screen.dart';

import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/providers/notifikasi_provider.dart';
import 'package:siptatif_app/providers/pembimbing_provider.dart';
import 'package:siptatif_app/providers/penguji_provider.dart';
import 'package:siptatif_app/providers/logbook_provider.dart';
import 'package:siptatif_app/providers/sidang_provider.dart';
import 'package:siptatif_app/providers/theme_provider.dart';

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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NotifikasiProvider()),
        ChangeNotifierProvider(create: (_) => LogbookProvider()),
        ChangeNotifierProvider(create: (_) => SidangProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            onGenerateRoute: (settings) {
              Widget page;
              switch (settings.name) {
                case "/login": page = const LoginScreen(); break;
                case "/register": page = const RegisterScreen(); break;
                case "/lupa-password": page = const LupaPasswordScreen(); break;
                case "/reset-password": page = const ResetPassword(); break;
                case "/main": page = const MainScreen(); break;
                case "/mhs-detail-screen": page = const MahasiswaDetailScreen(); break;
                case "/tambah-mahasiswa": page = const TambahMahasiswaScreen(); break;
                case "/tambah-penguji": page = const PengujiTambahScreen(); break;
                case "/tambah-pembimbing": page = const PembimbingTambahScreen(); break;
                case "/penguji-update-screen": page = const PengujiUpdateScreen(); break;
                case "/pembimbing-update-screen": page = const PembimbingUpdateScreen(); break;
                default: page = const AuthWrapper();
              }
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (context, animation, secondaryAnimation) => page,
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 300),
              );
            },
            title: "SIPTATIF Mobile",
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              brightness: Brightness.light,
              textTheme: GoogleFonts.montserratTextTheme(),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
            ),
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (authProvider.isAuthenticated) {
      return const MainScreen();
    } else {
      return const LoginScreen();
    }
  }
}
