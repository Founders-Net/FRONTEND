import 'package:dio/dio.dart';
import 'package:flutter_founders/data/api/dio_client.dart';
import 'package:flutter_founders/models/investment_model.dart';
import 'package:flutter/foundation.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class InvestmentApiService {
  final Dio _dio = DioClient().dio; // Assuming DioClient is set up correctly for Dio
  final _storage = const FlutterSecureStorage();

  Future<String> _getToken() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null || token.isEmpty) {
      throw Exception('No auth token found');
    }
    return 'Bearer $token';
  }

  // Fetch Investments
  Future<List<InvestmentModel>> getInvestments({
    int cursor = 0,
    int limit = 10,
    int? userId,
    String? statusFilter,
  }) async {
    try {
      final response = await _dio.get(
        '/investments/',
        queryParameters: {
          'cursor': cursor,
          'limit': limit,
          if (userId != null) 'userId': userId,
          if (statusFilter != null) 'statusFilter': statusFilter,
        },
      );

      debugPrint('✅ Investments fetched: ${response.data}');
      final List<dynamic> data = response.data['data'];
      return data.map((e) => InvestmentModel.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        debugPrint('📭 No investments found (empty list)');
        return [];
      }
      debugPrint('❌ Dio error fetching investments: $e');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unknown error fetching investments: $e');
      rethrow;
    }
  }

  // Get Investment by ID
  Future<InvestmentModel> getInvestmentById(int id) async {
    try {
      final response = await _dio.get('/investments/$id');
      debugPrint('✅ Investment fetched by ID: ${response.data}');
      return InvestmentModel.fromJson(response.data);
    } catch (e) {
      debugPrint('❌ Error fetching investment by ID: $e');
      rethrow;
    }
  }

  // Create Investment
  Future<Response> createInvestment({
    required String title,
    required String description,
    required String investmentAmount,
    required String paybackPeriodMonths,
    required String country,
    required String businessPlanUrl,
    required String financialModelUrl,
    required String presentationUrl,
  }) async {
    try {
      final data = {
        'title': title,
        'description': description,
        'investmentAmount': investmentAmount,
        'paybackPeriodMonths': paybackPeriodMonths,
        'country': country,
        'businessPlanUrl': businessPlanUrl,
        'financialModelUrl': financialModelUrl,
        'presentationUrl': presentationUrl,
      };

      debugPrint('📤 Sending investment creation data: $data');

      final response = await _dio.post('/investments/', data: data);

      debugPrint('✅ Investment created successfully: ${response.data}');
      return response;
    } on DioException catch (e) {
      debugPrint('❌ Dio error creating investment: ${e.response?.data}');
      rethrow;
    } catch (e) {
      debugPrint('❌ Unknown error creating investment: $e');
      rethrow;
    }
  }

  // Update Investment
  Future<void> updateInvestment({
    required int id,
    required String title,
    required String description,
    required int investmentAmount,
    required int paybackPeriodMonths,
    required String country,
    required String status,
  }) async {
    try {
      final response = await _dio.put(
        '/investments/$id',
        data: {
          'title': title,
          'description': description,
          'investmentAmount': investmentAmount,
          'paybackPeriodMonths': paybackPeriodMonths,
          'country': country,
          'status': status,
        },
      );
      debugPrint('✅ Investment updated: ${response.data}');
    } catch (e) {
      debugPrint('❌ Error updating investment: $e');
      rethrow;
    }
  }

  // Upload Investment Media (Business Plan, Financial Model, etc.)
  Future<Map<String, dynamic>> uploadInvestmentMedia(int id) async {
    try {
      final response = await _dio.put('/investments/media/$id');
      debugPrint('✅ Investment media uploaded: ${response.data}');
      return response.data;
    } catch (e) {
      debugPrint('❌ Error uploading investment media: $e');
      rethrow;
    }
  }

  // Delete Investment
  Future<void> deleteInvestment(int id) async {
    try {
      final response = await _dio.delete('/investments/$id');
      debugPrint('✅ Investment deleted: ${response.data}');
    } catch (e) {
      debugPrint('❌ Error deleting investment: $e');
      rethrow;
    }
  }

  // Like Investment
  Future<void> likeInvestment(int postId) async {
  final token = await _getToken();
  try {
    debugPrint('📤 Liking post with ID: $postId');
    final response = await _dio.post(
      '/likes/$postId', 
      options: Options(headers: {'Authorization': token}),
    );
    debugPrint('✅ Post liked successfully: ${response.data}');
  } on DioException catch (e) {
    debugPrint('❌ Error liking post: ${e.response?.data}');
    rethrow;
  } catch (e) {
    debugPrint('❌ Unknown error liking post: $e');
    rethrow;
  }
}

// Unlike Investment
Future<void> unlikeInvestment(int postId) async {
  final token = await _getToken();
  try {
    debugPrint('📤 Unliking post with ID: $postId');
    final response = await _dio.delete(
      '/likes/$postId', 
      options: Options(headers: {'Authorization': token}),
    );
    debugPrint('✅ Post unliked successfully: ${response.data}');
  } on DioException catch (e) {
    debugPrint('❌ Error unliking post: ${e.response?.data}');
    rethrow;
  } catch (e) {
    debugPrint('❌ Unknown error unliking post: $e');
    rethrow;
  }
}
}