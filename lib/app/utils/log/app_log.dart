import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class AdvancedPrinter extends LogPrinter {
  final DateFormat _timeFormat = DateFormat('HH:mm:ss');

  @override
  List<String> log(LogEvent event) {
    // Support for tagged/context log messages
    String tag = '';
    Map<String, dynamic>? context;
    dynamic msg = event.message;
    if (msg is AdvancedLogMessage) {
      tag = msg.tag ?? '';
      context = msg.context;
      msg = msg.message;
    }

    final time = _timeFormat.format(DateTime.now());
    final level = event.level;
    final color = _getColor(level);
    final icon = _getIcon(level);
    final levelName = level
        .toString()
        .split('.')
        .last
        .toUpperCase()
        .padRight(7);

    // Try to get file and line info from stack trace
    final trace = StackTrace.current.toString().split('\n');
    String fileLine = '';
    for (final line in trace) {
      if (line.contains('/lib/') && !line.contains('logger.dart')) {
        final match = RegExp(r'(\w+\.dart):(\d+)').firstMatch(line);
        if (match != null) {
          fileLine = '${match.group(1)}:${match.group(2)}';
          break;
        }
      }
    }
    fileLine = fileLine.isNotEmpty ? fileLine : '-';

    // Tag formatting
    final tagPart = tag.isNotEmpty ? '[${tag.toUpperCase()}] ' : '';
    final header = '$icon $color[$time] [$levelName] $tagPart$fileLine';
    final message = msg.toString();
    final lines = message.split('\n');
    final formatted = [
      '$header',
      ...lines.mapIndexed(
        (i, line) => i == 0 ? '     └─ $line' : '        $line',
      ),
    ];
    // Context formatting
    if (context != null && context.isNotEmpty) {
      formatted.add('     Context:');
      context.forEach((k, v) {
        formatted.add('        $k: $v');
      });
    }
    // Reset color after
    formatted[formatted.length - 1] = formatted.last + '\x1B[0m';
    return formatted;
  }

  String _getColor(Level level) {
    switch (level) {
      case Level.error:
        return '\x1B[31m'; // Red
      case Level.warning:
        return '\x1B[33m'; // Yellow
      case Level.info:
        return '\x1B[36m'; // Cyan
      case Level.debug:
        return '\x1B[37m'; // White
      case Level.trace:
        return '\x1B[32m'; // Green
      default:
        return '\x1B[0m'; // Reset
    }
  }

  String _getIcon(Level level) {
    switch (level) {
      case Level.error:
        return '🟥';
      case Level.warning:
        return '🟨';
      case Level.info:
        return '🟦';
      case Level.debug:
        return '⬜️';
      case Level.trace:
        return '🟩';
      default:
        return '▫️';
    }
  }
}

extension _IterableMapIndexed<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(int, E) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }
}

class AdvancedLogMessage {
  final String? tag;
  final dynamic message;
  final Map<String, dynamic>? context;
  AdvancedLogMessage(this.message, {this.tag, this.context});
}

class AppLogger {
  static final Logger _logger = Logger(
    printer: AdvancedPrinter(),
    level: Level.debug, // Set your desired default log level
  );

  static void info(dynamic message) => _logger.i(message);
  static void warning(dynamic message) => _logger.w(message);
  static void error(dynamic message) => _logger.e(message);
  static void debug(dynamic message) => _logger.d(message);
  static void verbose(dynamic message) => _logger.v(message);
}
