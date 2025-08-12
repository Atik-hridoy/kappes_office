// import 'package:canuck_mall/app/data/local/storage_service.dart';

// // Message model class
// class Message {
//   final String id;
//   final String chatId;
//   final String sender;
//   final String text;
//   final String? image;
//   final DateTime createdAt;
//   final DateTime updatedAt;
  
//   bool get isSentByMe => sender == LocalStorage.userId;

//   Message({
//     required this.id,
//     required this.chatId,
//     required this.sender,
//     required this.text,
//     this.image,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   // Create a Message from JSON
//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       id: json['_id'],
//       chatId: json['chatId'],
//       sender: json['sender'],
//       text: json['text'],
//       image: json['image'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt: DateTime.parse(json['updatedAt']),
//     );
//   }

//   // Convert Message to JSON for sending to the server
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': id,
//       'chatId': chatId,
//       'sender': sender,
//       'text': text,
//       'image': image,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt.toIso8601String(),
//     };
//   }
// }

// // GetMessageResponse model class
// class GetMessageResponse {
//   final bool success;
//   final String message;
//   final List<Message> messages;

//   GetMessageResponse({
//     required this.success,
//     required this.message,
//     required this.messages,
//   });

//   // Parse the response JSON into GetMessageResponse
//   factory GetMessageResponse.fromJson(Map<String, dynamic> json) {
//     return GetMessageResponse(
//       success: json['success'],
//       message: json['message'],
//       messages: (json['data']['messages'] as List)
//           .map((msgJson) => Message.fromJson(msgJson))
//           .toList(),
//     );
//   }

//   get meta => null;
// }


// class Meta {
//   final int total;
//   final int limit;
//   final int page;
//   final int totalPage;

//   // Constructor for metadata that contains pagination information
//   Meta({
//     required this.total,
//     required this.limit,
//     required this.page,
//     required this.totalPage,
//   });

//   // Parse the meta data from JSON
//   factory Meta.fromJson(Map<String, dynamic> json) {
//     return Meta(
//       total: json['total'],
//       limit: json['limit'],
//       page: json['page'],
//       totalPage: json['totalPage'],
//     );
//   }
// }
