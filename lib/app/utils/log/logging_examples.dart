import 'app_log.dart';

/// Examples of how to use the enhanced logging system
/// This file demonstrates best practices for logging in the Canuck Mall app

class LoggingExamples {
  /// Example: Basic logging
  static void basicLoggingExample() {
    AppLogger.info('User logged in successfully');
    AppLogger.warning('Network connection is slow');
    AppLogger.error('Failed to load product data');
    AppLogger.debug('Processing user input');
  }

  /// Example: Tagged logging
  static void taggedLoggingExample() {
    AppLogger.info('Processing payment', tag: 'PAYMENT');
    AppLogger.error('Payment failed', tag: 'PAYMENT');
    AppLogger.debug('Validating user input', tag: 'VALIDATION');
  }

  /// Example: Context logging
  static void contextLoggingExample() {
    AppLogger.info(
      'Product added to cart',
      tag: 'CART',
      context: {
        'productId': '12345',
        'productName': 'Canadian Maple Syrup',
        'price': 29.99,
        'quantity': 2,
      },
    );
  }

  /// Example: Category logging
  static void categoryLoggingExample() {
    AppLogger.info(
      'User profile updated',
      tag: 'PROFILE',
      category: 'User Management',
      context: {
        'userId': 'user123',
        'updatedFields': ['name', 'email'],
      },
    );
  }

  /// Example: Specialized logging methods
  static void specializedLoggingExample() {
    // Network operations
    AppLogger.network(
      'API request sent',
      context: {
        'endpoint': '/api/products',
        'method': 'GET',
        'responseTime': '150ms',
      },
    );

    // Performance tracking
    AppLogger.performance(
      'Image loading completed',
      context: {
        'imageUrl': 'https://example.com/image.jpg',
        'loadTime': '2.3s',
        'cacheHit': true,
      },
    );

    // Authentication
    AppLogger.auth(
      'User authentication successful',
      context: {
        'userId': 'user123',
        'authMethod': 'email',
        'sessionDuration': '24h',
      },
    );

    // API calls
    AppLogger.api(
      'Product data fetched',
      context: {
        'endpoint': '/api/products/123',
        'statusCode': 200,
        'responseSize': '2.5KB',
      },
    );

    // Local storage
    AppLogger.storage(
      'User preferences saved',
      context: {
        'key': 'user_preferences',
        'dataSize': '1.2KB',
        'operation': 'write',
      },
    );

    // UI interactions
    AppLogger.ui(
      'Button pressed: Add to Cart',
      context: {
        'screen': 'ProductDetails',
        'buttonId': 'add_to_cart_btn',
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Example: Success and failure logging
  static void successFailureLoggingExample() {
    // Success scenarios
    AppLogger.success(
      'Order placed successfully',
      context: {
        'orderId': 'ORD-12345',
        'totalAmount': 149.99,
        'paymentMethod': 'credit_card',
      },
    );

    // Failure scenarios
    AppLogger.failure(
      'Failed to process payment',
      context: {
        'errorCode': 'PAYMENT_DECLINED',
        'amount': 149.99,
        'cardType': 'visa',
      },
    );
  }

  /// Example: Data logging
  static void dataLoggingExample() {
    AppLogger.data(
      '{"userId": "123", "action": "login", "timestamp": "2024-01-15T10:30:00Z"}',
      description: 'User activity data',
      context: {'dataType': 'user_activity', 'size': '256 bytes'},
    );
  }

  /// Example: Navigation logging
  static void navigationLoggingExample() {
    AppLogger.navigation(
      'HomeScreen',
      'ProductDetailsScreen',
      context: {
        'productId': '12345',
        'navigationMethod': 'tap',
        'previousScreen': 'HomeScreen',
      },
    );
  }

  /// Example: State management logging
  static void stateLoggingExample() {
    AppLogger.state(
      'Cart state updated',
      context: {
        'previousItemCount': 3,
        'newItemCount': 4,
        'totalValue': 199.99,
        'trigger': 'add_item',
      },
    );
  }

  /// Example: Performance tracking
  static void performanceTrackingExample() {
    // Start timing an operation
    AppLogger.timeStart('Product data loading');

    // Simulate some work
    // await loadProductData();

    // End timing with additional info
    AppLogger.timeEnd(
      'Product data loading',
      additionalInfo: 'Loaded 25 products in 1.2s',
    );
  }

  /// Example: Error handling with logging
  static void errorHandlingExample() {
    try {
      // Simulate an operation that might fail
      // await riskyOperation();
    } catch (error) {
      AppLogger.error(
        'Operation failed',
        tag: 'OPERATION',
        context: {
          'operation': 'riskyOperation',
          'error': error.toString(),
          'stackTrace': error.toString(),
        },
        category: 'Error Handling',
      );
    }
  }

  /// Example: Network request logging
  static void networkRequestExample() {
    // Before making request
    AppLogger.network(
      'Making API request',
      context: {
        'url': 'https://api.canuckmall.com/products',
        'method': 'GET',
        'headers': {'Authorization': 'Bearer token123'},
      },
    );

    // After successful response
    AppLogger.network(
      'API request successful',
      context: {
        'url': 'https://api.canuckmall.com/products',
        'statusCode': 200,
        'responseTime': '450ms',
        'responseSize': '15.2KB',
      },
    );
  }

  /// Example: User interaction logging
  static void userInteractionExample() {
    AppLogger.info(
      'User interaction: Product search',
      tag: 'USER_INTERACTION',
      context: {
        'action': 'search',
        'query': 'maple syrup',
        'resultsCount': 12,
        'screen': 'SearchScreen',
        'timestamp': DateTime.now().toIso8601String(),
      },
      category: 'User Experience',
    );
  }
}

/// Usage examples in controllers and services
class LoggingUsageExamples {
  /// Example usage in a controller
  static void controllerExample() {
    // In a login controller
    AppLogger.auth(
      'Login attempt',
      context: {'email': 'user@example.com', 'method': 'email_password'},
    );

    // In a product controller
    AppLogger.info(
      'Product loaded',
      tag: 'PRODUCT',
      context: {'productId': '12345', 'loadTime': '1.2s', 'fromCache': false},
    );
  }

  /// Example usage in network services
  static void networkServiceExample() {
    // In API service
    AppLogger.api(
      'GET /api/products',
      context: {
        'endpoint': '/api/products',
        'method': 'GET',
        'statusCode': 200,
        'responseTime': '300ms',
      },
    );
  }

  /// Example usage in storage services
  static void storageServiceExample() {
    // In local storage service
    AppLogger.storage(
      'User data saved',
      context: {
        'key': 'user_profile',
        'dataSize': '2.1KB',
        'operation': 'write',
      },
    );
  }
}
