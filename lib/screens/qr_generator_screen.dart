import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:siptatif_app/datas/models/sidang.dart';
import 'package:siptatif_app/utils/app_theme.dart';
import 'package:siptatif_app/widgets/glass_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QrGeneratorScreen extends StatelessWidget {
  final Sidang sidang;

  const QrGeneratorScreen({super.key, required this.sidang});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Payload rahasia QR code
    final qrData = "SIDANG_SIPTATIF_${sidang.id}";

    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGlassGradient : AppTheme.neonGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("QR Code Sidang", style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: isDark ? Colors.white : Colors.black87,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tunjukkan QR ini kepada Penguji",
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ).animate().fade(duration: 500.ms).slideY(begin: -0.5, end: 0),
              const SizedBox(height: 32),
              GlassCard(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Harus putih agar QR bisa dibaca scanner
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryPurple.withValues(alpha: 0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 250.0,
                    ),
                  ),
                ),
              ).animate().scale(delay: 300.ms, duration: 600.ms, curve: Curves.easeOutBack).fade(),
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black45 : Colors.white60,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Text(
                  "ID Sidang: ${sidang.id}",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ).animate().fade(delay: 600.ms).slideY(begin: 0.5, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}
