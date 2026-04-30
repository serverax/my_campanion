import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_companion/app.dart';

void main() {
  testWidgets('App boots and renders the home page', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RahmaApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Welcome'), findsOneWidget);
  });
}
