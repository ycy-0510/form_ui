// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:form_ui/src/theme.dart';

///Primary Button
class FormPrimaryButton extends StatelessWidget {
  const FormPrimaryButton(
      {required this.onPressed, this.style, required this.child, super.key});

  ///Trigger on Press, set null to disable button
  final VoidCallback? onPressed;
  final Widget child;

  ///Button Style, you can use default style or use [FormPrimaryButton.dangerStyle] to use danger style.
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

  ///Danger Style For Priamry Button
  static ButtonStyle dangerStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.red, foregroundColor: Colors.white);
}

///Secondary Button
class FormSecondaryButton extends StatelessWidget {
  const FormSecondaryButton(
      {required this.onPressed, this.style, required this.child, super.key});

  ///Trigger on Press, set null to disable button
  final VoidCallback? onPressed;
  final Widget child;

  ///Button Style, you can use default style or use [FormSecondaryButton.dangerStyle] to use danger style.
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

  ///Danger Style For Secondary Button
  static ButtonStyle dangerStyle = ElevatedButton.styleFrom(
      foregroundColor: Colors.red, side: BorderSide(color: Colors.red));
}
