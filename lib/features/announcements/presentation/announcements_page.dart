import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/network/ktds_api.dart';
import '../../../core/widgets/ktds_states.dart';

class AnnouncementsPage extends ConsumerStatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  ConsumerState<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends ConsumerState<AnnouncementsPage> {
  late Future<List<Map<String, dynamic>>> _future;
  @override
  void initState() { super.initState(); _future = ref.read(ktdsApiProvider).announcements(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Announcements'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const KtdsLoadingState();
          if (snapshot.hasError) return KtdsErrorState(error: snapshot.error!, onRetry: () => setState(() => _future = ref.read(ktdsApiProvider).announcements()));
          final announcements = snapshot.data!;
          if (announcements.isEmpty) return const KtdsEmptyState(title: 'No announcements', message: 'School announcements will appear here.', icon: Icons.campaign_outlined);
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [for (final item in announcements) _AnnouncementCard(
              title: (item['title'] ?? 'Announcement').toString(),
              message: (item['message'] ?? '').toString(),
              date: (item['createdAt'] ?? '').toString(),
              audience: (item['audience'] ?? 'ALL').toString(),
            )],
          );
        },
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.title,
    required this.message,
    required this.date,
    required this.audience,
  });

  final String title;
  final String message;
  final String date;
  final String audience;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    audience,
                    style: const TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Text(date, style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade400)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.darkText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey.shade700,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
