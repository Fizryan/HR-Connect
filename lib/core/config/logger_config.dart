import 'package:hr_connect/core/config/env_config.dart';
import 'package:logger/logger.dart';

class LoggerConfig {
  LoggerConfig._();

  static final Logger logger = Logger(
    filter: ProductionFilter(),
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 8,
      lineLength: 0,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.none,
    ),
  );
}

class ProductionFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (EnvConfig.isDevelopment) {
      return true;
    }

    return event.level.index >= Level.warning.index;
  }
}
