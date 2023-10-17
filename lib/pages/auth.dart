import 'package:cotally/component/header.dart';
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
          H2("text".i18n),
          TextField(),
        ],
      ),
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
