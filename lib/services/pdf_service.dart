import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';
import 'package:intl/intl.dart';

class PdfService {
  static Future<void> exportLaporanSidang(List<Mahasiswa> listMahasiswa) async {
    final pdf = pw.Document();
    
    // Load logo / banner
    final ByteData logoBytes = await rootBundle.load('assets/img/banner-title-siptatif.png');
    final Uint8List logoImage = logoBytes.buffer.asUint8List();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildHeader(logoImage),
        build: (context) => [
          pw.SizedBox(height: 20),
          _buildTitle(),
          pw.SizedBox(height: 20),
          _buildTable(listMahasiswa),
        ],
        footer: (context) => _buildFooter(context),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Laporan_Tugas_Akhir.pdf',
    );
  }

  static pw.Widget _buildHeader(Uint8List logo) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Image(pw.MemoryImage(logo), width: 120),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text("UNIVERSITAS PAMULANG", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.Text("Fakultas Ilmu Komputer - Teknik Informatika", style: const pw.TextStyle(fontSize: 12)),
            pw.Text("Sistem Informasi Penjadwalan Tugas Akhir", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey)),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTitle() {
    return pw.Center(
      child: pw.Text(
        "REKAPITULASI PENDAFTARAN TUGAS AKHIR",
        style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _buildTable(List<Mahasiswa> data) {
    return pw.TableHelper.fromTextArray(
      headers: ['No', 'NIM', 'Nama Mahasiswa', 'Judul TA', 'Dosen Pembimbing', 'Status'],
      data: List<List<dynamic>>.generate(
        data.length,
        (index) {
          final mhs = data[index];
          return [
            index + 1,
            mhs.nim,
            mhs.nama,
            mhs.judulTugasAkhir,
            mhs.calonDosenPembimbing1,
            mhs.statusBerkas,
          ];
        },
      ),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 10),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.blue800),
      rowDecoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      ),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.center,
      cellAlignments: {
        2: pw.Alignment.centerLeft, // Nama
        3: pw.Alignment.centerLeft, // Judul
        4: pw.Alignment.centerLeft, // Dosen
      },
      columnWidths: {
        0: const pw.FixedColumnWidth(25),
        1: const pw.FixedColumnWidth(60),
        2: const pw.FlexColumnWidth(2),
        3: const pw.FlexColumnWidth(3),
        4: const pw.FlexColumnWidth(2),
        5: const pw.FixedColumnWidth(60),
      }
    );
  }

  static pw.Widget _buildFooter(pw.Context context) {
    String tgl = DateFormat('dd MMMM yyyy').format(DateTime.now());
    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text(
          "Tangerang Selatan, $tgl",
          style: const pw.TextStyle(fontSize: 10),
        ),
        pw.SizedBox(height: 50),
        pw.Text(
          "Koordinator Tugas Akhir",
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          "Halaman ${context.pageNumber} dari ${context.pagesCount}",
          style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey),
        ),
      ]
    );
  }
}
