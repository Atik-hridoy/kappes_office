import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

/// Enhanced console logging system with better styling and features
class EnhancedPrinter extends LogPrinter {
  final DateFormat _timeFormat = DateFormat('HH:mm:ss.SSS');
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  // ANSI Color codes for better console styling
  static const String _reset = '\x1B[0m';
  static const String _bold = '\x1B[1m';
  static const String _dim = '\x1B[2m';
  static const String _italic = '\x1B[3m';
  static const String _underline = '\x1B[4m';

  // Color palette
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _magenta = '\x1B[35m';
  static const String _cyan = '\x1B[36m';
  static const String _white = '\x1B[37m';
  static const String _gray = '\x1B[90m';

  @override
  List<String> log(LogEvent event) {
    final time = _timeFormat.format(DateTime.now());
    final date = _dateFormat.format(DateTime.now());
    final level = event.level;

    // Parse advanced log message
    String tag = '';
    Map<String, dynamic>? context;
    String? category;
    bool isNetwork = false;
    bool isPerformance = false;
    dynamic msg = event.message;

    if (msg is EnhancedLogMessage) {
      tag = msg.tag ?? '';
      context = msg.context;
      category = msg.category;
      isNetwork = msg.isNetwork;
      isPerformance = msg.isPerformance;
      msg = msg.message;
    }

    // Get file and line information
    final fileInfo = _getFileInfo();

    // Create styled header
    final header = _createHeader(
      time,
      level,
      tag,
      category,
      fileInfo,
      isNetwork,
      isPerformance,
    );

    // Format message with proper indentation
    final formattedMessage = _formatMessage(msg.toString(), header);

    // Add context if available
    final result = [...formattedMessage];
    if (context != null && context.isNotEmpty) {
      result.addAll(_formatContext(context));
    }

    // Add footer with reset color
    result[result.length - 1] = result.last + _reset;

    return result;
  }

  String _createHeader(
    String time,
    Level level,
    String tag,
    String? category,
    String fileInfo,
    bool isNetwork,
    bool isPerformance,
  ) {
    final levelColor = _getLevelColor(level);
    final levelIcon = _getLevelIcon(level);
    final levelName = _getLevelName(level);

    // Category indicator
    String categoryIndicator = '';
    if (category != null) {
      categoryIndicator = ' $_cyan[$category]$_reset';
    }

    // Special indicators
    String specialIndicator = '';
    if (isNetwork) {
      specialIndicator = ' $_yellow[🌐 NETWORK]$_reset';
    } else if (isPerformance) {
      specialIndicator = ' $_magenta[⚡ PERFORMANCE]$_reset';
    }

    // Tag formatting
    String tagPart = '';
    if (tag.isNotEmpty) {
      tagPart = ' $_green[$tag]$_reset';
    }

    return '$levelIcon $levelColor[$time] $levelName$tagPart$categoryIndicator$specialIndicator $_gray$fileInfo$_reset';
  }

  List<String> _formatMessage(String message, String header) {
    final lines = message.split('\n');
    final result = <String>[header];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (i == 0) {
        result.add('     $_bold└─$_reset $line');
      } else {
        result.add('        $line');
      }
    }

    return result;
  }

  List<String> _formatContext(Map<String, dynamic> context) {
    final result = <String>[];
    result.add('     $_cyan[Context]:$_reset');

    context.forEach((key, value) {
      final formattedValue = _formatValue(value);
      result.add('        $_green$key:$_reset $formattedValue');
    });

    return result;
  }

  String _formatValue(dynamic value) {
    if (value is Map) {
      return '$_yellow{${value.toString()}}$_reset';
    } else if (value is List) {
      return '$_yellow[${value.toString()}]$_reset';
    } else if (value is String) {
      return '$_white"$value"$_reset';
    } else {
      return '$_white$value$_reset';
    }
  }

  String _getFileInfo() {
    try {
      final trace = StackTrace.current.toString().split('\n');
      for (final line in trace) {
        if (line.contains('/lib/') &&
            !line.contains('logger.dart') &&
            !line.contains('app_log.dart')) {
          final match = RegExp(r'(\w+\.dart):(\d+)').firstMatch(line);
          if (match != null) {
            final fileName = match.group(1)!;
            final lineNumber = match.group(2)!;
            return 'at $fileName:$lineNumber';
          }
        }
      }
    } catch (e) {
      // Ignore file info errors
    }
    return 'at unknown location';
  }

  String _getLevelColor(Level level) {
    switch (level) {
      case Level.error:
        return _red;
      case Level.warning:
        return _yellow;
      case Level.info:
        return _cyan;
      case Level.debug:
        return _blue;
      case Level.trace:
        return _green;
      default:
        return _white;
    }
  }

  String _getLevelIcon(Level level) {
    switch (level) {
      case Level.error:
        return '🚨';
      case Level.warning:
        return '⚠️';
      case Level.info:
        return 'ℹ️';
      case Level.debug:
        return '🔍';
      case Level.trace:
        return '🔎';
      default:
        return '📝';
    }
  }

  String _getLevelName(Level level) {
    final name = level.toString().split('.').last.toUpperCase();
    return '$_bold[$name]$_reset';
  }
}

