import 'package:flutter/material.dart';
import 'package:flutter_fusioncharts_example/examples_menu.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('chart gallery presents its navigation menu', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Menu()));

    expect(find.text('Choose Chart Type'), findsOneWidget);
    expect(find.text('Single Series'), findsOneWidget);
    expect(find.text('Multi Series'), findsOneWidget);
  });
}
