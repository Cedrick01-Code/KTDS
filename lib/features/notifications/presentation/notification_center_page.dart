import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/ktds_api.dart';
import '../../../core/widgets/ktds_states.dart';

class NotificationCenterPage extends ConsumerStatefulWidget {
  const NotificationCenterPage({super.key});

  @override
  ConsumerState<NotificationCenterPage> createState() => _NotificationCenterPageState();
}

class _NotificationCenterPageState extends ConsumerState<NotificationCenterPage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = ref.read(ktdsApiProvider).notifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const KtdsLoadingState();
          if (snapshot.hasError) return KtdsErrorState(error: snapshot.error!, onRetry: () => setState(() => _future = ref.read(ktdsApiProvider).notifications()));
          final notifications = snapshot.data!;
          if (notifications.isEmpty) return const KtdsEmptyState(title: 'You are all caught up', message: 'New school and discipline updates will appear here.', icon: Icons.notifications_none_rounded);
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final item = notifications[index];
              return _NotificationItem(
                id: (item['_id'] ?? item['id'] ?? '').toString(),
                title: (item['title'] ?? 'KTDS notification').toString(),
                message: (item['message'] ?? '').toString(),
                type: (item['type'] ?? 'NOTICE').toString(),
                date: (item['createdAt'] ?? '').toString(),
                isRead: item['isRead'] == true,
                onRead: () async {
                  final id = (item['_id'] ?? item['id'] ?? '').toString();
                  if (id.isNotEmpty) await ref.read(ktdsApiProvider).markNotificationRead(id);
                  if (mounted) setState(() => _future = ref.read(ktdsApiProvider).notifications());
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  const _NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.date,
    required this.isRead,
    required this.onRead,
  });

  final String id;
  final String title;
  final String message;
  final String type;
  final String date;
  final bool isRead;
  final VoidCallback onRead;

  @override
  Widget build(BuildContext context) {
    final color = type == 'THRESHOLD' ? AppColors.danger : AppColors.primaryBlue;

    return Material(
      color: isRead ? Colors.transparent : AppColors.lightBlue.withValues(alpha: 0.3),
      child: InkWell(
        onTap: onRead,
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
        ),
      ),
    );
  }
}
