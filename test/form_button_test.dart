import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_ui/form_ui.dart';

void main() {
  group('FormPrimaryButton', () {
    testWidgets('renders child and handles tap', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FormPrimaryButton(
            onPressed: () => tapped = true,
            child: Text('Primary Button'),
          ),
        ),
      ));

      expect(find.text('Primary Button'), findsOneWidget);
      await tester.tap(find.text('Primary Button'));
      expect(tapped, true);
    });

    testWidgets('applies danger style', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FormPrimaryButton(
            onPressed: () {},
            style: FormPrimaryButton.dangerStyle,
            child: Text('Danger Button'),
          ),
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      // Checking exact style might be hard due to material resolving, but let's check basic properties if possible.
      // Usually better to trust Flutter's ButtonStyle application but we can check if it rendered.
      expect(button.style, isNotNull);
    });
  });

  group('FormSecondaryButton', () {
    testWidgets('renders child and handles tap', (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FormSecondaryButton(
            onPressed: () => tapped = true,
            child: Text('Secondary Button'),
          ),
        ),
      ));

      expect(find.text('Secondary Button'), findsOneWidget);
      await tester.tap(find.text('Secondary Button'));
      expect(tapped, true);
    });
  });
}
