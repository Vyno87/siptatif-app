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
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage(imgFile), fit: BoxFit.cover)),
      ),
    );
  }
}
