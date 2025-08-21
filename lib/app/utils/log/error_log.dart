import 'app_log.dart';

/// A utility class for logging errors with different levels of detail.
class ErrorLogger {
  /// Logs a detailed error with context, suitable for debugging.
  static void recordError(dynamic error, StackTrace stackTrace, {String? reason, Map<String, dynamic>? context}) {
    AppLogger.error(
      reason ?? 'An error occurred',
      tag: 'RECORD_ERROR',
      error: error,
      context: {
        'error': error.toString(),
        'stackTrace': stackTrace.toString(),
        if (context != null) ...context,
      },
    );
  }

  /// Logs a fatal error that has been caught in a try-catch block.
  static void logCaughtError(dynamic error, StackTrace stackTrace, {String? tag, Map<String, dynamic>? context}) {
    AppLogger.error(
      'Caught Error: ${error.toString()}',
      tag: tag ?? 'CAUGHT_ERROR',
      error: error,
      context: {
        'error': error.toString(),
        'stackTrace': stackTrace.toString(),
        if (context != null) ...context,
      },
    );
  }

  /// Logs an error specifically from an API call.
  static void apiErrorLog({required String message, String? tag, Map<String, dynamic>? context}) {
    AppLogger.error(
      message,
      tag: tag ?? 'API_ERROR',
      error: 'API_ERROR',
      context: context,
      category: 'API',
    );
  }

  /// Logs a validation error.
  static void validationLog({required String message, String? tag, Map<String, dynamic>? context}) {
    AppLogger.warning(
      message,
      tag: tag ?? 'VALIDATION',
      context: context,
      category: 'Validation',
    );
  }

  static void logError(String message, {String? tag, Map<String, dynamic>? context}) {
    AppLogger.error(
      message,
      tag: tag ?? 'ERROR',
      error: 'ERROR',
      context: context,
      category: 'Error',
    );
  }
}
