import 'package:get/get.dart';
import 'socket_service.dart';
import '../model/message_and_chat/get_message.dart';

class MessageSocketController extends GetxController {
  final SocketService _socketService = SocketService();
  
  RxList<Message> newMessages = <Message>[].obs;
  RxBool isTyping = false.obs;
  RxString typingUser = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    // Listen for new messages
    _socketService.onNewMessage((data) {
      _handleNewMessage(data);
    });

    // Listen for typing indicators
    _socketService.on('userTyping', (data) {
      if (data['chatId'] == currentChatId) {
        isTyping.value = true;
        typingUser.value = data['userName'] ?? 'Someone';
      }
    });

    _socketService.on('userStopTyping', (data) {
      if (data['chatId'] == currentChatId) {
        isTyping.value = false;
        typingUser.value = '';
      }
    });
  }

  void joinChatRoom(String chatId) {
    _socketService.joinChat(chatId);
    _socketService.onChatMessage(chatId, (data) {
      _handleChatMessage(data);
    });
  }

  void leaveChatRoom(String chatId) {
    _socketService.leaveChat(chatId);
    _socketService.offChatMessage(chatId);
  }

  void _handleNewMessage(dynamic data) {
    try {
      print('🔍 Raw newMessage data: $data');

      // Normalize to Map<String, dynamic>
      final Map<String, dynamic> json =
          data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data);

      final message = Message(
        id: json['_id'] ?? '',
        text: json['text'] ?? '',
        sender: json['sender'] ?? '',
        chatId: json['chatId'] ?? '',
        createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          json['updatedAt'] ?? DateTime.now().toIso8601String(),
        ),
        v: json['__v'] ?? 0,
      );

      newMessages.add(message);
      update();

      print('📨 New message received via socket: ${message.text}');
    } catch (e, st) {
      print('❌ Error parsing socket message: $e');
      print(st);
    }
  }

  void _handleChatMessage(dynamic data) {
    try {
      print('🔍 Raw chatMessage data: $data');

      final Map<String, dynamic> json =
          data is Map<String, dynamic> ? data : Map<String, dynamic>.from(data);

      final message = Message(
        id: json['_id'] ?? '',
        text: json['text'] ?? '',
        sender: json['sender'] ?? '',
        chatId: json['chatId'] ?? '',
        createdAt: DateTime.parse(
          json['createdAt'] ?? DateTime.now().toIso8601String(),
        ),
        updatedAt: DateTime.parse(
          json['updatedAt'] ?? DateTime.now().toIso8601String(),
        ),
        v: json['__v'] ?? 0,
      );

      newMessages.add(message);
      update();

      print('📨 Chat message received for ${json['chatId']}: ${message.text}');
    } catch (e, st) {
      print('❌ Error parsing chat message: $e');
      print(st);
    }
  }

  void sendMessage({
    required String chatId,
    required String text,
    required String senderId,
  }) {
    _socketService.sendMessage(
      chatId: chatId,
      text: text,
      senderId: senderId,
    );
  }

  void sendTypingIndicator(String chatId, String userName) {
    _socketService.emit('userTyping', {
      'chatId': chatId,
      'userName': userName,
    });
  }

  void sendStopTypingIndicator(String chatId) {
    _socketService.emit('userStopTyping', {'chatId': chatId});
  }

  // Clear new messages after they're processed
  void clearNewMessages() {
    newMessages.clear();
  }

  // Get current chat ID (this should be set from the chatting view controller)
  String? currentChatId;

  void setCurrentChatId(String chatId) {
    currentChatId = chatId;
  }

  // Check if socket is connected
  bool get isConnected => _socketService.isConnected;

  @override
  void onClose() {
    _socketService.offNewMessage();
    _socketService.off('userTyping');
    _socketService.off('userStopTyping');
    super.onClose();
  }
}
