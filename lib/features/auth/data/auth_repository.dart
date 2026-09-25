import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider));
});

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<Map<String, dynamic>> login(String emailOrPhone, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'emailOrPhone': emailOrPhone,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?.toString() ?? e.response?.data?['error']?['message'] ?? 'Login failed';
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> register({
    required String emailOrPhone,
    required String password,
    required String role,
    required String referralCode,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': emailOrPhone,
        'password': password,
        'role': role,
        'referralCode': referralCode,
      });
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['error']?['message'] ?? 'Registration failed';
      throw Exception(message);
    }
  }

  Future<Map<String, dynamic>> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await _dio.post('/auth/change-password', data: {
        'userId': userId,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
      return response.data;
    } on DioException catch (e) {
      final message = e.response?.data?['error']?['message'] ?? 'Password change failed';
      throw Exception(message);
    }
  }
}
