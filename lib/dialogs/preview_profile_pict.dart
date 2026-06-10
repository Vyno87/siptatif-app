import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'dart:convert';

class PreviewProfilePictDialog extends StatelessWidget {
  final String imgFile;

  const PreviewProfilePictDialog({super.key, required this.imgFile});

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (imgFile.isNotEmpty) {
      if (imgFile.startsWith('http')) {
        imageProvider = NetworkImage(imgFile);
      } else if (imgFile.startsWith('data:image')) {
        imageProvider = MemoryImage(base64Decode(imgFile.split(',').last));
      } else {
        imageProvider = AssetImage(imgFile);
      }
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                image: imageProvider != null
                    ? DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imgFile.isEmpty
                  ? const Center(
                      child: Icon(Icons.person, size: 100, color: Colors.white70))
                  : null,
            ),
          ),
        ),
      ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fade(duration: 400.ms),
    );
  }
}
