import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/pembimbing.dart';
import 'package:siptatif_app/providers/pembimbing_provider.dart';
import 'package:siptatif_app/providers/notifikasi_provider.dart';

class PembimbingTambahScreen extends StatefulWidget {
  const PembimbingTambahScreen({super.key});

  @override
  State<PembimbingTambahScreen> createState() => _PembimbingTambahScreenState();
}

class _PembimbingTambahScreenState extends State<PembimbingTambahScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nidnController = TextEditingController();
  final TextEditingController jkController = TextEditingController();
  final TextEditingController kuotaController = TextEditingController();
  final TextEditingController keahlianController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    nidnController.dispose();
    jkController.dispose();
    kuotaController.dispose();
    keahlianController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Pembimbing'),
        titleSpacing: 0,
      ),
      body: contentDetail(),
    );
  }

  Widget contentDetail() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          _contentInput("Nama Dosen", namaController),
          _contentInput("NIDN Dosen", nidnController),
          _contentInput("Jenis Kelamin Dosen", jkController),
          _contentInput("Kuota Mahasiswa Bimbingan", kuotaController, isNumber: true),
          _contentInput("Keahlian Dosen", keahlianController),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Kembali")),
              const SizedBox(
                width: 8,
              ),
              FilledButton(
                  onPressed: () {
                    final newPembimbing = Pembimbing(
                      nama: namaController.text.isEmpty ? "Tanpa Nama" : namaController.text,
                      nidn: nidnController.text.isEmpty ? "-" : nidnController.text,
                      jenisKelamin: jkController.text.isEmpty ? "-" : jkController.text,
                      kuota: int.tryParse(kuotaController.text) ?? 0,
                      keahlian: keahlianController.text.isEmpty ? "-" : keahlianController.text,
                    );

                    context.read<PembimbingProvider>().tambahPembimbing(newPembimbing);
                    context.read<NotifikasiProvider>().tambahNotifikasi(
                      "Data Pembimbing Baru",
                      "Dosen pembimbing baru bernama ${newPembimbing.nama} telah ditambahkan."
                    );

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Data berhasil disimpan secara real-time!')),
                    );
                  },
                  child: const Text("Kirim"))
            ],
          )
        ],
      ),
    );
  }

  Widget _contentInput(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 17, letterSpacing: -0.5),
        ),
        const SizedBox(height: 5),
        SizedBox(
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: const TextStyle(height: 1),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              hintText: label,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
