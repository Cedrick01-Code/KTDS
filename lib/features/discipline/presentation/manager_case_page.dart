import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';

class ManagerCasePage extends ConsumerStatefulWidget {
  const ManagerCasePage({super.key, required this.studentId});
  final String studentId;

  @override
  ConsumerState<ManagerCasePage> createState() => _ManagerCasePageState();
}

class _ManagerCasePageState extends ConsumerState<ManagerCasePage> {
  bool _isRemoved = false;

  void _showRemovalModal() {
    final reasonController = TextEditingController();
    String category = 'Discipline Threshold Exceeded (<= 18/40)';

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: const [
                Icon(Icons.remove_circle_outline, color: AppColors.danger, size: 28),
                SizedBox(width: 12),
                Text('Confirm Student Removal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.danger)),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Under Kageyo TSS procedures, removing a student will update their official status to REMOVED, generate an official removal letter PDF, and send an automatic WhatsApp notification to the parent/guardian.',
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(labelText: 'Removal Category'),
              items: const [
                DropdownMenuItem(value: 'Discipline Threshold Exceeded (<= 18/40)', child: Text('Threshold Exceeded (<= 18/40)')),
                DropdownMenuItem(value: 'Serious Misconduct', child: Text('Serious Misconduct')),
                DropdownMenuItem(value: 'Repeated Unapproved Absences', child: Text('Repeated Absences')),
                DropdownMenuItem(value: 'Property Damage / Theft', child: Text('Property Damage / Theft')),
              ],
              onChanged: (val) => category = val!,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Detailed justification / Manager notes',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.description_outlined),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
              onPressed: () {
                Navigator.pop(context);
                setState(() => _isRemoved = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Student REMOVED. Official PDF letter generated & parent notified via WhatsApp.'),
                    backgroundColor: AppColors.danger,
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Confirm Official Removal'),
            ),
          ],
        ),
      ),
    );
  }

  void _showPDFPreview() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('KTDS Official Letter Preview'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('KAGEYO TSS', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryBlue)),
                  Text('Discipline Management System (KTDS)', style: TextStyle(fontSize: 12)),
                  Divider(),
                  Text('Official Threshold Notice (18/40)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger)),
                  SizedBox(height: 6),
                  Text('Student: Patrick N. (S5 Software Development)'),
                  Text('Score: 18 / 40'),
                  Text('Parent: N. Patrick (+250788000001)'),
                  SizedBox(height: 8),
                  Text('Status: PDF generated & ready for delivery.', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF Letter downloaded.')));
            },
            child: const Text('Download PDF'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discipline Threshold Review'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _StudentHeader(
            name: 'Patrick N.',
            classInfo: 'S5 Software Development',
            score: _isRemoved ? 0 : 18,
            status: _isRemoved ? 'REMOVED' : '18/40 THRESHOLD',
          ),
          const SizedBox(height: 20),
          _WhatsAppStatusCard(),
          const SizedBox(height: 24),
          const _SectionTitle(title: 'Term Behavior History'),
          const SizedBox(height: 12),
          const _HistoryItem(date: '23 Sep 2026', incident: 'Uniform violation', points: 7, staff: 'Matron (Direct)'),
          const _HistoryItem(date: '22 Sep 2026', incident: 'Disrespect', points: 5, staff: 'DOD (Direct)'),
          const _HistoryItem(date: '20 Sep 2026', incident: 'Late to class', points: 2, staff: 'Teacher (Approved)'),
          const SizedBox(height: 32),
          if (!_isRemoved) ...[
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('WhatsApp 18/40 notice resent to parent (+250788000001) with PDF attachment.')),
                );
              },
              icon: const Icon(Icons.chat_bubble_outline_rounded),
              label: const Text('Send Parent WhatsApp Notice'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: _showPDFPreview,
              icon: const Icon(Icons.description_outlined),
              label: const Text('View Official 18/40 PDF Letter'),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _showRemovalModal,
              icon: const Icon(Icons.remove_circle_outline, color: AppColors.danger),
              label: const Text('Initiate Official Removal', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.danger),
              ),
              child: Column(
                children: const [
                  Icon(Icons.remove_circle, color: AppColors.danger, size: 36),
                  SizedBox(height: 8),
                  Text('STUDENT REMOVED', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.danger)),
                  Text('Official removal PDF notice sent to parent via WhatsApp.', textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _WhatsAppStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.lightBlue,
              child: Icon(Icons.mark_chat_read_rounded, color: AppColors.primaryBlue),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Parent WhatsApp Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text('Parent: N. Patrick (+250788000001)\nStatus: DELIVERED (PDF attached)', style: TextStyle(fontSize: 12, color: Colors.blueGrey)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
              child: const Text('DELIVERED', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudentHeader extends StatelessWidget {
  const _StudentHeader({required this.name, required this.classInfo, required this.score, required this.status});
  final String name;
  final String classInfo;
  final int score;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.mist,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.lightBlue,
              child: Icon(Icons.person, size: 36, color: AppColors.deepBlue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  Text(classInfo, style: TextStyle(color: Colors.blueGrey.shade600)),
                ],
              ),
            ),
            _ScoreBadge(score: score, status: status),
          ],
        ),
      ),
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.score, required this.status});
  final int score;
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = status == 'REMOVED' ? AppColors.danger : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Text('$score / 40', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
          Text(status, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800));
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({required this.date, required this.incident, required this.points, required this.staff});
  final String date;
  final String incident;
  final int points;
  final String staff;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.danger.withValues(alpha: .1),
          child: const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
        ),
        title: Text(incident, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('$date \u00B7 By $staff'),
        trailing: Text('-$points', style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w900, fontSize: 16)),
      ),
    );
  }
}
