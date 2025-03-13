import 'package:flutter/material.dart';

// Enum for ANSI colors
enum AnsiColor {
  black(code: '\x1B[30m'),
  red(code: '\x1B[31m'),
  green(code: '\x1B[32m'),
  yellow(code: '\x1B[33m'),
  blue(code: '\x1B[34m'),
  magenta(code: '\x1B[35m'),
  cyan(code: '\x1B[36m'),
  white(code: '\x1B[37m'),
  reset(code: '\x1B[0m');

  final String code;
  const AnsiColor({required this.code});
}

// Helper function for colored debug prints
void debugPrintColored(String message, {required AnsiColor color}) {
  // ignore: avoid_print
  debugPrint('${color.code}$message${AnsiColor.reset.code}');
}
