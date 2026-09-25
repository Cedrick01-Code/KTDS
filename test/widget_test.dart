// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ktds/app/app.dart';

void main() {
  testWidgets('KTDS starts with branded splash screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: KtdsApp()));
    expect(find.text('KTDS'), findsOneWidget);
    expect(find.text('Kageyo TSS Discipline System'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 900));
  });
}
