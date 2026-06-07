import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/auth_provider.dart';
import 'package:siptatif_app/providers/mahasiswa_provider.dart';
import 'package:siptatif_app/widgets/glass_card.dart';
import 'package:siptatif_app/screens/chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final mhsProvider = context.watch<MahasiswaProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    List<Map<String, String>> contacts = [];

    if (user != null) {
      if (user.roles == 'Mahasiswa') {
        // Find their own submission
        try {
          final myData = mhsProvider.listMahasiswa.firstWhere((m) => m.nim == user.nimNidn);
          if (myData.calonDosenPembimbing1.isNotEmpty) {
            contacts.add({'name': myData.calonDosenPembimbing1, 'id': myData.calonDosenPembimbing1, 'role': 'Dosen Pembimbing 1'});
          }
          if (myData.calonDosenPembimbing2.isNotEmpty) {
            contacts.add({'name': myData.calonDosenPembimbing2, 'id': myData.calonDosenPembimbing2, 'role': 'Dosen Pembimbing 2'});
          }
        } catch (e) {
          // No submission yet
        }
      } else if (user.roles == 'Dosen') {
        // Find all mahasiswa they mentor
        final bimbingans = mhsProvider.listMahasiswa.where((m) => 
          m.calonDosenPembimbing1 == user.fullName || m.calonDosenPembimbing2 == user.fullName).toList();
        for (var m in bimbingans) {
          contacts.add({'name': m.nama, 'id': m.nim, 'role': 'Mahasiswa Bimbingan'});
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Ruang Diskusi', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: contacts.isEmpty
          ? Center(
              child: Text(
                'Belum ada kontak tersedia.',
                style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoomScreen(
                            contactId: contact['id']!,
                            contactName: contact['name']!,
                            currentUserId: user?.roles == 'Mahasiswa' ? user!.nimNidn! : user!.fullName!,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: GlassCard(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent.withOpacity(0.2),
                          child: const Icon(Icons.person, color: Colors.blueAccent),
                        ),
                        title: Text(contact['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(contact['role']!),
                        trailing: const Icon(Icons.chat_bubble_outline, color: Colors.blueAccent),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
