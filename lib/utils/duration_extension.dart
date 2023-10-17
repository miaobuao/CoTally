import 'package:flutter/material.dart';

extension Division on Duration {
  double operator /(Duration t) {
    return inMicroseconds / t.inMicroseconds;
  }
}
