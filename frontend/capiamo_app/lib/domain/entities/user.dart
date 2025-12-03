class User {
  final String id;
  final String userId;
  final String displayedName;
  final String profilePictureUri;
  final bool hideProfilePicture;

  User({
    required this.id,
    required this.userId,
    required this.displayedName,
    required this.profilePictureUri,
    required this.hideProfilePicture,
  });
}
