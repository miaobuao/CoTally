import 'package:flutter/material.dart';

class H1 extends StatelessWidget {
  final String text;

  const H1({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.displayLarge);
  }
}

class H2 extends StatelessWidget {
  final String text;

  const H2({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.displayMedium);
  }
}

class H3 extends StatelessWidget {
  final String text;

  const H3({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.displaySmall);
  }
}
