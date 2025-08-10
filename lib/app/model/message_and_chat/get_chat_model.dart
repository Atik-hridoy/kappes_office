
class ChatResponse {
  final bool success;
  final String message;
  final ChatData data;

  ChatResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ChatData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data.toJson(),
  };
}

class ChatData {
  final Meta meta;
  final List<Chat> chats;

  ChatData({
    required this.meta,
    required this.chats,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      meta: Meta.fromJson(json['meta'] ?? {}),
      chats: List<Chat>.from(
        (json['chats'] ?? []).map((x) => Chat.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
    'meta': meta.toJson(),
    'chats': List<dynamic>.from(chats.map((x) => x.toJson())),
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
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      totalPage: json['totalPage'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'limit': limit,
    'page': page,
    'totalPage': totalPage,
  };
}

class Chat {
  final String id;
  final List<Participant> participants;
  final bool status;
  final LastMessage? lastMessage;

  Chat({
    required this.id,
    required this.participants,
    required this.status,
    this.lastMessage,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'] ?? '',
      participants: List<Participant>.from(
        (json['participants'] ?? []).map((x) => Participant.fromJson(x))),
      status: json['status'] ?? false,
      lastMessage: json['lastMessage'] != null 
          ? LastMessage.fromJson(json['lastMessage']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'participants': List<dynamic>.from(participants.map((x) => x.toJson())),
    'status': status,
    'lastMessage': lastMessage?.toJson(),
  };
}

class Participant {
  final String id;
  final ParticipantType participantType;
  final dynamic participantId; // Can be User or Shop

  Participant({
    required this.id,
    required this.participantType,
    required this.participantId,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'] ?? '',
      participantType: _parseParticipantType(json['participantType']),
      participantId: json['participantId'] is Map 
          ? (json['participantType'] == 'User'
              ? User.fromJson(json['participantId'])
              : Shop.fromJson(json['participantId']))
          : null,
    );
  }

  static ParticipantType _parseParticipantType(String type) {
    switch (type) {
      case 'User': return ParticipantType.user;
      case 'Shop': return ParticipantType.shop;
      default: return ParticipantType.unknown;
    }
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'participantType': participantType.toString().split('.').last,
    'participantId': participantId is User 
        ? (participantId as User).toJson()
        : (participantId as Shop).toJson(),
  };
}

enum ParticipantType { user, shop, unknown }

class User {
  final String id;
  final String fullName;
  final String email;
  final String? image;
  final String? phone;
  final bool verified;
  // Add other fields as needed

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.image,
    this.phone,
    required this.verified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'],
      phone: json['phone'],
      verified: json['verified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'full_name': fullName,
    'email': email,
    'image': image,
    'phone': phone,
    'verified': verified,
  };
}

class Shop {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final bool isActive;
  // Add other fields as needed

  Shop({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.isActive,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'],
      phone: json['phone'],
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'isActive': isActive,
  };
}

class LastMessage {
  final String id;
  final String chatId;
  final String sender;
  final String text;
  final String? image;
  final String createdAt;

  LastMessage({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.text,
    this.image,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['_id'] ?? '',
      chatId: json['chatId'] ?? '',
      sender: json['sender'] ?? '',
      text: json['text'] ?? '',
      image: json['image'],
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'chatId': chatId,
    'sender': sender,
    'text': text,
    'image': image,
    'createdAt': createdAt,
  };
}