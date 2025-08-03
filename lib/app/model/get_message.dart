// Main model for the response
class MessageResponse {
  final bool success;
  final String message;
  final MessageData data;

  MessageResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  // Factory constructor to parse the JSON data
  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: MessageData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  // Method to convert the response to JSON
  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

// Model for the data part of the response
class MessageData {
  final MessageMeta meta;
  final List<Message> messages;

  MessageData({required this.meta, required this.messages});

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      meta: MessageMeta.fromJson(json['meta'] as Map<String, dynamic>),
      messages:
          (json['messages'] as List)
              .map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'messages': messages.map((e) => e.toJson()).toList(),
    };
  }
}

// Model for the meta data (pagination info)
class MessageMeta {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  MessageMeta({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory MessageMeta.fromJson(Map<String, dynamic> json) {
    return MessageMeta(
      total: json['total'] as int,
      limit: json['limit'] as int,
      page: json['page'] as int,
      totalPage: json['totalPage'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'limit': limit,
      'page': page,
      'totalPage': totalPage,
    };
  }
}

// Model for each individual message
class Message {
  final String id;
  final String chatId;
  final String sender;
  final String text;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.text,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] as String,
      chatId: json['chatId'] as String,
      sender: json['sender'] as String,
      text: json['text'] as String,
      image: json['image'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'chatId': chatId,
      'sender': sender,
      'text': text,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
