# Enhanced Logging System for Canuck Mall

This directory contains the enhanced logging system for the Canuck Mall Flutter application. The system provides structured, colorful, and informative console output for better debugging and monitoring.

## 🎨 Features

### **Enhanced Console Output**
- **Color-coded log levels** with ANSI colors
- **Emojis and icons** for quick visual identification
- **Structured formatting** with proper indentation
- **File and line information** for easy debugging
- **Context data** with key-value pairs
- **Categories and tags** for better organization

### **Specialized Logging Methods**
- **Network logging** with 🌐 indicator
- **Performance tracking** with ⚡ indicator
- **Authentication logging** with 🔐 context
- **API logging** with 🔌 context
- **Storage logging** with 💾 context
- **UI logging** with 🎨 context

### **Performance Features**
- **Timing operations** with start/end tracking
- **Success/failure indicators** with ✅/❌
- **Data logging** with structured format
- **Navigation tracking** with 🔄 arrows
- **State management** with 🔄 indicators

## 📝 Usage Examples

### Basic Logging
```dart
import 'package:canuck_mall/app/utils/log/app_log.dart';

// Basic logging
AppLogger.info('User logged in successfully');
AppLogger.warning('Network connection is slow');
AppLogger.error('Failed to load product data');
AppLogger.debug('Processing user input');
```

### Tagged Logging
```dart
// With tags for better organization
AppLogger.info('Processing payment', tag: 'PAYMENT');
AppLogger.error('Payment failed', tag: 'PAYMENT');
AppLogger.debug('Validating user input', tag: 'VALIDATION');
```

### Context Logging
```dart
// With additional context data
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
```

### Specialized Methods
```dart
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
```

### Success and Failure Logging
```dart
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
```

### Performance Tracking
```dart
// Start timing an operation
AppLogger.timeStart('Product data loading');

// Simulate some work
await loadProductData();

// End timing with additional info
AppLogger.timeEnd(
  'Product data loading',
  additionalInfo: 'Loaded 25 products in 1.2s',
);
```

### Navigation Logging
```dart
AppLogger.navigation(
  'HomeScreen',
  'ProductDetailsScreen',
  context: {
    'productId': '12345',
    'navigationMethod': 'tap',
    'previousScreen': 'HomeScreen',
  },
);
```

## 🎯 Log Levels

| Level | Icon | Color | Usage |
|-------|------|-------|-------|
| **ERROR** | 🚨 | Red | Critical errors and failures |
| **WARNING** | ⚠️ | Yellow | Potential issues and warnings |
| **INFO** | ℹ️ | Cyan | General information and events |
| **DEBUG** | 🔍 | Blue | Detailed debugging information |
| **TRACE** | 🔎 | Green | Very detailed tracing |

## 🏷️ Special Indicators

| Indicator | Description | Usage |
|-----------|-------------|-------|
| 🌐 **NETWORK** | Network operations | API calls, requests, responses |
| ⚡ **PERFORMANCE** | Performance tracking | Timing, metrics, optimization |
| 🔐 **AUTH** | Authentication | Login, logout, token management |
| 🔌 **API** | API operations | Endpoint calls, responses |
| 💾 **STORAGE** | Local storage | Data persistence, caching |
| 🎨 **UI** | User interface | Screen changes, interactions |

## 📊 Console Output Format

The enhanced logging system produces structured output like this:

```
ℹ️ [14:30:25.123] [INFO] [AUTH] [Authentication] at login_controller.dart:45
     └─ Login attempt initiated
     Context:
        email: user@example.com
        rememberMe: true

🌐 [14:30:26.456] [INFO] [NETWORK] [🌐 NETWORK] at api_service.dart:23
     └─ API request sent
     Context:
        endpoint: /api/auth/login
        method: POST
        responseTime: 150ms
```

## 🔧 Configuration

### Log Level
Set the default log level in `app_log.dart`:

```dart
static final Logger _logger = Logger(
  printer: EnhancedPrinter(),
  level: Level.debug, // Change this to control verbosity
);
```

### Available Levels
- `Level.trace` - Most verbose
- `Level.debug` - Debug information
- `Level.info` - General information
- `Level.warning` - Warnings
- `Level.error` - Errors only

## 🚀 Best Practices

### 1. **Use Appropriate Tags**
```dart
// Good
AppLogger.info('User logged in', tag: 'AUTH');
AppLogger.error('Payment failed', tag: 'PAYMENT');

// Avoid
AppLogger.info('User logged in'); // No tag
```

### 2. **Include Relevant Context**
```dart
// Good
AppLogger.error(
  'API request failed',
  context: {
    'endpoint': '/api/products',
    'statusCode': 500,
    'error': 'Internal server error',
  },
);

// Avoid
AppLogger.error('API request failed'); // No context
```

### 3. **Use Specialized Methods**
```dart
// Good - Use specialized method
AppLogger.network('API request sent', context: {...});

// Avoid - Use generic method
AppLogger.info('API request sent', context: {...});
```

### 4. **Performance Tracking**
```dart
// Good - Track performance
AppLogger.timeStart('Data loading');
await loadData();
AppLogger.timeEnd('Data loading', additionalInfo: 'Loaded 100 items');

// Avoid - No performance tracking
await loadData();
```

### 5. **Error Handling**
```dart
// Good - Comprehensive error logging
try {
  await riskyOperation();
} catch (error) {
  AppLogger.error(
    'Operation failed',
    tag: 'OPERATION',
    context: {
      'operation': 'riskyOperation',
      'error': error.toString(),
    },
  );
}
```

## 📁 File Structure

```
lib/app/utils/log/
├── app_log.dart              # Main logging system
├── error_log.dart            # Error logging utilities
├── logging_examples.dart     # Usage examples
└── README.md                 # This file
```

## 🔄 Migration from Old Logging

### Before (Old Style)
```dart
print('🚀 Sending login request for $email...');
print('✅ Login API response: $data');
print('❌ Login failed: $errorMessage');
```

### After (New Style)
```dart
AppLogger.auth('Login attempt initiated', context: {'email': email});
AppLogger.auth('Login API response received', context: {'success': true});
AppLogger.failure('Login failed', context: {'errorMessage': errorMessage});
```

## 🎨 Customization

### Adding New Specialized Methods
```dart
// In app_log.dart, add new methods
static void database(String message, {Map<String, dynamic>? context}) {
  _logger.i(EnhancedLogMessage(message, tag: 'DATABASE', context: context, category: 'Database'));
}

static void cache(String message, {Map<String, dynamic>? context}) {
  _logger.i(EnhancedLogMessage(message, tag: 'CACHE', context: context, category: 'Cache'));
}
```

### Custom Colors and Icons
Modify the `_getLevelColor()` and `_getLevelIcon()` methods in `EnhancedPrinter` class.

## 📈 Benefits

1. **Better Debugging** - Structured, colorful output makes debugging easier
2. **Performance Monitoring** - Built-in timing and performance tracking
3. **Error Tracking** - Comprehensive error logging with context
4. **Development Efficiency** - Quick visual identification of log types
5. **Production Ready** - Can be easily configured for production environments
6. **Consistent Formatting** - Standardized log format across the application

## 🔍 Troubleshooting

### Logs Not Appearing
- Check if `kDebugMode` is true

- Verify log level is set appropriately
- Ensure logger is properly imported

### Colors Not Showing
- Check if your terminal supports ANSI colors
- Some IDEs may not display colors properly
- Colors are automatically disabled in production builds

### Performance Issues
- Use appropriate log levels in production
- Consider disabling verbose logging in release builds
- Monitor log output size in production environments 