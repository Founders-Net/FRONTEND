// lib/data/api/partners_api_service.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_founders/data/api/dio_client.dart';
import 'package:flutter_founders/presentation/profile/models/partner_request_model.dart';
import 'package:flutter_founders/presentation/profile/models/partner_model.dart';

class PartnersApiService {
  final Dio _dio = DioClient().dio;

  Future<List<PartnerModel>> getPartners() async {
    try {
      final response = await _dio.get('/partners/');
      debugPrint(
        '✅ [GET] /partners/ -> ${response.statusCode} (${response.requestOptions.uri})',
      );
      final data = response.data['data'] as List? ?? const [];
      return data.map((e) => PartnerModel.fromJson(e)).toList();
    } on DioException catch (e) {
      debugPrint(
        '❌ getPartners error ${e.response?.statusCode} (${e.requestOptions.uri}) -> ${e.response?.data}',
      );
      rethrow;
    }
  }

  Future<void> sendPartnerRequest(int id) async {
    try {
      final res = await _dio.post('/partners/$id');
      debugPrint(
        '✅ [POST] /partners/$id -> ${res.statusCode} (${res.requestOptions.uri})',
      );
    } on DioException catch (e) {
      debugPrint(
        '❌ sendPartnerRequest ${e.response?.statusCode} (${e.requestOptions.uri}) -> ${e.response?.data}',
      );
      rethrow;
    }
  }

  Future<void> respondToRequest(int id, String status) async {
    try {
      final res = await _dio.put(
        '/partners/$id/respond',
        data: {"status": status},
      );
      debugPrint(
        '✅ [PUT] /partners/$id/respond -> ${res.statusCode} (${res.requestOptions.uri})',
      );
    } on DioException catch (e) {
      debugPrint(
        '❌ respondToRequest ${e.response?.statusCode} (${e.requestOptions.uri}) -> ${e.response?.data}',
      );
      rethrow;
    }
  }

  Future<void> deletePartner(int id) async {
    try {
      final res = await _dio.delete('/partners/$id');
      debugPrint(
        '✅ [DELETE] /partners/$id -> ${res.statusCode} (${res.requestOptions.uri})',
      );
    } on DioException catch (e) {
      debugPrint(
        '❌ deletePartner ${e.response?.statusCode} (${e.requestOptions.uri}) -> ${e.response?.data}',
      );
      rethrow;
    }
  }

  Future<List<PartnerRequestModel>> getIncomingRequests() async {
    try {
      final res = await _dio.get('/partners/requests/incoming');
      debugPrint(
        '✅ [GET] /partners/requests/incoming -> ${res.statusCode} (${res.requestOptions.uri})',
      );
      final data = res.data['data'] as List? ?? const [];
      return data.map((e) => PartnerRequestModel.fromJson(e)).toList();
    } on DioException catch (e) {
      // 👇 لو السيرفر بيرجع 404 لما مفيش طلبات، نرجع list فاضية
      if (e.response?.statusCode == 404) {
        debugPrint(
          'ℹ️ incoming 404 (no data) -> return []  (${e.requestOptions.uri})',
        );
        return [];
      }
      debugPrint(
        '❌ getIncomingRequests ${e.response?.statusCode} (${e.requestOptions.uri}) -> ${e.response?.data}',
      );
      rethrow;
    }
  }

  Future<List<PartnerRequestModel>> getOutgoingRequests() async {
    try {
      final res = await _dio.get('/partners/requests/outgoing');
      debugPrint(
        '✅ [GET] /partners/requests/outgoing -> ${res.statusCode} (${res.requestOptions.uri})',
      );
      final data = res.data['data'] as List? ?? const [];
      return data.map((e) => PartnerRequestModel.fromJson(e)).toList();
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        debugPrint(
          'ℹ️ outgoing 404 (no data) -> return []  (${e.requestOptions.uri})',
        );
        return [];
      }
      debugPrint(
        '❌ getOutgoingRequests ${e.response?.statusCode} (${e.requestOptions.uri}) -> ${e.response?.data}',
      );
      rethrow;
    }
  }

  Future<void> cancelOutgoingRequest(int requestId) async {
    try {
      await _dio.delete('/partners/$requestId');
    } catch (e) {
      rethrow;
    }
  }
}
