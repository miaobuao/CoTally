import 'package:flutter/material.dart';
import '../style/colors.dart';
import '../generated/l10n.dart';

class Buttons {
  static const submit = 1;
  static const reset = 2;
  static const cancel = 4;
}

class SubmitButton extends ElevatedButton {
  SubmitButton({
    required super.onPressed,
    required super.child,
  });
}

class ResetButton extends OutlinedButton {
  ResetButton({
    required super.onPressed,
    required super.child,
  });
}

class CancelButton extends TextButton {
  CancelButton({
    required super.onPressed,
    required super.child,
  });
}

class ButtonGroup extends StatelessWidget {
  final int buttons;
  final Axis? direction;
  double? spacing;
  final void Function()? onSubmit;
  final void Function()? onReset;
  final void Function()? onCancel;
  ButtonGroup({
    super.key,
    required this.buttons,
    this.direction,
    this.onCancel,
    this.onSubmit,
    this.onReset,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = [];
    if (buttons & Buttons.reset != 0) {
      list.add(ResetButton(
        onPressed: onReset,
        child: Text(S.current.reset),
      ));
    }
    if (buttons & Buttons.submit != 0) {
      list.add(SubmitButton(
        onPressed: onSubmit,
        child: Text(S.current.confirm),
      ));
    }
    if (buttons & Buttons.cancel != 0) {
      list.add(CancelButton(
        onPressed: onCancel,
        child: Text(S.current.cancel),
      ));
    }
    return Wrap(
      spacing: spacing ?? 10,
      direction: direction ?? Axis.horizontal,
      children: list,
    );
  }
}
