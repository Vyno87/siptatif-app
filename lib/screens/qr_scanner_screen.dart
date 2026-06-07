import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:siptatif_app/utils/app_theme.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Scan Kehadiran Sidang', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (_isScanned) return;
              
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null && code.startsWith("SIDANG_SIPTATIF_")) {
                  setState(() {
                    _isScanned = true;
                  });
                  String sidangId = code.replaceFirst("SIDANG_SIPTATIF_", "");
                  
                  // Kembali dan bawa data
                  Navigator.pop(context, sidangId);
                  break;
                }
              }
            },
          ),
          // Overlay blur untuk bagian luar scanner
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
            ),
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primaryPurple, width: 4),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryPurple.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(
                    color: Colors.transparent, // Bolong di tengah agar tembus
                  ),
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scaleXY(end: 1.05, duration: 1000.ms),
          ),
          // Garis pemindai animasi
          Center(
            child: Container(
              width: 250,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.greenAccent,
                boxShadow: [
                  BoxShadow(color: Colors.greenAccent, blurRadius: 10, spreadRadius: 2)
                ],
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).slideY(begin: -2.5, end: 2.5, duration: 1500.ms),
          ),
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Arahkan kamera ke QR Code Mahasiswa",
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fade(delay: 500.ms).slideY(begin: 0.5, end: 0),
          )
        ],
      ),
    );
  }
}
