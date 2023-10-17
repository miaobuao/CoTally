import 'package:flutter/material.dart';

class BorderedTextFieldStyle extends InputDecoration {
  double? radius;
  String? hint;
  BorderedTextFieldStyle({this.radius, this.hint})
      : super(
            hintText: hint ?? '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 20)),
            ));
}
