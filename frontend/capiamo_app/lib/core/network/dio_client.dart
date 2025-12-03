import 'package:dio/dio.dart';

import '../config/env.dart';
import '../errors/exceptions.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Env.apiBaseUrl,
        connectTimeout: Env.connectTimeout,
        receiveTimeout: Env.receiveTimeout,
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.addAll([
      LoggingInterceptor(),
      AuthInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  Future<Response<T>> getRequest<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
      );
      return response;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Response<T>> postRequest<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Object? data,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Response<T>> putRequest<T>(
    String path, {
    Object? data,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
      );
      return response;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  AppException _mapDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.message ?? 'Network error';

    return AppException(
      message,
      statusCode: statusCode,
      details: e.response?.data,
    );
  }
}
