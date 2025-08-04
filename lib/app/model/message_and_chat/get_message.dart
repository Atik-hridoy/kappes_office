class GetMessageResponse {
  final bool success;
  final String message;
  final MessageData data;

  GetMessageResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory GetMessageResponse.fromJson(Map<String, dynamic> json) {
    return GetMessageResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: MessageData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

class MessageData {
  final Meta meta;
  final List<Message> messages;

  MessageData({required this.meta, required this.messages});

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
      messages:
          (json['messages'] as List<dynamic>? ?? [])
              .map((e) => Message.fromJson(e as Map<String, dynamic>? ?? {}))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'meta': meta.toJson(),
    'messages': messages.map((e) => e.toJson()).toList(),
  };
}

class Meta {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  Meta({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'] as int? ?? 0,
      limit: json['limit'] as int? ?? 0,
      page: json['page'] as int? ?? 0,
      totalPage: json['totalPage'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'limit': limit,
    'page': page,
    'totalPage': totalPage,
  };
}

class Message {
  final String id;
  final String chatId;
  final String sender;
  final String text;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Message({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.text,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] as String? ?? '',
      chatId: json['chatId'] as String? ?? '',
      sender: json['sender'] as String? ?? '',
      text: json['text'] as String? ?? '',
      image: json['image'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? '1970-01-01'),
      updatedAt: DateTime.parse(json['updatedAt'] as String? ?? '1970-01-01'),
      v: json['__v'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'chatId': chatId,
    'sender': sender,
    'text': text,
    if (image != null) 'image': image,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
  };
}
