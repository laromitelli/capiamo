class Validators {
  static String? nonEmpty(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  static String? message(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Message cannot be empty';
    }
    if (value.length > 300) {
      return 'Message too long (max 300 characters)';
    }
    // Basic XSS guard: disallow script tags
    final lowered = value.toLowerCase();
    if (lowered.contains('<script') || lowered.contains('</script>')) {
      return 'Invalid characters in message';
    }
    return null;
  }

  static bool isValidLatitude(double lat) => lat >= -90 && lat <= 90;
  static bool isValidLongitude(double lon) => lon >= -180 && lon <= 180;
}
