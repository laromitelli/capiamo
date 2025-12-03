class Message {
  final String id;
  final String userId;
  final String message;
  final double lat;
  final double lon;
  final DateTime createdAt;
  final DateTime expiresAt;

  Message({
    required this.id,
    required this.userId,
    required this.message,
    required this.lat,
    required this.lon,
    required this.createdAt,
    required this.expiresAt,
  });
}
