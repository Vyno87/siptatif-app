import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/datas/models/penguji.dart';
import 'package:siptatif_app/providers/penguji_provider.dart';

class PengujiScreen extends StatelessWidget {
  const PengujiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PengujiProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      child: Column(
        children: [
          const SizedBox(
            height: 3,
          ),
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
          const SizedBox(
            height: 14,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilledButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/tambah-penguji");
                  },
                  child: const Text("+ Tambah Data")),
            ],
          ),
          Column(
            children: provider.listPenguji
                .map((penguji) => _templatePengujiCard(context, penguji))
                .toList(),
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }

  Card _templatePengujiCard(BuildContext context, Penguji penguji) {
    return Card(
        elevation: 0,
        color: Colors.grey[200],
        margin: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _generateRowDataPoint(
                      Icons.account_circle_rounded, penguji.nama),
                  _generateRowDataPoint(
                      Icons.calendar_view_day_rounded, penguji.nidn),
                  _generateRowDataPoint(
                      Icons.transgender_rounded, penguji.jenisKelamin),
                  const SizedBox(
                    height: 4,
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.black,
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
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
                      ),
                      const Spacer(),
                      IconButton.filledTonal(
                        onPressed: () {
                          Navigator.pushNamed(context, "/penguji-update-screen",
                              arguments: penguji);
                        },
                        icon: const Icon(Icons.edit_note_outlined),
                      ),
                      IconButton.filled(
                        onPressed: () {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                        'Apakah anda yakin ingin menghapus data dosen penguji ini?'),
                                    const SizedBox(height: 15),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.amber[100],
                                          ),
                                          child: const Text(
                                            'Batalkan',
                                            style: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: -0.2),
                                          )),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<PengujiProvider>().hapusPenguji(penguji);
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.red[100],
                                          ),
                                          child: const Text(
                                            'Iya, Saya Yakin',
                                            style: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: -0.2),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        // onPressed: () {
                        // AwesomeDialog(
                        //   context: context,
                        //   dialogType: DialogType.warning,
                        //   title: "Data Removed Warning!",
                        //   desc: "Apakah anda yakin ingin menghapus data pengajuan mahasiswa ini?"
                        // ).show();
                        // },
                        icon: const Icon(Icons.delete_outline_sharp),
                      )
                    ],
                  )
                ],
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
}
