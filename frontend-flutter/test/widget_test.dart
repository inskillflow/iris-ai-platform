import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/main.dart';

void main() {
  testWidgets('App renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const IrisApp());
    expect(find.text('Iris ML Demo'), findsOneWidget);
    expect(find.byIcon(Icons.science_outlined), findsOneWidget);
  });
}
