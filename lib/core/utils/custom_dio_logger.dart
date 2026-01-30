import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class CustomPrettyDioLogger extends PrettyDioLogger {
  CustomPrettyDioLogger({
    super.requestHeader = true,
    super.request = true,
    super.requestBody = true,
    super.responseBody = true,
    super.responseHeader = true,
    super.error = true,
    super.compact = true,
    super.maxWidth = 90,
  });
}
