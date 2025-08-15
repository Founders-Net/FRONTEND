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

  final body = <String, dynamic>{
    if (profile.id != null) 'id': profile.id,                  // required by spec
    if ((profile.name).trim().isNotEmpty) 'fio': profile.name.trim(),
    if ((profile.email ?? '').trim().isNotEmpty) 'email': profile.email!.trim(),
    if ((profile.bio ?? '').trim().isNotEmpty) 'info': profile.bio!.trim(),
    if ((profile.country ?? '').trim().isNotEmpty) 'country': profile.country!.trim(),
    if ((profile.tags ?? const []).isNotEmpty) 'tags': profile.tags, // List<String>
    if ((profile.companyName ?? '').trim().isNotEmpty) 'companyName': profile.companyName!.trim(),
    if ((profile.industry ?? '').trim().isNotEmpty) 'companyIndustry': profile.industry!.trim(),
    if ((profile.companyInfo ?? '').trim().isNotEmpty) 'companyInfo': profile.companyInfo!.trim(),
  };

  final auth = (token ?? '').isEmpty
      ? null
      : (token!.toLowerCase().startsWith('bearer ') ? token : 'Bearer $token');

  debugPrint('🛠️ [PUT] /users/update  Body: $body');
  final res = await _dio.put(
    '/users/update', // assumes baseUrl has /api
    data: body,
    options: Options(headers: {
      if (auth != null) 'Authorization': auth,
      'Content-Type': 'application/json',
    }),
  );
  debugPrint('✅ Update status: ${res.statusCode}');
  debugPrint('✅ Update data: ${res.data}');
}
}
