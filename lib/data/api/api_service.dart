import 'package:dio/dio.dart';
import 'package:flutter_founders/models/request_model.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<List<RequestModel>> fetchRequests(String token) async {
    final response = await _dio.get(
      '/api/posts', // ✅ endpoint الخاص بالطلبات
      queryParameters: {
        'cursor': 0,
        'limit': 20,
      },
      options: Options(
        headers: {
          'Authorization': token,
        },
      ),
    );

    final List data = response.data['data'];
    return data.map((e) => RequestModel.fromJson(e)).toList();
  }
}