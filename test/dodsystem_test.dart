import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ktds/app/app.dart';
import 'package:ktds/features/auth/presentation/login_page.dart';
import 'package:ktds/features/auth/presentation/register_page.dart';

void main() {
  testWidgets('shows KTDS splash screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: KtdsApp()));

    expect(find.text('KTDS'), findsOneWidget);
    expect(find.text('Kageyo TSS Discipline System'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
  });

  test('role redirection excludes parent access', () {
    expect(homeForRole('ADMIN'), '/admin/dashboard');
    expect(homeForRole('SCHOOL_MANAGER'), '/manager/dashboard');
    expect(homeForRole('TEACHER'), '/staff/dashboard');
    expect(homeForRole('PARENT'), '/login');
  });

  testWidgets('register form only exposes staff roles', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: RegisterPage()),
      ),
    );

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();

    expect(find.text('Teacher'), findsOneWidget);
    expect(find.text('DOD'), findsOneWidget);
    expect(find.text('Patron'), findsOneWidget);
    expect(find.text('Matron'), findsOneWidget);
    expect(find.text('Parent'), findsNothing);
    expect(find.text('Admin'), findsNothing);
    expect(find.text('School Manager'), findsNothing);
  });
}
