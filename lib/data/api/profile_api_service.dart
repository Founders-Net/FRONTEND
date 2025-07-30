import 'package:dio/dio.dart';
import 'package:flutter_founders/presentation/profile/models/profile_model.dart';
import 'dio_client.dart';

class ProfileApiService {
  final Dio _dio = DioClient().dio;

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
}
