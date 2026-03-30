class AppConfig {
  static const String appName = 'Blinklean';
  static const String appVersion = '1.0.0';
  static const String environment = 'production';

  // AWS API Configuration
  static const String baseUrl =
      'https://3090drir79.execute-api.ap-south-1.amazonaws.com/prod';
  static const String apiVersion = 'v1';
  static const String apiBaseUrl = '$baseUrl/api/$apiVersion';

  // Support Configuration
  static const String supportNumber = '7022803582';
  static const String supportEmail = 'support@blinklean.com';
}
