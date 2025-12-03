class UserDto {
  final String id;
  final String userId;
  final String displayedName;
  final String profilePictureUri;
  final bool hideProfilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserDto({
    required this.id,
    required this.userId,
    required this.displayedName,
    required this.profilePictureUri,
    required this.hideProfilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      displayedName: json['displayed_name'] as String,
      profilePictureUri: json['profile_picture_uri'] as String,
      hideProfilePicture: json['hide_profile_picture'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'displayed_name': displayedName,
        'profile_picture_uri': profilePictureUri,
        'hide_profile_picture': hideProfilePicture,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
