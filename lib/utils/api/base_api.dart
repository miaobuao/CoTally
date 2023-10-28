import 'package:cotally/utils/constants.dart';
import 'package:cotally/utils/models/workspace.dart';

import '../models/user.dart';

abstract class BaseRepoApi {
  String? accessToken;
  BaseRepoApi(this.accessToken);

  Future<UserInfoModel?> checkAccessToken({
    required String accessToken,
  });

  Future<UserInfoModel?> getUser({
    required String username,
  });
  addCollaborator({
    required String owner,
    required String repo,
    required String username,
    required RepoPermission permission,
  });
  removeCollaborator({
    required String owner,
    required String repo,
    required String username,
  });
  Future<List<UserInfoModel>> listCollaborators({
    required String owner,
    required String repo,
    int? page,
    int? perPage,
  });
  Future<List<BookModel>?> listRepos({
    required String workspaceId,
    int page = 1,
    int perPage = 100,
  });

  Future<BookModel?> createRepo({
    required String workspaceId,
    required String name,
    required String description,
    required String summary,
    required bool public,
  });

  Future<BookModel?> updateRepoSettings({
    required String workspaceId,
    required BookModel book,
    bool? private,
    String? description,
  });

  Future<bool> createFile({
    required String namespace,
    required String path,
    required String filePath,
    required String content,
    required String message,
  });

  Future<bool> deleteRepo({
    required String namespace,
    required String path,
  });

  String cloneUrl(String namespace, String path);
}

enum RepoPermission {
  pull,
  push,
  admin,
}
