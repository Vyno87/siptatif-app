import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerScreen extends StatelessWidget {
  final String pdfUrl;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              // Tindakan untuk bookmark (opsional)
            },
          ),
        ],
      ),
      body: pdfUrl.startsWith('assets/')
          ? SfPdfViewer.asset(
              pdfUrl,
              canShowScrollHead: false,
              canShowScrollStatus: false,
            )
          : SfPdfViewer.file(
              File(pdfUrl),
              canShowScrollHead: false,
              canShowScrollStatus: false,
            ),
    );
  }
}
