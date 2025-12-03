import 'package:flutter/foundation.dart';

import '../../../data/repositories/message_repository.dart';
import '../../../domain/entities/message.dart';

class MessageFormViewModel extends ChangeNotifier {
  final MessageRepository messageRepository;

  bool _loading = false;
  String? _error;
  Message? _created;

  MessageFormViewModel({required this.messageRepository});

  bool get isLoading => _loading;
  String? get error => _error;
  Message? get created => _created;

  Future<void> createMessage({
    required String userId,
    required String message,
    required double lat,
    required double lon,
  }) async {
    _setLoading(true);
    _error = null;
    _created = null;

    try {
      _created = await messageRepository.createMessage(
        userId: userId,
        message: message,
        lat: lat,
        lon: lon,
      );
    } catch (e) {
      _error = 'Failed to create situa.';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
