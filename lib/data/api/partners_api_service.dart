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
      debugPrint('✅ response: ${response.data.runtimeType}');
      debugPrint('✅ response content: ${response.data}');

      final data = response.data['data'] as List; // ✅
      return data.map((e) => PartnerModel.fromJson(e)).toList();
    } catch (e) {
      debugPrint('❌ getPartners error: $e');
      rethrow;
    }
  }

  Future<void> sendPartnerRequest(int id) async {
    try {
      await _dio.post('/partners/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> respondToRequest(int id, bool accepted) async {
    try {
      await _dio.put('/partners/$id/respond', data: {"accepted": accepted});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePartner(int id) async {
    try {
      await _dio.delete('/partners/$id');
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PartnerRequestModel>> getIncomingRequests() async {
    try {
      final response = await _dio.get('/partners/requests/incoming');
      final data = response.data['data'] as List;
      return data.map((e) => PartnerRequestModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<PartnerRequestModel>> getOutgoingRequests() async {
    try {
      final response = await _dio.get('/partners/requests/outgoing');
      final data = response.data['data'] as List;
      return data.map((e) => PartnerRequestModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
