// lib/data/api/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(BaseOptions(baseUrl: 'http://194.87.151.46:3000/api')) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          const storage = FlutterSecureStorage();
          final token = await storage.read(key: 'auth_token');

          if (token != null) {
            options.headers['Authorization'] = ' $token';
            options.headers['Content-Type'] = 'application/json';
          }

          return handler.next(options);
        },
      ),
    );
  }
}
