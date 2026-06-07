import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/widgets/glass_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class TambahMahasiswaScreen extends StatefulWidget {
  const TambahMahasiswaScreen({super.key});

  @override
  State<TambahMahasiswaScreen> createState() => _TambahMahasiswaScreenState();
}

class _TambahMahasiswaScreenState extends State<TambahMahasiswaScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _judulTAController = TextEditingController();
  
  String? _selectedJenisPendaftaran;
  String? _selectedKategoriTA;
  String? _selectedDosen1;
  String? _selectedDosen2;

  String _berkasPath = '';

  Future<void> _pickBerkas() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final currentContext = context;
      setState(() {
        _berkasPath = result.files.single.path ?? result.files.single.name;
      });
      if (!currentContext.mounted) return;
      ScaffoldMessenger.of(currentContext).showSnackBar(
        SnackBar(content: Text('Berkas berhasil dipilih: ${result.files.single.name}')),
      );
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_berkasPath.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Harap pilih berkas PDF terlebih dahulu!')),
        );
        return;
      }

      final newMahasiswa = Mahasiswa(
        tglDaftar: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        jenisPendaftaran: _selectedJenisPendaftaran ?? '',
        nama: _namaController.text,
        nim: _nimController.text,
        email: _emailController.text,
        judulTugasAkhir: _judulTAController.text,
        kategoriTugasAkhir: _selectedKategoriTA ?? '',
        calonDosenPembimbing1: _selectedDosen1 ?? '',
        calonDosenPembimbing2: _selectedDosen2 ?? '',
        berkas: _berkasPath,
        statusBerkas: 'Diproses', // Default status
        catatanUntukMahasiswa: '',
      );

      try {
        final currentContext = context;
        await currentContext.read<MahasiswaProvider>().addMahasiswa(newMahasiswa);
        if (!currentContext.mounted) return;
        ScaffoldMessenger.of(currentContext).showSnackBar(
          const SnackBar(content: Text('Berhasil menambah pendaftar Mahasiswa')),
        );
        Navigator.pop(currentContext);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [const Color(0xFF1F1C2C), const Color(0xFF928DAB)]
              : [const Color(0xFF8EC5FC), const Color(0xFFE0C3FC)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Tambah Mahasiswa'),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: GlassCard(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Formulir Pendaftaran TA",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(_namaController, "Nama Lengkap"),
                  _buildTextField(_nimController, "NIM"),
                  _buildTextField(_emailController, "Email"),
                  _buildDropdownField(
                    "Jenis Pendaftaran",
                    ['Biasa', 'Lanjutan'],
                    _selectedJenisPendaftaran,
                    (val) => setState(() => _selectedJenisPendaftaran = val),
                  ),
                  _buildTextField(_judulTAController, "Judul Tugas Akhir"),
                  _buildDropdownField(
                    "Kategori TA",
                    ['RPL', 'Kecerdasan Buatan', 'Jaringan'],
                    _selectedKategoriTA,
                    (val) => setState(() => _selectedKategoriTA = val),
                  ),
                  _buildDropdownField(
                    "Calon Dosen Pembimbing 1",
                    ['Dr. Jane Doe', 'Prof. John Smith', 'Dr. Alan Turing', 'Dr. Ada Lovelace'],
                    _selectedDosen1,
                    (val) => setState(() => _selectedDosen1 = val),
                  ),
                  _buildDropdownField(
                    "Calon Dosen Pembimbing 2",
                    ['Dr. Jane Doe', 'Prof. John Smith', 'Dr. Alan Turing', 'Dr. Ada Lovelace'],
                    _selectedDosen2,
                    (val) => setState(() => _selectedDosen2 = val),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickBerkas,
                        icon: const Icon(Icons.upload_file),
                        label: const Text("Pilih Berkas PDF"),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _berkasPath.isNotEmpty ? _berkasPath.split(RegExp(r'[\\/]')).last : "Belum ada berkas",
                          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontStyle: FontStyle.italic),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: context.watch<MahasiswaProvider>().isLoading ? null : _submit,
                      child: context.watch<MahasiswaProvider>().isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Simpan & Unggah',
                              style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hint tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(
    String hint,
    List<String> items,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        initialValue: selectedValue,
        icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onSurface),
        dropdownColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1F1C2C)
            : Colors.white,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          hintText: hint,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hint tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }
}
