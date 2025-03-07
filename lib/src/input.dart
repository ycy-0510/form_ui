// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_ui/src/theme.dart';

///Text Input
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
      this.onFieldSubmitted,
      this.isPassword = false,
      this.tapOutsideCloseKeyboard = false,
      this.inputType,
      this.inputAction,
      this.focusNode,
      this.autofillHints,
      this.maxLine,
      this.minLine,
      this.disabled = false});

  ///Text Input Controller
  final TextEditingController? controller;

  ///String for Text Input
  final String? hintText, labelText, errorMsg;

  /// Error checker
  final bool Function(String)? checker;

  ///Trigger when value change
  final ValueChanged? onChange;

  ///Trigger when Editing Complete
  final VoidCallback? onEditingComplete;

  ///Trigger when Field Submit
  final ValueChanged<String>? onFieldSubmitted;

  ///Choose the Text Input is for password
  final bool isPassword;

  ///Auto close keyboard by tap outside
  final bool tapOutsideCloseKeyboard;

  ///Choose input type for text input, use [TextInputType.emailAddress] for emails and [TextInputType.number] for numbers
  final TextInputType? inputType;

  ///Choose input action
  final TextInputAction? inputAction;

  ///You can close open keyboard by using [FocusNode]
  final FocusNode? focusNode;

  ///Max line ui display
  final int? maxLine;

  ///Min line ui display
  final int? minLine;

  ///Use [AutofillHints] set auto fill hint
  final List<String>? autofillHints;

  ///Text input will be readonly when set true
  final bool disabled;

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
        readOnly: disabled,
        obscureText: isPassword,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
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
        onTapOutside: tapOutsideCloseKeyboard
            ? (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            : null,
        keyboardType: inputType,
        textInputAction: inputAction,
        focusNode: focusNode,
        maxLines: isPassword ? 1 : (maxLine ?? 1),
        minLines: isPassword ? 1 : (minLine ?? 1),
        autofillHints: autofillHints,
      ),
    );
  }
}

///Select Input
class FormSelect<T> extends StatelessWidget {
  const FormSelect(
      {required this.items,
      required this.hint,
      this.onChange,
      super.key,
      this.value,
      this.disabled = false});

  ///Select Itmes
  final List<DropdownMenuItem<T>> items;

  ///Trigger when Value Chaneg
  final ValueChanged<T?>? onChange;

  /// Default Value
  final T? value;

  /// hint
  final String hint;

  ///set true to disable
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: FormTheme.theme(context),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
              color: value == null ? Theme.of(context).colorScheme.error : Colors.grey.shade600,
              style: BorderStyle.solid,
              width: value == null ? 1.6 : 0.8),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            borderRadius: BorderRadius.circular(15),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
            hint: Text(hint),
            value: value,
            onChanged: (v) {
              HapticFeedback.lightImpact();
              if (onChange != null) {
                onChange!(v);
              }
            },
            items: disabled ? null : items,
          ),
        ),
      ),
    );
  }
}

///Counter Input
class FormCounter extends StatelessWidget {
  const FormCounter(
      {required this.hint,
      required this.value,
      this.max = 10000000,
      this.min = 0,
      this.onChange,
      super.key});

  /// hint
  final String hint;

  /// Max and Min value for counter
  final int min, max;

  ///Default value
  final int value;

  ///Trigger when Value Change
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

///Checkbox Input
class FormCheckBox extends StatelessWidget {
  const FormCheckBox({
    required this.value,
    required this.hint,
    this.onChange,
    super.key,
  });

  ///Default Value
  final bool value;

  /// hint
  final String hint;

