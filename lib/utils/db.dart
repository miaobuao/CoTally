import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'package:cotally/utils/models/config.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bcrypt/bcrypt.dart';

class DB {
  DB._();
  static final DB instance = DB._();
  factory DB() {
    return instance;
  }
  late String _basePath;
  String? pwd;
  late final RemoteRepo remoteRepo = RemoteRepo.get(db: this);

  set basePath(String value) {
    _basePath = value;
    remoteRepo.reload();
  }

  String get basePath {
    return _basePath;
  }

  File get pubKeyFile {
    return File(join(_basePath, "key.pub"));
  }

  Future registerPassword(String password) async {
    pwd = password;
    final String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
    await pubKeyFile.writeAsString(hashed);
  }

  bool checkPassword(String password) {
    if (!pubKeyFile.existsSync()) return false;
    final hashed = pubKeyFile.readAsStringSync();
    if (BCrypt.checkpw(password, hashed)) {
      pwd = password;
      return true;
    }
    return false;
  }
}

class RemoteRepo {
  RemoteRepo._();
  static final RemoteRepo instance = RemoteRepo._();
  factory RemoteRepo() {
    return instance;
  }

  late final DB db;
  final List<RemoteRepoData> repos = [];

  RemoteRepo.get({required this.db});

  File get file {
    return File(join(db.basePath, "remote-repo.conf"));
  }

  reload() {
    if (db.pwd != null && file.existsSync()) {
      file.readAsBytes();
    }
  }
  // add() {
  //   _repo.add();
  // }
}



// void main() {
//   open.overrideFor(OperatingSystem.linux, _openOnLinux);

//   final db = sqlite3.openInMemory();
//   // Use the database
//   db.dispose();
// }

// DynamicLibrary _openOnLinux() {
//   final scriptDir = File(Platform.script.toFilePath()).parent;
//   final libraryNextToScript = File(join(scriptDir.path, 'sqlite3.so'));
//   return DynamicLibrary.open(libraryNextToScript.path);
// }
