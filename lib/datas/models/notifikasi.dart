class Notifikasi {
  String? id;
  final String judul;
  final String pesan;
  final String waktu;
  bool isRead;

  Notifikasi({
    this.id,
    required this.judul,
    required this.pesan,
    required this.waktu,
    this.isRead = false,
  });

  factory Notifikasi.fromJson(Map<String, dynamic> json) {
    return Notifikasi(
      id: json['id']?.toString() ?? '',
      judul: json['judul'] ?? '',
      pesan: json['pesan'] ?? '',
      waktu: json['waktu'] ?? '',
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'pesan': pesan,
      'waktu': waktu,
      'isRead': isRead,
    };
  }
}
