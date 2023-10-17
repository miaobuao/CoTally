import 'package:cotally/component/input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i18n_extension/default.i18n.dart';
import '../component/header.dart';

class AccessTokenPage extends StatelessWidget {
  final counter = 0.obs;
  var acccessToken = "";

  AccessTokenPage({super.key});

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
            ).marginOnly(top: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("reset"),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("submit"),
                ),
              ],
            ).marginOnly(top: 10),
          ],
        ).paddingOnly(left: 20, right: 20),
      ),
    );
  }
}
