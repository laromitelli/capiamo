import 'dart:convert';
import 'package:dio/dio.dart';
import '../../utils/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final username =
        await SecureStorage.read(SecureStorage.keyBasicAuthUsername);
    final password =
        await SecureStorage.read(SecureStorage.keyBasicAuthPassword);

    if (username != null && password != null) {
      final basic = base64Encode(utf8.encode('$username:$password'));
      options.headers['Authorization'] = 'Basic $basic';
    }

    super.onRequest(options, handler);
  }
}
