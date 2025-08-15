// lib/data/api/search_api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_founders/models/user_short.dart';
import 'package:flutter_founders/models/tag_item.dart';
import 'dio_client.dart';

class SearchApiService {
  final Dio _dio = DioClient().dio;
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async => _storage.read(key: 'auth_token');

  /// GET /api/tags/  -> { tags: [{ id, name, subtags: [{id,name}] }] }
 Future<List<TagItem>> getAvailableTags() async {
  final token = await _getToken();

  final res = await _dio.get(
    // Use '/api/tags/' if your baseUrl does NOT already include '/api'
    '/api/tags/',
    options: Options(headers: {
      if (token != null && token.isNotEmpty)
        'Authorization': token.toLowerCase().startsWith('bearer ')
            ? token
            : 'Bearer $token',
    }),
  );

  final data = res.data;
  if (data is Map && data['tags'] is List) {
    final List tags = data['tags'];
    return tags.map<TagItem>((t) {
      final String name = t['name']?.toString() ?? '';
      final List<String> subs = (t['subtags'] as List? ?? [])
          .map((s) => s['name']?.toString() ?? '')
          .where((s) => s.isNotEmpty)
          .toList();
      // ✅ TagItem expects 2 positional args (name, subTags)
      return TagItem(name, subs);
    }).toList();
  }

  return const [];
}


  /// GET /api/users/?cursor&limit&fio?&country?&tags?
  /// According to spec: tags: string[]  (send as repeated query param)
  Future<List<UserShort>> searchUsers({
    String? query,          // maps to 'fio'
    String? country,        // optional
    List<String>? tags,     // optional string[]
    int cursor = 0,
    int limit = 50,
  }) async {
    final token = await _getToken();

    final params = <String, dynamic>{
      'cursor': cursor,
      'limit': limit,
      if ((query ?? '').trim().isNotEmpty) 'fio': query!.trim(),
      if ((country ?? '').trim().isNotEmpty) 'country': country!.trim(),
      if ((tags ?? []).isNotEmpty) 'tags': tags, // -> tags=IT&tags=SEO
    };

    final res = await _dio.get(
      '/users/', // assumes baseUrl includes /api
      queryParameters: params,
      options: Options(headers: {
        if (token != null && token.isNotEmpty)
          'Authorization': token.toLowerCase().startsWith('bearer ')
              ? token
              : 'Bearer $token',
      }),
    );

    // Response: { data: [...], nextCursor: number }
    final body = res.data;
    final List<UserShort> out = [];
    if (body is Map && body['data'] is List) {
      for (final e in (body['data'] as List)) {
        out.add(UserShort.fromJson(Map<String, dynamic>.from(e)));
      }
    }
    return out;
  }
}
