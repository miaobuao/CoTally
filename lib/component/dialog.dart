// ignore_for_file: non_constant_identifier_names

import 'package:cotally/component/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fc/flutter_fc.dart';

final LoadingDialog = defineFC(((props) => const AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.only(top: 26.0),
            child: Text("正在加载，请稍后..."),
          )
        ],
      ),
    )));
