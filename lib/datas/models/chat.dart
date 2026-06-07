class Chat {
  String? id;
  String senderId;
  String receiverId;
  String message;
  String timestamp;
  String? fileUrl;

  Chat({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
    this.fileUrl,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id']?.toString(),
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
      fileUrl: json['fileUrl']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      if (fileUrl != null) 'fileUrl': fileUrl,
    };
  }
}
