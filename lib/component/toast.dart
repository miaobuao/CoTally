import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import '../style/colors.dart';

enum ToastType {
  info,
  success,
  error,
  warning,
}

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
  Duration refreshDuration = const Duration(milliseconds: 100);

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
    final diff = refresh.inMilliseconds / duration.inMilliseconds;

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
            width: 20,
            height: 20,
            child: Obx(
              () => CircularProgressIndicator(
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(front),
                value: progressPercent.value,
              ),
            ))
      ]).paddingAll(6),
    ).marginOnly(top: 4).marginSymmetric(horizontal: 10).opacity(opacity ?? 1);

    Timer.periodic(refresh, (timer) {
      progressPercent.value += diff;
      if (progressPercent.value >= 1) {
        timer.cancel();
        _list.remove(item);
      }
    });

    _list.insert(0, item);
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
