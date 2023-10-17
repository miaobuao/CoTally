import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BorderedTextFieldStyle extends InputDecoration {
  final double? radius;
  final String? hint;
  BorderedTextFieldStyle({this.radius, this.hint})
      : super(
            hintText: hint ?? '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 20)),
            ));
}

class Input extends TextField {
  Input({
    super.key,
    super.decoration,
    ValueChanged<String>? onSubmitted,
    ValueChanged<String>? onChanged,
    RxString? value,
  }) : super(
          onSubmitted: onSubmitted,
          onChanged: value == null
              ? onChanged
              : (str) {
                  value.value = str;
                  if (onChanged != null) onChanged(str);
                },
        );
}
