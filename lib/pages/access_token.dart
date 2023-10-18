import 'package:cotally/component/button.dart';
import 'package:cotally/component/input.dart';
import 'package:cotally/utils/db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i18n_extension/default.i18n.dart';
import '../component/header.dart';

class AccessTokenPage extends StatelessWidget {
  AccessTokenPage({super.key});

  final tokenFieldController = TextEditingController();

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
              hint: "Gitee Access Token",
              controller: tokenFieldController,
            ).marginOnly(top: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                ButtonGroup(
                  buttons: Buttons.submit | Buttons.reset,
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
    final db = DB();
    db.remoteRepo.add(org, token);
    Get.offAllNamed("/home");
  }
}