  ///Trigger when Value Chage
  final ValueChanged? onChange;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: FormTheme.theme(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
              value: value,
              onChanged: (v) {
                HapticFeedback.lightImpact();
                if (onChange != null) {
                  onChange!(v);
                }
              }),
          Expanded(
            child: GestureDetector(
              child: Text(
                hint,
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                HapticFeedback.lightImpact();
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

///Position Select Input
class FormPositionSelect extends StatelessWidget {
  FormPositionSelect(
      {required this.bytes,
      this.position,
      this.onChange,
      required this.allowSelectZone,
      this.showAllowSelectZone = false,
      this.flip = false,
      this.tapOffset = Offset.zero,
      this.allowedOffset = 10,
      super.key});

  ///Image Bytes
  final Uint8List bytes;

  /// Selected Position
  final Offset? position;

  /// List of Allow Select Zone
  final List<Rect> allowSelectZone;

  ///Show Allow Select Zone on Image for Debug
  final bool showAllowSelectZone;

  ///Trigger when Value Change
  final ValueChanged<Offset>? onChange;

  ///Value for Flip or not
  final bool flip;

  ///The difference between intended and actual touch position
  final Offset tapOffset;

  ///
  final double allowedOffset;

  final StreamController<bool> _selectZone = StreamController();

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
                  Offset point = _adjustedOffset(details.localPosition - tapOffset,
                          Size(snapshot.data!.width.toDouble(), snapshot.data!.height.toDouble()))
                      .scale(100 / snapshot.data!.width, 100 / snapshot.data!.height);
                  if (allowSelectZone.any((zone) => zone.contains(point))) {
                    HapticFeedback.lightImpact();
                    if (onChange != null) {
                      onChange!(point);
                    }
                  } else if (allowSelectZone.any((zone) => Rect.fromCenter(
                          center: zone.center,
                          width: zone.width + allowedOffset,
                          height: zone.height + allowedOffset)
                      .contains(point))) {
                    HapticFeedback.lightImpact();
                    if (onChange != null) {
                      onChange!(_fitToZone(point, allowSelectZone));
                    }
                  } else {
                    _selectZone.add(true);
                    Future.delayed(Duration(milliseconds: 300)).then((_) {
                      _selectZone.add(false);
                    });
                  }
                },
                child: StreamBuilder(
                    stream: _selectZone.stream,
                    builder: (context, selectSnapShot) {
                      return StreamBuilder<int>(
                          stream: _blink(),
                          builder: (context, blinkStreamSnap) {
                            if (blinkStreamSnap.hasData) {
                              return CustomPaint(
                                painter: _FormPosisionSelectPainter(
                                  snapshot.data!,
                                  position,
                                  blinkStreamSnap.data!,
                                  allowSelectZone,
                                  showAllowSelectZone || (selectSnapShot.data ?? false),
                                  flip,
                                ),
                                size: Size(300, 20),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }
                          });
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

  Offset _adjustedOffset(Offset offset, Size size) =>
      flip ? Offset(size.width - offset.dx, size.height - offset.dy) : offset;

  Future<ui.Image> _bg() async {
    ui.Image image = await decodeImageFromList(bytes);
    if (flip) {
      image = await _rotatedImage(image: image, angle: pi);
    }
    return image;
  }

  Offset _fitToZone(Offset point, List<Rect> zones) {
    Offset minPoint = Offset.zero;
    //point to point
    double minDis = double.infinity;
    for (final zone in zones) {
      if (zone.left < point.dx && point.dx < zone.right) {
        //line top bottom
        if (point.dy < zone.top) {
          if ((point.dy - zone.top).abs() < minDis) {
            minDis = (point.dy - zone.top).abs();
            minPoint = Offset(point.dx, zone.top);
          }
        } else {
          if ((point.dy - zone.bottom).abs() < minDis) {
            minDis = (point.dy - zone.bottom).abs();
            minPoint = Offset(point.dx, zone.bottom);
          }
        }
      } else if (zone.top < point.dy && point.dy < zone.bottom) {
        //line left right
        if (point.dx < zone.left) {
          if ((point.dx - zone.left).abs() < minDis) {
            minDis = (point.dx - zone.left).abs();
            minPoint = Offset(zone.left, point.dy);
          }
        } else {
          if ((point.dx - zone.right).abs() < minDis) {
            minDis = (point.dx - zone.right).abs();
            minPoint = Offset(zone.right, point.dy);
          }
        }
      } else {
        //point
        final testPoints = [zone.topLeft, zone.topRight, zone.bottomRight, zone.bottomLeft];
        for (final testPoint in testPoints) {
          if ((point - testPoint).distance < minDis) {
            minDis = (point - testPoint).distance;
            minPoint = testPoint;
          }
        }
      }
    }
    return minPoint;
  }

  Future<ui.Image> _rotatedImage({required ui.Image image, required double angle}) {
    var pictureRecorder = ui.PictureRecorder();
    Canvas canvas = Canvas(pictureRecorder);
    final double r = sqrt(image.width * image.width + image.height * image.height) / 2;
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

  Stream<int> _blink() {
    return Stream.periodic(Duration(milliseconds: 200), (i) {
      return i % 10;
    });
  }
}

class _FormPosisionSelectPainter extends CustomPainter {
  final ui.Image bg;
  final Offset? position;
  final int blink;
  final List<Rect> allowSelectZone;
  final bool showAllowSelectZone;
  final bool flip;
  const _FormPosisionSelectPainter(this.bg, this.position, this.blink, this.allowSelectZone,
      this.showAllowSelectZone, this.flip);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(bg, Offset.zero, Paint());
    if (showAllowSelectZone) {
      Paint paint = Paint()
        ..color = Colors.black.withAlpha(150)
        ..style = PaintingStyle.fill;
      for (var zone in allowSelectZone) {
        canvas.drawRect(
            Rect.fromPoints(
                adjustedOffset(zone.topLeft.scale(size.width / 100, size.height / 100), size),
                adjustedOffset(zone.bottomRight.scale(size.width / 100, size.height / 100), size)),
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
          adjustedOffset(position!.scale(size.width / 100, size.height / 100), size), 10, paint);
      for (int i = 0; i <= blink; i++) {
        canvas.drawCircle(
            adjustedOffset(position!.scale(size.width / 100, size.height / 100), size),
            10 + i.toDouble(),
            linePaint);
      }
    } else {
      Paint linePaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), linePaint);
    }
  }

  Offset adjustedOffset(Offset offset, Size size) =>
      flip ? Offset(size.width - offset.dx, size.height - offset.dy) : offset;

  @override
  bool shouldRepaint(_FormPosisionSelectPainter oldDelegate) {
    return true;
  }
}

///Position View
class FormPositionView extends StatelessWidget {
  FormPositionView({required this.bytes, required this.positions, super.key});

  ///Image Bytes
  final Uint8List bytes;

  /// Selected Position
  final List<Offset> positions;

  final StreamController<bool> _selectZone = StreamController();

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
              child: StreamBuilder(
                  stream: _selectZone.stream,
                  builder: (context, selectSnapShot) {
                    return StreamBuilder<int>(
                        stream: _blink(),
                        builder: (context, blinkStreamSnap) {
                          if (blinkStreamSnap.hasData) {
                            return CustomPaint(
                              painter: _FormPosisionViewPainter(
                                  snapshot.data!, positions, blinkStreamSnap.data!),
                              size: Size(300, 20),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator.adaptive(),
                            );
                          }
                        });
                  }),
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
    ui.Image image = await decodeImageFromList(bytes);
    return image;
  }

  Stream<int> _blink() {
    return Stream.periodic(Duration(milliseconds: 200), (i) {
      return i % 10;
    });
  }
}

class _FormPosisionViewPainter extends CustomPainter {
  final ui.Image bg;
  final List<Offset> positions;
  final int blink;
  const _FormPosisionViewPainter(this.bg, this.positions, this.blink);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(bg, Offset.zero, Paint());
    for (final position in positions) {
      Paint linePaint = Paint()
        ..color = Colors.yellow.withAlpha(50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = blink.toDouble();
      Paint paint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill;
      canvas.drawCircle(position.scale(size.width / 100, size.height / 100), 10, paint);
      for (int i = 0; i <= blink; i++) {
        canvas.drawCircle(
            position.scale(size.width / 100, size.height / 100), 10 + i.toDouble(), linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(_FormPosisionViewPainter oldDelegate) {
    return true;
  }
}
