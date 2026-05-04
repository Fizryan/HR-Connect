import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? 'https://example.com/api';
  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  
  static bool get isDevelopment => environment == 'development';
  static bool get isProduction => environment == 'production';
}
