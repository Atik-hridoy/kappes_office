class Notification {
  final String id;
  final String message;
  final String title;
  final Receiver receiver;
  final bool read;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notification({
    required this.id,
    required this.message,
    required this.title,
    required this.receiver,
    required this.read,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create Notification object from JSON
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['_id'] ?? '',
      message: json['message'] ?? '',
      title: json['title'] ?? '',
      receiver: Receiver.fromJson(json['receiver']),
      read: json['read'] ?? false,
      type: json['type'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert Notification object back to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'message': message,
      'title': title,
      'receiver': receiver.toJson(),
      'read': read,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class Receiver {
  final String id;
  final String email;

  Receiver({required this.id, required this.email});

  // Factory constructor to create Receiver object from JSON
  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(id: json['_id'] ?? '', email: json['email'] ?? '');
  }

  // Method to convert Receiver object back to JSON
  Map<String, dynamic> toJson() {
    return {'_id': id, 'email': email};
  }
}

class NotificationResponse {
  final bool success;
  final String message;
  final Meta meta;
  final List<Notification> notifications;

  NotificationResponse({
    required this.success,
    required this.message,
    required this.meta,
    required this.notifications,
  });

  // Factory constructor to create NotificationResponse object from JSON
  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    return NotificationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      meta: Meta.fromJson(json['data']['meta']),
      notifications: List<Notification>.from(
        json['data']['result']['result'].map((x) => Notification.fromJson(x)),
      ),
    );
  }

  // Method to convert NotificationResponse object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': {
        'meta': meta.toJson(),
        'result': {'result': notifications.map((x) => x.toJson()).toList()},
      },
    };
  }
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

  // Factory constructor to create Meta object from JSON
  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 0,
      page: json['page'] ?? 0,
      totalPage: json['totalPage'] ?? 0,
    );
  }

  // Method to convert Meta object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'limit': limit,
      'page': page,
      'totalPage': totalPage,
    };
  }
}
