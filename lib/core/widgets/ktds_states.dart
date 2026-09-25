import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

class KtdsLoadingState extends StatelessWidget {
  const KtdsLoadingState({super.key, this.label = 'Loading KTDS data...'});
  final String label;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 14),
          Text(label),
        ]),
      );
}

class KtdsErrorState extends StatelessWidget {
  const KtdsErrorState({super.key, required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.cloud_off_rounded, size: 48, color: AppColors.warning),
            const SizedBox(height: 12),
            const Text('We could not load this KTDS workspace.',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            Text('Check the connection to the school server and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.blueGrey.shade600)),
            const SizedBox(height: 16),
            FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh), label: const Text('Try again')),
          ]),
        ),
      );
}

class KtdsEmptyState extends StatelessWidget {
  const KtdsEmptyState({super.key, required this.title, required this.message, this.icon = Icons.inbox_outlined});
  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 48, color: AppColors.primaryBlue),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey.shade600)),
          ]),
        ),
      );
}

class KtdsStatusBadge extends StatelessWidget {
  const KtdsStatusBadge(this.label, {super.key, this.color});
  final String label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? AppColors.primaryBlue;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label.replaceAll('_', ' '),
          style: TextStyle(color: badgeColor, fontSize: 11, fontWeight: FontWeight.w800)),
    );
  }
}
