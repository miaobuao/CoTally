import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:cotally/stores/stores.dart';
import 'package:cotally/utils/api/base_api.dart';
import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/models/config.dart';
import 'package:cotally/utils/models/user.dart';
import 'package:cotally/utils/models/workspace.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';
import 'crypto.dart';
import './api/api.dart';

const uuid = Uuid();
typedef StringMapBox = CollectionBox<Map<String, dynamic>>;
// ignore: constant_identifier_names
const PASSWORD_LENGTH = 32;

final store = Store();

class DB {
  DB._();
  static final DB instance = DB._();
  factory DB() => instance;

  String _pwd = "";
  late String basePath;
  late Storage storage = Storage.bind(this);
  late final remoteRepo = RemoteRepo.bind(this);
  late final users = Users.bind(this);
  late final workspaces = Workspaces.bind(this);
  late final fs = FS.bind(this);

  void prepare() {
    remoteRepo.reload();
  }

  String get pwd {
    return _pwd;
  }

  set pwd(String value) {
    if (_pwd == value) return;
    _pwd = value;
    prepare();
  }

  String encrypt(String plain) {
    return encryptByPwd(pwd, plain);
  }

  String? decrypt(String encrypted) {
    return decryptByPwd(pwd, encrypted);
  }

  clear() {
    // pubKeyFile.delete();
    remoteRepo.file.delete();
    users.users.clear();
    workspaces.workspaces.clear();
  }

  set collection(BoxCollection collection) {
    storage.collection = collection;
  }

  File get pubKeyFile {
    return File(join(basePath, "key.pub"));
  }

  Future registerPassword(String password) async {
    pwd = password;
    final String hashed =
        BCrypt.hashpw(password, BCrypt.gensalt(logRounds: 31));
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

  String get lastOpenedId {
    return remoteRepo.config.lastOpenedId ?? remoteRepo.config.repos[0].id;
  }

  set lastOpenedId(String id) {
    remoteRepo.config.lastOpenedId = id;
    remoteRepo.save();
  }
}

class Users {
  final DB db;
  Users.bind(this.db);

  Future<UserModel?> get(String id) async {
    final json = await users.get(id);
    return json == null ? null : UserModel.fromJson(json);
  }

  Future create(String uuid, UserModel user) async {
    return await users.save(uuid, user.toJson());
  }

  JsonBox get users {
    return db.storage.users;
  }
}

class Workspaces {
  final DB db;
  Workspaces.bind(this.db);

  Future<WorkspaceModel> create(String id, Org org) async {
    final workspace = WorkspaceModel(
      accessTokenId: id,
      org: org,
      books: await listRepos(id),
    );
    await save(id, workspace);
    return workspace;
  }

  Future save(String workspaceId, WorkspaceModel workspace) {
    return workspaces.save(workspaceId, workspace.toJson());
  }

  Future<WorkspaceModel?> open(String id) async {
    final json = await workspaces.get(id);
    if (db.lastOpenedId != id) {
      db.lastOpenedId = id;
    }
    return json == null ? null : WorkspaceModel.fromJson(json);
  }

  JsonBox get workspaces {
    return db.storage.workspaces;
  }

  Future<WorkspaceModel?> updateBooks(String workspaceId) async {
    final space = await open(workspaceId).then((workspace) async {
      if (workspace == null) return null;
      final repos = await listRepos(workspaceId);
      workspace.books = repos;
      await save(workspaceId, workspace);
      return workspace;
    });
    return space;
  }

  Future<BookModel?> createBook(
    String workspaceId,
    String name,
    String summary,
    bool public,
  ) async {
    final api = getApi(workspaceId);
    return api == null
        ? null
        : await api.createRepo(
            name: name,
            description: db.encrypt(DESCRIPTION),
            summary: db.encrypt(summary),
            public: public,
          );
  }

  Future<List<BookModel>> listRepos(String id) async {
    final api = getApi(id);
    return api == null
        ? []
        : await api.listRepos().then((repos) {
            if (repos == null) return [];
            return List.from(repos.where((element) => element.description ==
                    null
                ? false
                : db.decrypt(element.description as String) == DESCRIPTION));
          });
  }

  BaseRepoApi? getApi(String id) {
    final repo = db.remoteRepo.get(id);
    if (repo == null) return null;
    final api = apiOf(repo.org);
    api.accessToken = repo.accessToken;
    return api;
  }
}

class RemoteRepo {
  late final DB db;
  late var config = RemoteRepoConfigModel(repos: []);

  RemoteRepo.bind(this.db);

  File get file {
    return File(join(db.basePath, "remote-repo.conf"));
  }

  reload() {
    if (db.pwd.isNotEmpty && file.existsSync()) {
      final data = file.readAsStringSync();
      final decrypted = db.decrypt(data);
      if (decrypted == null) return;
      final json = convert.jsonDecode(decrypted);
      config = RemoteRepoConfigModel.fromJson(json);
      store.workspace.count.value = config.repos.length;
    }
  }

  Future<WorkspaceModel?> add({
    required Org org,
    required String accessToken,
  }) async {
    final owner = await apiOf(org).checkAccessToken(accessToken: accessToken);
    if (owner == null) {
      return null;
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
    store.workspace.count.value = config.repos.length;
    if (config.repos.length == 1) {
      db.lastOpenedId = workspaceId;
    } else {
      await save();
    }
    return await db.workspaces.create(workspaceId, org);
  }

  RemoteRepoDataModel getByIndex(int idx) {
    return config.repos.elementAt(idx);
  }

  RemoteRepoDataModel? get(String id) {
    return config.repos.firstWhereOrNull((element) => element.id == id);
  }

  Future<File> save() {
    final data = convert.jsonEncode(config);
    final encrypted = db.encrypt(data);
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
  late final books = JsonBox.bind(this, 'books');
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

class FS {
  late final DB db;
  FS.bind(this.db);

  String getOrgPath(Org org) {
    return join(db.basePath, org.toString());
  }

  String getBookPath(Org org, BookModel book) {
    return join(getOrgPath(org), book.namespace, book.name);
  }

  Directory getBookDir(Org org, BookModel book) {
    final path = getBookPath(org, book);
    return Directory(path);
  }
}
