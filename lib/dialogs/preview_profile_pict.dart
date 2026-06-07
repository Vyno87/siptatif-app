import 'package:flutter/material.dart';

class PreviewProfilePictDialog extends StatelessWidget {
  final String imgFile;

  const PreviewProfilePictDialog({super.key, required this.imgFile});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 400,
        decoration: imgFile.isNotEmpty
            ? BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage(imgFile), fit: BoxFit.cover))
            : const BoxDecoration(color: Colors.grey),
        child: imgFile.isEmpty ? const Center(child: Icon(Icons.person, size: 100, color: Colors.white)) : null,
      ),
    );
  }
}
