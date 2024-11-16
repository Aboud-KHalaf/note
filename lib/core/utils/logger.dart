import 'dart:developer';

class Log {
  static const String _resetColor = '\x1B[0m';
  static const String _red = '\x1B[31m';
  static const String _green = '\x1B[32m';
  static const String _yellow = '\x1B[33m';
  static const String _blue = '\x1B[34m';
  static const String _black = '\x1B[30m';
  static const String _cyan = '\x1B[36m';
  static const String _white = '\x1B[37m';

  // Log methods for different levels
  static void black(String message) {
    _log(message, _black, 'damn');
  }

  static void white(String message) {
    _log(message, _white, 'happy');
  }

  static void cyan(String message) {
    _log(message, _cyan, 'look');
  }

  static void debug(String message) {
    _log(message, _blue, 'DEBUG');
  }

  static void info(String message) {
    _log(message, _green, 'INFO');
  }

  static void warning(String message) {
    _log(message, _yellow, 'WARNING');
  }

  static void error(String message) {
    _log(message, _red, 'ERROR');
  }

  // Internal log method
  static void _log(String message, String color, String level) {
    final formattedMessage = '$color[$level] $message$_resetColor';
    log(formattedMessage);
    // Optionally, you could use `print` instead of `developer.log` if you don't need developer tools:
    // print(formattedMessage);
  }
}
