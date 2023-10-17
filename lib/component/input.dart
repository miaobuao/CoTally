import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BorderedTextFieldDecoration extends InputDecoration {
  final double? radius;
  final String? hint;
  BorderedTextFieldDecoration({
    this.radius,
    this.hint,
  }) : super(
          hintText: hint ?? '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 15.5)),
          ),
        );
}

class Input extends TextField {
  Input({
    super.key,
    InputDecoration? decoration,
    ValueChanged<String>? onSubmitted,
    ValueChanged<String>? onChanged,
    RxString? value,
    String? hint,
    double? borderRadius,
    super.keyboardType,
    super.obscureText,
  }) : super(
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
          decoration: decoration ??
              BorderedTextFieldDecoration(hint: hint, radius: borderRadius),
          onSubmitted: onSubmitted,
          onChanged: value == null
              ? onChanged
              : (str) {
                  value.value = str;
                  if (onChanged != null) onChanged(str);
                },
        );
}
