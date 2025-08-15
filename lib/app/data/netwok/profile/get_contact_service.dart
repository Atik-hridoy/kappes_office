import 'package:canuck_mall/app/constants/app_urls.dart';
import 'package:canuck_mall/app/data/local/storage_service.dart';
import 'package:canuck_mall/app/model/contact_model.dart';
import 'package:canuck_mall/app/utils/log/app_log.dart';
import 'package:dio/dio.dart';

class ContactService {
  final Dio _dio = Dio();

  // Method to get contact details with headers and data
  Future<ContactResponse> getContact(Map<String, dynamic> requestBody) async {
    final String url = '${AppUrls.baseUrl}${AppUrls.getContact}';
    final token = LocalStorage.token;

    try {
      AppLogger.info('📦 GET contacts: $url');
      AppLogger.info(
        '🔑 Token: ${token.isNotEmpty ? 'present (${token.substring(0, 8)}...)' : 'missing'}',
      );
      AppLogger.info('🔍 Query params: $requestBody');

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
        queryParameters: requestBody,
      );

      AppLogger.info('📥 Contacts GET Status: ${response.statusCode}');
      AppLogger.info('📥 Contacts GET Data: ${response.data}');

      if (response.statusCode == 200) {
        return ContactResponse.fromJson(response.data);
      } else if (response.statusCode == 401) {
        AppLogger.warning('🔒 Unauthorized (401) for contacts endpoint');
        throw Exception('Unauthorized. Please log in again.');
      } else {
        AppLogger.error(
          '❌ Failed to load contacts: ${response.statusCode} ${response.data}',
          tag: 'ContactService',
          error: 'Failed to load contacts',
        );
        throw Exception('Failed to load contacts');
      }
    } on DioException catch (e) {
      AppLogger.error(
        '🌐 Dio error while fetching contacts: ${e.message}',
        tag: 'ContactService',
        error: 'DioException: ${e.type}, response: ${e.response?.data}',
      );
      throw Exception('Network error fetching contacts: ${e.message}');
    } catch (e) {
      AppLogger.error(
        '💥 Unexpected error fetching contacts: $e',
        tag: 'ContactService',
        error: 'Unexpected error: $e',
      );
      throw Exception('Error fetching contacts: $e');
    }
  }
}