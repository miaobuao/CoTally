// ignore_for_file: must_be_immutable
import 'dart:async';
import 'package:cotally/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cotally/component/button.dart';
import 'package:cotally/component/header.dart';
import 'package:cotally/component/input.dart';
import 'package:cotally/component/toast.dart';
import 'package:cotally/utils/db.dart';
import 'package:cotally/utils/delay.dart';

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
    pubKeyFileExists.value = DB().pubKeyFile.existsSync();
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
      appBar: AppBar(title: Text(S.current.encryptionSettings)),
      body: Obx(() => Stepper(
            currentStep: stepperIndex.value,
            onStepCancel: onReset,
            onStepContinue: onContinue,
            steps: [
              Step(
                title: H3(S.current.enterPwd),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Input(
                          hint: S.current.password,
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
                title: H3(S.current.enterPwdAgain),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Input(
                          hint: S.current.password,
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
        toast.add(S.current.cannotBeEmpty(S.current.password),
            type: ToastType.warning);
        firstFocusNode.requestFocus();
        return;
      }
      pwd1 = firstController.text;
      firstController.clear();
      stepperIndex.value = 1;
      delayedFocus(secondFocusNode, milliseconds: 200);
    } else if (stepperIndex.value == 1) {
      if (secondController.text.isEmpty) {
        toast.add(S.current.cannotBeEmpty(S.current.password),
            type: ToastType.warning);
        secondFocusNode.requestFocus();
        return;
      }
      pwd2 = secondController.text;
      if (pwd1 != pwd2) {
        toast.add(S.current.twoPwdDifferent, type: ToastType.warning);
        secondFocusNode.requestFocus();
        return;
      }
      secondController.clear();
      secondFocusNode.unfocus();
      toast.add(S.current.done, type: ToastType.success);
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
          H2(S.current.verify).marginOnly(bottom: 20),
          Input(
            onChanged: (value) {},
            obscureText: true,
            hint: S.current.enterPwd,
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
          )
        ],
      )).paddingSymmetric(horizontal: 20),
    );
  }

  void submit() {
    if (pwd.isEmpty) {
      toast.add(S.current.cannotBeEmpty(S.current.password),
          type: ToastType.warning);
      return;
    }
    final db = DB();
    if (db.checkPassword(pwd)) {
      toast.add(S.current.done, type: ToastType.success);
      if (db.remoteRepo.lastOpenedIdFile.existsSync()) {
        Get.offAllNamed("/workspace", arguments: db.lastOpenedId);
      } else {
        Get.offAllNamed("/access_token");
      }
    } else {
      toast.add(S.current.authenticationFailed, type: ToastType.error);
    }
    fieldController.clear();
  }
}
