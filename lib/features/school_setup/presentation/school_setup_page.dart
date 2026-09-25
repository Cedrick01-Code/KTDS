import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';

class SchoolSetupPage extends ConsumerStatefulWidget {
  const SchoolSetupPage({super.key});

  @override
  ConsumerState<SchoolSetupPage> createState() => _SchoolSetupPageState();
}

class _SchoolSetupPageState extends ConsumerState<SchoolSetupPage> {
  int _currentStep = 0;
  
  // Step 1: School Info
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  
  // Step 2: Academic Year
  final _academicYearController = TextEditingController(text: '2026\u20132027');
  
  // Step 3: Terms
  final List<String> _terms = ['Term 1', 'Term 2', 'Term 3'];
  
  // Step 4: Classes
  final List<String> _classes = ['S1 A', 'S1 B', 'S2 A', 'S2 B'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _academicYearController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
    } else {
      _finishSetup();
    }
  }

  void _previous() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _finishSetup() async {
    // In a real app, call API here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('School setup completed!')),
    );
    context.go('/admin/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Initial School Setup'),
        leading: _currentStep > 0 
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _previous)
            : null,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: _next,
        onStepCancel: _previous,
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: details.onStepContinue,
                    child: Text(_currentStep == 3 ? 'Finish Setup' : 'Next Step'),
                  ),
                ),
              ],
            ),
          );
        },
        steps: [
          Step(
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            title: const Text('School'),
            content: _SchoolInfoStep(
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
              addressController: _addressController,
            ),
          ),
          Step(
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            title: const Text('Year'),
            content: TextField(
              controller: _academicYearController,
              decoration: const InputDecoration(labelText: 'Academic Year Name'),
            ),
          ),
          Step(
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            title: const Text('Terms'),
            content: Column(
              children: [
                for (final term in _terms)
                  ListTile(
                    title: Text(term),
                    leading: const Icon(Icons.calendar_today, color: AppColors.primaryBlue),
                  ),
              ],
            ),
          ),
          Step(
            isActive: _currentStep >= 3,
            state: _currentStep > 3 ? StepState.complete : StepState.indexed,
            title: const Text('Classes'),
            content: Column(
              children: [
                for (final className in _classes)
                  ListTile(
                    title: Text(className),
                    leading: const Icon(Icons.class_outlined, color: AppColors.primaryBlue),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SchoolInfoStep extends StatelessWidget {
  const _SchoolInfoStep({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'School Name'),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: emailController,
          decoration: const InputDecoration(labelText: 'School Email'),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: phoneController,
          decoration: const InputDecoration(labelText: 'School Phone'),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: addressController,
          decoration: const InputDecoration(labelText: 'School Address'),
        ),
      ],
    );
  }
}
