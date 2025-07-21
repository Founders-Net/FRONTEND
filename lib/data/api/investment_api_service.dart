import 'package:dio/dio.dart';
import 'package:flutter_founders/data/api/dio_client.dart';
import 'package:flutter_founders/models/investment_model.dart';
import 'package:flutter/foundation.dart'; // for debugPrint

class InvestmentApiService {
  final Dio _dio = DioClient().dio;

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

  Future<Response> createInvestment({
    required String title,
    required String description,
    required int investmentAmount,
    required int paybackPeriodMonths,
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

  Future<void> deleteInvestment(int id) async {
    try {
      final response = await _dio.delete('/investments/$id');
      debugPrint('✅ Investment deleted: ${response.data}');
    } catch (e) {
      debugPrint('❌ Error deleting investment: $e');
      rethrow;
    }
  }
}
