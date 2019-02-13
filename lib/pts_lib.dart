import 'dart:async';

import 'package:flutter/services.dart';

class PtsLib {
  static const MethodChannel _channel =
      const MethodChannel('pts_lib');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
