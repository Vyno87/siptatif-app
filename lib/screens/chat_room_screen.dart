import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siptatif_app/providers/chat_provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:siptatif_app/utils/app_theme.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';

class ChatRoomScreen extends StatefulWidget {
  final String contactId;
  final String contactName;
  final String currentUserId;

  const ChatRoomScreen({
    super.key,
    required this.contactId,
    required this.contactName,
    required this.currentUserId,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().fetchChats().then((_) {
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _pickAndUploadFile() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        File file = File(result.files.single.path!);
        String fileName = "${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}";
        Reference ref = FirebaseStorage.instance.ref().child('chat_files/$fileName');
        UploadTask uploadTask = ref.putFile(file);
        
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        if (mounted) {
          context.read<ChatProvider>().sendMessage(
            widget.currentUserId,
            widget.contactId,
            "Mengirim file: ${result.files.single.name}",
            fileUrl: downloadUrl,
          );
          Future.delayed(const Duration(milliseconds: 100), () => _scrollToBottom());
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal mengunggah file')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final chats = chatProvider.getChatsBetween(widget.currentUserId, widget.contactId);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.darkGlassGradient : AppTheme.neonGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white24,
                radius: 16,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(widget.contactName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: isDark ? Colors.white : Colors.black87,
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  final isMe = chat.senderId == widget.currentUserId;
                  final time = DateFormat('HH:mm').format(DateTime.parse(chat.timestamp));

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.75,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(isMe ? 20 : 0),
                          bottomRight: Radius.circular(isMe ? 0 : 20),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isMe 
                                  ? AppTheme.primaryPurple.withValues(alpha: 0.7) 
                                  : (isDark ? Colors.grey[800]!.withValues(alpha: 0.6) : Colors.white.withValues(alpha: 0.7)),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chat.message,
                                  style: TextStyle(
                                    color: isMe ? Colors.white : (isDark ? Colors.white : Colors.black87),
                                    fontSize: 15,
                                  ),
                                ),
                                if (chat.fileUrl != null) ...[
                                  const SizedBox(height: 8),
                                  ElevatedButton.icon(
                                    onPressed: () async {
                                      final uri = Uri.parse(chat.fileUrl!);
                                      if (await canLaunchUrl(uri)) {
                                        await launchUrl(uri, mode: LaunchMode.externalApplication);
                                      }
                                    },
                                    icon: Icon(Icons.download, size: 16, color: isMe ? AppTheme.primaryPurple : Colors.white),
                                    label: Text("Unduh File", style: TextStyle(color: isMe ? AppTheme.primaryPurple : Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isMe ? Colors.white : AppTheme.primaryPurple,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      minimumSize: const Size(0, 30),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  )
                                ],
                                const SizedBox(height: 6),
                                Text(
                                  time,
                                  style: TextStyle(
                                    color: isMe ? Colors.white70 : Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ).animate().fade(duration: 300.ms).slideY(begin: 0.1, end: 0);
                },
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.5),
                    border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _msgController,
                            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                            decoration: InputDecoration(
                              hintText: 'Ketik pesan...',
                              hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: isDark ? Colors.black26 : Colors.white70,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_isUploading)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryPurple),
                            ),
                          )
                        else
                          IconButton(
                            icon: Icon(Icons.attach_file, color: isDark ? Colors.white70 : Colors.black54),
                            onPressed: _pickAndUploadFile,
                          ),
                        CircleAvatar(
                          backgroundColor: AppTheme.primaryPurple,
                          child: IconButton(
                            icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                            onPressed: () {
                              if (_msgController.text.trim().isNotEmpty) {
                                chatProvider.sendMessage(
                                  widget.currentUserId,
                                  widget.contactId,
                                  _msgController.text.trim(),
                                );
                                _msgController.clear();
                                Future.delayed(const Duration(milliseconds: 100), () => _scrollToBottom());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
