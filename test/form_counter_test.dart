import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_ui/form_ui.dart';

void main() {
  testWidgets('FormCounter default step is 1', (WidgetTester tester) async {
    int value = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) {
            return FormCounter(
              hint: 'Counter',
              value: value,
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

    expect(find.byIcon(Icons.remove), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(value, 1);
    expect(find.text('1'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(value, 0);
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('FormCounter custom step is 5', (WidgetTester tester) async {
    int value = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) {
            return FormCounter(
              hint: 'Counter',
              value: value,
              step: 5,
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

    expect(find.text('-5'), findsOneWidget);
    expect(find.text('+5'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    await tester.tap(find.text('+5'));
    await tester.pump();
    expect(value, 5);
    expect(find.text('5'), findsOneWidget);

    await tester.tap(find.text('-5'));
    await tester.pump();
    expect(value, 0);
    expect(find.text('0'), findsOneWidget);
  });
}
