import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';

final authRoleProvider = StateProvider<String?>((ref) => null);
final authUserIdProvider = StateProvider<String?>((ref) => null);
final mustChangePasswordProvider = StateProvider<bool>((ref) => false);

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider), ref);
});

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._repository, this._ref) : super(const AsyncData(null));

  final AuthRepository _repository;
  final Ref _ref;

  Future<bool> login(String emailOrPhone, String password) async {
    state = const AsyncLoading();
    try {
      final response = await _repository.login(emailOrPhone, password);
      final user = response['data']?['user'];
      if (user is Map<String, dynamic>) {
        final role = user['role'] as String?;
        final id = user['id'] as String?;
        final mustChange = user['mustChangePassword'] == true;

        if (role == null || role.isEmpty) {
          throw Exception('Account response did not include a user role.');
        }

        _ref.read(authRoleProvider.notifier).state = role;
        _ref.read(authUserIdProvider.notifier).state = id;
        _ref.read(mustChangePasswordProvider.notifier).state = mustChange;

        state = const AsyncData(null);
        return true;
      }
      throw Exception('Invalid response format');
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> register({
    required String emailOrPhone,
    required String password,
    required String role,
    required String referralCode,
  }) async {
    state = const AsyncLoading();
    try {
      await _repository.register(
        emailOrPhone: emailOrPhone,
        password: password,
        role: role,
        referralCode: referralCode,
      );
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    try {
      final userId = _ref.read(authUserIdProvider);
      await _repository.changePassword(
        userId: userId ?? '',
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      _ref.read(mustChangePasswordProvider.notifier).state = false;
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
