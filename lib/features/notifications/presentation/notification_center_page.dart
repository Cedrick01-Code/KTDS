import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';

class NotificationCenterPage extends ConsumerWidget {
  const NotificationCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all as read'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: const [
          _NotificationItem(
            title: 'Deduction Approved',
            message: 'Patrick N. received -3 points for Late to class.',
            type: 'DEDUCTION',
            date: '2 mins ago',
            isRead: false,
          ),
          _NotificationItem(
            title: 'Threshold Reached',
            message: 'Diane M. has reached 18/40 points. Review required.',
            type: 'THRESHOLD',
            date: '1 hour ago',
            isRead: false,
          ),
          _NotificationItem(
            title: 'School Announcement',
            message: 'Mid-term discipline meeting scheduled for Friday.',
            type: 'ANNOUNCEMENT',
            date: '5 hours ago',
            isRead: true,
          ),
        ],
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    required this.isRead,
  });

  final String title;
  final String message;
  final String type;
  final String date;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    final color = type == 'THRESHOLD' ? AppColors.danger : AppColors.primaryBlue;

    return Container(
      color: isRead ? null : AppColors.lightBlue.withValues(alpha: 0.3),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(
            type == 'THRESHOLD' ? Icons.warning_amber_rounded : Icons.notifications_none_rounded,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(message, style: TextStyle(color: Colors.blueGrey.shade700)),
            const SizedBox(height: 4),
            Text(date, style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade400)),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}
