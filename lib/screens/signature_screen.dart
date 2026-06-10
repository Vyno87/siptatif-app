import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:siptatif_app/utils/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  void _handleClear() {
    _signaturePadKey.currentState?.clear();
  }

  void _handleSave() async {
    final signatureData = await _signaturePadKey.currentState?.toImage(pixelRatio: 3.0);
    if (signatureData != null) {
      final byteData = await signatureData.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final bytes = byteData.buffer.asUint8List();
        if (mounted) {
          // Mengembalikan data bytes gambar ke layar sebelumnya
          Navigator.pop(context, bytes);
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanda tangan masih kosong!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tanda Tangan Digital', style: TextStyle(fontFamily: 'Montserrat-Bold')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      backgroundColor: isDark ? const Color(0xFF1E1E2C) : Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Silakan bubuhkan tanda tangan Anda di dalam kotak di bawah ini menggunakan jari atau stylus.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontFamily: 'Montserrat-Medium'),
            ).animate().fade().slideY(begin: -0.2),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.black54 : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppTheme.primaryPurple.withValues(alpha: 0.5), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryPurple.withValues(alpha: 0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SfSignaturePad(
                    key: _signaturePadKey,
                    backgroundColor: Colors.transparent,
                    strokeColor: isDark ? Colors.white : Colors.black,
                    minimumStrokeWidth: 2.0,
                    maximumStrokeWidth: 5.0,
                  ),
                ),
              ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton.icon(
                  onPressed: _handleClear,
                  icon: const Icon(Icons.clear),
                  label: const Text('Bersihkan'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.redAccent,
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ).animate().fade(delay: 400.ms).slideX(begin: -0.2),
                ElevatedButton.icon(
                  onPressed: _handleSave,
                  icon: const Icon(Icons.check),
                  label: const Text('Simpan & Sahkan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ).animate().fade(delay: 400.ms).slideX(begin: 0.2),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
