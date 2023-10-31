import 'dart:async';

import 'package:flutter/material.dart';

void delayedFocus(
  FocusNode focusNode, {
  int days = 0,
  int hours = 0,
  int minutes = 0,
  int seconds = 0,
  int milliseconds = 0,
  int microseconds = 0,
}) {
  Future.delayed(
      Duration(
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds,
      ), () {
    focusNode.requestFocus();
  });
}

Future<T> waitFor<T>(
  T? value, {
  int days = 0,
  int hours = 0,
  int minutes = 0,
  int seconds = 0,
  int milliseconds = 10,
  int microseconds = 0,
}) async {
  final duration = Duration(
    days: days,
    hours: hours,
    minutes: minutes,
    seconds: seconds,
    milliseconds: milliseconds,
    microseconds: microseconds,
  );
  while (value == null) {
    await Future.delayed(duration);
  }
  return value;
}
