
import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/utils/app_utils.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/model/message_and_chat/create_messages.dart';

class CreateMessageService {
  final Dio dio;

  CreateMessageService() : dio = Dio();

  // Method to send the message
  Future<SendMessageResponse> sendMessage(
      String chatId, String messageText, List<String> participantIds) async {
    try {
      // Prepare the data to send
      final data = {
        'chatId': chatId,
        'sender': LocalStorage.userId,  // Use the current user's ID
        'text': messageText,
        'participantIds': participantIds, // Adding multiple participants
      };

      final response = await dio.post(
        AppUrls.createMessage,  // Your API URL for creating messages
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${LocalStorage.token}',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return SendMessageResponse.fromJson(response.data);
      } else {
        AppUtils.showError('Failed to send message');
        return SendMessageResponse(
          success: false,
          message: 'Failed to send message',
          data: MessageData(
            chatId: '',
            sender: '',
            text: '',
            id: '',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
      }
    } on DioError catch (e) {
      AppUtils.showError('DioError: ${e.message}');
      return SendMessageResponse(
        success: false,
        message: 'Failed to send message',
        data: MessageData(
          chatId: '',
          sender: '',
          text: '',
          id: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      AppUtils.showError('Error: ${e.toString()}');
      return SendMessageResponse(
        success: false,
        message: 'Failed to send message',
        data: MessageData(
          chatId: '',
          sender: '',
          text: '',
          id: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    }
  }
}
