import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:siptatif_app/datas/models/sidang.dart';

class QrGeneratorScreen extends StatelessWidget {
  final Sidang sidang;

  const QrGeneratorScreen({super.key, required this.sidang});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Payload rahasia QR code
    final qrData = "SIDANG_SIPTATIF_${sidang.id}";

    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code Sidang"),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0F2F5),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Tunjukkan QR ini kepada Penguji",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 250.0,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "ID Sidang: ${sidang.id}",
              style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
