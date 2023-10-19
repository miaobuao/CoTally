import 'package:cotally/component/button.dart';
import 'package:cotally/component/input.dart';
import 'package:cotally/component/toast.dart';
import 'package:cotally/generated/l10n.dart';
import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/header.dart';

// ignore: must_be_immutable
class AccessTokenPage extends StatelessWidget {
  AccessTokenPage({super.key});

  final tokenFieldController = TextEditingController();

  Org org = Org.gitee;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            H1(S.current.appName),
            Input(
              hint: "Gitee Access Token",
              controller: tokenFieldController,
            ).marginOnly(top: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                ButtonGroup(
                  buttons: Buttons.submit,
                  onSubmit: onSubmit,
                ),
              ],
            ).marginOnly(top: 10),
          ],
        ).paddingOnly(left: 20, right: 20),
      ),
    );
  }

  void onSubmit() {
    final token = tokenFieldController.text;
    if (token.isEmpty) {
      toast.add(S.current.cannotBeEmpty(S.current.accessToken),
          type: ToastType.warning);
      return;
    }
    final db = DB();
    db.remoteRepo
        .add(
      org: org,
      accessToken: token,
    )
        .then((success) {
      if (success) {
        toast.add(S.current.done, type: ToastType.success);
        Get.offAllNamed("/home");
      } else {
        toast.add(S.current.wrongAccessToken, type: ToastType.error);
      }
    });
  }
}
