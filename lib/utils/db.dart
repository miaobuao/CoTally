import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';
import 'dart:typed_data';
import 'package:cotally/stores/stores.dart';
import 'package:cotally/utils/api/base_api.dart';
import 'package:cotally/utils/config.dart';
import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/extensions/file.dart';
import 'package:cotally/utils/git.dart';
import 'package:cotally/utils/models/config.dart';
import 'package:cotally/utils/models/user.dart';
import 'package:cotally/utils/models/workspace.dart';
import 'package:cotally/utils/types.dart';
import 'package:hive/hive.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';
import 'crypto.dart';
import './api/api.dart';
import 'package:bcrypt/bcrypt.dart';

const uuid = Uuid();
typedef StringMapBox = CollectionBox<Map<String, dynamic>>;
final store = Store();
final db = DB();

class DB {
  DB._();
  static final DB instance = DB._();
  factory DB() => instance;

  late final remoteRepo = RemoteRepo();
  late final users = Users();
  late final fs = FS();
  late final workspaces = Workspaces();

  Future clear({bool? removePwd}) async {
    if ((removePwd ?? false) && pubKeyFile.existsSync()) {
      pubKeyFile.deleteSync();
    }
    await config.clear();
    await users.box.clear();
    await workspaces.box.clear();
  }

  File get pubKeyFile {
    return File(join(config.basePath, "key.pub"));
  }

  Future registerPassword(String password) async {
    final key = await kdf(password);
    final hashed = BCrypt.hashpw(convert.base64Encode(key), BCrypt.gensalt());
    await pubKeyFile.writeAsString(hashed);
  }

  Future<Uint8List?> checkPassword(String password) async {
    if (!pubKeyFile.existsSync()) return null;
    final hashed = await pubKeyFile.readAsString();
    final key = await kdf(password);
    if (BCrypt.checkpw(convert.base64Encode(key), hashed)) {
      return key;
    }
    return null;
  }
}

class Users {
  JsonBox get box {
    return JsonBox('users');
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
  JsonBox get box {
    return JsonBox('workspaces');
  }

  Future<WorkspaceModel> create({
    required String id,
    required Org org,
  }) async {
    final workspace = WorkspaceModel(
      id: id,
      org: org,
      books: await listRepos(id),
    );
    await save(id: id, workspace: workspace);
    return workspace;
  }

  Future save({
    required String id,
    required WorkspaceModel workspace,
  }) {
    return box.save(id, workspace.toJson());
  }

  Future<WorkspaceModel?> open(String id, {bool save = false}) async {
    final json = await box.get(id.toString());
    if (save) {
      config.lastOpenedId = id;
    }
    return json == null ? null : WorkspaceModel.fromJson(json);
  }

  Future<WorkspaceModel?> updateBooksOf(String workspaceId) async {
    final space = await open(workspaceId).then((workspace) async {
      if (workspace == null) return null;
      final repos = await listRepos(workspaceId);
      workspace.books = repos;
      await save(id: workspaceId, workspace: workspace);
      return workspace;
    });
    return space;
  }

  Future<BookModel?> createBook({
    required String accessPwd,
    required String workspaceId,
    required String name,
    required String summary,
    required bool public,
  }) async {
    final api = await getApi(workspaceId);
    summary = await encryptByPwd(accessPwd, summary);
    final book = api == null
        ? null
        : await api.createRepo(
            workspaceId: workspaceId,
            name: name,
            description: DESCRIPTION_PREFIX,
            summary: summary,
            public: public,
          );
    if (book == null) return null;
    final workspace = await open(workspaceId);
    workspace!.books.add(book);
    await save(id: workspaceId, workspace: workspace);
    return book;
  }

  Future<bool> removeBook({
    required String workspaceId,
    required BookModel book,
  }) async {
    final api = await getApi(workspaceId);
    final workspace = await open(workspaceId);
    final idx = workspace!.books.indexWhere((element) =>
        element.namespace == book.namespace && element.name == book.name);
    if (idx == -1) return true;
    workspace.books.removeAt(idx);
    await save(id: workspaceId, workspace: workspace);
    return api == null
        ? false
        : await api.deleteRepo(
            namespace: book.namespace,
            path: book.name,
          );
  }

  Future<List<BookModel>> listRepos(String id) async {
    final api = await getApi(id);
    return api == null
        ? []
        : await api.listRepos(workspaceId: id).then((repos) {
            if (repos == null) return [];
            return List.from(repos.where((element) {
              if (element.description.startsWith(DESCRIPTION_PREFIX)) {
                return true;
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

  Future<Iterable<WorkspaceModel>> get list {
    return box.iter
        .then((value) => value.map((e) => WorkspaceModel.fromJson(e.$2)));
  }
}

class RemoteRepo {
  JsonBox get box {
    return JsonBox('tokens');
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
    await box.save(repo.id,
        repo.encrypt(getEncryptFunc(config.tokenDerivatinoKey)).toJson());
    await db.workspaces.create(id: workspaceId, org: org);
    if (config.lastOpenedIdFile.notExistsSync()) {
      config.lastOpenedId = workspaceId;
    }
    return repo;
  }

  Future<RemoteRepoDataModel?> get(String id) async {
    final json = await box.get(id);
    final dk = config.tokenDerivatinoKey;
    return json == null
        ? null
        : EncryptedRemoteRepoDataModel.fromJson(json).decrypt(dk);
  }
}

class JsonBox {
  final String name;
  JsonBox(this.name);

  Future<CollectionBox<String>> get box {
    return config.collection.openBox<String>(name);
  }

  Future save(String key, Json json) async {
    return await box.then((value) => value.put(key, convert.jsonEncode(json)));
  }

  Future<Json?> get(String key) async {
    final data = await box.then((value) => value.get(key));
    if (data == null) return null;
    return convert.jsonDecode(data);
  }

  Future<Iterable<(String, Json)>> get iter {
    return box
        .then((value) => value.getAllValues())
        .then((value) => value.entries)
        .then(
            (value) => value.map((e) => (e.key, convert.jsonDecode(e.value))));
  }

  Future clear() async {
    return box.then((value) => value.clear());
  }
}

class FS {
  Future<bool> removeLocal(BookModel book) async {
    final dir = book.directory;
    try {
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    } on Exception catch (_) {
      return false;
    } on Error catch (_) {
      return false;
    }
    return true;
  }

  Future<bool> removeRemote(String workspaceId, BookModel book) async {
    return db.workspaces
        .removeBook(
          workspaceId: workspaceId,
          book: book,
        )
        .then((value) async => value ? await removeLocal(book) : value);
  }

  Future<bool> clone(BookModel book) async {
    final api = await db.workspaces.getApi(book.workspaceId);
    final url = api?.cloneUrl(book.namespace, book.name);
    if (url == null) return false;
    final dir = book.directory;
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    await Git.clone(url, dir.path);
    return true;
  }
}
