import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/models/config.dart';
import 'package:cotally/utils/models/user.dart';
import 'package:cotally/utils/models/workspace.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';
import './encrypt.dart';
import './api/api.dart';

const uuid = Uuid();
typedef StringMapBox = CollectionBox<Map<String, dynamic>>;
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
  late Storage storage = Storage.bind(this);
  late final RemoteRepo remoteRepo = RemoteRepo.bind(this);
  late final Users users = Users.bind(this);
  late final Workspaces workspaces = Workspaces.bind(this);

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

  set collection(BoxCollection collection) {
    storage.collection = collection;
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

class GetStorage {
  final DB db;
  GetStorage.bind(this.db);

  Storage get storage {
    return db.storage;
  }
}

class Users extends GetStorage {
  Users.bind(DB db) : super.bind(db);

  Future<UserModel?> get(String id) async {
    return JsonToModel(UserModel, await users.get(id));
  }

  Future create(String uuid, UserModel user) async {
    return await users.save(uuid, user.toJson());
  }

  JsonBox get users {
    return storage.users;
  }
}

class Workspaces extends GetStorage {
  Workspaces.bind(DB db) : super.bind(db);

  Future create(String workspaceId, WorkspaceModel workspace) async {
    return workspaces.save(workspaceId, workspace.toJson());
  }

  Future<WorkspaceModel?> get(String id) async {
    return JsonToModel(WorkspaceModel, await workspaces.get(id));
  }

  JsonBox get workspaces {
    return storage.workspaces;
  }
}

class RemoteRepo {
  late final DB db;
  late var config = RemoteRepoConfigModel(repos: []);
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
        config = RemoteRepoConfigModel.fromJson(json);
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
    final workspaceId = uuid.v1();
    await db.users.create(
      ownerId,
      UserModel(
        info: owner,
        org: org,
        id: ownerId,
      ),
    );
    config.repos.add(RemoteRepoDataModel(
      org: org,
      accessToken: accessToken,
      updateTime: DateTime.now(),
      id: workspaceId,
      ownerId: ownerId,
    ));
    length.value = config.repos.length;
    await save();
    return true;
  }

  RemoteRepoDataModel get(int idx) {
    return config.repos.elementAt(idx);
  }

  Future<File> save() {
    final data = convert.jsonEncode(config);
    final encrypted = encryptByPwd(db.pwd, data);
    return file.writeAsString(encrypted);
  }
}

typedef Json = Map<String, dynamic>;

class Storage {
  final DB db;
  late final BoxCollection collection;
  Storage.bind(this.db);

  late final users = JsonBox.bind(this, "users");
  late final workspaces = JsonBox.bind(this, "workspaces");
}

class JsonBox {
  final String name;
  final Storage storage;
  JsonBox.bind(this.storage, this.name);

  Future<CollectionBox<String>> get box {
    return storage.collection.openBox<String>(name);
  }

  Future save(String key, Json json) async {
    return await box.then((value) => value.put(key, convert.jsonEncode(json)));
  }

  Future<Json?> get(String key) async {
    final data = await box.then((value) => value.get(key));
    if (data == null) return null;
    return convert.jsonDecode(data);
  }

  Future clear() async {
    return box.then((value) => value.clear());
  }
}

// ignore: non_constant_identifier_names
dynamic JsonToModel(dynamic Model, Json? json) {
  if (json == null) return null;
  return Model.fromJson(json);
}
