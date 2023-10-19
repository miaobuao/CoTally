import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/models/config.dart';
import 'package:cotally/utils/models/user.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';
import './encrypt.dart';
import './api/api.dart';

const uuid = Uuid();

// ignore: constant_identifier_names
const PASSWORD_LENGTH = 32;

class DB {
  DB._();
  static final DB instance = DB._();
  factory DB() {
    return instance;
  }
  String _pwd = "";
  late String basePath;
  late BoxCollection collection;
  late final RemoteRepo remoteRepo = RemoteRepo.bind(this);
  late final Users users = Users.bind(this);

  void prepare() {
    remoteRepo.reload();
  }

  Uint8List get pwd {
    var list = Uint8List.fromList(convert.utf8.encode(_pwd));
    return Uint8List.fromList(
        [...list, ...Uint8List(PASSWORD_LENGTH - list.length)]);
  }

  setPwd(String value) {
    if (_pwd == value) return;
    _pwd = value;
    prepare();
  }

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

class Users {
  final DB db;
  Users.bind(this.db);

  Future<User?> get(String id) async {
    return (await box).get(id);
  }

  Future add(String uuid, User user) async {
    return (await box).put(uuid, user);
  }

  Future<CollectionBox<User>> get box {
    return db.collection.openBox("users");
  }
}

class Workspace {
  final DB db;
  Workspace.bind(this.db);
}

class RemoteRepo {
  late final DB db;
  late var config = RemoteRepoConfig(repos: []);
  var length = 0.obs;

  RemoteRepo.bind(this.db);

  File get file {
    return File(join(db.basePath, "remote-repo.conf"));
  }

  reload() {
    if (db.pwd.isNotEmpty && file.existsSync()) {
      file.readAsString().then((data) {
        final decrypted = decryptByPwd(db.pwd, data);
        final json = convert.jsonDecode(decrypted);
        config = RemoteRepoConfig.fromJson(json);
        length.value = config.repos.length;
      });
    }
  }

  Future<bool> add({
    required Org org,
    required String accessToken,
  }) async {
    final owner = await apiOf(org).checkAccessToken(accessToken: accessToken);
    if (owner == null) {
      return false;
    }
    final ownerId = uuid.v1();
    await db.users.add(ownerId, User(info: owner, org: org, id: ownerId));
    config.repos.add(RemoteRepoData(
      org: org,
      accessToken: accessToken,
      updateTime: DateTime.now(),
      id: uuid.v1(),
      ownerId: ownerId,
    ));
    length.value = config.repos.length;
    save();
    return true;
  }

  RemoteRepoData get(int idx) {
    return config.repos.elementAt(idx);
  }

  Future<File> save() {
    final data = convert.jsonEncode(config);
    final encrypted = encryptByPwd(db.pwd, data);
    return file.writeAsString(encrypted);
  }
}
