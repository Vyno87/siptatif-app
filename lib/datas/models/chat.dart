class Chat {
  String? id;
  String senderId;
  String receiverId;
  String message;
  String timestamp;

  Chat({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.timestamp,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id']?.toString(),
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
