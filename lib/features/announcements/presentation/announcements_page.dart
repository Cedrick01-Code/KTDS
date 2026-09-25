import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';

class AnnouncementsPage extends ConsumerWidget {
  const AnnouncementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Announcements'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _AnnouncementCard(
            title: 'End of Term Notice',
            message: 'All discipline records must be finalized by the end of this week. Thank you for your cooperation.',
            date: '20 Sep 2026',
            audience: 'ALL STAFF',
          ),
          _AnnouncementCard(
            title: 'Uniform Policy Update',
            message: 'Please note the slight changes in the school uniform policy effective next term. Details attached.',
            date: '15 Sep 2026',
            audience: 'PARENTS & STUDENTS',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_rounded),
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
