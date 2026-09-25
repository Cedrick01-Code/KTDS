import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dio_provider.dart';

final ktdsApiProvider = Provider<KtdsApi>((ref) => KtdsApi(ref.watch(dioProvider)));

class KtdsApi {
  KtdsApi(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> dashboardStats() async {
    final response = await _dio.get('/reports/discipline');
    return _dataMap(response);
  }

  Future<List<Map<String, dynamic>>> students() async =>
      _dataList(await _dio.get('/students'));

  Future<Map<String, dynamic>> student(String id) async {
    final response = await _dio.get('/students/$id');
    return _dataMap(response);
  }

  Future<List<Map<String, dynamic>>> incidents() async =>
      _dataList(await _dio.get('/discipline/incidents'));

  Future<List<Map<String, dynamic>>> cases() async =>
      _dataList(await _dio.get('/escalations'));

  Future<List<Map<String, dynamic>>> notifications() async =>
      _dataList(await _dio.get('/notifications'));

  Future<List<Map<String, dynamic>>> announcements() async =>
      _dataList(await _dio.get('/announcements'));

  Future<List<Map<String, dynamic>>> invitations() async =>
      _dataList(await _dio.get('/invitations'));

  Future<Map<String, dynamic>> createInvitation({
    required String name,
    required String email,
    required String role,
  }) async {
    final response = await _dio.post('/invitations', data: {
      'name': name,
      'email': email,
      'role': role,
    });
    return _dataMap(response);
  }

  Future<Map<String, dynamic>> recordIncident({
    required String studentId,
    required String category,
    required String description,
    required int points,
    required String role,
  }) async {
    final response = await _dio.post('/discipline/incidents', data: {
      'studentId': studentId,
      'category': category,
      'description': description,
      'points': points,
      'role': role,
    });
    return _dataMap(response);
  }

  Future<void> markNotificationRead(String id) async {
    await _dio.patch('/notifications/$id/read');
  }

  Future<void> approveDeduction(String id) async {
    await _dio.post('/discipline/deductions/$id/approve');
  }

  Future<void> rejectDeduction(String id, String reason) async {
    await _dio.post('/discipline/deductions/$id/reject', data: {'reason': reason});
  }

  List<Map<String, dynamic>> _dataList(Response<dynamic> response) {
    final data = response.data is Map ? response.data['data'] : response.data;
    if (data is! List) throw const FormatException('The server returned an invalid list.');
    return data.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Map<String, dynamic> _dataMap(Response<dynamic> response) {
    final data = response.data is Map ? response.data['data'] : response.data;
    if (data is! Map) throw const FormatException('The server returned an invalid record.');
    return Map<String, dynamic>.from(data);
  }
}
