import 'package:dio/dio.dart';

class AuthErrorHandler {
  /// Handles authentication related errors and returns a user-friendly message
  static String handleError(dynamic error) {
    // Handle Dio errors
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet connection and try again.';
          
        case DioExceptionType.badResponse:
          if (error.response?.statusCode == 401) {
            return 'The email or password you entered is incorrect. Please try again.';
          } else if (error.response?.statusCode == 404) {
            return 'The requested service is currently unavailable. Please try again later.';
          } else if (error.response?.statusCode == 500) {
            return 'An internal server error occurred. Please try again later.';
          } else if (error.response?.statusCode == 400) {
            return _extractErrorMessage(error.response?.data) ?? 'Invalid request. Please check your input and try again.';
          } else {
            return _extractErrorMessage(error.response?.data) ?? 'An error occurred. Please try again.';
          }
          
        case DioExceptionType.cancel:
          return 'Request was cancelled';
          
        case DioExceptionType.connectionError:
          return 'No internet connection. Please check your network settings.';
          
        default:
          return 'An unexpected error occurred. Please try again.';
      }
    }
    
    // Handle string errors
    if (error is String) {
      final errorLower = error.toLowerCase();
      if (errorLower.contains('socket') || 
          errorLower.contains('network') || 
          errorLower.contains('connection')) {
        return 'No internet connection. Please check your network settings.';
      }
      return error;
    }
    
    // Default error message
    return 'An unexpected error occurred. Please try again.';
  }
  
  /// Extracts error message from response data
  static String? _extractErrorMessage(dynamic data) {
    try {
      if (data is Map) {
        return data['message']?.toString() ?? 
               data['error']?.toString() ??
               'An error occurred';
      } else if (data is String) {
        return data;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
