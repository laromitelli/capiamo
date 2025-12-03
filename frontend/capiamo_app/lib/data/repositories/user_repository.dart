import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../../core/utils/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../models/user_dto.dart';

class UserRepository {
  final DioClient dioClient;

  UserRepository({required this.dioClient});

  Future<User> upsertUser({
    required String userId,
    required String displayedName,
    required String profileUri,
    required bool hideProfilePicture,
  }) async {
    final Response<dynamic> response = await dioClient.putRequest(
      '/users',
      data: {
        'user_id': userId,
        'name': displayedName,
        'profile_uri': profileUri,
        'hide_pic': hideProfilePicture,
      },
    );

    final userDto = UserDto.fromJson(response.data as Map<String, dynamic>);
    final user = User(
      id: userDto.id,
      userId: userDto.userId,
      displayedName: userDto.displayedName,
      profilePictureUri: userDto.profilePictureUri,
      hideProfilePicture: userDto.hideProfilePicture,
    );

    await _persistUser(user);

    return user;
  }

  Future<void> _persistUser(User user) async {
    await SecureStorage.write(SecureStorage.keyUserId, user.id);
    await SecureStorage.write(SecureStorage.keyDisplayedName, user.displayedName);
    await SecureStorage.write(SecureStorage.keyProfileUri, user.profilePictureUri);
    await SecureStorage.write(
      SecureStorage.keyHideProfilePicture,
      user.hideProfilePicture.toString(),
    );
  }

  Future<User?> loadUserFromStorage() async {
    final id = await SecureStorage.read(SecureStorage.keyUserId);
    if (id == null) return null;

    final displayedName =
        await SecureStorage.read(SecureStorage.keyDisplayedName) ?? '';
    final profileUri =
        await SecureStorage.read(SecureStorage.keyProfileUri) ?? '';
    final hidePicStr =
        await SecureStorage.read(SecureStorage.keyHideProfilePicture) ?? 'false';

    return User(
      id: id,
      userId: '', // not stored locally currently
      displayedName: displayedName,
      profilePictureUri: profileUri,
      hideProfilePicture: hidePicStr.toLowerCase() == 'true',
    );
  }

  Future<void> clearUser() async {
    await SecureStorage.delete(SecureStorage.keyUserId);
    await SecureStorage.delete(SecureStorage.keyDisplayedName);
    await SecureStorage.delete(SecureStorage.keyProfileUri);
    await SecureStorage.delete(SecureStorage.keyHideProfilePicture);
  }
}
