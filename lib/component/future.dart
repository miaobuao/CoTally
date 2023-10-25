import 'package:cotally/component/placeholder.dart';
import 'package:flutter/material.dart';
import "package:skeletonizer/skeletonizer.dart";

Color baseColorOf(BuildContext context) {
  return Colors.grey.shade50;
}

Color highlightColorOf(BuildContext context) {
  return Colors.grey.shade50;
}

class FutureText extends TextPlaceholder {
  final Future<String> future;

  const FutureText({
    super.key,
    required this.future,
    required super.width,
    super.height,
    super.spacing,
    super.row,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) => isWaiting(snapshot.connectionState)
            ? Skeletonizer(child: super.build(context))
            : Text(snapshot.data ?? ""));
  }
}

bool isWaiting(ConnectionState state) {
  return state != ConnectionState.done;
}
