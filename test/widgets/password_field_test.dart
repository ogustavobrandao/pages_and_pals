import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pages_and_pals/widgets/password_field.dart';

void main() {
  testWidgets('PasswordField toggles obscureText and button label when tapped', (tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PasswordField(label: 'Senha', controller: controller),
        ),
      ),
    );

    expect(find.text('Mostrar'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isTrue);

    await tester.tap(find.text('Mostrar'));
    await tester.pump();

    expect(find.text('Ocultar'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isFalse);

    await tester.tap(find.text('Ocultar'));
    await tester.pump();

    expect(find.text('Mostrar'), findsOneWidget);
    expect(tester.widget<TextField>(find.byType(TextField)).obscureText, isTrue);
  });
}
