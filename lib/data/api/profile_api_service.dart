import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_founders/models/tag_item.dart';
import 'package:flutter_founders/models/user_short.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_founders/presentation/profile/models/profile_model.dart';
import 'dio_client.dart';

class ProfileApiService {
  final Dio _dio = DioClient().dio;
  final _storage = FlutterSecureStorage();

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
    debugPrint(
      '🛠️ [PUT] /users/update with data: {id: $userId, companyId: $companyId}',
    );
    final response = await _dio.put(
      '/users/update',
      data: {"id": userId, "companyId": companyId},
    );
    debugPrint('✅ Update response status: ${response.statusCode}');
  }

  Future<void> updateProfile(ProfileModel profile) async {
    final token = await _storage.read(key: 'auth_token');

    final Map<String, dynamic> updateData = {
      "id": profile.id,
      "fio": profile.name,
      "email": profile.email ?? "",
      "info": profile.bio ?? "",
      "companyName": profile.companyName ?? "",
      "companyIndustry": profile.industry ?? "",
      "companyInfo": profile.companyInfo ?? "",
    };

    debugPrint('🛠️ [PUT] /users/update with data: $updateData');

    final response = await _dio.put(
      '/users/update',
      data: updateData,
      options: Options(
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json',
        },
      ),
    );

    debugPrint('✅ Update response status: ${response.statusCode}');
  }
  
  Future<List<UserShort>> searchUsers({
    String? query,
    String? country,         // <- single country
    List<String>? tags,      // <- flat list (main or sub)
    int cursor = 0,
    int limit = 50,
  }) async {
  final token = await _getToken();
  final response = await _dio.get(
    '/users',
    queryParameters: {
      'cursor': cursor,
      'limit': limit,
      if (query != null && query.isNotEmpty) 'fio': query,
      if (country != null && country.isNotEmpty) 'country': country,
      if (tags != null && tags.isNotEmpty) 'tags': tags,
    },
    options: Options(headers: {'Authorization': token}),
  );

  final data = (response.data['data'] as List);
  return data.map((e) => UserShort.fromJson(e)).toList();
}

  Future<List<TagItem>> getAvailableTags() async {
    final token = await _getToken();
    final res = await _dio.get(
      '/tags',
      options: Options(headers: {'Authorization': token}),
    );

    final raw = res.data['tags'] as List<dynamic>? ?? const [];
    return raw.map((t) {
      final name = (t['name'] ?? '').toString();
      final subtagsRaw = (t['subtags'] as List<dynamic>? ?? const []);
      final subtags = subtagsRaw.map((s) => (s['name'] ?? '').toString()).toList();
      return TagItem(name, subtags);
    }).toList();
  }


}
