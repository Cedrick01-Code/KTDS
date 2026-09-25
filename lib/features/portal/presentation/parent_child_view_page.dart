import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';

class ParentChildViewPage extends ConsumerWidget {
  const ParentChildViewPage({super.key, required this.studentId});
  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Behavior Detail'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ChildSummary(name: 'Patrick N.', classInfo: 'S5 Software Development', score: 32),
          const SizedBox(height: 24),
          Text('Timeline', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          _TimelineEvent(date: '19 Sep', event: 'Fighting', points: -4, status: 'Direct Deduction'),
          _TimelineEvent(date: '17 Sep', event: 'Late to class', points: -2, status: 'Approved'),
          _TimelineEvent(date: '12 Sep', event: 'Disrespect', points: -3, status: 'Direct Deduction'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded),
            label: const Text('Download Last School Letter'),
          ),
        ],
      ),
    );
  }
}

class _ChildSummary extends StatelessWidget {
  const _ChildSummary({required this.name, required this.classInfo, required this.score});
  final String name;
  final String classInfo;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.deepBlue,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.lightBlue,
            child: Icon(Icons.person, size: 42, color: AppColors.deepBlue),
          ),
          const SizedBox(height: 16),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
          Text(classInfo, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatItem(label: 'Discipline Score', value: '$score/40'),
              const SizedBox(width: 32),
              _StatItem(label: 'Status', value: score <= 18 ? 'Action Required' : 'Monitoring'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _TimelineEvent extends StatelessWidget {
  const _TimelineEvent({required this.date, required this.event, required this.points, required this.status});
  final String date;
  final String event;
  final int points;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(event, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('$date \u00B7 $status'),
        trailing: Text('$points', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w900, fontSize: 16)),
      ),
    );
  }
}
