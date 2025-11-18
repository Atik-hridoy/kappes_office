
import 'dart:convert';
import 'dart:io';

import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:dio/dio.dart';
import 'package:canuck_mall/app/utils/app_utils.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/model/message_and_chat/create_messages.dart';
import 'package:path/path.dart' as p;

class CreateMessageService {
  final Dio dio;

  CreateMessageService() : dio = Dio();

  // Method to send the message
  Future<SendMessageResponse> sendMessage({
    required String chatId,
    required String text,
    File? image,
  }) async {
    try {
      final payload = jsonEncode({
        'chatId': chatId,
        'text': text,
      });

      final formData = FormData.fromMap({
        'data': payload,
        if (image != null)
          'image': await MultipartFile.fromFile(
            image.path,
            filename: p.basename(image.path),
          ),
      });

      final response = await dio.post(
        '${AppUrls.baseUrl}${AppUrls.createMessage}',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${LocalStorage.token}',
            'Accept': 'application/json',
          },
          contentType: 'multipart/form-data',
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
    } on DioException catch (e) {
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
