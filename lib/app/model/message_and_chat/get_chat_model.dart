
class ChatResponse {
  bool success;
  String message;
  ChatData data;

  ChatResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      success: json['success'],
      message: json['message'],
      data: ChatData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}

class ChatData {
  Meta meta;
  List<Chat> chats;

  ChatData({required this.meta, required this.chats});

  factory ChatData.fromJson(Map<String, dynamic> json) {
    var list = json['chats'] as List;
    List<Chat> chatsList = list.map((i) => Chat.fromJson(i)).toList();

    return ChatData(meta: Meta.fromJson(json['meta']), chats: chatsList);
  }

  Map<String, dynamic> toJson() {
    return {
      'meta': meta.toJson(),
      'chats': chats.map((chat) => chat.toJson()).toList(),
    };
  }
}

class Meta {
  int total;
  int limit;
  int page;
  int totalPage;

  Meta({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'],
      limit: json['limit'],
      page: json['page'],
      totalPage: json['totalPage'],
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

class Chat {
  // Define your Chat model properties here (e.g., id, message, participants, etc.)
  // Example:
  String id;
  String message;

  Chat({required this.id, required this.message});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'], // Example field
      message: json['message'], // Example field
    );
  }

  DateTime get date => DateTime.now();

  bool get isSentByMe => false;

  Map<String, dynamic> toJson() {
    return {'_id': id, 'message': message};
  }
}
