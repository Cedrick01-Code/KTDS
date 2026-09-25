import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import 'auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    final success = await ref.read(authControllerProvider.notifier).login(
      _emailController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      if (ref.read(mustChangePasswordProvider)) {
        context.go('/forced-password-change');
      } else {
        context.go(homeForRole(ref.read(authRoleProvider)));
      }
    } else if (mounted) {
      final error = ref.read(authControllerProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error?.toString() ?? 'Login failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isSubmitting = authState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _BrandHeader(),
                    const SizedBox(height: 42),
                    Text('Welcome back',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text('Sign in to manage your school discipline workspace.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.blueGrey.shade600)),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          labelText: 'Email or phone',
                          prefixIcon: Icon(Icons.person_outline)),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? 'Enter your email or phone'
                              : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onFieldSubmitted: (_) => _login(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'Show password'
                              : 'Hide password',
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                      validator: (value) => value == null || value.length < 6
                          ? 'Use at least 6 characters'
                          : null,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please contact your school administrator to reset your password.')),
                          ),
                          child: const Text('Forgot password?')),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: isSubmitting ? null : _login,
                      icon: isSubmitting
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.login_rounded),
                      label: Text(isSubmitting ? 'Signing in...' : 'Sign in'),
                    ),
                    const SizedBox(height: 26),
                    Row(children: [
                      Expanded(child: Divider(color: Colors.blueGrey.shade100)),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text('KTDS')),
                      Expanded(child: Divider(color: Colors.blueGrey.shade100))
                    ]),
                    const SizedBox(height: 18),
                    TextButton(
                        onPressed: () => context.push('/register'),
                        child: const Text('Create account with an invitation')),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
              color: AppColors.lightBlue,
              borderRadius: BorderRadius.circular(28)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child:
                Image.asset('assets/images/KTSSlogo.png', fit: BoxFit.contain),
          ),
        ),
        const SizedBox(height: 18),
        Text('Kageyo TSS',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800, color: AppColors.deepBlue)),
        const SizedBox(height: 4),
        Text('DISCIPLINE SYSTEM',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                letterSpacing: 1.8,
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w700)),
      ],
    );
  }
}

String homeForRole(String? role) => switch (role) {
      'ADMIN' => '/admin/dashboard',
      'SCHOOL_MANAGER' => '/manager/dashboard',
      'TEACHER' || 'DOD' || 'PATRON' || 'MATRON' => '/staff/dashboard',
      _ => '/login',
    };