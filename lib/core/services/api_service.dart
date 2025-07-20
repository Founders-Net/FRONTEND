import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://your-base-url.com/api', // 👈 غيره حسب API الحقيقي
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // ✅ توكن JWT (لو متوفر)
  static void setToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // ✅ طلب SMS كود
  static Future<String> requestSmsCode({
    required String fio,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/request',
        data: {'fio': fio, 'phone': phone},
      );

      return response.data['message'];
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'خطأ غير متوقع';
    }
  }

  // ✅ تأكيد كود SMS والحصول على التوكن
  static Future<(String token, String? userStatus)> confirmSmsCode({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/confirm',
        data: {'phone': phone, 'code': code},
      );

      final data = response.data;
      return (
        data['token'] as String,
        data['userStatus'] as String?,
      ); 
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'فشل في التحقق من الكود';
    }
  }

  // ✅ جلب بيانات البروفايل (بمجرد ما المستخدم يتسجل)
  static Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final response = await _dio.get('/users/profile/');
      return response.data;
    } on DioException catch (e) {
      throw e.response?.data['message'] ?? 'فشل في جلب البيانات';
    }
  }
}
