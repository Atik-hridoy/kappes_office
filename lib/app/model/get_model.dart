// import 'dart:convert';

// // Main model for the response
// class ChatResponse {
//   final bool success;
//   final String message;
//   final ChatData data;

//   ChatResponse({
//     required this.success,
//     required this.message,
//     required this.data,
//   });

//   // Factory constructor to parse the JSON data
//   factory ChatResponse.fromJson(Map<String, dynamic> json) {
//     return ChatResponse(
//       success: json['success'] as bool,
//       message: json['message'] as String,
//       data: ChatData.fromJson(json['data'] as Map<String, dynamic>),
//     );
//   }

//   // Method to convert the response to JSON
//   Map<String, dynamic> toJson() {
//     return {'success': success, 'message': message, 'data': data.toJson()};
//   }
// }

// // Model for the data part of the response (Meta and Chats)
// class ChatData {
//   final ChatMeta meta;
//   final List<Chat> chats;

//   ChatData({required this.meta, required this.chats});

//   factory ChatData.fromJson(Map<String, dynamic> json) {
//     return ChatData(
//       meta: ChatMeta.fromJson(json['meta'] as Map<String, dynamic>),
//       chats:
//           (json['chats'] as List)
//               .map((e) => Chat.fromJson(e as Map<String, dynamic>))
//               .toList(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'meta': meta.toJson(),
//       'chats': chats.map((e) => e.toJson()).toList(),
//     };
//   }
// }

// // Model for the meta data (pagination info)
// class ChatMeta {
//   final int total;
//   final int limit;
//   final int page;
//   final int totalPage;

//   ChatMeta({
//     required this.total,
//     required this.limit,
//     required this.page,
//     required this.totalPage,
//   });

//   factory ChatMeta.fromJson(Map<String, dynamic> json) {
//     return ChatMeta(
//       total: json['total'] as int,
//       limit: json['limit'] as int,
//       page: json['page'] as int,
//       totalPage: json['totalPage'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'total': total,
//       'limit': limit,
//       'page': page,
//       'totalPage': totalPage,
//     };
//   }
// }

// // Model for an individual chat
// class Chat {
//   // You can add more fields as per your actual chat data structure.
//   final String? chatId;
//   final String? sender;
//   final String? receiver;
//   final String? message;
//   final DateTime? timestamp;

//   Chat({this.chatId, this.sender, this.receiver, this.message, this.timestamp});

//   factory Chat.fromJson(Map<String, dynamic> json) {
//     return Chat(
//       chatId: json['chatId'] as String?,
//       sender: json['sender'] as String?,
//       receiver: json['receiver'] as String?,
//       message: json['message'] as String?,
//       timestamp:
//           json['timestamp'] != null
//               ? DateTime.parse(json['timestamp'] as String)
//               : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'chatId': chatId,
//       'sender': sender,
//       'receiver': receiver,
//       'message': message,
//       'timestamp': timestamp?.toIso8601String(),
//     };
//   }
// }
