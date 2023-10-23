import 'package:cotally/utils/models/user.dart';
import 'package:cotally/utils/models/workspace.dart';
import 'package:dio/dio.dart';

import './base_api.dart';

final dio = Dio();

class GiteeApi implements BaseRepoApi {
  @override
  String? accessToken;
  GiteeApi({this.accessToken});

  static const String base = "https://gitee.com/api/v5";

  @override
  addCollaborator({
    required String owner,
    required String repo,
    required String username,
    required RepoPermission permission,
  }) {
    // TODO: implement addCollaborator
    throw UnimplementedError();
  }

  @override
  // https://gitee.com/api/v5/swagger#/getV5User
  Future<UserInfoModel?> checkAccessToken({required String accessToken}) async {
    final response = await dio.get(
      "$base/user",
      queryParameters: {
        "access_token": accessToken,
      },
    );
    if (response.statusCode == 200) {
      return UserInfoModel.fromJson(response.data);
    }
    return null;
  }

  @override
  // https://gitee.com/api/v5/swagger#/getV5UsersUsername
  Future<UserInfoModel?> getUser({required String username}) async {
    final url = "$base/users/$username";
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      return UserInfoModel.fromJson(response.data);
    }
    return null;
  }

  @override
  Future<List<UserInfoModel>> listCollaborators({
    required String owner,
    required String repo,
    int? page,
    int? perPage,
  }) {
    // TODO: implement listCollaborators
    throw UnimplementedError();
  }

  @override
  removeCollaborator({
    required String owner,
    required String repo,
    required String username,
  }) {
    // TODO: implement removeCollaborator
    throw UnimplementedError();
  }

// https://gitee.com/api/v5/swagger#/getV5UserRepos
  @override
  Future<List<BookModel>?> listRepos({
    int page = 1,
    int perPage = 100,
  }) async {
    const url = "$base/user/repos";
    final response = await dio.get(url, queryParameters: {
      "access_token": accessToken,
      "page": page,
      "per_page": perPage,
      "visibility": 'all',
    });

    if (response.statusCode == 200) {
      return List.from(response.data.map((value) {
        return BookModel(
          description: value['description'],
          namespace: value['namespace']['path'],
          name: value['name'],
          url: value['url'],
          public: value['public'],
        );
      }));
    }
    return null;
  }
}
