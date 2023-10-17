import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i18n_extension/default.i18n.dart';
import '../component/header.dart';

class AuthPage extends StatelessWidget {
  final counter = 0.obs;
  var acccessToken = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            H1(text: "CoTally".i18n),
            TextField(
              onChanged: (value) {
                acccessToken = value;
              },
              onSubmitted: (value) {},
              decoration: const InputDecoration(
                hintText: "Gitee Access Token",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
              ),
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
