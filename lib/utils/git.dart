import 'dart:isolate';

import 'package:cotally/utils/constants.dart';
import 'package:libgit2dart/libgit2dart.dart';

class Git {
  late final Repository repo;
  final String path;

  Git(this.path) {
    repo = Repository.open(path);
  }

  static Future<Git> clone(String url, path) {
    return Isolate.run(() => Repository.clone(url: url, localPath: path))
        .then((repo) => Git(path));
  }
}
