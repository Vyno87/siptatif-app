import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:siptatif_app/datas/models/user.dart';
import 'package:siptatif_app/utils/app_theme.dart';
import 'package:siptatif_app/widgets/glass_card.dart';

class PersetujuanAkunScreen extends StatelessWidget {
  const PersetujuanAkunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGlassGradient : AppTheme.neonGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Persetujuan Akun',
            style: TextStyle(
              fontFamily: 'Montserrat-Bold',
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('status', isEqualTo: 'pending')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Terjadi kesalahan data.'));
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 80,
                      color: isDark ? Colors.white54 : Colors.black45,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tidak ada akun yang menunggu persetujuan.',
                      style: TextStyle(
                        fontFamily: 'Montserrat-Medium',
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }

            final pendingUsers = snapshot.data!.docs;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pendingUsers.length,
              itemBuilder: (context, index) {
                final doc = pendingUsers[index];
                final data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                final user = User.fromJson(data);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.primaryPurple.withValues(alpha: 0.2),
                                child: Icon(
                                  user.roles == 'Mahasiswa' ? Icons.school : Icons.work,
                                  color: AppTheme.primaryPurple,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.fullName ?? user.email,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat-Bold',
                                        fontSize: 16,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      user.roles,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat-Medium',
                                        fontSize: 14,
                                        color: AppTheme.primaryPurple,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(Icons.email, 'Email', user.email, isDark),
                          const SizedBox(height: 8),
                          if (user.nimNidn != null && user.nimNidn!.isNotEmpty)
                            _buildDetailRow(
                              Icons.badge,
                              user.roles == 'Mahasiswa' ? 'NIM' : 'NIDN',
                              user.nimNidn!,
                              isDark,
                            ),
                          if (user.extraInfo != null && user.extraInfo!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            _buildDetailRow(
                              user.roles == 'Mahasiswa' ? Icons.book : Icons.lightbulb,
                              user.roles == 'Mahasiswa' ? 'Program Studi' : 'Bidang Keahlian',
                              user.extraInfo!,
                              isDark,
                            ),
                          ],
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () => _handleReject(context, doc.id),
                                icon: const Icon(Icons.close, color: Colors.redAccent),
                                label: const Text('Tolak', style: TextStyle(color: Colors.redAccent)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () => _handleApprove(context, doc.id),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                icon: const Icon(Icons.check),
                                label: const Text('Terima'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: isDark ? Colors.white54 : Colors.black45),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Montserrat-Regular',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Montserrat-Medium',
                  fontSize: 14,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleApprove(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        'status': 'approved',
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun berhasil disetujui.'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyetujui akun: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _handleReject(BuildContext context, String docId) async {
    // Confirm dialog
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Pendaftaran?'),
        content: const Text('Akun ini akan dihapus permanen. Apakah Anda yakin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(docId).delete();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pendaftaran ditolak dan akun dihapus.')),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal menolak akun: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }
}
