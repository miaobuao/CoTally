import 'dart:async';
import 'dart:convert' as convert;
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:cotally/utils/models/config.dart';
import 'package:encrypt/encrypt.dart';
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

  void prepare() {
    remoteRepo.reload();
  }

  late String basePath;
  static const passwordLength = 32;
  String _pwd = "";

  Uint8List get pwd {
    var list = Uint8List.fromList(convert.utf8.encode(_pwd));
    return Uint8List.fromList(
        [...list, ...Uint8List(passwordLength - list.length)]);
  }

  setPwd(String value) {
    if (_pwd == value) return;
    _pwd = value;
    prepare();
  }

  late final RemoteRepo remoteRepo = RemoteRepo.get(db: this);

  File get pubKeyFile {
    return File(join(basePath, "key.pub"));
  }

  Future registerPassword(String password) async {
    setPwd(password);
    final String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
    await pubKeyFile.writeAsString(hashed);
  }

  bool checkPassword(String password) {
    if (!pubKeyFile.existsSync()) return false;
    final hashed = pubKeyFile.readAsStringSync();
    if (BCrypt.checkpw(password, hashed)) {
      setPwd(password);
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
  late var config = RemoteRepoConfig(repos: []);

  RemoteRepo.get({required this.db});

  File get file {
    return File(join(db.basePath, "remote-repo.conf"));
  }

  reload() {
    if (db.pwd.isNotEmpty && file.existsSync()) {
      file.readAsString().then((data) {
        final decrypted = decryptByPwd(db.pwd, data);
        final json = convert.jsonDecode(decrypted);
        config = RemoteRepoConfig.fromJson(json);
      });
    }
  }

  add(String org, String accessToken) {
    config.repos.add(RemoteRepoData(
      org: org,
      accessToken: accessToken,
      updateTime: DateTime.now(),
    ));
    save();
  }

  Future<File> save() {
    final data = convert.jsonEncode(config);
    final encrypted = encryptByPwd(db.pwd, data);
    return file.writeAsString(encrypted);
  }
}

(Encrypter, IV) generateEncrypter(Uint8List pwd, {String? iv}) {
  return (
    Encrypter(AES(Key(pwd), mode: AESMode.cbc)),
    iv == null ? IV.fromLength(16) : IV.fromBase64(iv),
  );
}

String encryptByPwd(Uint8List pwd, String plainText) {
  final (encrypter, iv) = generateEncrypter(pwd);
  final encrypted = encrypter.encrypt(plainText, iv: iv);
  return "${iv.base64}.${encrypted.base64}";
}

String decryptByPwd(Uint8List pwd, String encrypted) {
  final splitted = encrypted.split(".");
  encrypted = splitted[1];
  final (encrypter, iv) = generateEncrypter(pwd, iv: splitted[0]);
  final decrypted = encrypter.decrypt(Encrypted.fromBase64(encrypted), iv: iv);
  return decrypted;
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
