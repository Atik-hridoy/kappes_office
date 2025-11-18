class SendMessageResponse {
  final bool success;
  final String message;
  final MessageData data;

  SendMessageResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MessageData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class MessageData {
  final String chatId;
  final String sender;
  final String text;
  final String? image;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  MessageData({
    required this.chatId,
    required this.sender,
    required this.text,
    this.image,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      chatId: json['chatId'] ?? '',
      sender: json['sender'] ?? '',
      text: json['text'] ?? '',
      image: json['image'] as String?,
      id: json['_id'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? '1970-01-01T00:00:00Z'),
      updatedAt: DateTime.parse(json['updatedAt'] ?? '1970-01-01T00:00:00Z'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'sender': sender,
      'text': text,
      if (image != null) 'image': image,
      '_id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
