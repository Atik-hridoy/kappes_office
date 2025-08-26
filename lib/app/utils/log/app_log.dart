// ignore_for_file: unused_field

import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import 'package:stack_trace/stack_trace.dart';

/// Enhanced console logging system with better styling and features
class EnhancedPrinter extends LogPrinter {
  final DateFormat _timeFormat = DateFormat('HH:mm:ss.SSS');
  final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');

  static const String _reset = '\x1B[0m';
  static const String _bold = '\x1B[1m';
  static const String _dim = '\x1B[2m';
  static const String _cyan = '\x1B[36m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _red = '\x1B[31m';
  static const String _white = '\x1B[37m';
  static const String _gray = '\x1B[90m';

  @override
  List<String> log(LogEvent event) {
    final time = _timeFormat.format(DateTime.now());
    dynamic msg = event.message;

    // Extract EnhancedLogMessage properties
    final msgData = msg is EnhancedLogMessage ? msg : EnhancedLogMessage(msg);
    
    final header = _createHeader(time, event.level, msgData);
    final formattedMessage = _formatMessage(msgData.message.toString(), header);

    final result = <String>[...formattedMessage];
    if (msgData.context?.isNotEmpty ?? false) {
      result.addAll(_formatContext(msgData.context!));
    }

    result.last += _reset;
    return result;
  }

  String _createHeader(String time, Level level, EnhancedLogMessage msgData) {
    final levelColor = _getLevelColor(level);
    final levelIcon = _getLevelIcon(level);
    final levelName = _getLevelName(level);
    final fileInfo = _getFileInfo(msgData.stackTrace);

    final categoryIndicator = msgData.category != null
        ? ' $_cyan[${msgData.category}]$_reset'
        : '';
    final specialIndicator = msgData.isNetwork
        ? ' $_yellow[🌐 NETWORK]$_reset'
        : msgData.isPerformance
            ? ' $_blue[⚡ PERFORMANCE]$_reset'
            : '';
    final tagPart = msgData.tag?.isNotEmpty == true
        ? ' $_green[${msgData.tag}]$_reset'
        : '';

    return '$levelIcon $levelColor[$time] $levelName$tagPart$categoryIndicator$specialIndicator $_gray$fileInfo$_reset';
  }

  List<String> _formatMessage(String message, String header) {
    const prefix = '├─ >>>   ';
    final lines = message.split('\n');
    final result = <String>[header];

    for (int i = 0; i < lines.length; i++) {
      result.add(i == 0 ? '     $prefix${lines[i]}' : '        $prefix${lines[i]}');
    }
    return result;
  }

  List<String> _formatContext(Map<String, dynamic> context) {
    final result = <String>['     $_cyan[Context]:$_reset'];

    context.forEach((key, value) {
      result.add('        $_green$key:$_reset ${_formatValue(value)}');
    });
    return result;
  }

  String _formatValue(dynamic value) {
    if (value is Map) return '$_yellow{${value.toString()}}$_reset';
    if (value is List) return '$_yellow[${value.toString()}]$_reset';
    if (value is String) return '$_white"$value"$_reset';
    return '$_white$value$_reset';
  }

  String _getFileInfo(StackTrace? stackTrace) {
    if (stackTrace == null) return 'at unknown location';

    try {
      final trace = Trace.parse(stackTrace.toString());
      final frame = trace.frames.firstWhere(
        (f) => !f.uri.path.endsWith('logger.dart') && !f.uri.path.endsWith('app_log.dart'),
        orElse: () => trace.frames.first,
      );
      return 'at ${frame.uri.pathSegments.last}:${frame.line}';
    } catch (_) {
      return 'at unknown location';
    }
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
      case Level.error: return '🚨';
      case Level.warning: return '⚠️';
      case Level.info: return 'ℹ️';
      case Level.debug: return '🔍';
      case Level.trace: return '🔎';
      default: return '📝';
    }
  }

