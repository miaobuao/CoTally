import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/main.dart';

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
            TextField(
              decoration: InputDecoration(
                hintText: "hi",
                border: OutlineInputBorder(),
              ),
            ).marginAll(10),
            Counter(),
          ],
        ),
      ),
    );
  }
}
