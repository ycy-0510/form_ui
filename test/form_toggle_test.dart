import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_ui/form_ui.dart';

void main() {
  testWidgets('FormToggle renders ElevatedButton when value is true', (WidgetTester tester) async {
    bool value = true;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FormToggle(
          value: value,
          hint: 'Toggle Hint',
          onChange: (v) {},
        ),
      ),
    ));

    expect(find.text('Toggle Hint'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNothing);
  });

  testWidgets('FormToggle renders OutlinedButton when value is false', (WidgetTester tester) async {
    bool value = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FormToggle(
          value: value,
          hint: 'Toggle Hint',
          onChange: (v) {},
        ),
      ),
    ));

    expect(find.text('Toggle Hint'), findsOneWidget);
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);
  });

  testWidgets('FormToggle toggles value when pressed', (WidgetTester tester) async {
    bool value = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return FormToggle(
              value: value,
              hint: 'Toggle Hint',
              onChange: (v) {
                setState(() {
                  value = v;
                });
              },
            );
          },
        ),
      ),
    ));

    // Initially false -> OutlinedButton
    expect(value, false);
    expect(find.byType(OutlinedButton), findsOneWidget);

    // Tap button
    await tester.tap(find.byType(OutlinedButton));
    await tester.pump();
    // Animation in progress (pump(Duration) would forward time)
    // But since we are checking functional state, pump() settles microtasks.
    // If AnimatedSwitcher delays the removal of old widget, we might see both momentarily if not pumped enough.
    // Let's settle.
    await tester.pumpAndSettle();

    // Now true -> ElevatedButton
    expect(value, true);
    expect(find.byType(ElevatedButton), findsOneWidget);
    // OutlinedButton should be gone after settle
    expect(find.byType(OutlinedButton), findsNothing);

    // Tap button again
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Back to false -> OutlinedButton
    expect(value, false);
    expect(find.byType(OutlinedButton), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNothing);
  });

  testWidgets('FormToggle has AnimatedSwitcher', (WidgetTester tester) async {
    bool value = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: FormToggle(
          value: value,
          hint: 'Toggle Hint',
          onChange: (v) {},
        ),
      ),
    ));
    expect(find.byType(AnimatedSwitcher), findsOneWidget);
  });
}
