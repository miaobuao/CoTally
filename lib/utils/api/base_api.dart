import '../models/user.dart';

abstract class BaseRepoApi {
  String? accessToken;
  BaseRepoApi(this.accessToken);

  Future<UserInfo?> checkAccessToken({
    required String accessToken,
  });

  Future<UserInfo?> getUser({
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
  Future<List<UserInfo>> listCollaborators({
    required String owner,
    required String repo,
    int? page,
    int? perPage,
  });
}

enum RepoPermission {
  pull,
  push,
  admin,
}
