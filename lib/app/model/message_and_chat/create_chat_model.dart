


// from product details to seller


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

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}

class ChatData {
  String id;
  final List<Participant> participants;
  final bool status;

  ChatData({
    required this.id,
    required this.participants,
    required this.status,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      id: json['_id'] ?? '',
      participants: (json['participants'] as List)
          .map((e) => Participant.fromJson(e))
          .toList(),
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participants': participants.map((e) => e.toJson()).toList(),
      'status': status,
    };
  }
}

class Participant {
  final String id;
  final ParticipantId participantId;
  final String participantType;

  Participant({
    required this.id,
    required this.participantId,
    required this.participantType,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['_id'] ?? '',
      participantId: ParticipantId.fromJson(json['participantId'] ?? {}),
      participantType: json['participantType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'participantId': participantId.id, // Send only the ID string
      'participantType': participantType,
    };
  }
}

class ParticipantId {
  final String id;
  final String fullName;
  final String role;
  final String email;
  final String phone;
  final String? image;
  final bool verified;
  final bool isDeleted;
  final String? googleId;
  final String? facebookId;

  ParticipantId({
    required this.id,
    required this.fullName,
    required this.role,
    required this.email,
    required this.phone,
    this.image,
    required this.verified,
    required this.isDeleted,
    this.googleId,
    this.facebookId,
  });

  factory ParticipantId.fromJson(Map<String, dynamic> json) {
    return ParticipantId(
      id: json['_id'] ?? '',
      fullName: json['full_name'] ?? '',
      role: json['role'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
      verified: json['verified'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      googleId: json['googleId'],
      facebookId: json['facebookId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'full_name': fullName,
      'role': role,
      'email': email,
      'phone': phone,
      'image': image,
      'verified': verified,
      'isDeleted': isDeleted,
      'googleId': googleId,
      'facebookId': facebookId,
    };
  }
}

class Shop {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String description;
  final String website;
  final String logo;
  final String coverPhoto;
  final String banner;
  final double revenue;

  Shop({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.description,
    required this.website,
    required this.logo,
    required this.coverPhoto,
    required this.banner,
    required this.revenue,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      description: json['description'] ?? '',
      website: json['website'] ?? '',
      logo: json['logo'] ?? '',
      coverPhoto: json['coverPhoto'] ?? '',
      banner: json['banner'] ?? '',
      revenue: json['revenue']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'description': description,
      'website': website,
      'logo': logo,
      'coverPhoto': coverPhoto,
      'banner': banner,
      'revenue': revenue,
    };
  }
}

class LastMessage {
  final String id;
  final String chatId;
  final String sender;
  final String text;
  final String image;
  final DateTime createdAt;

  LastMessage({
    required this.id,
    required this.chatId,
    required this.sender,
    required this.text,
    required this.image,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      id: json['_id'] ?? '',
      chatId: json['chatId'] ?? '',
      sender: json['sender'] ?? '',
      text: json['text'] ?? '',
      image: json['image'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? ''),
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
    };
  }
}
