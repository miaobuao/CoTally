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
    int page = 1,
    int perPage = 100,
  });
}

enum RepoPermission {
  pull,
  push,
  admin,
}
