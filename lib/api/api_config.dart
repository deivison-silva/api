import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  /// Base URL configurada para resolver automaticamente o ambiente de execução:
  /// - Web / Desktop / iOS Simulator: http://localhost:3000
  /// - Emulador Android: http://10.0.2.2:3000
  ///
  /// Para alternar de volta ao JSONPlaceholder em nuvem, basta alternar a flag ou trocar para:
  /// static const String baseUrl = 'https://jsonplaceholder.typicode.com';
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    }
    return 'http://localhost:3000';
  }
}
