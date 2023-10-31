import 'dart:io';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:path/path.dart';

class Config {
  Config._();
  static final Config instance = Config._();
  factory Config() => instance;

  late String basePath;
  late Uint8List tokenDerivatinoKey;
  late final BoxCollection collection;

  File get lastOpenedIdFile {
    final path = join(config.basePath, "lastOpenedRepo.id");
    return File(path);
  }

  String? get lastOpenedId {
    if (lastOpenedIdFile.existsSync()) {
      return lastOpenedIdFile.readAsStringSync();
    } else {
      return null;
    }
  }

  set lastOpenedId(String? id) {
    if (id == null) {
      lastOpenedIdFile.deleteSync();
    } else {
      lastOpenedIdFile.writeAsStringSync(id);
    }
  }

  clear() async {
    if (lastOpenedIdFile.existsSync()) {
      lastOpenedIdFile.deleteSync();
    }
  }
}

final config = Config();
