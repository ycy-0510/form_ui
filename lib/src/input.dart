import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_ui/src/theme.dart';

class FormTextInput extends StatelessWidget {
  const FormTextInput(
      {this.hintText,
      this.labelText,
      this.onChange,
      this.onEditingComplete,
      this.controller,
      super.key,
      this.errorMsg,
      this.checker,
      this.onFieldSubmitted});
  final TextEditingController? controller;
  final String? hintText, labelText, errorMsg;
  final bool Function(String)? checker;
  final ValueChanged? onChange;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: FormTheme.theme(context),
      child: TextFormField(
        selectionHeightStyle: ui.BoxHeightStyle.strut,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(height: 2),
          labelText: labelText,
        ),
        validator: checker != null
            ? (value) {
                if (checker!(value ?? '')) {
                  return errorMsg ?? 'Please enter text';
                }
                return null;
              }
            : null,
        onChanged: onChange,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
      ),
    );
  }
}

class FormSelect<T> extends StatelessWidget {
  const FormSelect(
      {required this.items,
      required this.hint,
      this.onChange,
      super.key,
      this.value});
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChange;
  final T? value;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: FormTheme.theme(context),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: value == null
                  ? Theme.of(context).colorScheme.error
                  : Colors.grey.shade600,
              style: BorderStyle.solid,
              width: value == null ? 1.6 : 0.8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            borderRadius: BorderRadius.circular(15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            hint: Text(hint),
            value: value,
            onChanged: onChange,
            items: items,
          ),
        ),
      ),
    );
  }
}

class FormCounter extends StatelessWidget {
  const FormCounter(
      {required this.hint,
      required this.value,
      this.max = 10000000,
      this.min = 0,
      this.onChange,
      super.key});
  final String hint;
  final int min, max;
  final int value;
  final ValueChanged<int>? onChange;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: FormTheme.theme(context),
      child: SizedBox(
        height: 50,
        child: Row(
          spacing: 5,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Text(
                hint,
                style: TextStyle(fontSize: 18),
              ),
            ),
            OutlinedButton(
                onPressed: () {
                  if (onChange != null && min < value) {
                    onChange!(value - 1);
                    HapticFeedback.lightImpact();
                  }
                },
                child: Icon(Icons.remove)),
            SizedBox(
              width: 100,
              child: Text(
                '$value',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.center,
              ),
            ),
            OutlinedButton(
                onPressed: () {
                  if (onChange != null && value < max) {
                    onChange!(value + 1);
                    HapticFeedback.lightImpact();
                  }
                },
                child: Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}

class FormCheckBox extends StatelessWidget {
  const FormCheckBox({
    required this.value,
    required this.hint,
    this.onChange,
    super.key,
  });
  final bool value;
  final String hint;
  final ValueChanged? onChange;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: FormTheme.theme(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(value: value, onChanged: onChange),
          Expanded(
            child: GestureDetector(
              child: Text(
                hint,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                if (onChange != null) {
                  onChange!(!value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FormPositionSelect extends StatelessWidget {
  const FormPositionSelect(
      {required this.bytes,
      this.position,
      this.onChenage,
      required this.allowSelectZone,
      this.showAllowSelectZone = false,
      this.flip = false,
      super.key});
  final Uint8List bytes;
  final Offset? position;
  final List<Rect> allowSelectZone;
  final bool showAllowSelectZone;
  final ValueChanged<Offset>? onChenage;
  final bool flip;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: bg(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return FittedBox(
            child: SizedBox(
              width: snapshot.data?.width.toDouble(),
              height: snapshot.data?.height.toDouble(),
              child: GestureDetector(
                onTapDown: (details) {
                  if (onChenage != null) {
                    Offset point = adjustedOffset(
                            details.localPosition,
                            Size(snapshot.data!.width.toDouble(),
                                snapshot.data!.height.toDouble()))
                        .scale(100 / snapshot.data!.width,
                            100 / snapshot.data!.height);
                    if (allowSelectZone.any((zone) => zone.contains(point))) {
                      onChenage!(point);
                    }
                  }
                },
                child: StreamBuilder<int>(
                    stream: blink(),
                    builder: (context, streamSnap) {
                      if (streamSnap.hasData) {
                        return CustomPaint(
                          painter: FormPosisionSelectPainter(
                            snapshot.data!,
                            position,
                            streamSnap.data!,
                            allowSelectZone,
                            showAllowSelectZone,
                            flip,
                          ),
                          size: Size(300, 20),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                    }),
              ),
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

  Offset adjustedOffset(Offset offset, Size size) =>
      flip ? Offset(size.width - offset.dx, size.height - offset.dy) : offset;

  Future<ui.Image> bg() async {
    ui.Image image = await decodeImageFromList(bytes);
    if (flip) {
      image = await rotatedImage(image: image, angle: pi);
    }
    return image;
  }

  Future<ui.Image> rotatedImage(
      {required ui.Image image, required double angle}) {
    var pictureRecorder = ui.PictureRecorder();
    Canvas canvas = Canvas(pictureRecorder);
    final double r =
        sqrt(image.width * image.width + image.height * image.height) / 2;
    final alpha = atan(image.height / image.width);
    final beta = alpha + angle;
    final shiftY = r * sin(beta);
    final shiftX = r * cos(beta);
    final translateX = image.width / 2 - shiftX;
    final translateY = image.height / 2 - shiftY;
    canvas.translate(translateX, translateY);
    canvas.rotate(angle);
    canvas.drawImage(image, Offset.zero, Paint());
    return pictureRecorder.endRecording().toImage(image.width, image.height);
  }

  Stream<int> blink() {
    return Stream.periodic(Duration(milliseconds: 200), (i) {
      return i % 10;
    });
  }
}

class FormPosisionSelectPainter extends CustomPainter {
  final ui.Image bg;
  final Offset? position;
  final int blink;
  final List<Rect> allowSelectZone;
  final bool showAllowSelectZone;
  final bool flip;
  const FormPosisionSelectPainter(this.bg, this.position, this.blink,
      this.allowSelectZone, this.showAllowSelectZone, this.flip);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(bg, Offset.zero, Paint());
    if (showAllowSelectZone) {
      Paint paint = Paint()
        ..color = Colors.blue.withAlpha(200)
        ..style = PaintingStyle.fill;
      for (var zone in allowSelectZone) {
        canvas.drawRect(
            Rect.fromPoints(
                adjustedOffset(
                    zone.topLeft.scale(size.width / 100, size.height / 100),
                    size),
                adjustedOffset(
                    zone.bottomRight.scale(size.width / 100, size.height / 100),
                    size)),
            paint);
      }
    }
    if (position != null) {
      Paint linePaint = Paint()
        ..color = Colors.yellow.withAlpha(50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = blink.toDouble();
      Paint paint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          adjustedOffset(
              position!.scale(size.width / 100, size.height / 100), size),
          10,
          paint);
      for (int i = 0; i <= blink; i++) {
        canvas.drawCircle(
            adjustedOffset(
                position!.scale(size.width / 100, size.height / 100), size),
            10 + i.toDouble(),
            linePaint);
      }
    }
  }

  Offset adjustedOffset(Offset offset, Size size) =>
      flip ? Offset(size.width - offset.dx, size.height - offset.dy) : offset;

  @override
  bool shouldRepaint(FormPosisionSelectPainter oldDelegate) {
    return true;
  }
}
