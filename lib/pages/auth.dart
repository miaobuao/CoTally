// ignore_for_file: must_be_immutable
import 'dart:async';
import 'package:cotally/component/dialog.dart';
import 'package:cotally/generated/l10n.dart';
import 'package:cotally/utils/config.dart';
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
  bool pubKeyFileExists = db.pubKeyFile.existsSync();

  @override
  void initState() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      updateKeyState(db.pubKeyFile.existsSync());
      if (!mounted) {
        timer.cancel();
      }
    });
    super.initState();
  }

  updateKeyState(bool value) {
    if (value != pubKeyFileExists) {
      setState(() {
        pubKeyFileExists = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return pubKeyFileExists ? VerifyView() : InputPasswordView();
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
            onStepContinue: () {
              onContinue(context);
            },
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
                            onContinue(context);
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
                            onContinue(context);
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

  void onContinue(BuildContext context) {
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
      final db = DB();
      if (pwd1 == pwd2 && pwd1.isNotEmpty) {
        showDialog(context: context, builder: (context) => LoadingDialog());
        db.registerPassword(pwd1).then((value) {
          Navigator.pop(context);
          toast.add(S.current.done, type: ToastType.success);
        });
      }
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
                  submit(context);
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

  void submit(BuildContext context) {
    if (pwd.isEmpty) {
      toast.add(S.current.cannotBeEmpty(S.current.password),
          type: ToastType.warning);
      return;
    }
    final db = DB();
    showDialog(context: context, builder: (context) => LoadingDialog());
    db.checkPassword(pwd).then((key) {
      Navigator.pop(context);
      if (key == null) {
        toast.add(S.current.authenticationFailed, type: ToastType.error);
      } else {
        config.tokenDerivationKey = key;
        toast.add(S.current.done, type: ToastType.success);
        final lastOpened = config.lastOpenedId;
        if (lastOpened == null) {
          Get.offAllNamed("/access_token");
        } else {
          Get.offAllNamed("/workspace");
        }
      }
      fieldController.clear();
    });
  }
}
