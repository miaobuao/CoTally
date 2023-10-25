import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'package:cotally/stores/stores.dart';
import 'package:cotally/utils/api/base_api.dart';
import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/models/config.dart';
import 'package:cotally/utils/models/user.dart';
import 'package:cotally/utils/models/workspace.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:uuid/uuid.dart';
import 'crypto.dart';
import './api/api.dart';

const uuid = Uuid();
typedef StringMapBox = CollectionBox<Map<String, dynamic>>;
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

  String get pwd {
    return _pwd;
  }

  set pwd(String value) {
    if (_pwd == value) return;
    _pwd = value;
  }

  String encrypt(String plain) {
    return encryptByPwd(pwd, plain);
  }

  String decrypt(String encrypted) {
    return decryptByPwd(pwd, encrypted);
  }

  clear({bool? removePwd}) async {
    if ((removePwd ?? false) && pubKeyFile.existsSync()) {
      pubKeyFile.deleteSync();
    }
    await remoteRepo.clear();
    await users.box.clear();
    await workspaces.box.clear();
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
    return remoteRepo.lastOpenedId;
  }

  set lastOpenedId(String id) {
    remoteRepo.lastOpenedId = id;
  }
}

class Users {
  final DB db;
  Users.bind(this.db);
  JsonBox get box {
    return db.storage.users;
  }

  Future<UserModel?> get(String id) async {
    final json = await box.get(id);
    return json == null ? null : UserModel.fromJson(json);
  }

  Future create(String uuid, UserModel user) async {
    return await box.save(uuid, user.toJson());
  }
}

class Workspaces {
  final DB db;
  Workspaces.bind(this.db);
  JsonBox get box {
    return db.storage.workspaces;
  }

  Future<WorkspaceModel> create(String id, Org org) async {
    final workspace = WorkspaceModel(
      id: id,
      org: org,
      books: await listRepos(id),
    );
    await save(id, workspace);
    return workspace;
  }

  Future save(String id, WorkspaceModel workspace) {
    return box.save(id, workspace.toJson());
  }

  Future<WorkspaceModel?> open(String id) async {
    final json = await box.get(id.toString());
    if (db.lastOpenedId != id) {
      db.lastOpenedId = id;
    }
    return json == null ? null : WorkspaceModel.fromJson(json);
  }

  Future<WorkspaceModel?> updateBooksOf(String workspaceId) async {
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
    final api = await getApi(workspaceId);
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
    final api = await getApi(id);
    return api == null
        ? []
        : await api.listRepos().then((repos) {
            if (repos == null) return [];
            return List.from(repos.where((element) {
              if (element.description == null) {
                return false;
              }
              try {
                if (db.decrypt(element.description as String) == DESCRIPTION) {
                  return true;
                }
              } on DecyptError catch (_) {
                return false;
              }
              return false;
            }));
          });
  }

  Future<BaseRepoApi?> getApi(String id) async {
    final repo = await db.remoteRepo.get(id);
    if (repo == null) return null;
    final api = apiOf(repo.org);
    api.accessToken = repo.accessToken;
    return api;
  }
}

class RemoteRepo {
  late final DB db;

  RemoteRepo.bind(this.db);

  JsonBox get box {
    return db.storage.tokens;
  }

  clear() {
    if (lastOpenedIdFile.existsSync()) {
      lastOpenedIdFile.deleteSync();
    }
  }

  File get lastOpenedIdFile {
    final path = join(db.basePath, "lastOpenedRepo.id");
    return File(path);
  }

  String get lastOpenedId {
    return lastOpenedIdFile.readAsStringSync();
  }

  set lastOpenedId(String id) {
    lastOpenedIdFile.writeAsStringSync(id);
  }

  Future<DecryptedRemoteRepoDataModel?> add({
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
    final repo = DecryptedRemoteRepoDataModel(
      id: workspaceId,
      org: org,
      accessToken: accessToken,
      updateTime: DateTime.now(),
      ownerId: ownerId,
    );
    await db.workspaces.create(workspaceId, org);
    if (!lastOpenedIdFile.existsSync()) {
      lastOpenedId = workspaceId;
    }
    await box.save(repo.id, repo.encrypt(db.encrypt).toJson());
    return repo;
  }

  Future<DecryptedRemoteRepoDataModel?> get(String id) async {
    final json = await box.get(id);
    return json == null
        ? null
        : EncryptedRemoteRepoDataModel.fromJson(json).decrypt(db.decrypt);
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
  late final tokens = JsonBox.bind(this, "tokens");
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
