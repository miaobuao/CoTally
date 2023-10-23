import 'package:cotally/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GitAppIconData {
  static const fontFamily = 'GitApps';
  static const github = IconData(0xea0a, fontFamily: fontFamily);
  static const gitlab = IconData(0xe87f, fontFamily: fontFamily);
  static const gitee = IconData(0xe60c, fontFamily: fontFamily);
  static IconData of(Org? org) {
    if (org == Org.gitee) {
      return gitee;
    } else if (org == Org.github) {
      return github;
    }
    return Icons.store_rounded;
  }
}
