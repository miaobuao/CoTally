import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../component/header.dart';

class AuthPage extends StatelessWidget {
  final counter = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const H1(text: "CoTally"),
            ListView(
              children: [
                TextField(
                  onSubmitted: (value) {},
                  decoration: const InputDecoration(
                    hintText: "Gitee Access Token",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                ),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("submit"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("submit"),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("submit"),
                    ),
                  ],
                )
              ],
            ).marginOnly(top: 20, left: 20, right: 20)
          ],
        ),
      ),
    );
  }
}
