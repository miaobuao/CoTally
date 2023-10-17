import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:path_provider/path_provider.dart';

class DB {
  DB._();
  static final DB instance = DB._();
  factory DB() {
    return instance;
  }
  String basePath = '';

  File get pubKeyFile {
    return File(join(basePath, ".keys", "rsa.pub"));
  }
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
