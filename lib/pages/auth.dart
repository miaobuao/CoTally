// ignore_for_file: must_be_immutable

import 'package:cotally/component/header.dart';
import 'package:cotally/component/input.dart';
import 'package:cotally/component/toast.dart';
import 'package:cotally/utils/db.dart';
import 'package:cotally/utils/delay.dart';
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
    return Obx(
        () => pubKeyFileExists.value ? VerifyView() : InputPasswordView());
  }
}

class InputPasswordView extends StatelessWidget {
  InputPasswordView({super.key});

  final stepperIndex = 0.obs;
  String pwd1 = "";
  String pwd2 = "";
  final firstController = TextEditingController();
  final secondController = TextEditingController();
  final firstFocusNode = FocusNode();
  final secondFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("加密设置".i18n)),
      body: Obx(() => Stepper(
            currentStep: stepperIndex.value,
            onStepCancel: onReset,
            onStepContinue: onContinue,
            steps: [
              Step(
                title: H3("请输入一次密码".i18n),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Input(
                          hint: "密码".i18n,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          controller: firstController,
                          autofocus: true,
                          focusNode: firstFocusNode,
                        ).marginOnly(top: 10),
                      ],
                    ),
                  ],
                ),
              ),
              Step(
                title: H3("请再输入一次密码".i18n),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Input(
                          hint: "密码".i18n,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          controller: secondController,
                          autofocus: true,
                          focusNode: secondFocusNode,
                        ).marginOnly(top: 10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void onReset() {
    firstController.clear();
    secondController.clear();
    pwd1 = '';
    pwd2 = '';
    stepperIndex.value = 0;
    delayedFocus(firstFocusNode, milliseconds: 100);
    toast.clear();
  }

  void onContinue() {
    if (stepperIndex.value == 0) {
      if (firstController.text.isEmpty) {
        toast.add("不可为空".i18n, type: ToastType.warning);
        firstFocusNode.requestFocus();
        return;
      }
      pwd1 = firstController.text;
      firstController.clear();
      stepperIndex.value = 1;
      delayedFocus(secondFocusNode, milliseconds: 200);
    } else if (stepperIndex.value == 1) {
      if (secondController.text.isEmpty) {
        toast.add("不可为空".i18n, type: ToastType.warning);
        secondFocusNode.requestFocus();
        return;
      }
      pwd2 = secondController.text;
      if (pwd1 != pwd2) {
        toast.add("两次输入的密码不相同".i18n, type: ToastType.warning);
        secondFocusNode.requestFocus();
        return;
      }
      secondController.clear();
      secondFocusNode.unfocus();
      toast.add("完成".i18n, type: ToastType.success);
      onSubmit();
    }
  }

  void onSubmit() {}
}

class VerifyView extends StatelessWidget {
  const VerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
