import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import '../utils/duration_extension.dart';

enum ToastType {
  info,
  success,
  error,
  warning,
}

const successColor = Color.fromARGB(255, 103, 194, 58);
const successColorLight = Color.fromARGB(255, 240, 249, 235);

const warningColor = Color.fromARGB(255, 230, 162, 60);
const warningColorLight = Color.fromARGB(255, 255, 242, 222);

const dangerColor = Color.fromARGB(255, 245, 108, 108);
const dangerColorLight = Color.fromARGB(255, 255, 228, 228);

const infoColor = Color.fromARGB(255, 144, 147, 153);
const infoColorLight = Color.fromARGB(255, 246, 249, 255);

// ignore: constant_identifier_names
const StatusColorMap = {
  ToastType.success: (successColor, successColorLight),
  ToastType.error: (dangerColor, dangerColorLight),
  ToastType.warning: (warningColor, warningColorLight),
  ToastType.info: (infoColor, infoColorLight),
};

const StatusIconMap = {
  ToastType.success: Icons.done,
  ToastType.error: Icons.error,
  ToastType.warning: Icons.warning,
  ToastType.info: Icons.info,
};

// ignore: camel_case_types
class useToast {
  useToast._();
  static final useToast instance = useToast._();
  factory useToast() {
    return instance;
  }

  late BuildContext context;
  final RxList<Widget> _list = RxList<Widget>([]);
  Duration defaultDuration = const Duration(seconds: 3);
  Duration refreshDuration = const Duration(milliseconds: 50);

  void add(
    String msg, {
    ToastType? type,
    Duration? duration,
    Duration? refresh,
    double? opacity,
  }) {
    final (front, bg) = StatusColorMap[type] ?? (Colors.blue, Colors.blue[50]);

    final progressPercent = .0.obs;
    duration ??= defaultDuration;
    refresh ??= refreshDuration;
    final diff = refresh / duration;

    final item = Card(
      color: bg,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(
          children: [
            Icon(
              StatusIconMap[type],
              color: front,
            ),
            Text(
              msg,
              style: TextStyle(color: front),
            ).marginOnly(left: 10),
          ],
        ),
        SizedBox(
            child: Obx(
          () => CircularProgressIndicator(
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(front),
            value: progressPercent.value,
          ),
        ))
      ]).paddingAll(4),
    ).marginOnly(top: 4).marginSymmetric(horizontal: 10).opacity(opacity ?? 1);

    Timer.periodic(refresh, (timer) {
      progressPercent.value += diff;
      if (progressPercent.value >= 1) {
        timer.cancel();
        _list.remove(item);
      }
    });

    _list.add(item);
  }

  void clear() {
    _list.clear();
  }

  RxList<Widget> get list {
    return _list;
  }
}

// ignore: must_be_immutable
class ToastPage extends StatelessWidget {
  Widget child;
  final toast = useToast();
  ToastPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    toast.context = context;
    return Stack(
      children: [
        child,
        Obx(() => IgnorePointer(
              child: ListView(
                children: toast.list,
              ),
            ))
      ],
    );
  }
}

final toast = useToast();
