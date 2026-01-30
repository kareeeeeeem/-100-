class ApiConstants {
  static const String baseUrl = 'https://100-academy.com/api/$_apiVersion';
  static const String _apiVersion = 'v1';
  static const Duration connectTimeout = Duration(seconds: 45);
  static const Duration receiveTimeout = Duration(seconds: 45);
  static const Duration sendTimeout = Duration(seconds: 45);
  static const String requiresAuthKey = 'requiresAuthKey';
  static const String authRefreshToken = '';
  static const String login = '/login';
  static const String register = '/register';
}
