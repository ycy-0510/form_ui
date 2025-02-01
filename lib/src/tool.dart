import 'dart:developer';
import 'dart:math' hide log;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///Tool to adjust use tap position
class FormTapOffsetTool extends StatefulWidget {
  const FormTapOffsetTool({required this.bytes, this.onTap, super.key});

  ///Trigger when User Tap, function will return an Offset between intended and actual touch position
  final ValueChanged<Offset>? onTap;

  ///Image Bytes, use to get size of image
  final Uint8List bytes;

  @override
  State<FormTapOffsetTool> createState() => _FormTapOffsetToolState();
}

class _FormTapOffsetToolState extends State<FormTapOffsetTool> {
  int width = 0;
  int height = 0;
  Offset intendedPosition = Offset.zero;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 200)).then((_) => nextPosition());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _bg(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return FittedBox(
            child: SizedBox(
              width: snapshot.data?.width.toDouble(),
              height: snapshot.data?.height.toDouble(),
              child: GestureDetector(
                  onTapDown: (details) {
                    if ((details.localPosition - intendedPosition).distance <
                        min(height, width) * 0.3) {
                      if (kDebugMode) {
                        log(
                            (details.localPosition - intendedPosition)
                                .toString(),
                            name: 'TapOffset');
                        if (widget.onTap != null) {
                          widget
                              .onTap!(details.localPosition - intendedPosition);
                        }
                      }
                      Future.delayed(Duration(milliseconds: 200))
                          .then((_) => nextPosition());
                    }
                  },
                  child: StreamBuilder<int>(
                      stream: _blink(),
                      builder: (context, blinkStreamSnap) {
                        if (blinkStreamSnap.hasData) {
                          return CustomPaint(
                            painter: _FormTapOffsetPainter(
                              intendedPosition,
                              blinkStreamSnap.data!,
                            ),
                            size: Size(300, 20),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                      })),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  Future<ui.Image> _bg() async {
    final image = await decodeImageFromList(widget.bytes);
    width = image.width;
    height = image.height;
    return image;
  }

  void nextPosition() {
    setState(() {
      intendedPosition =
          Offset(Random().nextDouble() * width, Random().nextDouble() * height);
    });
  }

  Stream<int> _blink() {
    return Stream.periodic(Duration(milliseconds: 200), (i) {
      return i % 10;
    });
  }
}

class _FormTapOffsetPainter extends CustomPainter {
  final Offset? position;
  final int blink;
  const _FormTapOffsetPainter(
    this.position,
    this.blink,
  );
  @override
  void paint(Canvas canvas, Size size) {
    Paint borderPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.drawRRect(
        RRect.fromLTRBR(0, 0, size.width, size.height, Radius.circular(25)),
        borderPaint);
    if (position != null) {
      Paint linePaint = Paint()
        ..color = Colors.yellow.withAlpha(50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = blink.toDouble();
      Paint paint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.fill;
      canvas.drawCircle(position!, 10, paint);
      for (int i = 0; i <= blink; i++) {
        canvas.drawCircle(position!, 10 + i.toDouble(), linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(_FormTapOffsetPainter oldDelegate) {
    return true;
  }
}
