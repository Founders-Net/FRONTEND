import 'package:dio/dio.dart';
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
    print('📡 [GET] /users/profile');
    final response = await _dio.get('/users/profile');
    print('📥 Response: ${response.data}');
    return ProfileModel.fromJson(response.data);
  }

  Future<ProfileModel> getUserProfileById(int id) async {
    print('📡 [GET] /users/$id');
    final response = await _dio.get('/users/$id');
    print('📥 Response: ${response.data}');
    return ProfileModel.fromJson(response.data);
  }

  Future<void> updateCompany(int userId, int companyId) async {
    print(
      '🛠️ [PUT] /users/update with data: {id: $userId, companyId: $companyId}',
    );
    final response = await _dio.put(
      '/users/update',
      data: {"id": userId, "companyId": companyId},
    );
    print('✅ Update response status: ${response.statusCode}');
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

    print('🛠️ [PUT] /users/update with data: $updateData');

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

    print('✅ Update response status: ${response.statusCode}');
  }
  
  Future<List<UserShort>> searchUsers({String? query}) async {
  final token = await _getToken();
  final response = await _dio.get(
    '/users',
    queryParameters: {
      'cursor': 0,
      'limit': 50,
      if (query != null && query.isNotEmpty) 'fio': query,
    },
    options: Options(headers: {'Authorization': token}),
  );

  final data = response.data['data'] as List;
  return data.map((e) => UserShort.fromJson(e)).toList();
}

}
