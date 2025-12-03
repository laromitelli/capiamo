import 'package:dio/dio.dart';

import '../../core/config/env.dart';
import '../../core/network/dio_client.dart';
import '../../core/utils/validators.dart';
import '../../domain/entities/message.dart';
import '../models/message_dto.dart';

class MessageRepository {
  final DioClient dioClient;

  MessageRepository({required this.dioClient});

  Future<List<Message>> getMessagesNearby({
    required double lat,
    required double lon,
    int? radiusMeters,
  }) async {
    if (!Validators.isValidLatitude(lat) ||
        !Validators.isValidLongitude(lon)) {
      throw ArgumentError('Invalid coordinates');
    }

    final Response<dynamic> response =
        await dioClient.getRequest('/messages', queryParameters: {
      'lat': lat,
      'lon': lon,
      'radius': radiusMeters ?? Env.defaultRadiusMeters,
    });

    final data = response.data as List<dynamic>;
    final messages = data
        .map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
        .map(
          (dto) => Message(
            id: dto.id,
            userId: dto.userId,
            message: dto.message,
            lat: dto.lat,
            lon: dto.lon,
            createdAt: dto.createdAt,
            expiresAt: dto.expiresAt,
          ),
        )
        .toList();
    return messages;
  }

  Future<Message> createMessage({
    required String userId,
    required String message,
    required double lat,
    required double lon,
  }) async {
    if (!Validators.isValidLatitude(lat) ||
        !Validators.isValidLongitude(lon)) {
      throw ArgumentError('Invalid coordinates');
    }

    final Response<dynamic> response =
        await dioClient.postRequest('/messages', data: {
      'user_id': userId,
      'message': message,
      'lat': lat,
      'lon': lon,
    });

    final dto = MessageDto.fromJson(response.data as Map<String, dynamic>);
    return Message(
      id: dto.id,
      userId: dto.userId,
      message: dto.message,
      lat: dto.lat,
      lon: dto.lon,
      createdAt: dto.createdAt,
      expiresAt: dto.expiresAt,
    );
  }
}
