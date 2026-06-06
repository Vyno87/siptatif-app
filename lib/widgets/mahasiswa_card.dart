import 'package:flutter/material.dart';
import 'package:siptatif_app/datas/models/mahasiswa.dart';

class MahasiswaCard extends StatelessWidget {
  final Mahasiswa mhs;

  const MahasiswaCard({super.key, required this.mhs});

  Color? _warnaStatusCard(String status, {int shade = 50}) {
    if (status == "Disetujui") {
      return Colors.green[shade];
    } else if (status == "Ditolak") {
      return Colors.red[shade];
    }
    return Colors.amber[shade];
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

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        color: _warnaStatusCard(mhs.statusBerkas),
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
                      Icons.calendar_month_rounded, mhs.tglDaftar),
                  _generateRowDataPoint(Icons.account_circle_rounded, mhs.nama),
                  _generateRowDataPoint(
                      Icons.calendar_view_day_rounded, mhs.nim),
                  _generateRowDataPoint(Icons.email_rounded, mhs.email),
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
                    '"${mhs.judulTugasAkhir}"',
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
                          color: _warnaStatusCard(mhs.statusBerkas, shade: 200),
                        ),
                        child: Text(
                          mhs.statusBerkas,
                          style: const TextStyle(
                            fontFamily: "Montserrat-SemiBold",
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton.filledTonal(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            "/mhs-detail-screen",
                            arguments: mhs,
                          );
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
                                        'Apakah anda yakin ingin menghapus data pengajuan mahasiswa ini?'),
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
}
