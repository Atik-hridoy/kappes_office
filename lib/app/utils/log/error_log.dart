import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'app_log.dart';

/// Enhanced error logging with better styling and context
void errorLog(
  dynamic error, {
  String source = "",
  Map<String, dynamic>? context,
}) {
  try {
    if (kDebugMode) {
      // Use the enhanced logger for better formatting
      AppLogger.error(
        '🚨 ERROR OCCURRED',
        tag: 'ERROR',
        context: {
          'source': source,
          'error': error.toString(),
          'timestamp': DateTime.now().toIso8601String(),
          ...?context,
        },
        category: 'Error Handling',
      );

      // Also log to developer console for debugging
      developer.log(
        '''
╔══════════════════════════════════════════════════════════════════════════════╗
║                              🚨 ERROR DETECTED 🚨                            ║
╠══════════════════════════════════════════════════════════════════════════════╣
║ Source: $source                                                              ║
║ Error: ${error.toString()}                                                   ║
║ Time: ${DateTime.now().toIso8601String()}                                   ║
╚══════════════════════════════════════════════════════════════════════════════╝
        ''',
        name: 'ERROR_LOG',
        error: error is Error ? error : null,
      );
    }
  } catch (e) {
    // Fallback logging if the enhanced logger fails
    developer.log('Failed to log error: $e', name: 'ERROR_LOG_FALLBACK');
  }
}

/// Network error logging
void networkErrorLog(
  dynamic error, {
  String endpoint = "",
  Map<String, dynamic>? context,
}) {
  try {
    if (kDebugMode) {
      AppLogger.error(
        '🌐 NETWORK ERROR',
        tag: 'NETWORK_ERROR',
        context: {
          'endpoint': endpoint,
          'error': error.toString(),
          'timestamp': DateTime.now().toIso8601String(),
          ...?context,
        },
        category: 'Network',
      );
    }
  } catch (e) {
    developer.log(
      'Failed to log network error: $e',
      name: 'NETWORK_ERROR_LOG_FALLBACK',
    );
  }
}

/// API error logging
void apiErrorLog(
  dynamic error, {
  String endpoint = "",
  int? statusCode,
  Map<String, dynamic>? context,
}) {
  try {
    if (kDebugMode) {
      AppLogger.error(
        '🔌 API ERROR',
        tag: 'API_ERROR',
        context: {
          'endpoint': endpoint,
          'statusCode': statusCode,
          'error': error.toString(),
          'timestamp': DateTime.now().toIso8601String(),
          ...?context,
        },
        category: 'API',
      );
    }
  } catch (e) {
    developer.log(
      'Failed to log API error: $e',
      name: 'API_ERROR_LOG_FALLBACK',
    );
  }
}

/// Validation error logging
void validationErrorLog(
  String field,
  String message, {
  Map<String, dynamic>? context,
}) {
  try {
    if (kDebugMode) {
      AppLogger.warning(
        '📝 VALIDATION ERROR',
        tag: 'VALIDATION',
        context: {
          'field': field,
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
          ...?context,
        },
        category: 'Validation',
      );
    }
  } catch (e) {
    developer.log(
      'Failed to log validation error: $e',
      name: 'VALIDATION_ERROR_LOG_FALLBACK',
    );
  }
}

/// Performance error logging
void performanceErrorLog(
  String operation,
  dynamic error, {
  Map<String, dynamic>? context,
}) {
  try {
    if (kDebugMode) {
      AppLogger.error(
        '⚡ PERFORMANCE ERROR',
        tag: 'PERFORMANCE_ERROR',
        context: {
          'operation': operation,
          'error': error.toString(),
          'timestamp': DateTime.now().toIso8601String(),
          ...?context,
        },
        category: 'Performance',
      );
    }
  } catch (e) {
    developer.log(
      'Failed to log performance error: $e',
      name: 'PERFORMANCE_ERROR_LOG_FALLBACK',
    );
  }
}
