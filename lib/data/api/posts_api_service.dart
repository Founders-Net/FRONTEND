// posts_api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_founders/data/api/dio_client.dart';
import '../../models/post_model.dart';

class PostsApiService {
  final Dio _dio = DioClient().dio;

  Future<List<PostModel>> fetchPosts({int cursor = 0, int limit = 10}) async {
    final response = await _dio.get(
      '/posts/',
      queryParameters: {'cursor': cursor, 'limit': limit},
    );

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('❌ Failed to load posts: ${response.statusCode}');
    }
  }
}