import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_ui/form_ui.dart';

void main() {
  group('FormTextInput', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FormTextInput(
            hintText: 'Hint',
            labelText: 'Label',
          ),
        ),
      ));

      expect(find.text('Hint'), findsOneWidget);
      expect(find.text('Label'), findsOneWidget);
    });

    testWidgets('accepts input', (WidgetTester tester) async {
      String value = '';
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FormTextInput(
            onChange: (v) => value = v,
          ),
        ),
      ));

      await tester.enterText(find.byType(TextFormField), 'Hello');
      expect(value, 'Hello');
    });

    testWidgets('validates input', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FormTextInput(
            checker: (v) => v.isEmpty,
            errorMsg: 'Error',
          ),
        ),
      ));

      // Trigger validation (e.g., by entering text then clearing it if auto-validate,
      // but FormTextInput uses autovalidateMode disabled by default, let's see.
      // Actually it passes validator to TextFormField.
      // Usually validator is called on form save or field submit/loss of focus depending on config.
      // Let's rely on finding the error text after pumping.

      // Since we didn't wrapping Form, we might need to trigger validation manually or use AutovalidateMode if exposed.
      // The current implementation doesn't expose autovalidate mode.

      // However, usually we can test validator logic by wrapping in a Form and calling validate.

      final formKey = GlobalKey<FormState>();
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Form(
            key: formKey,
            child: FormTextInput(
              checker: (v) => v.isEmpty,
              errorMsg: 'Error',
            ),
          ),
        ),
      ));

      formKey.currentState!.validate();
      await tester.pump();
      expect(find.text('Error'), findsOneWidget);
    });
  });

  group('FormSelect', () {
    testWidgets('selectable', (WidgetTester tester) async {
      String? value;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FormSelect<String>(
            hint: 'Select',
            items: [
              DropdownMenuItem(value: 'A', child: Text('A')),
              DropdownMenuItem(value: 'B', child: Text('B')),
            ],
            onChange: (v) => value = v,
          ),
        ),
      ));

      expect(find.text('Select'), findsOneWidget);
      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('A').last);
      await tester.pumpAndSettle();
      expect(value, 'A');
    });
  });

  group('FormCheckBox', () {
    testWidgets('toggles', (WidgetTester tester) async {
      bool value = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return FormCheckBox(
                hint: 'Check me',
                value: value,
                onChange: (v) => setState(() => value = v),
              );
            },
          ),
        ),
      ));

      expect(find.text('Check me'), findsOneWidget);
      await tester.tap(find.text('Check me'));
      await tester.pump();
      expect(value, true);
    });
  });
}
