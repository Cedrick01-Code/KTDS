import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../auth/presentation/auth_controller.dart';

class RecordIncidentPage extends ConsumerStatefulWidget {
  const RecordIncidentPage({super.key});

  @override
  ConsumerState<RecordIncidentPage> createState() => _RecordIncidentPageState();
}

class _RecordIncidentPageState extends ConsumerState<RecordIncidentPage> {
  int _currentStep = 0;

  String? _selectedStudent = 'Patrick N. (S5 Software Development)';
  String? _selectedCategory = 'Late to class';
  int _points = 2;
  final _reasonController = TextEditingController(text: 'Arrived 20 minutes late without valid excuse.');

  final List<String> _students = [
    'Patrick N. (S5 Software Development)',
    'Amina K. (S3 Business Studies)',
    'Joel M. (S2 Geography)',
  ];

  final List<String> _categories = [
    'Late to class',
    'Uniform violation',
    'Disrespect',
    'Absence',
    'Fighting',
    'Property damage',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep == 5) {
      _submit();
      return;
    }
    setState(() => _currentStep++);
  }

  void _previous() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submit() async {
    final role = ref.read(authRoleProvider) ?? 'TEACHER';
    final isDirect = role == 'DOD' || role == 'PATRON' || role == 'MATRON';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isDirect
              ? 'Direct deduction applied immediately! New score calculated.'
              : 'Deduction submitted! Pending Admin approval.',
        ),
        backgroundColor: isDirect ? AppColors.success : AppColors.primaryBlue,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.read(authRoleProvider) ?? 'TEACHER';
    final isDirect = role == 'DOD' || role == 'PATRON' || role == 'MATRON';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Record Discipline Incident'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: isDirect ? AppColors.lightBlue : const Color(0xFFFFF3D6),
            child: Row(
              children: [
                Icon(
                  isDirect ? Icons.shield_rounded : Icons.pending_actions_rounded,
                  color: isDirect ? AppColors.deepBlue : AppColors.warning,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    isDirect
                        ? '$role Role: Direct deduction authority active. Score will update immediately upon submission.'
                        : 'Teacher Role: Deductions require Admin approval before reducing student discipline score.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isDirect ? AppColors.darkText : const Color(0xFF7A5900),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: _next,
              onStepCancel: _previous,
              controlsBuilder: (context, details) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: details.onStepContinue,
                          child: Text(_currentStep == 5 ? (isDirect ? 'Apply Direct Deduction' : 'Submit for Admin Approval') : 'Continue'),
                        ),
                      ),
                      if (_currentStep > 0) ...[
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Back'),
                        ),
                      ]
                    ],
                  ),
                );
              },
              steps: [
                Step(
                  isActive: _currentStep >= 0,
                  title: const Text('Select Student'),
                  content: Column(
                    children: _students
                        .map((s) => RadioListTile<String>(
                              title: Text(s),
                              value: s,
                              groupValue: _selectedStudent,
                              onChanged: (value) => setState(() => _selectedStudent = value),
                            ))
                        .toList(),
                  ),
                ),
                Step(
                  isActive: _currentStep >= 1,
                  title: const Text('Category'),
                  content: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories
                        .map((c) => ChoiceChip(
                              label: Text(c),
                              selected: _selectedCategory == c,
                              onSelected: (v) => setState(() => _selectedCategory = v ? c : null),
                            ))
                        .toList(),
                  ),
                ),
                Step(
                  isActive: _currentStep >= 2,
                  title: const Text('Deduction Points'),
                  content: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: AppColors.danger),
                        onPressed: () => setState(() => _points = _points > 1 ? _points - 1 : 1),
                      ),
                      Text('-$_points Points', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.danger)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: AppColors.danger),
                        onPressed: () => setState(() => _points++),
                      ),
                    ],
                  ),
                ),
                Step(
                  isActive: _currentStep >= 3,
                  title: const Text('Reason / Incident Details'),
                  content: TextField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: 'Provide detailed justification for this incident...'),
                  ),
                ),
                Step(
                  isActive: _currentStep >= 4,
                  title: const Text('Evidence'),
                  content: OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Evidence photo/document attached.')));
                    },
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Attach photo or written explanation'),
                  ),
                ),
                Step(
                  isActive: _currentStep >= 5,
                  title: const Text('Review & Confirm'),
                  content: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.lightBlue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Student: $_selectedStudent', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 4),
                        Text('Violation Category: $_selectedCategory'),
                        const SizedBox(height: 4),
                        Text('Point Deduction: -$_points Points', style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('Reason: ${_reasonController.text}'),
                        const SizedBox(height: 6),
                        Text('Submission Mode: ${isDirect ? 'Direct Deduction (Immediate)' : 'Pending Admin Approval'}',
                            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.blueGrey.shade700)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
