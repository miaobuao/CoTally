import 'package:flutter/material.dart';
import '../utils/locale.dart';
import '../style/colors.dart';

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

class CancelButton extends TextButton {
  CancelButton({
    required super.onPressed,
    required super.child,
  });
}

class ResetButton extends ElevatedButton {
  ResetButton({
    required super.onPressed,
    required super.child,
  });
}

class ButtonGroup extends StatelessWidget {
  final int buttons;
  final bool? horizontal;
  final void Function()? onSubmit;
  final void Function()? onReset;
  final void Function()? onCancel;
  const ButtonGroup({
    super.key,
    required this.buttons,
    this.horizontal,
    this.onCancel,
    this.onSubmit,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = [];
    if (buttons & Buttons.submit != 0) {
      list.add(SubmitButton(
        onPressed: onSubmit,
        child: Text("确定".i18n),
      ));
    }
    if (buttons & Buttons.reset != 0) {
      list.add(ResetButton(
        onPressed: onReset,
        child: Text("重置".i18n),
      ));
    }
    if (buttons & Buttons.cancel != 0) {
      list.add(CancelButton(
        onPressed: onSubmit,
        child: Text("取消".i18n),
      ));
    }
    if (horizontal ?? true) {
      return Row(
        children: list,
      );
    } else {
      return Column(
        children: list,
      );
    }
  }
}
