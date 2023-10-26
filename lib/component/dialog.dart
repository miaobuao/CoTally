// ignore_for_file: non_constant_identifier_names

import 'package:cotally/component/input.dart';
import 'package:cotally/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fc/flutter_fc.dart';

final LoadingDialog = defineFC(((props) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 26.0),
            child: Text(S.current.loading),
          )
        ],
      ),
    )));

class ReconfirmDialog extends StatelessWidget {
  final Widget title, content;
  const ReconfirmDialog(
      {super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(S.current.abort)),
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(S.current.goOn)),
      ],
    );
  }

  Future<bool> show(BuildContext context) async {
    final bool flag = await showDialog(context: context, builder: build);
    return flag;
  }
}
