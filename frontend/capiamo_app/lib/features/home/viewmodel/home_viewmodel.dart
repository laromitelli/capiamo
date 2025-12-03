import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/errors/exceptions.dart';
import '../../../core/utils/validators.dart';
import '../../../data/repositories/message_repository.dart';
import '../../../domain/entities/message.dart';

class HomeViewModel extends ChangeNotifier {
  final MessageRepository messageRepository;

  HomeViewModel({required this.messageRepository});

  List<Message> _messages = [];
  bool _loading = false;
  String? _error;
  Position? _currentPosition;

  List<Message> get messages => _messages;
  bool get isLoading => _loading;
  String? get error => _error;
  Position? get currentPosition => _currentPosition;

  Future<void> loadCurrentLocation() async {
    _setLoading(true);
    _error = null;

    try {
      final permission = await Geolocator.checkPermission();
      LocationPermission finalPerm = permission;
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        finalPerm = await Geolocator.requestPermission();
      }

      if (finalPerm == LocationPermission.denied ||
          finalPerm == LocationPermission.deniedForever) {
        _error = 'Location permission denied';
        _setLoading(false);
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      _error = 'Failed to get location';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadNearbyMessages({int? radiusMeters}) async {
    if (_currentPosition == null) {
      await loadCurrentLocation();
      if (_currentPosition == null) {
        return;
      }
    }

    _setLoading(true);
    _error = null;

    try {
      final lat = _currentPosition!.latitude;
      final lon = _currentPosition!.longitude;

      if (!Validators.isValidLatitude(lat) ||
          !Validators.isValidLongitude(lon)) {
        throw AppException('Invalid coordinates');
      }

      _messages = await messageRepository.getMessagesNearby(
        lat: lat,
        lon: lon,
        radiusMeters: radiusMeters,
      );
    } catch (e) {
      _error = 'Failed to load situas.';
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
}
