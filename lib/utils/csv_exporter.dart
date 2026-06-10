import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';

class CsvExporter {
  static Future<void> exportMahasiswa(List<Mahasiswa> students) async {
    try {
      List<List<dynamic>> rows = [];
      
      // Header CSV
      rows.add([
        "No",
        "Nama Lengkap",
        "NIM",
        "Email",
        "Judul TA",
        "Status Berkas",
      ]);

      // Data Mahasiswa
      for (int i = 0; i < students.length; i++) {
        final student = students[i];
        rows.add([
          i + 1,
          student.nama,
          student.nim,
          student.email,
          student.judulTugasAkhir,
          student.statusBerkas,
        ]);
      }

      String csvData = const CsvEncoder().convert(rows);

      // Dapatkan direktori penyimpanan dokumen
      final directory = await getApplicationDocumentsDirectory();
      final path = "${directory.path}/Laporan_Mahasiswa_SIPTATIF.csv";
      final File file = File(path);

      await file.writeAsString(csvData);

      // Buka file CSV yang baru saja dibuat
      await OpenFile.open(path);
    } catch (e) {
      throw Exception("Gagal mengekspor CSV: $e");
    }
  }
}
