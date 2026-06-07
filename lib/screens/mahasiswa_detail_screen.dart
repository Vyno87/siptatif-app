import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';
import 'package:siptatif_app/datas/models/penguji.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/penguji_provider.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/providers/logbook_provider.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:siptatif_app/screens/pdf_viewer_screen.dart';
import 'package:siptatif_app/datas/models/logbook.dart';

class MahasiswaDetailScreen extends StatefulWidget {
  const MahasiswaDetailScreen({super.key});

  @override
  State<MahasiswaDetailScreen> createState() => _MahasiswaDetailScreenState();
}

class _MahasiswaDetailScreenState extends State<MahasiswaDetailScreen> {
  bool value = false; // Disetujui
  bool value2 = false; // Ditolak
  
  final _catatanController = TextEditingController();
  final _penguji1Controller = TextEditingController();
  final _penguji2Controller = TextEditingController();
  bool _isInitialized = false;

  @override
  void dispose() {
    _catatanController.dispose();
    _penguji1Controller.dispose();
    _penguji2Controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)?.settings.arguments as Mahasiswa?;
      if (args != null) {
        value = args.statusBerkas == "Disetujui";
        value2 = args.statusBerkas == "Ditolak";
        _catatanController.text = args.catatanUntukMahasiswa;
        _penguji1Controller.text = args.dosenPenguji1 ?? '';
        _penguji2Controller.text = args.dosenPenguji2 ?? '';
      }
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Mahasiswa;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Berkas Mahasiswa",
              ),
              Tab(
                text: "Status & Timeline",
              ),
              Tab(
                text: "Input Dos. Penguji",
              ),
              Tab(
                text: "Logbook Bimbingan",
              ),
            ],
          ),
          title: const Text('Detail Pengajuan Mhs'),
          titleSpacing: 0,
        ),
        body: TabBarView(
          children: [
            contentDetail(args),
            statusTimeline(args),
            inputPenguji(context, args),
            _logbookTab(context, args),
          ],
        ),
      ),
    );
  }

  Widget _logbookTab(BuildContext context, Mahasiswa args) {
    final logbookProvider = context.watch<LogbookProvider>();
    final user = context.watch<AuthProvider>().currentUser;
    final isDosen = user?.roles == 'Dosen';

    final myLogbooks = logbookProvider.listLogbook.where((l) => l.mahasiswaId == args.nim).toList();
    myLogbooks.sort((a, b) => b.tanggal.compareTo(a.tanggal));

    if (myLogbooks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_edu_rounded, size: 80, color: Colors.grey.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            const Text(
              'Mahasiswa ini belum mengisi logbook.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myLogbooks.length,
      itemBuilder: (context, index) {
        final logbook = myLogbooks[index];
        final isFirst = index == 0;
        final isLast = index == myLogbooks.length - 1;

        Color statusColor = Colors.grey;
        if (logbook.status == 'Disetujui') statusColor = Colors.green;
        if (logbook.status == 'Direvisi') statusColor = Colors.orange;

        return TimelineTile(
          isFirst: isFirst,
          isLast: isLast,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: statusColor,
          ),
          beforeLineStyle: LineStyle(color: statusColor.withValues(alpha: 0.5)),
          endChild: Card(
            margin: const EdgeInsets.only(left: 16, bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(logbook.tanggal, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(logbook.status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(logbook.materiProgres),
                  const SizedBox(height: 8),
                  if (logbook.catatanDosen.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.orange.withValues(alpha: 0.1),
                      child: Text('Catatan Dosen: ${logbook.catatanDosen}'),
                    ),
                  if (isDosen && logbook.status == 'Menunggu Validasi')
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: ElevatedButton.icon(
                        onPressed: () => _showValidasiDialog(context, logbook),
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Validasi Logbook'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showValidasiDialog(BuildContext context, Logbook logbook) {
    final catatanEvalController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Validasi Logbook'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Progres: ${logbook.materiProgres}'),
              const SizedBox(height: 16),
              TextField(
                controller: catatanEvalController,
                decoration: const InputDecoration(
                  labelText: 'Catatan Evaluasi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                logbook.status = 'Direvisi';
                logbook.catatanDosen = catatanEvalController.text;
                await context.read<LogbookProvider>().updateLogbook(logbook);
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              child: const Text('Revisi'),
            ),
            ElevatedButton(
              onPressed: () async {
                logbook.status = 'Disetujui';
                logbook.catatanDosen = catatanEvalController.text;
                await context.read<LogbookProvider>().updateLogbook(logbook);
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Setujui'),
            ),
          ],
        );
      },
    );
  }

  Widget _textFieldGenerator(String label, {TextEditingController? controller}) {
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

  Widget inputPenguji(BuildContext context, Mahasiswa mhs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            style: const TextStyle(height: 1),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              hintText: 'Search',
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: context.watch<PengujiProvider>().listPenguji
                  .map((penguji) => _templatePengujiCard(penguji))
                  .toList(),
            ),
          ),
          const SizedBox(
            height: 23,
          ),
          _textFieldGenerator("Input Dosen Penguji 1", controller: _penguji1Controller),
          _textFieldGenerator("Input Dosen Penguji 2", controller: _penguji2Controller),
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
                  onPressed: () async {
                    final currentContext = context;
                    try {
                      mhs.dosenPenguji1 = _penguji1Controller.text;
                      mhs.dosenPenguji2 = _penguji2Controller.text;
                      await currentContext.read<MahasiswaProvider>().updateMahasiswa(mhs);
                      
                      if (!currentContext.mounted) return;
                      ScaffoldMessenger.of(currentContext).showSnackBar(
                        const SnackBar(content: Text('Dosen Penguji berhasil ditugaskan!')),
                      );
                      Navigator.pop(currentContext);
                    } catch (e) {
                      if (!currentContext.mounted) return;
                      ScaffoldMessenger.of(currentContext).showSnackBar(
                        SnackBar(content: Text('Gagal: $e')),
                      );
                    }
                  },
                  child: const Text("Kirim"))
            ],
          )
        ],
      ),
    );
  }

  Card _templatePengujiCard(Penguji penguji) {
    return Card(
        elevation: 0,
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.fromLTRB(0, 18, 17, 0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _generateRowDataPoint(Icons.account_circle_rounded, penguji.nama),
              _generateRowDataPoint(
                  Icons.calendar_view_day_rounded, penguji.nidn),
              _generateRowDataPoint(
                  Icons.transgender_rounded, penguji.jenisKelamin),
              const SizedBox(
                height: 4,
              ),
              Divider(
                height: 1,
                color: Theme.of(context).dividerColor,
                thickness: 0.8,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                '"${penguji.keahlian}"',
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.amber[200]),
                child: Text(
                  "${penguji.kuota.toString()} kuota tersedia",
                  style: const TextStyle(
                    fontFamily: "Montserrat-SemiBold",
                    letterSpacing: -0.5,
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Row _generateRowDataPoint(IconData icon, String label) {
    return Row(
      children: [
        Icon(
          icon,
          size: 15,
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        )
      ],
    );
  }

  Widget contentDetail(Mahasiswa mhs) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        children: [
          _contentInput("Jenis Pendaftaran", mhs.jenisPendaftaran),
          Hero(
            tag: 'mhs-nama-${mhs.nim}',
            child: Material(
              type: MaterialType.transparency,
              child: _contentInput("Nama Mahasiswa", mhs.nama),
            ),
          ),
          _contentInput("NIM Mahasiswa", mhs.nim),
          _contentInput("Email Mahasiswa", mhs.email),
          _contentInput("Judul Tugas Akhir", mhs.judulTugasAkhir),
          _contentInput("Kategori TA", mhs.kategoriTugasAkhir),
          _contentInput("Calon Dosen Pembimbing 1", mhs.calonDosenPembimbing1),
          _contentInput("Calon Dosen Pembimbing 2", mhs.calonDosenPembimbing2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Berkas",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    letterSpacing: -0.5),
              ),
              const SizedBox(height: 5),
              Container(
                width: 320,
                height: 115,
                decoration:
                    BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(mhs.berkas.isNotEmpty ? "Berkas: ${mhs.berkas.split(RegExp(r'[\\/]')).last}" : "Buka Berkas"),
                    IconButton(
                      onPressed: () {
                        if (mhs.berkas.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Tidak ada berkas yang diunggah.')),
                          );
                          return;
                        }
                        // Membuka PDF Viewer dengan URL/Path berkas yang tersimpan
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PdfViewerScreen(
                              pdfUrl: mhs.berkas,
                              title: 'Proposal TA - ${mhs.nama}',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.picture_as_pdf_rounded,
                        size: 40,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          const SizedBox(
              width: 320,
              child: Text(
                "Status Berkas",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    letterSpacing: -0.5),
              )),
          Row(
            children: [
              Checkbox(
                value: value,
                onChanged: (bool? value) {
                  setState(() {
                    this.value = value ?? true;
                    value2 = !this.value;
                  });
                },
              ),
              const Text("Diterima"),
              Checkbox(
                value: value2,
                onChanged: (bool? value) {
                  setState(() {
                    value2 = value ?? true;
                    this.value = !value2;
                  });
                },
              ),
              const Text("Ditolak"),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          _contentInputController("Catatan Untuk Mahasiswa", _catatanController),
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
                  onPressed: () async {
                    final currentContext = context;
                    try {
                      if (value) {
                        mhs.statusBerkas = "Disetujui";
                      } else if (value2) {
                        mhs.statusBerkas = "Ditolak";
                      } else {
                        mhs.statusBerkas = "Menunggu";
                      }
                      mhs.catatanUntukMahasiswa = _catatanController.text;
                      
                      await currentContext.read<MahasiswaProvider>().updateMahasiswa(mhs);
                      
                      if (!currentContext.mounted) return;
                      ScaffoldMessenger.of(currentContext).showSnackBar(
                        const SnackBar(content: Text('Status Berkas berhasil diperbarui!')),
                      );
                      Navigator.pop(currentContext);
                    } catch (e) {
                      if (!currentContext.mounted) return;
                      ScaffoldMessenger.of(currentContext).showSnackBar(
                        SnackBar(content: Text('Gagal: $e')),
                      );
                    }
                  },
                  child: const Text("Simpan Status"))
            ],
          )
        ],
      ),
    );
  }

  Widget _contentInput(String label, String val) {
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
          child: TextFormField(
            initialValue: val,
            style: const TextStyle(height: 1),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _contentInputController(String label, TextEditingController controller) {
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
          child: TextFormField(
            controller: controller,
            style: const TextStyle(height: 1),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget statusTimeline(Mahasiswa mhs) {
    bool isDisetujui = mhs.statusBerkas == "Disetujui";
    bool isDitolak = mhs.statusBerkas == "Ditolak";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Pelacakan Berkas Tugas Akhir",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 20),
          _buildTimelineTile(
            isFirst: true,
            isLast: false,
            isPast: true,
            title: "Pengajuan Judul",
            subtitle: "Mahasiswa mengirimkan form pengajuan",
            icon: Icons.check_circle,
            color: Colors.green,
          ),
          _buildTimelineTile(
            isFirst: false,
            isLast: false,
            isPast: true,
            title: "Review Koordinator",
            subtitle: "Koordinator TA meninjau berkas",
            icon: Icons.check_circle,
            color: Colors.green,
          ),
          _buildTimelineTile(
            isFirst: false,
            isLast: false,
            isPast: isDisetujui || isDitolak,
            title: "Persetujuan Berkas",
            subtitle: isDisetujui
                ? "Berkas disetujui, lanjut penunjukan pembimbing"
                : isDitolak
                    ? "Berkas ditolak, harap perbaiki"
                    : "Menunggu keputusan koordinator",
            icon: isDisetujui
                ? Icons.check_circle
                : isDitolak
                    ? Icons.cancel
                    : Icons.hourglass_bottom,
            color: isDisetujui
                ? Colors.green
                : isDitolak
                    ? Colors.red
                    : Colors.orange,
          ),
          _buildTimelineTile(
            isFirst: false,
            isLast: true,
            isPast: false,
            title: "Penunjukan Pembimbing",
            subtitle: isDisetujui
                ? "Segera ditunjuk"
                : "Terkunci",
            icon: Icons.lock,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTile({
    required bool isFirst,
    required bool isLast,
    required bool isPast,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      height: 90,
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
          color: isPast ? color : Colors.grey.shade300,
        ),
        indicatorStyle: IndicatorStyle(
          width: 40,
          color: color,
          iconStyle: IconStyle(
            iconData: icon,
            color: Colors.white,
          ),
        ),
        endChild: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isPast ? Theme.of(context).colorScheme.onSurface : Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: isPast ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
