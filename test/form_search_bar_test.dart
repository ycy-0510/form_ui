import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_ui/form_ui.dart';

void main() {
  testWidgets('FormSearchBar renders correctly', (WidgetTester tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormSearchBar(
            controller: controller,
            hintText: 'Custom Hint',
          ),
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Custom Hint'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.clear), findsNothing);
  });

  testWidgets('FormSearchBar clear button works and clears controller',
      (WidgetTester tester) async {
    final controller = TextEditingController();
    controller.text = 'Initial Text';
    String? changedValue;
    bool clearPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(builder: (context, setState) {
            return FormSearchBar(
              controller: controller,
              onChanged: (value) {
                changedValue = value;
                setState(() {});
              },
              onClear: () {
                clearPressed = true;
              },
            );
          }),
        ),
      ),
    );

    // Initial state: text is present, clear button should be visible
    expect(find.byIcon(Icons.clear), findsOneWidget);

    // Tap clear button
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pump();

    // Verify controller cleared
    expect(controller.text, isEmpty);
    // Verify callbacks
    expect(changedValue, isEmpty);
    expect(clearPressed, isTrue);
    // Verify button gone
    expect(find.byIcon(Icons.clear), findsNothing);
  });
}
