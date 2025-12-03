class MessageDto {
  final String id;
  final String userId;
  final String message;
  final double lat;
  final double lon;
  final DateTime createdAt;
  final DateTime expiresAt;

  MessageDto({
    required this.id,
    required this.userId,
    required this.message,
    required this.lat,
    required this.lon,
    required this.createdAt,
    required this.expiresAt,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) {
    return MessageDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      message: json['message'] as String,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'message': message,
        'lat': lat,
        'lon': lon,
        'created_at': createdAt.toIso8601String(),
        'expires_at': expiresAt.toIso8601String(),
      };
}
