// ignore_for_file: must_be_immutable
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:cotally/component/button.dart';
import 'package:cotally/component/header.dart';
import 'package:cotally/component/input.dart';
import 'package:cotally/component/toast.dart';
import 'package:cotally/utils/db.dart';
import 'package:cotally/utils/delay.dart';
import 'package:cotally/utils/locale.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final pubKeyFileExists = false.obs;

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (DB().pubKeyFile.existsSync()) {
        pubKeyFileExists.value = true;
      } else {
        pubKeyFileExists.value = false;
      }
      if (!mounted) {
        timer.cancel();
      }
    });
    super.initState();
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
                          maxLength: 32,
                          inputFormatters: Aes256PwdInputFormatter,
                          onSubmitted: (value) {
                            onContinue();
                          },
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
                          maxLength: 32,
                          autofocus: true,
                          inputFormatters: Aes256PwdInputFormatter,
                          focusNode: secondFocusNode,
                          onSubmitted: (value) {
                            onContinue();
                          },
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

  void onSubmit() {
    final db = DB();
    if (pwd1 == pwd2 && pwd1.isNotEmpty) {
      db.registerPassword(pwd1);
    }
  }
}

class VerifyView extends StatelessWidget {
  VerifyView({super.key});

  final fieldController = TextEditingController();
  final fieldFocusNode = FocusNode();
  String pwd = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          H2("身份验证".i18n).marginOnly(bottom: 20),
          Input(
            onChanged: (value) {},
            obscureText: true,
            hint: "请输入密码".i18n,
            controller: fieldController,
            focusNode: fieldFocusNode,
            inputFormatters: Aes256PwdInputFormatter,
            maxLength: 32,
            autofocus: true,
          ),
          Row(
            children: [
              const Spacer(),
              ButtonGroup(
                buttons: Buttons.submit | Buttons.reset,
                onSubmit: () {
                  pwd = fieldController.text;
                  submit();
                },
                onReset: () {
                  fieldController.clear();
                  fieldFocusNode.requestFocus();
                },
              ),
            ],
          ).paddingOnly(top: 10)
        ],
      )).paddingSymmetric(horizontal: 20),
    );
  }

  void submit() {
    if (pwd.isEmpty) {
      toast.add("不可为空".i18n, type: ToastType.warning);
      return;
    }
    final db = DB();
    if (db.checkPassword(pwd)) {
      toast.add("完成".i18n, type: ToastType.success);
      if (db.remoteRepo.file.existsSync()) {
      } else {
        Get.offAllNamed("/access_token");
      }
    } else {
      toast.add("认证失败".i18n, type: ToastType.error);
    }
    fieldController.clear();
  }
}