/// Enhanced log message with additional metadata
class EnhancedLogMessage {
  final String? tag;
  final dynamic message;
  final Map<String, dynamic>? context;
  final String? category;
  final bool isNetwork;
  final bool isPerformance;

  EnhancedLogMessage(
    this.message, {
    this.tag,
    this.context,
    this.category,
    this.isNetwork = false,
    this.isPerformance = false,
  });
}

/// Enhanced logger with better organization and features
class AppLogger {
  static final Logger _logger = Logger(
    printer: EnhancedPrinter(),
    level: Level.debug,
  );

  // Basic logging methods
  static void info(
    dynamic message, {
    String? tag,
    Map<String, dynamic>? context,
    String? category,
  }) {
    _logger.i(
      EnhancedLogMessage(
        message,
        tag: tag,
        context: context,
        category: category,
      ),
    );
  }

  static void warning(
    dynamic message, {
    String? tag,
    Map<String, dynamic>? context,
    String? category,
  }) {
    _logger.w(
      EnhancedLogMessage(
        message,
        tag: tag,
        context: context,
        category: category,
      ),
    );
  }

  static void error(
    dynamic message, {
    String? tag,
    Map<String, dynamic>? context,
    String? category,
  }) {
    _logger.e(
      EnhancedLogMessage(
        message,
        tag: tag,
        context: context,
        category: category,
      ),
    );
  }

  static void debug(
    dynamic message, {
    String? tag,
    Map<String, dynamic>? context,
    String? category,
  }) {
    _logger.d(
      EnhancedLogMessage(
        message,
        tag: tag,
        context: context,
        category: category,
      ),
    );
  }

  static void verbose(
    dynamic message, {
    String? tag,
    Map<String, dynamic>? context,
    String? category,
  }) {
    _logger.v(
      EnhancedLogMessage(
        message,
        tag: tag,
        context: context,
        category: category,
      ),
    );
  }

  // Specialized logging methods
  static void network(String message, {Map<String, dynamic>? context}) {
    _logger.i(
      EnhancedLogMessage(
        message,
        tag: 'NETWORK',
        context: context,
        isNetwork: true,
      ),
    );
  }

  static void performance(String message, {Map<String, dynamic>? context}) {
    _logger.i(
      EnhancedLogMessage(
        message,
        tag: 'PERFORMANCE',
        context: context,
        isPerformance: true,
      ),
    );
  }

  static void auth(String message, {Map<String, dynamic>? context}) {
    _logger.i(
      EnhancedLogMessage(
        message,
        tag: 'AUTH',
        context: context,
        category: 'Authentication',
      ),
    );
  }

  static void api(String message, {Map<String, dynamic>? context}) {
    _logger.i(
      EnhancedLogMessage(
        message,
        tag: 'API',
        context: context,
        category: 'API',
      ),
    );
  }

  static void storage(String message, {Map<String, dynamic>? context}) {
    _logger.i(
      EnhancedLogMessage(
        message,
        tag: 'STORAGE',
        context: context,
        category: 'Local Storage',
      ),
    );
  }

  static void ui(String message, {Map<String, dynamic>? context}) {
    _logger.i(
      EnhancedLogMessage(
        message,
        tag: 'UI',
        context: context,
        category: 'User Interface',
      ),
    );
  }

  // Performance tracking
  static void timeStart(String operation) {
    developer.log('⏱️  START: $operation', name: 'PERFORMANCE');
  }

  static void timeEnd(String operation, {String? additionalInfo}) {
    developer.log(
      '⏱️  END: $operation${additionalInfo != null ? ' - $additionalInfo' : ''}',
      name: 'PERFORMANCE',
    );
  }

  // Success and failure logging
  static void success(String message, {Map<String, dynamic>? context}) {
    _logger.i(
      EnhancedLogMessage('✅ $message', tag: 'SUCCESS', context: context),
    );
  }

  static void failure(String message, {Map<String, dynamic>? context}) {
    _logger.e(
      EnhancedLogMessage('❌ $message', tag: 'FAILURE', context: context),
    );
  }

  // Data logging
  static void data(
    String data, {
    String? description,
    Map<String, dynamic>? context,
  }) {
    final message = description != null ? '$description: $data' : data;
    _logger.d(
      EnhancedLogMessage(
        message,
        tag: 'DATA',
        context: context,
        category: 'Data',
      ),
    );
  }

  // Navigation logging
  static void navigation(
    String from,
    String to, {
    Map<String, dynamic>? context,
  }) {
    _logger.i(
      EnhancedLogMessage(
        '🔄 $from → $to',
        tag: 'NAVIGATION',
        context: context,
        category: 'Navigation',
      ),
    );
  }

  // State management logging
  static void state(String state, {Map<String, dynamic>? context}) {
    _logger.d(
      EnhancedLogMessage(
        '🔄 State: $state',
        tag: 'STATE',
        context: context,
        category: 'State Management',
      ),
    );
  }
}
