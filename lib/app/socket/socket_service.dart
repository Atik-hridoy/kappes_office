import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:get/get.dart';
import '../constants/app_urls.dart';

class SocketService extends GetxService {
  late IO.Socket socket;
  static final SocketService _instance = SocketService._internal();
  
  factory SocketService() => _instance;
  SocketService._internal() {
    initSocket();
  }

  @override
  void onInit() {
    super.onInit();
    // Socket is already initialized in constructor
  }

  void initSocket() {
    socket = IO.io(AppUrls.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Socket events
    socket.onConnect((_) {
      print('✅ Connected to socket: ${AppUrls.socketUrl}');
    });

    socket.onDisconnect((_) {
      print('❌ Disconnected from socket');
    });

    socket.onConnectError((err) {
      print('🔥 Socket Connect Error: $err');
    });

    socket.onError((err) {
      print('🔥 Socket Error: $err');
    });
  }

  // Join a chat room
  void joinChat(String chatId) {
    socket.emit('joinChat', {'chatId': chatId});
    print('📝 Joined chat room: $chatId');
  }

  // Leave a chat room
  void leaveChat(String chatId) {
    socket.emit('leaveChat', {'chatId': chatId});
    print('📝 Left chat room: $chatId');
  }

  // Listen for new messages
  void onNewMessage(Function(dynamic data) callback) {
    socket.on('newMessage', callback);
  }

  // Stop listening for new messages
  void offNewMessage() {
    socket.off('newMessage');
  }

  // Listen for specific chat messages (like getMessage::68)
  void onChatMessage(String chatId, Function(dynamic data) callback) {
    socket.on('getMessage::$chatId', callback);
    print('📡 Listening to getMessage::$chatId');
  }

  // Stop listening for specific chat messages
  void offChatMessage(String chatId) {
    socket.off('getMessage::$chatId');
    print('🛑 Stopped listening to getMessage::$chatId');
  }

  // Send message through socket
  void sendMessage({
    required String chatId,
    required String text,
    required String senderId,
  }) {
    final messageData = {
      'chatId': chatId,
      'text': text,
      'sender': senderId,
      'createdAt': DateTime.now().toIso8601String(),
    };
    
    socket.emit('sendMessage', messageData);
    print('📤 Message sent to $chatId');
  }

  // General emit method
  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  // General on method
  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  // General off method
  void off(String event) {
    socket.off(event);
  }

  // Check connection status
  bool get isConnected => socket.connected;

  // Get socket ID
  String? get socketId => socket.id;

  @override
  void onClose() {
    if (socket.connected) {
      socket.disconnect();
    }
    socket.dispose();
    print('🔌 Socket service closed');
    super.onClose();
  }
}
