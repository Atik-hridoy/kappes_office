import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class StylishPrinter extends LogPrinter {
  final DateFormat _timeFormat = DateFormat('HH:mm:ss');

  @override
  List<String> log(LogEvent event) {
    final time = _timeFormat.format(DateTime.now());
    final level = event.level;
    final emoji = _getEmoji(level);
    final color = _getColor(level);
    final lvl = level.toString().split('.').last.toUpperCase();
    final msg = event.message;

    // Support both List and String messages
    List<String> msgLines;
    if (msg is List) {
      msgLines = msg.map((e) => e.toString()).toList();
    } else {
      msgLines = msg.toString().split('\n');
    }

    // Header is always the first line, content is the rest
    final header =
        '$emoji $color[$time]\x1B[0m[$lvl] ${msgLines.isNotEmpty ? msgLines.first : ''}';
    List<String> allLines = [header];
    if (msgLines.length > 1) {
      allLines.addAll(msgLines.sublist(1));
    }

    // Find max length for box
    int maxLen = allLines
        .map((l) => _stripAnsi(l).length)
        .reduce((a, b) => a > b ? a : b);
    int boxWidth = maxLen + 2;
    String boxTop = '┌' + '─' * boxWidth + '┐';
    String boxBot = '└' + '─' * boxWidth + '┘';
    List<String> boxed = [color + boxTop];
    for (var line in allLines) {
      int pad = boxWidth - _stripAnsi(line).length;
      boxed.add('│ ' + line + ' ' * pad + '│');
    }
    boxed.add(boxBot + '\x1B[0m');
    return [boxed.join('\n')];
  }

  // Remove ANSI color codes for width calculation
  String _stripAnsi(String input) {
    final ansiEscape = RegExp(r'\x1B\[[0-9;]*m');
    return input.replaceAll(ansiEscape, '');
  }

  String _getEmoji(Level level) {
    switch (level) {
      case Level.error:
        return '🛑';
      case Level.warning:
        return '⚠️';
      case Level.info:
        return 'ℹ️';
      case Level.debug:
        return '🐛';
      case Level.trace:
        return '🔍';
      case Level.fatal:
        return '💥';
      default:
        return '💬';
    }
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
        return '\x1B[35m'; // Magenta
      case Level.trace:
        return '\x1B[32m'; // Green
      default:
        return '\x1B[0m'; // Reset
    }
  }
}

class AppLogger {
  static final Logger _logger = Logger(printer: StylishPrinter());
  static void info(dynamic message) => _logger.i(message);
  static void warning(dynamic message) => _logger.w(message);
  static void error(dynamic message) => _logger.e(message);
  static void debug(dynamic message) => _logger.d(message);
  static void trace(dynamic message) => _logger.t(message);
}
