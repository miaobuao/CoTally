import 'package:cotally/component/header.dart';
import 'package:cotally/component/input.dart';
import 'package:cotally/utils/db.dart';
import 'package:cotally/utils/locale.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:get/get.dart';

class AuthPage extends StatelessWidget {
  late File pubKeyFile;
  final pubKeyFileExists = false.obs;
  String password = '';
  AuthPage({super.key}) {
    final db = DB();
    pubKeyFile = db.pubKeyFile;
    pubKeyFileExists.value = pubKeyFile.existsSync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
          () => pubKeyFileExists.value ? VerifyView() : InputPasswordView()),
    );
  }
}

class InputPasswordView extends StatelessWidget {
  const InputPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              H2("please ".i18n),
            ],
          ),
          Input(
            hint: "hin",
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ).marginOnly(top: 20),
        ],
      ).paddingSymmetric(horizontal: 20),
    );
  }
}

class VerifyView extends StatelessWidget {
  const VerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
