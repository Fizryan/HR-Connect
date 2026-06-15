import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://example.com/api';

  static String get phase => dotenv.env['PHASE'] ?? 'production';

  static bool get isDevelopment => phase == 'development';
}
