import 'dart:convert';
import 'package:canuck_mall/app/utils/log/app_log.dart';

class CreateChat {
  bool success;
  String message;
  ChatData data;

  CreateChat({
    required this.success,
    required this.message,
    required this.data,
  });

  factory CreateChat.fromJson(Map<String, dynamic> json) {
    return CreateChat(
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
  String id;
  List<Participant> participants;
  bool status;

  ChatData({
    required this.id,
    required this.participants,
    required this.status,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    var participantsList = json['participants'] as List;
    List<Participant> participants =
        participantsList.map((i) => Participant.fromJson(i)).toList();

    return ChatData(
      id: json['_id'],
      participants: participants,
      status: json['status'],
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
  String participantId;
  String participantType;
  String id;

  Participant({
    required this.participantId,
    required this.participantType,
    required this.id,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      participantId: json['participantId'],
      participantType: json['participantType'],
      id: json['_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participantId': participantId,
      'participantType': participantType,
      '_id': id,
    };
  }
}

void main() {
  String jsonString =
      '{"success": true, "message": "Create Chat Successfully", "data": {"_id": "686b4723ff0ea5b6a9ee6972", "participants": [{"participantId": "685a209195fac3398ed00fca", "participantType": "User", "_id": "686b4723ff0ea5b6a9ee6973"}, {"participantId": "6857d5988a47be1e4bf6adc4", "participantType": "Shop", "_id": "686b4723ff0ea5b6a9ee6974"}], "status": true, "__v": 0}}';

  // Parse JSON to Dart object
  var jsonData = jsonDecode(jsonString);
  var createChat = CreateChat.fromJson(jsonData);

  // Log the chat creation details
  AppLogger.info(
    'Chat created successfully',
    tag: 'CHAT',
    context: {
      'chatId': createChat.data.id,
      'message': createChat.message,
      'participantCount': createChat.data.participants.length,
    },
  );
}