  String _getLevelName(Level level) {
    return '$_bold[${level.toString().split('.').last.toUpperCase()}]$_reset';
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
  final StackTrace? stackTrace;

  EnhancedLogMessage(
    this.message, {
    this.tag,
    this.context,
    this.category,
    this.isNetwork = false,
    this.isPerformance = false,
    this.stackTrace,
  });
}

/// Enhanced logger with better organization and features
class AppLogger {
  static final Logger _logger = Logger(
    printer: EnhancedPrinter(),
    level: Level.debug,
  );

  static void info(dynamic message, {String? tag, Map<String, dynamic>? context, String? category}) {
    _log(Level.info, message, tag, context, category);
  }
  static void state(dynamic message, {String? tag, Map<String, dynamic>? context, String? category}) {
    _log(Level.info, '📱 $message', 'STATE', context, 'State');
  } 
  static void network(dynamic message, {String? tag, Map<String, dynamic>? context, String? category}) {
    _log(Level.info, '🌐 $message', 'NETWORK', context, 'Network');
  }
  static void ui(dynamic message, {String? tag, Map<String, dynamic>? context, String? category}) {
    _log(Level.info, '📱 $message', 'UI', context, 'UI');
  }
  static void data(dynamic message, {String? tag, Map<String, dynamic>? context, String? category, required String description}) {
    _log(Level.info, '📱 $message', 'DATA', context, 'Data');
  }
  static void navigation(dynamic message, String s, {String? tag, Map<String, dynamic>? context, String? category}) {
    _log(Level.info, '📱 $message', 'NAVIGATION', context, 'Navigation');
  }
  static void timeStart(dynamic message, {String? tag, Map<String, dynamic>? context, String? category}) {
    _log(Level.info, '⏱️ $message', 'TIME_START', context, 'Time Start');
  }
  static void timeEnd(dynamic message, {String? tag, Map<String, dynamic>? context, String? category, required String additionalInfo}) {
    _log(Level.info, '⏱️ $message', 'TIME_END', context, 'Time End');
  } 
  static void performance(dynamic message, {String? tag, Map<String, dynamic>? context, String? category}) {
    _log(Level.info, '⏱️ $message', 'PERFORMANCE', context, 'Performance');
  }


  static void success(dynamic message, {String? tag, Map<String, dynamic>? context, String? category}) {
    _log(Level.info, '✅ $message', 'SUCCESS', context, 'Success');
  }

  static void failure(dynamic message, {String? tag, Map<String, dynamic>? context, String? category}) {
    _log(Level.error, '❌ $message', 'FAILURE', context, 'Failure');
  }
  static void auth(dynamic message, {String? tag, Map<String, dynamic>? context, String? category}) {
    _log(Level.info, '✅ $message', 'AUTH', context, 'Auth');
  }

  static void warning(dynamic message, {String? tag, Map<String, dynamic>? context, String? category}) {
    _log(Level.warning, message, tag, context, category);
  }

  static void error(dynamic message, {String? tag, Map<String, dynamic>? context, String? category, required Object error}) {
    _log(Level.error, message, tag, context, category);
  }

  static void debug(dynamic message, {String? tag, Map<String, dynamic>? context, String? category, required Object error}) {
    _log(Level.debug, message, tag, context, category);
  }

  static void verbose(dynamic message, {String? tag, Map<String, dynamic>? context, String? category}) {
    _log(Level.verbose, message, tag, context, category);
  }

  static void _log(Level level, dynamic message, String? tag, Map<String, dynamic>? context, String? category) {
    _logger.log(level, EnhancedLogMessage(message, tag: tag, context: context, category: category));
  }

   

  static void api(String message, {Map<String, dynamic>? context}) {
    _log(Level.info, '✅ $message', 'API', context, 'Api');
  }

  static void storage(String message, {Map<String, dynamic>? context}) {
    _log(Level.info, '✅ $message', 'STORAGE', context, 'Storage');
  }
}
