import 'app_log.dart';

/// This file provides examples of how to use the enhanced logging system.
class LoggingExamples {
  /// Demonstrates all available logging methods.
  static void runAll() {
    basic();
    specialized();
    result();
    events();
    performance();
    errorHandling();
  }

  /// Example: Basic logging with different levels.
  static void basic() {
    AppLogger.info('User logged in successfully', tag: 'AUTH');
    AppLogger.warning('Network connection is slow', tag: 'NETWORK');
    AppLogger.error('Failed to load product data', tag: 'API');
    AppLogger.debug('User session token: xyz123', tag: 'AUTH');
  }

  /// Example: Specialized logging for common categories.
  static void specialized() {
    AppLogger.network('API request sent', context: {'endpoint': '/api/products'});
    AppLogger.auth('User authentication successful', context: {'userId': 'user123'});
    AppLogger.api('Product data fetched', context: {'statusCode': 200});
    AppLogger.storage('User preferences saved', context: {'key': 'theme'});
    AppLogger.ui('Button pressed: Add to Cart', context: {'screen': 'ProductDetails'});
  }

  /// Example: Logging success and failure events.
  static void result() {
    AppLogger.success('Order placed successfully', context: {'orderId': 'ORD-12345'});
    AppLogger.failure('Failed to process payment', context: {'errorCode': 'PAYMENT_DECLINED'});
  }

  /// Example: Logging specific application events.
  static void events() {
    AppLogger.data('{"userId": "123"}', description: 'User activity data');
    AppLogger.navigation('HomeScreen', 'ProductDetailsScreen', context: {'method': 'tap'});
    AppLogger.state('Cart state updated', context: {'itemCount': 4});
  }

  /// Example: Performance tracking.
  static void performance() {
    AppLogger.timeStart('Product data loading');
    // Simulate work...
    AppLogger.timeEnd('Product data loading', additionalInfo: 'Loaded 25 products');
    AppLogger.performance('Image loading completed', context: {'loadTime': '2.3s'});
  }

  /// Example: Error handling with logging.
  static void errorHandling() {
    try {
      throw Exception('Something went wrong');
    } catch (e, s) {
      AppLogger.error('Operation failed', tag: 'DATA_PROCESSING', context: {
        'error': e.toString(),
        'stackTrace': s.toString(),
      });
    }
  }
}
