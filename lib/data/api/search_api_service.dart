import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_founders/data/api/dio_client.dart';
import 'package:flutter_founders/models/tag_item.dart';
import 'package:flutter_founders/models/user_short.dart';
import 'package:flutter/foundation.dart';

class SearchApiService {
  final Dio _dio = DioClient().dio;
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  /// ترميز tags:
  /// - 'csv'      => tags=it,seo   (افتراضي)
  /// - 'array'    => tags=it&tags=seo
  /// - 'brackets' => tags[]=it&tags[]=seo
  Future<List<UserShort>> searchUsers({
    String? query,
    String? country,
    List<String>? tags,
    int cursor = 0,
    int limit = 50,
    String tagsEncoding = 'csv',
    String defaultCountry = 'Россия',
    List<String> defaultTags = const ['IT'],
  }) async {
    final token = await _getToken();

    // ✅ القيم الافتراضية لو مفيش اختيار من المستخدم
    final String safeCountry = (country != null && country.isNotEmpty)
        ? country
        : defaultCountry;
    final List<String> safeTags = (tags != null && tags.isNotEmpty)
        ? tags
        : defaultTags;

    // Base query
    final Map<String, dynamic> qpBase = {
      'cursor': cursor,
      'limit': limit,
      if (query != null && query.isNotEmpty) 'fio': query,
      'country': safeCountry,
    };

    // Build params according to encoding
    late final Map<String, dynamic> queryParameters;

    switch (tagsEncoding) {
      case 'array':
        // tags=it&tags=seo
        queryParameters = {...qpBase, 'tags': safeTags};
        break;
      case 'brackets':
        // tags[]=it&tags[]=seo
        queryParameters = {...qpBase, 'tags[]': safeTags};
        break;
      case 'csv':
      default:
        // tags=it,seo
        queryParameters = {...qpBase, 'tags': safeTags.join(',')};
        break;
    }

    debugPrint(
      '🔎 [GET] /users  query=$queryParameters (encoding=$tagsEncoding)',
    );

    final response = await _dio.get(
      '/users',
      queryParameters: queryParameters,
      options: Options(
        headers: {
          if (token != null && token.isNotEmpty) 'Authorization': token,
        },
      ),
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
      final subtags = subtagsRaw
          .map((s) => (s['name'] ?? '').toString())
          .toList();
      return TagItem(name, subtags);
    }).toList();
  }
}
