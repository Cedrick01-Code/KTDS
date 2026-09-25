import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import 'auth_controller.dart';
import 'login_page.dart';

class ForcedPasswordChangePage extends ConsumerStatefulWidget {
  const ForcedPasswordChangePage({super.key});

  @override
  ConsumerState<ForcedPasswordChangePage> createState() => _ForcedPasswordChangePageState();
}

class _ForcedPasswordChangePageState extends ConsumerState<ForcedPasswordChangePage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitPasswordChange() async {
    final current = _currentPasswordController.text.trim();
    final next = _newPasswordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    if (current.isEmpty || next.length < 6 || next != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter current password and a matching new password (6+ chars).')),
      );
      return;
    }

    final success = await ref.read(authControllerProvider.notifier).changePassword(
      currentPassword: current,
      newPassword: next,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully! Redirecting...')),
      );
      context.go(homeForRole(ref.read(authRoleProvider)));
    } else if (mounted) {
      final error = ref.read(authControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error?.toString() ?? 'Failed to change password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isSubmitting = authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Security Update Required')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: AppColors.deepBlue, size: 28),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You are logging in with an initial default password. Please update your password to continue.',
                          style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.darkText),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _currentPasswordController,
                  obscureText: _obscure,
                  decoration: const InputDecoration(
                    labelText: 'Current initial password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _newPasswordController,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'New password',
                    prefixIcon: const Icon(Icons.lock_reset),
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscure = !_obscure),
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscure,
                  decoration: const InputDecoration(
                    labelText: 'Confirm new password',
                    prefixIcon: Icon(Icons.check_circle_outline),
                  ),
                ),
                const SizedBox(height: 28),
                ElevatedButton.icon(
                  onPressed: isSubmitting ? null : _submitPasswordChange,
                  icon: isSubmitting
                      ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.check_rounded),
                  label: Text(isSubmitting ? 'Updating...' : 'Update Password & Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
