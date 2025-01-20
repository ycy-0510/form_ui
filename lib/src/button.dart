import 'package:flutter/material.dart';
import 'package:form_ui/src/theme.dart';

class FormPrimaryButton extends StatelessWidget {
  const FormPrimaryButton(
      {required this.onPressed, this.style, required this.child, super.key});

  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: FormTheme.theme(context),
      child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: onPressed,
            style: style,
            child: child,
          )),
    );
  }

  static ButtonStyle dangerStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.red, foregroundColor: Colors.white);
}

class FormSecondaryButton extends StatelessWidget {
  const FormSecondaryButton(
      {required this.onPressed, this.style, required this.child, super.key});

  final VoidCallback onPressed;
  final Widget child;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: FormTheme.theme(context),
      child: SizedBox(
          height: 50,
          child: OutlinedButton(
            onPressed: onPressed,
            style: style,
            child: child,
          )),
    );
  }

  static ButtonStyle dangerStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.red, side: BorderSide(color: Colors.red));
}
