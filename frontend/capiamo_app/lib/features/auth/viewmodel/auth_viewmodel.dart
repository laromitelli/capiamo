import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../../../core/utils/secure_storage.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../domain/entities/user.dart';

class AuthViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  AuthViewModel({required this.userRepository});

  User? _currentUser;
  bool _loading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isLoading => _loading;
  String? get error => _error;

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  String _generatePassword() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#%&*()';
    final rand = Random.secure();
    return List.generate(32, (i) => chars[rand.nextInt(chars.length)]).join();
  }

  Future<void> loginWithFacebook() async {
    _setLoading(true);
    _error = null;

    try {
      final result = await FacebookAuth.instance.login(
        permissions: const ['public_profile', 'email'],
      );

      if (result.status != LoginStatus.success) {
        _error = 'Login cancelled or failed.';
        _setLoading(false);
        return;
      }

      // Get user data from Meta
      final userData = await FacebookAuth.instance.getUserData(
        fields: 'id,name,picture.width(400)',
      );

      final fbId = userData['id'] as String;
      final name = (userData['name'] as String?) ?? 'Unknown';
      final picture =
          (userData['picture']?['data']?['url'] as String?) ?? '';

      // Generate local password for backend Basic Auth
      final password = _generatePassword();

      await SecureStorage.write(
          SecureStorage.keyBasicAuthUsername, fbId);
      await SecureStorage.write(
          SecureStorage.keyBasicAuthPassword, password);

      // Upsert user in backend
      final user = await userRepository.upsertUser(
        userId: fbId,
        displayedName: name,
        profileUri: picture,
        hideProfilePicture: false,
      );

      _currentUser = user;
    } catch (e, st) {
      debugPrint('Facebook login error: $e\n$st');
      _error = 'Unexpected error during login.';
    }

    _setLoading(false);
  }

  Future<void> logout() async {
    await FacebookAuth.instance.logOut();
    await SecureStorage.clear();
    _currentUser = null;
    notifyListeners();
  }
}
