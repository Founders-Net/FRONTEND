import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_founders/models/user_short.dart';
import 'package:flutter_founders/models/tag_item.dart';
import 'dio_client.dart';

class SearchApiService {
  final Dio _dio = DioClient().dio;
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async => _storage.read(key: 'auth_token');

  /// GET /tags/  -> { tags: [{ id, name, subtags: [{id,name}] }] }
  Future<List<TagItem>> getAvailableTags() async {
    final token = await _getToken();

    final res = await _dio.get(
      // ✅ baseUrl already has /api → use just '/tags/'
      '/tags/',
      options: Options(headers: {
        if (token != null && token.isNotEmpty)
          'Authorization': token.toLowerCase().startsWith('bearer ')
              ? token
              : 'Bearer $token',
        'Accept': 'application/json',
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
        return TagItem(name, subs); // positional ctor
      }).toList();
    }
    return const [];
  }

  /// GET /users/?cursor&limit&fio?&country?&tags? (array)
  Future<List<UserShort>> searchUsers({
    String? query,          // maps to 'fio'
    String? country,
    List<String>? tags,
    int cursor = 0,
    int limit = 50,
  }) async {
    final token = await _getToken();

    // Build params (omit empties)
    final params = <String, dynamic>{
      'cursor': cursor,
      'limit': limit,
      if ((query ?? '').trim().isNotEmpty) 'fio': query!.trim(),
      if ((country ?? '').trim().isNotEmpty) 'country': country!.trim(),
    };

    // ✅ Use key 'tags[]' so servers that require bracket-array accept it
    final cleanTags =
        (tags ?? []).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    if (cleanTags.isNotEmpty) {
      params['tags[]'] = cleanTags; // => tags[]=IT&tags[]=SEO
    }

    // Force multi-value encoding (Dio v5 supports this)
    final res = await _dio.get(
      '/users/', // baseUrl already includes /api
      queryParameters: params,
      options: Options(
        listFormat: ListFormat.multi, // ensure repeated keys
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': token.toLowerCase().startsWith('bearer ')
                ? token
                : 'Bearer $token',
          'Accept': 'application/json',
        },
      ),
    );

    // Response: { data: [...], nextCursor: number }
    final body = res.data;
    final out = <UserShort>[];
    if (body is Map && body['data'] is List) {
      for (final e in (body['data'] as List)) {
        out.add(UserShort.fromJson(Map<String, dynamic>.from(e)));
      }
    }
    return out;
  }
}
