import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pages_and_pals/widgets/app_text_field.dart';
import 'package:pages_and_pals/widgets/primary_button.dart';

void main() {
  testWidgets('AppTextField renders its label and hint', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppTextField(label: 'E-mail', hintText: 'voce@email.com'),
        ),
      ),
    );

    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('voce@email.com'), findsOneWidget);
  });

  testWidgets('PrimaryButton triggers its callback when tapped', (WidgetTester tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrimaryButton(label: 'Entrar', onPressed: () => tapped = true),
        ),
      ),
    );

    await tester.tap(find.text('Entrar'));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
