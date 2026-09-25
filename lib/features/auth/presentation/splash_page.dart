import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

@override
  Widget build(BuildContext context) => Scaffold(
          backgroundColor: Colors.orange,
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
              Container(
                  width: 112,
                  height: 112,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(32)),
                  child: Image.asset('assets/images/KTSSlogo.png',
                      fit: BoxFit.contain)),
              const SizedBox(height: 24),
              Text('KTDS',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.deepBlue, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text('Kageyo TSS Discipline System'),
              const SizedBox(height: 28),
              const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2))
          ])));
}
