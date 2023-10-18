import 'package:cotally/component/button.dart';
import 'package:cotally/component/input.dart';
import 'package:cotally/component/toast.dart';
import 'package:cotally/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/locale.dart';
import '../component/header.dart';

class AccessTokenPage extends StatelessWidget {
  AccessTokenPage({super.key});

  final tokenFieldController = TextEditingController();
  final usernameController = TextEditingController();

  String org = 'gitee';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            H1("CoTally".i18n),
            Input(
              hint: "用户名".i18n,
              controller: usernameController,
            ).marginOnly(top: 20),
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
      toast.add("Access Token不可为空".i18n, type: ToastType.warning);
      return;
    }
    final db = DB();
    String username = usernameController.text;
    if (username.isEmpty) {
      username = "用户 ".i18n + DateTime.now().toIso8601String();
    }
    db.remoteRepo.add(
      org: org,
      accessToken: token,
      username: usernameController.text,
    );
    Get.offAllNamed("/home");
  }
}
