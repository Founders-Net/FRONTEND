import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_founders/data/api/dio_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthApiService {
  final Dio dio = DioClient().dio;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> sendPhoneRequest(String phone) async {
    await dio.post('/auth/request', data: {'fio': 'Test User', 'phone': phone});
    debugPrint("📞 Phone request sent to: $phone");
  }

  Future<Map<String, dynamic>> confirmCode(String phone, String code) async {
    final response = await dio.post(
      '/auth/confirm',
      data: {'phone': phone, 'code': code},
    );

    final token = response.data['token'];
    debugPrint("🟢 Token from server: $token");

    if (token != null) {
      await secureStorage.write(key: 'auth_token', value: token);
      debugPrint("✅ Token saved");
    }

    return response.data;
  }

  Future<void> sendRegisterRequest() async {
    try {
      final response = await dio.post('/register', data: {});
      if (response.statusCode == 401) {
        throw Exception("Unauthorized: Token might be invalid or expired.");
      }
      debugPrint("📩 Register request sent: ${response.statusCode} - ${response.data}");
    } on DioException catch (e) {
      debugPrint("❌ DioException in register request: ${e.response?.data}");
      rethrow;
    }
  }

  Future<Map<String, dynamic>> checkRegisterStatus() async {
    try {
      final response = await dio.post('/register');
      if (response.statusCode == 401) {
        throw Exception("Unauthorized");
      }
      debugPrint("📋 Register status: ${response.statusCode} ${response.data}");
      return response.data;
    } on DioException catch (e) {
      debugPrint("🔴 Error checking register status: ${e.response?.data}");
      rethrow;
    }
  }
}
