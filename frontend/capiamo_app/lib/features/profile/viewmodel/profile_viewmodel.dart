import 'package:flutter/foundation.dart';

import '../../../data/repositories/user_repository.dart';
import '../../../domain/entities/user.dart';

class ProfileViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  ProfileViewModel({required this.userRepository});

  bool _loading = false;
  String? _error;
  User? _user;

  bool get isLoading => _loading;
  String? get error => _error;
  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  Future<void> updateProfile({
    required String displayedName,
    required String profileUri,
    required bool hideProfilePicture,
  }) async {
    if (_user == null) return;

    _setLoading(true);
    _error = null;

    try {
      final updated = await userRepository.upsertUser(
        userId: _user!.userId,
        displayedName: displayedName,
        profileUri: profileUri,
        hideProfilePicture: hideProfilePicture,
      );
      _user = updated;
    } catch (e) {
      _error = 'Failed to update profile.';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
