import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Minimal logging, avoid leaking sensitive data in production logs.
    // You can enhance this with debug flags.
    // ignore: avoid_print
    print('--> ${options.method.toUpperCase()} ${options.uri}');
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('<-- ERROR ${err.response?.statusCode} ${err.requestOptions.uri}');
    super.onError(err, handler);
  }
}
