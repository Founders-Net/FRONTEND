import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_founders/presentation/profile/models/profile_model.dart';
import 'dio_client.dart';

class ProfileApiService {
  final Dio _dio = DioClient().dio;
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<ProfileModel> getMyProfile() async {
    debugPrint('📡 [GET] /users/profile');
    final response = await _dio.get('/users/profile');
    debugPrint('📥 Response: ${response.data}');
    return ProfileModel.fromJson(response.data);
  }

  Future<ProfileModel> getUserProfileById(int id) async {
    debugPrint('📡 [GET] /users/$id');
    final response = await _dio.get('/users/$id');
    debugPrint('📥 Response: ${response.data}');
    return ProfileModel.fromJson(response.data);
  }

  Future<void> updateCompany(int userId, int companyId) async {
    debugPrint('🛠️ [PUT] /users/update with data: {id: $userId, companyId: $companyId}');
    final response = await _dio.put(
      '/users/update',
      data: {"id": userId, "companyId": companyId}, // ✅ شيلنا $companyId الغلط
    );
    debugPrint('✅ Update response status: ${response.statusCode}');
  }

  Future<void> updateProfile(ProfileModel profile) async {
    final token = await _storage.read(key: 'auth_token');

    final Map<String, dynamic> body = {
      "id": profile.id,
      "fio": profile.name.trim(),
      "email": (profile.email ?? '').trim(),
      "info": (profile.bio ?? '').trim(),
      "companyName": (profile.companyName ?? '').trim(),
      "companyIndustry": (profile.industry ?? '').trim(),
      "companyInfo": (profile.companyInfo ?? '').trim(),
      "userPhone": (profile.phone ?? '').trim(),
      // لو هتضيف country/tags هنا بعد موافقة الباك إند:
      // "country": profile.country,
      // "tags": profile.tags,
    };

    // 🧹 امسح الفاضي
    body.removeWhere((k, v) => v == null || (v is String && v.isEmpty));

    // Authorization header
    String? authHeader = token;
    if (authHeader != null &&
        authHeader.isNotEmpty &&
        !authHeader.toLowerCase().startsWith('bearer ')) {
      authHeader = 'Bearer $authHeader';
    }

    try {
      debugPrint('🛠️ [PUT] /users/update\nBody: $body');
      final response = await _dio.put(
        '/users/update',
        data: body,
        options: Options(
          headers: {
            if (authHeader != null && authHeader.isNotEmpty)
              'Authorization': authHeader,
            'Content-Type': 'application/json',
          },
        ),
      );
      debugPrint('✅ Update response status: ${response.statusCode}');
      debugPrint('✅ Update response data: ${response.data}');
    } on DioException catch (e) {
      debugPrint('❌ DioException: ${e.message}');
      debugPrint('❌ Status: ${e.response?.statusCode}');
      debugPrint('❌ Response data: ${e.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unknown error: $e');
      rethrow;
    }
  }
}
