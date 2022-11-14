import 'package:logger/logger.dart';

final LogUtil logUtil = LogUtil();

class LogUtil {
  static final Logger logger = Logger(printer: PrettyPrinter());

  void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.d(message, error, stackTrace);
  }

  void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.i(message, error, stackTrace);
  }

  void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    logger.e(message, error, stackTrace);
  }
}
