import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'error_log.dart';

void appLog(dynamic message, {String source = '', required bool isError}) {
  try {
    if (kDebugMode) {
      log("""
${source.isNotEmpty ? ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" : ""}
      $source
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

               =============>${message.toString()}

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

""");
    }
  } catch (e) {
    errorLog(e, source: "App Log");
  }
}
