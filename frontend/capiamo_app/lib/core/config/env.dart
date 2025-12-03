class Env {

  static String get apiBaseUrl =>
      const String.fromEnvironment('API_BASE_URL', defaultValue: '');

  // Radius in meters for nearby situes
  static const int defaultRadiusMeters = 5000;

  // Network timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Validation to ensure the URL is provided in production
  static void ensureConfigured() {
    if (apiBaseUrl.isEmpty) {
      throw Exception(
        'API_BASE_URL is not configured. '
        'Use --dart-define=API_BASE_URL=<your-url> when building or running the app.',
      );
    }
  }
}
