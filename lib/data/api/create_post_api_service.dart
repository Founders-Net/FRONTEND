import 'package:dio/dio.dart';
import 'package:flutter_founders/data/api/dio_client.dart';

class CreatePostApiService {
  final Dio _dio = DioClient().dio;

  Future<void> createPost({
    required String title,
    required String description,
    required List<String> tags,
  }) async {
    final response = await _dio.post(
      '/posts/',
      data: {
        'title': title,
        'content': description, // ✅ التصحيح هنا
        'tags': tags,
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create post: ${response.data}');
    }
  }
}
