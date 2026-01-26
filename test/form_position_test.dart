import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_ui/form_ui.dart';

const String _base64Pixel =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';
final Uint8List _pixelBytes = base64Decode(_base64Pixel);

void main() {
  testWidgets('FormPositionSelect renders', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FormPositionSelect(
            bytes: _pixelBytes,
            allowSelectZone: [Rect.fromLTWH(0, 0, 10, 10)],
            onChange: (offset) {},
          ),
        ),
      ));

      // Initial pump starts the future builder
      await tester.pump();
      // Wait for future to complete (image decoding)
      await tester.pump(Duration(seconds: 1));
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  testWidgets('FormPositionView renders', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FormPositionView(
            bytes: _pixelBytes,
            positions: [Offset(0, 0)],
          ),
        ),
      ));

      await tester.pump();
      await tester.pump(Duration(seconds: 1));
      expect(find.byType(CustomPaint), findsWidgets);
    });
  });

  testWidgets('FormTapOffsetTool renders', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: FormTapOffsetTool(
            bytes: _pixelBytes,
            onTap: (offset) {},
          ),
        ),
      ));

      await tester.pump();
      await tester.pump(Duration(seconds: 1));

      expect(find.byType(CustomPaint), findsWidgets);
    });
  });
}
